function component_counts = population_fourier_analysis(rate_maps_smooth, threshold_pct)
%POPULATION_FOURIER_ANALYSIS  Fourier component analysis for every tracked neuron.
%
%   Computes component counts, wavelength, and the Fourier symmetry ratio
%   (count of 60-deg pairs / count of 90-deg pairs across all neurons),
%   where 60-deg pairs indicate hexagonal alignment and 90-deg pairs
%   indicate quadrant-like alignment (Ying et al. 2023 primary metric:
%   nTG-a = 3.61, APP-a = 0.91).
%
%   Baseline is the 75th percentile of 100 pixel-permutation shuffles of
%   the population mean rate map (shared across all neurons).
%
%   Inputs
%   ------
%   rate_maps_smooth - n_bins x n_bins x n_neurons smoothed rate maps
%   threshold_pct    - fraction of per-neuron post-baseline max to threshold
%                      (0.40 for CAN model -- suppresses cross-harmonics from
%                      periodic BC; 0.25 to match Ying et al. 2023 pipeline)
%
%   Output
%   ------
%   component_counts - n_neurons x 1 vector of unique axis counts per neuron

    bin_size_m = 0.0208;
    n_shuffles = 100;

    [n_bins, ~, n_neurons] = size(rate_maps_smooth);
    N      = n_bins;
    M      = n_bins;
    PAD    = 256;
    CENTRE = [129, 129];
    r_off  = floor((PAD - N) / 2);
    c_off  = floor((PAD - M) / 2);

    % ------------------------------------------------------------------
    % Shared 75th-percentile baseline from population mean rate map
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
    % Display collection -- first n_display neurons per target count
    % ------------------------------------------------------------------
    targets     = [2, 4];
    n_display   = 2;
    n_targets   = numel(targets);
    disp_rm     = cell(n_targets, n_display);
    disp_pc     = cell(n_targets, n_display);
    disp_pr     = cell(n_targets, n_display);
    disp_phi    = cell(n_targets, n_display);
    disp_powers = cell(n_targets, n_display);
    disp_found  = zeros(n_targets, 1);

    % ------------------------------------------------------------------
    % Accumulators
    % ------------------------------------------------------------------
    all_wavelengths = [];
    count_60 = 0;   % neighbouring component pairs separated by ~60 deg (hexagonal)
    count_90 = 0;   % neighbouring component pairs separated by ~90 deg (quadrant-like)

    % ------------------------------------------------------------------
    % Random display setup -- 25 neurons, rate map + spectrum pairs
    % ------------------------------------------------------------------
    n_display_maps     = min(25, n_neurons);
    rand_idx           = sort(randperm(n_neurons, n_display_maps));
    is_rand            = false(n_neurons, 1);
    is_rand(rand_idx)  = true;
    rand_pos           = zeros(n_neurons, 1);
    rand_pos(rand_idx) = 1:n_display_maps;

    disp_rm_rand = zeros(n_bins, n_bins, n_display_maps);
    disp_pc_rand = zeros(PAD,    PAD,    n_display_maps);

    % ------------------------------------------------------------------
    % Main loop
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

        % Save rate map before any early exit so random display always has it
        if is_rand(k)
            rp = rand_pos(k);
            disp_rm_rand(:,:,rp) = rm;
        end

        % Steps 1-6: zero-padded FFT, normalise, square, fftshift, DC notch
        power = compute_power(rm, mean_fr, N, M, PAD, r_off, c_off);

        % Steps 7-8: subtract shared baseline, clip negatives
        power_clean = max(power - baseline_75, 0);

        % Step 9: zero below threshold fraction of remaining max
        pmax = max(power_clean(:));
        if pmax == 0,  continue;  end
        power_clean(power_clean < threshold_pct * pmax) = 0;

        % Step 10: discard blobs with area < 10 pixels
        props = regionprops(power_clean > 0, 'Area', 'Centroid', 'PixelIdxList');
        for p = 1:numel(props)
            if props(p).Area < 10
                power_clean(props(p).PixelIdxList) = 0;
            end
        end
        props = props([props.Area] >= 10);

        if isempty(props),  continue;  end

        % Centroid offsets from spectrum centre
        all_centroids = reshape([props.Centroid], 2, [])';
        centroid_cols = all_centroids(:, 1);
        centroid_rows = all_centroids(:, 2);

        dx = centroid_cols - CENTRE(2);
        dy = centroid_rows - CENTRE(1);

        % Wavelength from centroid distance in PAD-grid pixels
        % lambda (cm) = PAD * bin_size_m * 100 / r
        r_blobs        = sqrt(dx.^2 + dy.^2);
        lambda_blobs   = (PAD * bin_size_m * 100) ./ r_blobs;
        all_wavelengths = [all_wavelengths; lambda_blobs]; %#ok<AGROW>

        % Component angle: scale factors (2*pi)/(N*bin_size_m) cancel in
        % atan2d since N=M and bin_size_m is the same for both arguments
        phi = atan2d(dy, dx);

        % Save spectrum for random display after all thresholding
        if is_rand(k)
            rp = rand_pos(k);
            disp_pc_rand(:,:,rp) = power_clean;
        end

        % Fold into unique spatial axes in [0, 180) deg with 10 deg tolerance
        phi_sorted          = sort(mod(phi(:), 180));
        phi_unique          = phi_sorted([true; diff(phi_sorted) > 10]);
        component_counts(k) = numel(phi_unique);

        % Symmetry ratio: angular differences between consecutive unique axes.
        % Includes wraparound on the [0,180) circle to catch the pair bridging
        % the highest and lowest axis (e.g. the third 60-deg gap in a hexagonal
        % cell whose axes are at 10, 70, 130 deg).
        if numel(phi_unique) >= 2
            diffs     = diff(phi_unique);
            wrap      = 180 - (phi_unique(end) - phi_unique(1));
            all_diffs = [diffs(:); wrap];
            count_60  = count_60 + sum(abs(all_diffs - 60) <= 10);
            count_90  = count_90 + sum(abs(all_diffs - 90) <= 10);
        end

        % Collect display data for sample figures
        for t = 1:n_targets
            if component_counts(k) == targets(t) && disp_found(t) < n_display
                disp_found(t)    = disp_found(t) + 1;
                d                = disp_found(t);
                blob_powers      = arrayfun(@(p) max(power_clean(p.PixelIdxList)), props);
                disp_rm{t,d}     = rm;
                disp_pc{t,d}     = power_clean;
                disp_pr{t,d}     = round(centroid_rows);
                disp_phi{t,d}    = phi;
                disp_powers{t,d} = blob_powers(:);
            end
        end

    end

    % ------------------------------------------------------------------
    % Histogram
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

    % ------------------------------------------------------------------
    % Terminal summary
    % ------------------------------------------------------------------
    fprintf('\n[population_fourier_analysis] Component count summary:\n');
    for v = 0:max_comp
        cnt = sum(component_counts == v);
        fprintf('  %d components: %5d neurons  (%.1f%%)\n', v, cnt, 100*cnt/n_neurons);
    end

    if ~isempty(all_wavelengths)
        fprintf('\n[population_fourier_analysis] Wavelength summary (%d blobs from %d neurons):\n', ...
            numel(all_wavelengths), sum(component_counts > 0));
        fprintf('  Mean:    %.2f cm\n', mean(all_wavelengths));
        fprintf('  Median:  %.2f cm\n', median(all_wavelengths));
        fprintf('  SD:      %.2f cm\n', std(all_wavelengths));
        fprintf('  Range:   %.2f -- %.2f cm\n', min(all_wavelengths), max(all_wavelengths));
    end

    if count_60 + count_90 > 0
        fprintf('\n[population_fourier_analysis] Fourier symmetry ratio (60 / 90 deg):\n');
        fprintf('  60 deg pairs: %d\n', count_60);
        fprintf('  90 deg pairs: %d\n', count_90);
        fprintf('  Ratio = %.3f   (Ying et al. targets: nTG-a = 3.61, APP-a = 0.91)\n', ...
            count_60 / count_90);
    else
        fprintf('\n[population_fourier_analysis] Fourier symmetry ratio: no qualifying pairs found.\n');
    end

    % ------------------------------------------------------------------
    % 25 random neurons: rate map | Fourier spectrum pairs
    % ------------------------------------------------------------------
    n_pairs_per_row = 5;
    n_rows_rand     = ceil(n_display_maps / n_pairs_per_row);

    figure('Position', [50 50 2000 400 * n_rows_rand], ...
           'Name', '25 Random Neurons: Rate Map and Fourier Spectrum');
    for i = 1:n_display_maps
        row      = ceil(i / n_pairs_per_row);
        col_pair = mod(i - 1, n_pairs_per_row);

        subplot(n_rows_rand, n_pairs_per_row * 2, ...
                (row-1) * n_pairs_per_row*2 + col_pair*2 + 1);
        imagesc(disp_rm_rand(:,:,i));
        colormap(gca, jet); axis equal tight off;
        title(sprintf('N%d', rand_idx(i)), 'FontSize', 6);

        pc_i   = disp_pc_rand(:,:,i);
        pmax_i = max(pc_i(:));
        subplot(n_rows_rand, n_pairs_per_row * 2, ...
                (row-1) * n_pairs_per_row*2 + col_pair*2 + 2);
        imagesc(pc_i, [0, max(pmax_i, eps)]);
        colormap(gca, jet); axis equal tight off;
        title(sprintf('c=%d', component_counts(rand_idx(i))), 'FontSize', 6);
    end
    sgtitle('25 Random Neurons  |  Rate Map (left)  Fourier Spectrum (right)');

    % ------------------------------------------------------------------
    % Sample figures for target component counts
    % ------------------------------------------------------------------
    for t = 1:n_targets
        n_found = disp_found(t);
        if n_found == 0,  continue;  end

        figure('Position', [50 50 1300 400 * n_found], ...
               'Name', sprintf('%d-component examples', targets(t)));

        for d = 1:n_found
            rm_d  = disp_rm{t,d};
            pc_d  = disp_pc{t,d};
            pr_d  = disp_pr{t,d};
            phi_d = disp_phi{t,d};

            subplot(n_found, 3, (d-1)*3 + 1)
            imagesc(rm_d); colormap(gca, jet); colorbar;
            title(sprintf('Rate map  (%d\\times%d bins)', N, M));
            xlabel('x bin'); ylabel('y bin');
            axis equal tight; set(gca, 'YDir', 'normal');

            subplot(n_found, 3, (d-1)*3 + 2)
            imagesc(pc_d, [0, max(pc_d(:))]); colormap(gca, jet); colorbar;
            title(sprintf('Thresholded spectrum  |  %d blobs', numel(pr_d)));
            xlabel('bin'); ylabel('bin'); axis equal tight;

            subplot(n_found, 3, (d-1)*3 + 3)
            peak_powers   = disp_powers{t,d};
            idx           = mod(round(mod(phi_d(:) + 90, 360)) - 1, 360) + 1;
            polar_profile = accumarray(idx, peak_powers(:), [360, 1])';
            polarplot(deg2rad(0:359), polar_profile, 'k-', 'LineWidth', 1.5);
            title('Fourier polar representation');
        end

        sgtitle(sprintf('%d-component neurons  |  %d examples', targets(t), n_found));
    end

end


% ======================================================================
%  LOCAL FUNCTION — power spectrum with DC notch removal
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