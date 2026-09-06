function [pwr_clean, spectra, props] = fourier_power(rm_raw, thresh)
% Reimplements the Fourier power calculation of Ying et al. (2023),
% Current Biology 33:2425-2437 — zero-pad to 256, normalise by mean rate,
% FFT, square, Gaussian DC notch (width 1). Steps as described in their
% Methods are validated against their released code (Grid component
% extraction.m, L1329-1350).

% Inputs
%   rm_raw        — raw rate maps with no smoothing

% Outputs
%   pwr           — power spectrum of the rate map


    % Constants  
    PAD        = 256;                          % Zero-padding width
    n_bins     = 36;                           % Rate map bins
    offset     = floor((PAD - n_bins)/2);      % For centering the spectrum
    mean_fr    = mean(rm_raw(:));
    SIGMA_DC   = 1;
    CENTRE     = [129, 129];                   % Centre of spectrum
    % Spectrum cropping
    CROP    = 40;                              % half-width of stored spectrum crop (px)
    CROP_R  = CENTRE(1)-CROP : CENTRE(1)+CROP;
    CROP_C  = CENTRE(2)-CROP : CENTRE(2)+CROP;

    if isnan(mean_fr) || mean_fr == 0, mean_fr = 1; end % Assigned to prevent silent cells from crashing the code

    % Step 1-6: Zero-padded FFT, normalisation, square, fftshift, DC notch
    % Directly from Ying et al. 2023
    padded = padarray(rm_raw, [offset offset], 0, 'both');                  % Zero-padding
    coef = 1 / (mean_fr*sqrt(n_bins^2));                                    % Normalisation coeff Ying et al., 2023
    imgX = coef * fftshift(fft2(padded));                                   % 2D fft and normalised  
    pwr = abs(imgX.^2);                                                     % Power calculation                 
    [rr,cc] = ndgrid(1:PAD, 1:PAD);                                         % Coordinate grid
    [mrow, mcol] = find(ismember(pwr, max(pwr(:))));
    gaus2d = 1 - exp(-((rr-mrow(1)).^2 + (cc-mcol(1)).^2)./(2*SIGMA_DC^2)); % Gaussian dc notch
    gaus2d = gaus2d .* (gaus2d == 1);
    pwr = pwr .* gaus2d;
    % Step 7-8: Filter baseline, clip negatives
    % Call Voronoi shuffle
    [base, ~] = voronoi_baseline(rm_raw, n_bins, PAD, 50);

    pwr_clean = max(pwr - base, 0);
    spectra   = single(pwr_clean(CROP_R, CROP_C));
    % Step 9: Zero pixels below threshold
    pwr_clean(pwr_clean < thresh*max(pwr_clean(:))) = 0;
    % Step 10: Discard small harmonics
    props = regionprops(pwr_clean>0, 'Area', 'Centroid', 'PixelIdxList'); % find blobs post cleaning
    for i = 1:numel(props)                                                  
        if props(i).Area < 10
            pwr_clean(props(i).PixelIdxList) = 0;
        end
    end
    props = props([props.Area]>=10); % Clear out small blobs from the list
end