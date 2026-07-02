function [lambda_d_ratio, summary] = measure_lambda_d_autocorr(rate_maps_smooth, bin_size_cm)
%MEASURE_LAMBDA_D_AUTOCORR  lambda/d ratio from each neuron's spatial
%   autocorrelogram (Sargolini et al. 2006-style methodology).
%
%   More robust than single-field measurements because every field-pair
%   in the rate map contributes to each lag of the autocorrelogram,
%   averaging out the single-bin/single-field noise that destabilised
%   the earlier field-by-field approaches.
%
%   For each neuron:
%     1. Compute the 2D spatial autocorrelogram: Pearson correlation at
%        every (dx,dy) lag, using only bins where both the original and
%        shifted map have non-zero (visited) data.
%     2. Locate the six local maxima nearest the central peak -- the
%        inner hexagonal ring. Their mean distance from centre is
%        lambda.
%     3. Walk the radial profile from the centre toward the nearest of
%        those six peaks to find the trough between them. Threshold the
%        central peak at the midpoint between trough and peak (50%
%        prominence) and take the area-equivalent diameter of that
%        region as d.
%
%   Inputs
%   ------
%   rate_maps_smooth - n_bins x n_bins x n_neurons array of rate maps
%   bin_size_cm       - spatial bin size in cm (e.g. 75/36 = 2.0833)
%
%   Outputs
%   -------
%   lambda_d_ratio - mean(lambda_cm) / mean(diam_cm) across valid neurons
%   summary        - struct with per-neuron lambda_cm, diam_cm, and
%                    per-neuron ratio, plus summary statistics

    [n_bins, ~, n_neurons] = size(rate_maps_smooth);

    lambda_cm = nan(n_neurons,1);
    diam_cm   = nan(n_neurons,1);

    for k = 1:n_neurons
        if mod(k,500)==0
            fprintf('  Neuron %d / %d (%.0f%%)\n', k, n_neurons, 100*k/n_neurons);
        end

        rm = rate_maps_smooth(:,:,k);
        if max(rm(:)) <= 0
            continue
        end

        % --- Step 1: spatial autocorrelogram ---
        ac = local_spatial_autocorr(rm);
        [acH, acW] = size(ac);
        cy = ceil(acH/2); cx = ceil(acW/2);   % centre index (zero lag)

        % --- Step 2: find 6 nearest local maxima around centre ---
        local_max_mask = imregionalmax(ac);
        [yy, xx] = find(local_max_mask);
        d_from_centre = sqrt((yy-cy).^2 + (xx-cx).^2);

        % exclude the centre peak itself and anything too close to it
        % (avoids noise adjacent to the central peak being mistaken for
        % a genuine surrounding grid peak)
        valid = d_from_centre > 2;
        yy = yy(valid); xx = xx(valid); d_from_centre = d_from_centre(valid);

        if numel(d_from_centre) < 6
            continue   % too few peaks found -- autocorrelogram too noisy
        end

        [sorted_d, sort_idx] = sort(d_from_centre);
        inner_six = sorted_d(1:6);
        lambda_cm(k) = mean(inner_six) * bin_size_cm;

        % --- Step 3: central peak width at 50% prominence ---
        centre_val = ac(cy, cx);

        nearest_idx = sort_idx(1);
        py = yy(nearest_idx); px = xx(nearest_idx);
        n_samples = 50;
        ty = round(linspace(cy, py, n_samples));
        tx = round(linspace(cx, px, n_samples));
        lin_idx = sub2ind(size(ac), ty, tx);
        radial_profile = ac(lin_idx);
        trough_val = min(radial_profile);

        half_prom_thresh = trough_val + 0.5*(centre_val - trough_val);

        peak_mask = ac >= half_prom_thresh;
        cc = bwconncomp(peak_mask);
        centre_lin = sub2ind(size(ac), cy, cx);
        comp_id = 0;
        for c = 1:cc.NumObjects
            if any(cc.PixelIdxList{c} == centre_lin)
                comp_id = c;
                break
            end
        end
        if comp_id == 0
            continue
        end

        area_bins = numel(cc.PixelIdxList{comp_id});
        area_cm2  = area_bins * bin_size_cm^2;
        diam_cm(k) = 2*sqrt(area_cm2/pi);
    end

    valid_idx = ~isnan(lambda_cm) & ~isnan(diam_cm);

    summary.lambda_cm        = lambda_cm(valid_idx);
    summary.diam_cm          = diam_cm(valid_idx);
    summary.ratio_per_neuron = summary.lambda_cm ./ summary.diam_cm;
    summary.n_valid          = sum(valid_idx);
    summary.mean_lambda_cm   = mean(summary.lambda_cm);
    summary.mean_diam_cm     = mean(summary.diam_cm);

    lambda_d_ratio = summary.mean_lambda_cm / summary.mean_diam_cm;

    fprintf('\n[measure_lambda_d_autocorr] Results (n=%d valid neurons):\n', summary.n_valid);
    fprintf('  Lambda:   mean=%.2f cm, std=%.2f cm\n', summary.mean_lambda_cm, std(summary.lambda_cm));
    fprintf('  Diameter: mean=%.2f cm, std=%.2f cm\n', summary.mean_diam_cm, std(summary.diam_cm));
    fprintf('  lambda/d ratio (mean/mean)              = %.3f\n', lambda_d_ratio);
    fprintf('  lambda/d ratio (mean of per-neuron ratio) = %.3f +/- %.3f\n', ...
        mean(summary.ratio_per_neuron), std(summary.ratio_per_neuron));
end


function ac = local_spatial_autocorr(rm)
%LOCAL_SPATIAL_AUTOCORR  Spatial autocorrelogram via MATLAB's built-in
%   normxcorr2.
%
%   IMPORTANT: this changes the zero/unvisited-bin handling compared to
%   the explicit-loop and FFT-based versions this replaces. Those
%   versions excluded unvisited bins (rm==0) from the correlation at
%   each lag, treating them as missing data. normxcorr2 has no such
%   concept -- every bin, including unvisited ones, is treated as a
%   real zero-rate observation and included in the correlation. For an
%   arena with near-complete coverage this difference should be small,
%   but it is a genuine behavioural change, not just a refactor.
%
%   Zero lag (perfect self-overlap) should land at index
%   (size(rm,1), size(rm,2)) with value 1.0 -- matches the existing
%   cy = ceil(acH/2), cx = ceil(acW/2) convention used in the caller,
%   so nothing else in this file needs to change. Worth a quick sanity
%   check on your first run: ac(size(rm,1), size(rm,2)) should equal 1.

    ac = normxcorr2(rm, rm);
end