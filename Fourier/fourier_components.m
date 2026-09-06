function [har_count, lobes, n60, n90] = fourier_components(props)
% Counts the components that make up the spectrum
% Inputs
%   props         — rate map property outputs from regionprop
% Outputs
%   har_count     — number of harmonics on the Fourier spectrum
%   lobes         — number of harmonics on the Fourier spectrum
%   n60           — 60 degree separation with adjacent axes
%   n90           — 90 degree separation with adjacent axes
    
    % Constants
    ANGULAR_CENTRE = [128.5, 128.5]; % Centre as defined by Ying et al. 2023. Note: half a pixel off
    har_count = 0;  
    lobes = [];  
    n60 = 0;  
    n90 = 0;
    % Centroid extraction using regionprop
    all_cen = reshape([props.Centroid],2,[])';
    cen_col = all_cen(:,1);
    cen_row = all_cen(:,2);
    dx      = cen_col - ANGULAR_CENTRE(1);  % Distance from centre
    dy      = cen_row - ANGULAR_CENTRE(2);
    if isempty(dx), return; end             % Guard from empty spectra
    % Component analysis, conventions validated to Ying et al., 2023
    phi = mod(atan2d(-1./dy, 1./dx), 360); % 2D atan translated to degree
    phi(dx == 0 | dy == 0) = NaN;          % Reproduce NaN behaviour when 
    % lobes count
    har_count   = round(numel(phi)/2);    % Symmetry principle in fourier domain
    lobes       = sort(phi(~isnan(phi))); % Sort non undefined lobes
    % Symmetry
    if numel(lobes) >=2
        lobes_w = [lobes(:); lobes(1) + 360];
        all_diffs = abs(diff(lobes_w));
        n60 = n60 + sum(all_diffs > 50 & all_diffs < 70);
        n90 = n90 + sum(all_diffs > 80 & all_diffs < 100);
    end
end