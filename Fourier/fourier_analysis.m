function results = fourier_analysis(rm_raw, rm_smooth, thresh)
% Fourier analysis pipeline for a single neuron
    % Initialise struct & Constants
    results = struct('count',0, 'lobes',[], 'n60',0, 'n90',0, ...
             'wl_cm',NaN, 'gridness',NaN, 'pwr_clean',[], 'spectra',[]);
    bin_cm = 75/36; % bin size in cm
    [pwr_clean, spectra, props] = fourier_power(rm_raw, thresh);
    [har_count, lobes, n60, n90] = fourier_components(props);
    [wl_cm, gridness] = ac_metrics(rm_smooth, bin_cm);
    % Saving results as a struct
    results.count      = har_count;
    results.pwr_clean  = pwr_clean;
    results.lobes      = lobes;
    results.n60        = n60;
    results.n90        = n90;
    results.wl_cm      = wl_cm;
    results.gridness   = gridness;
    results.spectra    = spectra;     % 81x81 single
    
    % Plotting
    if ~usejava('desktop'), return; end               
    W = 89:169;                       % spectra crop window
    A = double(spectra);
    B = pwr_clean(W, W);
    figure;
    subplot(1,2,1);                                  % pre-threshold
    mA = max(A(:));                                   
    cl = [log10(mA) - 4, log10(mA)];                   
    if ~all(isfinite(cl)) || cl(2) <= cl(1), cl = [0 1]; end % empty spectrum
    imagesc(log10(A + eps), cl);
    colormap(gca, jet); axis equal tight off;
    subplot(1,2,2);                                  % post-threshold
    mB = max(B(:), [], 'all');                               
    cb = [0, mB];                                         
    if ~all(isfinite(cb)) || cb(2) <= cb(1), cb = [0 1]; end % empty spectrum
    imagesc(B, cb);
    colormap(gca, jet); axis equal tight off;
    hold on
    if ~isempty(props)
        C = reshape([props.Centroid],2,[])';
        plot(C(:,1)-88, C(:,2)-88, 'r+','MarkerSize',10,'LineWidth',1.5)
    end
    hold off
    title(sprintf('post-threshold %.2f  |  %d blobs', thresh, numel(props)))
end
