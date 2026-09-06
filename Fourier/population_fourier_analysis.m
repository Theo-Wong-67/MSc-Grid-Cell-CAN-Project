function res = population_fourier_analysis(rm_raw, rm_smooth, thresh, subset, rng_base)
%POPULATION_FOURIER_ANALYSIS  Run fourier_analysis over a set of neurons.
%
%   res = population_fourier_analysis(rm_raw, rm_smooth, thresh, subset)
%   res = population_fourier_analysis(rm_raw, rm_smooth, thresh, subset, rng_base)
%
% Inputs
%   rm_raw     n_bins x n_bins x n_neurons, unsmoothed maps (Fourier input)
%   rm_smooth  same size, smoothed maps (autocorrelogram input)
%   thresh     scalar fraction of peak power. 0.25 reproduces Ying et al.
%              (2023) on their data; 0.43 is the model default.
%   subset     neuron indices to analyse
%   rng_base   optional integer, default 0. Cell k is seeded rng(rng_base + k).
%
% Output: res, a scalar struct. EVERY per-cell field is SUBSET-ORDERED --
%   res.count(i) describes neuron res.subset(i), NOT neuron i. The old
%   pipeline mixed conventions (full-length count/gridness indexed by neuron
%   id, subset-length spectra indexed by position), so spectra(:,:,j) paired
%   with count(subset(j)). One convention here.
%
%   subset       1 x n   neuron ids, in analysis order
%   count        n x 1   harmonic count. NaN = loop never reached this cell,
%                        0 = analysed and nothing found. Distinct on purpose.
%   lobes        n x 1 cell, lobe angles (deg, 0-360), NaNs already stripped
%   n60, n90     n x 1   per-cell adjacent-gap counts
%   wl_cm        n x 1   grid spacing (cm)
%   gridness     n x 1
%   spectra      81 x 81 x n single, PRE-threshold, baseline subtracted
%   s60 s90 ratio_60_90   population totals. Ying's biomarker is a ratio of
%                SUMMED pair counts, not a mean of per-cell ratios (which
%                would also divide by zero on every n90 == 0 cell).
%
%
% REMOVED 2026-08-14: res.axes_deg and res.axes_pooled. They came from
% fourier_components' phi_unique -- lobes folded onto 0-180 and merged within
% 10 deg, neither of which Ying et al. do. The merge chained (diff compares
% each angle to its predecessor, not to the last one kept, so 0 6 12 18 -> 0)
% and never merged across the 0/180 wrap. It fed one plot panel and no
% statistic: n60, n90, s60, s90 and the ratio all come from `lobes`. Files
% written before this date still carry both fields and remain readable;
% nothing in the aggregators reads them. Orientations are mod(lobes,180).
%
% pwr_clean is deliberately NOT returned: 256x256 double is 512 kB per cell,
% i.e. 8.6 GB for a full 16384-cell population. Re-run a single cell through
% fourier_analysis if you need it.
    if nargin < 5 || isempty(rng_base), rng_base = 0; end
    % ---------- validate ----------
    assert(isequal(size(rm_raw), size(rm_smooth)), ...
        'population_fourier_analysis:size', ...
        'rm_raw and rm_smooth must be the same size.');
    assert(isscalar(thresh) && thresh > 0 && thresh < 1, ...
        'population_fourier_analysis:thresh', ...
        'thresh must be a scalar in (0,1); got %g.', thresh);
    n_neurons = size(rm_raw, 3);
    subset    = subset(:)';
    assert(~isempty(subset) && all(subset == fix(subset)) && ...
           all(subset >= 1 & subset <= n_neurons), ...
        'population_fourier_analysis:subset', ...
        'subset must be integer neuron indices in 1..%d.', n_neurons);
    n = numel(subset);
    % ---------- scoped warning suppression ----------
    % onCleanup, not a bare warning('off'): this restores on error and on
    % Ctrl-C too. The old pipeline's bare warning('off') at line 7 left
    % warnings globally disabled for the rest of the MATLAB session.
    w0 = warning('off', 'all');
    restoreWarn = onCleanup(@() warning(w0));
    % ---------- preallocate ----------
    % NaN rather than zeros, so "loop never reached this cell" is
    % distinguishable from "analysed, found nothing". The old pipeline
    % preallocated com_count with zeros and could not tell them apart.
    count    = nan(n,1);
    n60      = nan(n,1);
    n90      = nan(n,1);
    wl_cm    = nan(n,1);
    gridness = nan(n,1);
    lobes    = cell(n,1);
    spectra  = [];                  % sized from the first result
    fprintf('[population_fourier_analysis] %d of %d neurons | thresh %.2f | rng base %d\n', ...
            n, n_neurons, thresh, rng_base);
    t0 = tic;
    % ---------- the loop ----------
    % Plain for, not parfor: fourier_analysis draws, and the per-cell seeding
    % below is what would make a parfor version reproducible if you convert
    % it later.
    for i = 1:n
        k = subset(i);
        % Seed per cell, not once before the loop. voronoi_baseline draws
        % ~50 shuffles' worth of randi/randperm, so a single up-front seed
        % makes cell i depend on every cell analysed before it, and
        % re-running one cell alone would not reproduce its population
        % result. Seeding on the neuron id also makes the answer independent
        % of subset composition and order.
        rng(rng_base + k);
        % fourier_analysis draws a figure per call. Close one only if that
        % call actually created it, so windows you already had open survive.
        % Becomes a no-op once the plotting block moves into fourier_plot.
        nfig = numel(findall(0, 'Type', 'figure'));
        r = fourier_analysis(rm_raw(:,:,k), rm_smooth(:,:,k), thresh);
        if numel(findall(0, 'Type', 'figure')) > nfig, close(gcf); end
        count(i)    = r.count;
        n60(i)      = r.n60;
        n90(i)      = r.n90;
        wl_cm(i)    = r.wl_cm;
        gridness(i) = r.gridness;
        lobes{i}    = r.lobes(:);
        % Size the store from the first result rather than hard-coding 81,
        % which would duplicate CROP from fourier_power and drift from it.
        if ~isempty(r.spectra)
            if isempty(spectra)
                spectra = zeros([size(r.spectra), n], 'single');
            end
            spectra(:,:,i) = single(r.spectra);   %#ok<AGROW> preallocated above
        end
        % r.pwr_clean is intentionally dropped -- see the header.
        if mod(i,25) == 0 || i == n
            el = toc(t0);
            fprintf('  %5d/%d   %6.1f s elapsed   ~%.0f s left\n', ...
                    i, n, el, el/i*(n-i));
        end
    end
    % ---------- population statistics ----------
    % Plain division on purpose: Inf means all 60 and no 90 (a perfectly
    % hexagonal population), NaN means no qualifying pairs at all. Both are
    % more informative than a guarded NaN, and it removes a branch.
    s60   = sum(n60, 'omitnan');
    s90   = sum(n90, 'omitnan');
    ratio = s60 / s90;
    % ---------- pack ----------
    % Fields assigned one at a time: struct('lobes', someCell) would build
    % a STRUCT ARRAY with one element per cell entry, not a scalar struct.
    res             = struct();
    res.subset      = subset;
    res.thresh      = thresh;
    res.rng_base    = rng_base;
    res.count       = count;
    res.lobes       = lobes;
    res.n60         = n60;
    res.n90         = n90;
    res.wl_cm       = wl_cm;
    res.gridness    = gridness;
    res.spectra     = spectra;
    res.s60         = s60;
    res.s90         = s90;
    res.ratio_60_90 = ratio;
    % ---------- summary ----------
    % median/min/max already ignore NaN, so none of this needs guarding.
    fprintf('\n[population_fourier_analysis] done in %.1f s\n', toc(t0));
    fprintf('  components : median %.1f   zero-component cells %d of %d\n', ...
            median(count, 'omitnan'), sum(count == 0), n);
    fprintf('  gridness   : median %.3f   passing 0.54: %d of %d\n', ...
            median(gridness, 'omitnan'), sum(gridness > 0.54), sum(~isnan(gridness)));
    fprintf('  spacing    : median %.2f cm   range %.2f - %.2f\n', ...
            median(wl_cm, 'omitnan'), min(wl_cm), max(wl_cm));
    fprintf('  60/90      : n60 %d  n90 %d  ratio %.3f\n', s60, s90, ratio);
end
