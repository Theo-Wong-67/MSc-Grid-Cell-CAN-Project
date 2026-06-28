function component_counts = population_fourier_analysis(rate_maps_smooth, bin_size_m, n_shuffles)
%POPULATION_FOURIER_ANALYSIS  Count Fourier components for every tracked neuron.
%   Uses the same pipeline as fourier_analysis.m with a shared baseline
%   computed from the population mean rate map (per-neuron shuffles would
%   be prohibitively slow for thousands of neurons).
%
%   Inputs
%   ------
%   rate_maps_smooth - n_bins x n_bins x n_neurons array of rate maps
%   bin_size_m       - Bin size in metres. Default: 0.0208 m (75 cm / 36 bins).
%   n_shuffles       - Shuffles for shared baseline. Default: 100.
%
%   Output
%   ------
%   component_counts - n_neurons x 1 vector of unique axis counts per neuron

    if nargin < 2 || isempty(bin_size_m), bin_size_m = 0.0208; end
    if nargin < 3 || isempty(n_shuffles), n_shuffles = 100;    end

    [n_bins, ~, n_neurons] = size(rate_maps_smooth);
    N               = n_bins;
    M               = n_bins;
    PAD             = 256;
    CENTRE          = [129, 129];
    r_off           = floor((PAD - N) / 2);
    c_off           = floor((PAD - M) / 2);

    % ------------------------------------------------------------------
    % Shared 75th-percentile baseline from the population mean rate map.
    % ------------------------------------------------------------------
    fprintf('[population_fourier_analysis] Computing shared baseline (%d shuffles)...\n', n_shuffles);

    mean_map    = mean(rate_maps_smooth, 3);
    pos         = mean_map(mean_map > 0);
    mean_fr_pop = mean(pos(:));
    if isnan(mean_fr_pop) || mean_fr_pop == 0,  mean_fr_pop = 1;  end

    shuffle_stack = zeros(PAD, PAD, n_shuffles);
    for s = 1:n_shuffles
        rm_s = reshape(mean_map(randperm(numel(mean_map))), N, M);
        shuffle_stack(:,:,s) = compute_power(rm_s, mean_fr_pop, N, M, PAD, r_off, c_off);
    end
    baseline_75 = prctile(shuffle_stack, 75, 3);
    clear shuffle_stack
    fprintf('[population_fourier_analysis] Baseline done.\n');

    % ------------------------------------------------------------------
    % Display collection — save data for the first n_display neurons
    % found at each target component count for post-hoc visualisation.
    % ------------------------------------------------------------------
    targets    = [2, 4];
    n_display  = 2;
    n_targets  = numel(targets);
    disp_rm    = cell(n_targets, n_display);
    disp_pc    = cell(n_targets, n_display);   % power_clean
    disp_pr    = cell(n_targets, n_display);   % peak_rows
    disp_pcols = cell(n_targets, n_display);   % peak_cols
    disp_phi   = cell(n_targets, n_display);
    disp_found = zeros(n_targets, 1);

    % ------------------------------------------------------------------
    % Process each neuron
    % ------------------------------------------------------------------
    component_counts = zeros(n_neurons, 1);
    fprintf('[population_fourier_analysis] Analysing %d neurons...\n', n_neurons);

    for k = 1:n_neurons

        if mod(k, 1000) == 0
            fprintf('  Neuron %d / %d  (%.0f%%)\n', k, n_neurons, 100*k/n_neurons);
        end

        rm      = rate_maps_smooth(:,:,k);
        pos     = rm(rm > 0);
        mean_fr = mean(pos(:));
        if isnan(mean_fr) || mean_fr == 0,  mean_fr = 1;  end

        % Steps 1-6: power spectrum with DC removal
        power = compute_power(rm, mean_fr, N, M, PAD, r_off, c_off);

        % Steps 7-8: subtract shared baseline, zero negatives
        power_clean = max(power - baseline_75, 0);

        % Step 9: zero below 40% of remaining maximum
        pmax = max(power_clean(:));
        if pmax == 0,  continue;  end
        power_clean(power_clean < 0.4 * pmax) = 0;

        % Step 10: discard connected regions with area < 10 pixels
        props = regionprops(power_clean > 0, 'Area', 'Centroid', 'PixelIdxList');
        for p = 1:numel(props)
            if props(p).Area < 10
                power_clean(props(p).PixelIdxList) = 0;
            end
        end
        props = props([props.Area] >= 10);

        if isempty(props),  continue;  end

        % Wave vectors directly from regionprops centroids — one per blob
        all_centroids = reshape([props.Centroid], 2, [])';
        centroid_cols = all_centroids(:, 1);
        centroid_rows = all_centroids(:, 2);

        dx  = centroid_cols - CENTRE(2);
        dy  = centroid_rows - CENTRE(1);
        phi = atan2d((2*pi .* dy) ./ (M * bin_size_m), ...
                     (2*pi .* dx) ./ (N * bin_size_m));

        % Fold phi into unique spatial axes [0, 180) deg
        phi_sorted          = sort(mod(phi(:), 180));
        phi_unique          = phi_sorted([true; diff(phi_sorted) > 10]);
        component_counts(k) = numel(phi_unique);

        % Collect display data if this neuron hits a target component count
        for t = 1:n_targets
            if component_counts(k) == targets(t) && disp_found(t) < n_display
                disp_found(t)        = disp_found(t) + 1;
                d                    = disp_found(t);
                disp_rm{t,d}         = rm;
                disp_pc{t,d}         = power_clean;
                disp_pr{t,d}         = round(centroid_rows);
                disp_pcols{t,d}      = round(centroid_cols);
                disp_phi{t,d}        = phi;
            end
        end

    end

    % ------------------------------------------------------------------
    % Histogram — neurons per component count
    % ------------------------------------------------------------------
    max_comp = max(component_counts);

    figure('Position', [100 100 650 450], 'Name', 'Population Fourier Analysis');
    histogram(component_counts, ...
              'BinEdges',  -0.5 : 1 : max_comp + 0.5, ...
              'FaceColor', [0.20 0.45 0.75], ...
              'EdgeColor', 'white');
    xlabel('Number of components (unique axes)');
    ylabel('Number of neurons');
    title(sprintf('Component count distribution  |  %d neurons', n_neurons));
    grid on;

    % Terminal summary
    fprintf('\n[population_fourier_analysis] Component count summary:\n');
    for v = 0:max_comp
        cnt = sum(component_counts == v);
        fprintf('  %d components: %5d neurons  (%.1f%%)\n', v, cnt, 100*cnt/n_neurons);
    end

    % ------------------------------------------------------------------
    % Sample figures — one figure per target component count, showing
    % n_display example neurons in rows (rate map | spectrum | polar).
    % ------------------------------------------------------------------
    for t = 1:n_targets
        n_found = disp_found(t);
        if n_found == 0,  continue;  end

        figure('Position', [50 50 1300 400 * n_found], ...
               'Name', sprintf('%d-component examples', targets(t)));

        for d = 1:n_found
            rm_d    = disp_rm{t,d};
            pc_d    = disp_pc{t,d};
            pr_d    = disp_pr{t,d};
            pcols_d = disp_pcols{t,d};
            phi_d   = disp_phi{t,d};

            % Panel 1 — rate map
            subplot(n_found, 3, (d-1)*3 + 1)
            imagesc(rm_d); colormap(gca, jet); colorbar;
            title(sprintf('Rate map  (%d\\times%d bins)', N, M));
            xlabel('x bin'); ylabel('y bin');
            axis equal tight; set(gca, 'YDir', 'normal');

            % Panel 2 — thresholded spectrum with peak markers
            subplot(n_found, 3, (d-1)*3 + 2)
            imagesc(pc_d, [0, max(pc_d(:))]); colormap(gca, jet); colorbar; hold on;
            title(sprintf('Thresholded spectrum  |  %d peaks', numel(pr_d)));
            xlabel('bin'); ylabel('bin'); axis equal tight;

            % Panel 3 — Fourier polar representation
            subplot(n_found, 3, (d-1)*3 + 3)
            peak_powers  = pc_d(sub2ind(size(pc_d), pr_d(:), pcols_d(:)));
            theta_folded = mod(phi_d + 90, 180);
            idx1         = mod(round(theta_folded(:)) - 1, 360) + 1;
            idx2         = mod(idx1 + 179, 360) + 1;
            polar_profile = accumarray([idx1; idx2], ...
                                       repmat(peak_powers(:), 2, 1), [360, 1])';
            polarplot(deg2rad(0:359), polar_profile, 'k-', 'LineWidth', 1.5);
            title('Fourier polar representation');
        end

        sgtitle(sprintf('%d-component neurons  |  %d examples', targets(t), n_found));
    end

end


% ======================================================================
%  LOCAL FUNCTION — matches compute_power in fourier_analysis.m exactly
% ======================================================================
function pwr = compute_power(rm, mfr, N, M, PAD, r_off, c_off)
    SIGMA_DC = 10;

    padded = zeros(PAD, PAD);
    padded(r_off+1:r_off+N, c_off+1:c_off+M) = rm;

    F   = fftshift(fft2(padded));
    pwr = (abs(F) ./ mfr) .^ 2;

    [~, idx]     = max(pwr(:));
    [r_pk, c_pk] = ind2sub([PAD, PAD], idx);
    [rr, cc]     = ndgrid(1:PAD, 1:PAD);
    pwr = pwr .* (1 - exp(-((rr-r_pk).^2 + (cc-c_pk).^2) ./ (2*SIGMA_DC^2)));
end