function G = plot_band_phase(outdir, popmode, sqmode)
%PLOT_BAND_PHASE  Phase-diagram panels for the alpha x R synaptic-damage sweep.
%
%   Reproduces the three panels of the progress-report phase diagram, with the
%   y-axis as DAMAGE RADIUS R (linear) rather than % area damaged. % area goes as
%   R^2, so equal steps in R produced a compressed, non-linear axis that squashed
%   the low-damage rows -- which is where the transition edge actually sits.
%
%   R increases DOWNWARD (R = 0 at the top), and dashed white lines mark integer
%   multiples of the sheet wavelength lambda = 13 neurons.
%
%     1. mean Fourier component count
%     2. 2-axis near-square proportion
%     3. mean gridness score          (Ying et al. 2023; grid cell if > 0.54)
%
%   G = plot_band_phase                            % default output_band3 in cwd
%   G = plot_band_phase(outdir)
%   G = plot_band_phase(outdir, popmode)           % 'all' (default) | 'inside'
%   G = plot_band_phase(outdir, popmode, sqmode)   % 'pop' (default) | 'cond'
%
%   THE GRID IS DISCOVERED FROM THE FILES, not hardcoded -- so this survives any
%   change to ALPHAS/RS in hpc_run_band.m without editing. It also means a stale
%   file from an older grid will silently add a row or column: if the reported
%   grid shape is not what you expect, check for leftovers in the output folder.
%
%   popmode  'all'    - PRIMARY. Every tracked neuron, all 78, at every grid point.
%                       Damage status is not observable experimentally: Ying et al.
%                       recorded grid cells in APP mice without knowing which had
%                       pathology nearby, so their population is a blind sample.
%                       Selecting on `inside` would measure something no experiment
%                       can, which breaks the comparison to their 3.62 -> 0.91. It
%                       also fixes the denominator at 78 for all 2346 grid points.
%            'inside' - SENSITIVITY CHECK ONLY -- do not use for the headline figure.
%                       Neurons inside the damaged disk. The count is a function of R
%                       by construction (0 at R=0, 12 at R=4, 36 at R=20, 78 at
%                       R>=58), so comparing across R compares samples of different
%                       size. Read along rows of constant R. Above R~58 it must agree
%                       with 'all' exactly, since every tracked cell is then inside
%                       the disk -- which makes it a free consistency test.
%
%   Because the readout is the whole population, R is best read as PREVALENCE (what
%   fraction of the network is affected) and alpha as SEVERITY (how badly an affected
%   synapse is compromised), rather than R as "lesion size".
%
%   sqmode   how the 2-axis near-square proportion is normalised:
%            'pop'  - (# 2-axis near-square cells) / (# cells)         <-- DEFAULT
%            'cond' - (# 2-axis near-square cells) / (# 2-axis cells)
%
%   READ THIS BEFORE INTERPRETING THE SQUARE PANEL. 'cond' is almost certainly
%   what the original slide plotted -- it is the only way that panel reaches 1.0
%   -- and it has a vanishing denominator. In the collapse region (low alpha,
%   large R) very few cells retain two resolvable axes, so the ratio is computed
%   from a handful of neurons and saturates at 0 or 1 while carrying almost no
%   information. That is what produced the saturated red block at the bottom-left
%   of the original figure. 'pop' has a constant denominator and cannot do this.
%   Both are computed; N2AXIS is returned so the conditional panel can be masked.
%
%   Returns G with fields ALPHAS, RS, one nA x nR grid per metric, NSEEN (seeds
%   found per grid point) and the pooled s60/s90 sums.
%
%   Files are read with an explicit variable list, so the large `spectra` and
%   `rm_*_tr` arrays are never loaded. Expect ~4-6 min for a full 18768-file grid.

if nargin < 1 || isempty(outdir),  outdir  = 'output_band3'; end
if nargin < 2 || isempty(popmode), popmode = 'all';          end
if nargin < 3 || isempty(sqmode),  sqmode  = 'pop';          end
assert(ismember(popmode, {'all','inside'}), 'popmode must be ''all'' or ''inside''');
assert(ismember(sqmode,  {'pop','cond'}),   'sqmode must be ''pop'' or ''cond''');
% ---------- replot-only entry point ----------
% Pass a saved grid instead of a sweep folder:
%     plot_band_phase('phase_band_all_pop.mat')
% Loads the reduced G and goes straight to plotting -- no aggregation, no access
% to the 18768 raw files. Use this to iterate on the figure locally when the
% sweep output lives on the cluster.
if (ischar(outdir) || isstring(outdir)) && endsWith(string(outdir), '.mat')
    assert(isfile(outdir), 'grid file not found: %s', outdir);
    G = load(outdir);
    fprintf('[phase] replotting from %s (no aggregation)\n', outdir);
    hp = draw_panels(G);
    hr = draw_ratio(G);
    [~, stem] = fileparts(char(outdir));
    try
        exportgraphics(hp, [stem '_replot.png'],       'Resolution', 200);
        exportgraphics(hr, [stem '_replot_ratio.png'], 'Resolution', 200);
        fprintf('[phase] wrote %s_replot.png and %s_replot_ratio.png\n', stem, stem);
    catch ME
        fprintf('[phase] PNG export failed (%s)\n', ME.message);
    end
    return
end

assert(exist(outdir,'dir')==7, 'output dir not found: %s', outdir);

files = dir(fullfile(outdir, 'bd_a*_R*_s*.mat'));
assert(~isempty(files), 'no bd_*.mat files in %s', outdir);
nf = numel(files);
fprintf('[phase] %d files found\n', nf);

% ---------- pass 1: per-file scalars ----------
fa = nan(nf,1); fR = nan(nf,1);
mComp = nan(nf,1); mGrid = nan(nf,1);
n2ax = zeros(nf,1); nsq = zeros(nf,1); ncell = zeros(nf,1);
v60 = zeros(nf,1); v90 = zeros(nf,1);
ok = false(nf,1);

t0 = tic;
for f = 1:nf
    fn = fullfile(files(f).folder, files(f).name);
    try
        D = load(fn, 'alpha','R','seed','counts','angles','gscore','inside','lobes');
    catch ME
        fprintf('  SKIP %s (%s)\n', files(f).name, ME.message);  continue
    end

    if strcmp(popmode,'inside'), sel = logical(D.inside(:));
    else,                        sel = true(numel(D.counts),1);
    end
    if ~any(sel), fa(f) = D.alpha; fR(f) = D.R; ok(f) = true; continue; end   % R=0 under 'inside'

    cnt = D.counts(sel);  gsc = D.gscore(sel);  ang = D.angles(sel);

    % --- two-axis near-square ---
    % `angles` is the axis form: sorted mod 180 with a 10 deg merge, so a cell
    % with exactly two entries has exactly two resolvable orientation axes.
    % Near-square = those two axes separated by 90 +/- 10 deg after folding.
    a2 = 0; s2 = 0;
    for k = 1:numel(ang)
        a = ang{k};  a = a(~isnan(a));
        if numel(a) ~= 2, continue; end
        a2 = a2 + 1;
        sep = abs(a(2) - a(1));  sep = min(sep, 180 - sep);
        if sep >= 80 && sep <= 100, s2 = s2 + 1; end
    end

    % --- 60/90 gaps, recomputed over the SELECTED population ---
    % NOT the saved s60/s90 scalars: hpc_run_band.m computes those over
    % `find(inside)` -- damaged cells only -- as a per-run log line. Reusing them
    % here would make the ratio describe a different population from the other
    % three panels, and would make it undefined at small R for no physical reason.
    % `lobes` is saved for every tracked cell, so the statistic is rebuilt here
    % under whatever popmode asked for. Counting rule is Ying's: consecutive gaps
    % round the sorted 0-360 lobe list, wrap duplicate at theta_1+360, open windows.
    lb = D.lobes(sel);
    c60 = 0; c90 = 0;
    for k = 1:numel(lb)
        L = lb{k};  L = L(~isnan(L));
        if numel(L) < 2, continue; end
        gaps = abs(diff([L(:); L(1) + 360]));
        c60 = c60 + sum(gaps > 50 & gaps < 70);
        c90 = c90 + sum(gaps > 80 & gaps < 100);
    end

    fa(f) = D.alpha;  fR(f) = D.R;
    mComp(f) = mean(cnt,'omitnan');  mGrid(f) = mean(gsc,'omitnan');
    n2ax(f) = a2;  nsq(f) = s2;  ncell(f) = numel(cnt);
    v60(f) = c60;   v90(f) = c90;
    ok(f) = true;

    if mod(f, 2000) == 0, fprintf('  %d/%d\n', f, nf); end
end
fprintf('[phase] loaded in %.1f s (%d usable)\n', toc(t0), nnz(ok));

% ---------- discover the grid ----------
ALPHAS = unique(round(fa(ok), 6));   ALPHAS = ALPHAS(:)';
RS     = unique(round(fR(ok), 6));   RS     = RS(:)';
nA = numel(ALPHAS); nR = numel(RS);
fprintf('[phase] grid discovered: %d alpha x %d R  (alpha %.3f..%.3f, R %g..%g)\n', ...
        nA, nR, min(ALPHAS), max(ALPHAS), min(RS), max(RS));

% ---------- pass 2: accumulate ----------
z = @() zeros(nA,nR);
A.comp=z(); A.grid=z(); A.sq=z(); A.n2=z(); A.nc=z(); A.s60=z(); A.s90=z(); A.n=z();
for f = find(ok)'
    ia = find(abs(ALPHAS - round(fa(f),6)) < 1e-9, 1);
    ir = find(abs(RS     - round(fR(f),6)) < 1e-9, 1);
    if isempty(ia) || isempty(ir), continue; end
    A.n(ia,ir) = A.n(ia,ir) + 1;
    if isnan(mComp(f)), continue; end                 % 'inside' with no cells
    A.comp(ia,ir) = A.comp(ia,ir) + mComp(f);
    A.grid(ia,ir) = A.grid(ia,ir) + mGrid(f);
    A.sq(ia,ir)   = A.sq(ia,ir)   + nsq(f);
    A.n2(ia,ir)   = A.n2(ia,ir)   + n2ax(f);
    A.nc(ia,ir)   = A.nc(ia,ir)   + ncell(f);
    A.s60(ia,ir)  = A.s60(ia,ir)  + v60(f);
    A.s90(ia,ir)  = A.s90(ia,ir)  + v90(f);
end

NSEED_EXP = mode(A.n(A.n>0));
miss = A.n == 0;
if any(miss(:))
    fprintf('[phase] WARNING: %d of %d grid points have NO data\n', nnz(miss), nA*nR);
end
inc = A.n > 0 & A.n < NSEED_EXP;
if any(inc(:))
    fprintf('[phase] %d grid points incomplete (min %d of %d seeds)\n', ...
            nnz(inc), min(A.n(inc)), NSEED_EXP);
end

% ---------- reduce ----------
nz = max(A.n, 1);
G.ALPHAS = ALPHAS;  G.RS = RS;  G.NSEEN = A.n;
G.popmode = popmode;  G.sqmode = sqmode;
G.meanComp = A.comp ./ nz;   G.meanComp(miss) = NaN;
G.meanGrid = A.grid ./ nz;   G.meanGrid(miss) = NaN;
G.N2AXIS   = A.n2   ./ nz;                       % 2-axis cells per run
G.NSQ      = A.sq   ./ nz;
G.s60 = A.s60;  G.s90 = A.s90;
% Provenance stamp: lets draw_ratio tell a freshly aggregated grid from a
% legacy .mat whose s60/s90 came from the damaged-cells-only log scalars.
G.ratio_source = sprintf('recomputed from lobes over popmode=%s', popmode);
G.ratio = A.s60 ./ max(A.s90, eps);              % counts pooled across seeds first --
G.ratio(A.s90 == 0) = NaN;                       % never average per-seed ratios
G.npair = (A.s60 + A.s90) ./ max(A.nc, eps);     % symmetry-bearing gaps per cell
G.fsq   = A.s90 ./ max(A.s60 + A.s90, eps);
G.fsq(A.s60 + A.s90 == 0) = NaN;

switch sqmode
    case 'pop',  G.sqProp = A.sq ./ max(A.nc, eps);
    case 'cond', G.sqProp = A.sq ./ max(A.n2, eps);
end
G.sqProp(miss) = NaN;
if strcmp(sqmode,'cond')
    thin = G.N2AXIS < 5;                          % <5 two-axis cells per run
    G.sqProp(thin) = NaN;
    fprintf(['[phase] ''cond'' mode: %d grid points masked for having <5 two-axis\n' ...
             '        cells per run -- there this metric is undefined, not extreme.\n'], ...
             nnz(thin & ~miss));
end

% ---------------- plot ----------------
hp = draw_panels(G);
hr = draw_ratio(G);

stem = sprintf('phase_band_%s_%s', popmode, sqmode);
% <<< CHANGED: save the grids BEFORE exporting. exportgraphics can fail on a
%     headless compute node, and a minutes-long aggregation over ~19k files must
%     not be lost to a plotting call.
save([stem '.mat'], '-struct', 'G');
fprintf('[phase] wrote %s.mat\n', stem);
try
    exportgraphics(hp, [stem '.png'],       'Resolution', 200);
    exportgraphics(hr, [stem '_ratio.png'], 'Resolution', 200);
    fprintf('[phase] wrote %s.png and %s_ratio.png\n', stem, stem);
catch ME
    fprintf('[phase] PNG export failed (%s)\n        grids are safe in %s.mat -- plot locally\n', ...
            ME.message, stem);
end

% gridness is "higher is better"; flip its colormap if you prefer red = damaged:
%   colormap(subplot(1,3,3), flipud(turbo))
%
% Sanity checks worth running on the returned struct:
%   G.meanGrid(G.ALPHAS==1, :)   % alpha = 1 column: no damage, should be flat
%   G.meanGrid(:, G.RS==0)       % R = 0 row:       no damage, should match it
end


function h = draw_panels(G)
%DRAW_PANELS  The three phase-diagram panels. Single source of truth, called
%   both after a fresh aggregation and from the .mat replot entry point.
    ALPHAS = G.ALPHAS;  RS = G.RS;
    nA = numel(ALPHAS); nR = numel(RS);

    % Colour convention: RED = DEGRADED in every panel. Component count and
    % gridness are "high = healthy", so their maps are REVERSED; the near-square
    % proportion is "high = degraded" and keeps turbo as-is. Without this the
    % three panels attach opposite meanings to the same colour and cannot be
    % compared by eye. Fourth column is the reverse flag.
    panels = { G.meanComp', 'mean component count',          'components/cell', true
               G.sqProp',   '2-axis near-square proportion', 'proportion',      false
               G.meanGrid', 'mean gridness score',           'gridness',        true };

    xt = unique(round(linspace(1, nA, 6)));
    yt = unique(round(linspace(1, nR, 8)));

    % --- lambda reference lines ---
    % lambda = 13 neurons is the inhibitory-kernel periodicity (beta = 3/lambda^2
    % in hpc_run_band.m) -- the grid wavelength ON THE NEURAL SHEET. R is in the
    % same units, so these mark where the damage disk spans an integer number of
    % sheet periods. Placed by interpolating into the index space imagesc uses, so
    % they land correctly even though the R grid steps by 2 and never samples an
    % odd multiple of 13 exactly.
    %
    % NB the measured gridness troughs sit at R ~ 19 / 37 / 55, a spacing of ~18 ~
    % sqrt(2)*lambda -- they do NOT coincide with these lines. See
    % CAN_sweep_results_memo.md before reading any alignment into them.
    LAMBDA = 13;
    Rlines = LAMBDA : LAMBDA : max(RS);
    ypos   = interp1(RS, 1:nR, Rlines);
    ypos   = ypos(isfinite(ypos));

    h = figure('Color','w','Position',[80 80 1500 460]);
    for p = 1:3
        subplot(1,3,p);
        % AlphaData is what actually makes NaN show the axes background. Setting
        % the axes Color alone does nothing -- NaN would render as the bottom
        % colour of the map and read as a real, extreme value.
        Z = panels{p,1};
        imagesc(1:nA, 1:nR, Z, 'AlphaData', ~isnan(Z));      % rows = R, cols = alpha
        % YDir reverse: R = 0 at the TOP, increasing downward, so the healthy edge
        % is at the top and damage deepens as the eye travels down.
        set(gca,'YDir','reverse','Color',[0.85 0.85 0.85]);  % NaN renders grey
        if panels{p,4}, colormap(gca, flipud(turbo));
        else,           colormap(gca, turbo);
        end
        xlabel('\alpha  (severity)'); ylabel('damage radius R  (prevalence)');
        title(panels{p,2}, 'FontWeight','normal');
        set(gca, 'XTick', xt, 'XTickLabel', compose('%.2f', ALPHAS(xt)), ...
                 'YTick', yt, 'YTickLabel', compose('%g', RS(yt)), 'TickDir','out');

        hold on
        for q = 1:numel(ypos)
            yl = yline(ypos(q), '--', sprintf('%d\\lambda', q));
            yl.Color = 'w';  yl.LineWidth = 0.9;  yl.Alpha = 0.65;
            yl.FontSize = 7; yl.Interpreter = 'tex';
            yl.LabelHorizontalAlignment = 'left';
            yl.LabelVerticalAlignment   = 'bottom';
        end
        hold off

        cb = colorbar; cb.Label.String = panels{p,3};
        box off
    end

    NSEED_EXP = mode(G.NSEEN(G.NSEEN > 0));
    sgtitle(sprintf(['Synaptic damage phase diagram  --  red = degraded in all panels' ...
                     '  |  population: %s,  square metric: %s  (%d/%d grid points complete)'], ...
                     G.popmode, G.sqmode, nnz(G.NSEEN >= NSEED_EXP), nA*nR), 'FontSize', 11);
end


function h = draw_ratio(G)
%DRAW_RATIO  The 60/90 symmetry ratio, as its own figure.
%
%   Log colour scale, reversed turbo so LOW ratio (square-dominant, degraded) is
%   red -- matching the three-panel convention. Colourbar ticks include Ying et
%   al.'s published endpoints 3.62 (nTG-y) and 0.91 (APP-a) so the model surface
%   can be read directly against the biomarker range. No contours: they obscure
%   the fine structure this grid resolves.
%
%   POPULATION. s60/s90 are recomputed in pass 1 from the saved per-cell `lobes`
%   over whatever popmode selects, so this figure describes the same population as
%   the three panels. It deliberately does NOT use the s60/s90 scalars stored by
%   hpc_run_band.m: those are summed over `find(inside)` -- damaged cells only --
%   as a per-run log line, which would silently make this panel a different
%   measurement from the ones beside it.
    ALPHAS = G.ALPHAS;  RS = G.RS;
    nA = numel(ALPHAS); nR = numel(RS);

    % Mask PER RUN, not on the seed-summed total: G.s90 is the sum over all seeds
    % at a grid point, so a threshold on it would essentially never fire. Grey
    % therefore marks "typical run had fewer than NMIN ninety-degree gaps", which
    % is where the ratio is a handful of counts and carries no information --
    % the healthy edge (no square components) and small R (few damaged cells).
    % Colour limits, symmetric in log about ratio = 1 (equal numbers of 60 and 90
    % degree gaps), so the midpoint of the map is the balance point and red/blue
    % are equally weighted. Chosen from the measured distribution over points with
    % n90 >= NMIN per run: p25 = 0.16, median = 0.97, p95 = 8.2, max = 24.2. The
    % previous [0.5 6] window put 38% of points on the bottom colour and 8% on the
    % top -- nearly half the map unresolved. At [0.05 20] the only clamping left
    % at the bottom is points with ratio at or near exactly zero (no 60 degree
    % gaps at all), which cannot be placed on a log axis in any case.
    NMIN = 10;  BOT = 0.05;  TOP = 20;
    n90_per_run = G.s90 ./ max(G.NSEEN, 1);

    % Points with fewer than NMIN ninety-degree gaps per run are shown at the TOP
    % of the scale rather than greyed out. They are not a separate category: too
    % few 90-degree components means the cells are hexagon-dominated, which is the
    % same end of the axis as a large finite ratio. Grey read as a third state and
    % broke the continuity of the surface.
    %
    % CAVEAT: this conflates "strongly hexagonal" with "too few cells to say", and
    % the two coincide at small R under the inside-cells-only population, where
    % barely any tracked cell lies in the disk. Do not read the top band as a
    % measured result.
    Rt = G.ratio;
    Rt(n90_per_run < NMIN) = Inf;
    Rt(isnan(Rt))          = Inf;
    L = log10(min(max(Rt, BOT), TOP))';

    if isfield(G, 'ratio_source')
        src = sprintf('population: %s', G.popmode);
    else
        src = 'LEGACY GRID -- damaged cells only';
    end

    h = figure('Color','w','Position',[120 120 900 580]);
    imagesc(1:nA, 1:nR, L);
    set(gca,'YDir','reverse');
    colormap(gca, flipud(turbo));
    clim(log10([BOT TOP]));

    % End labels carry < and > because both ends are clamped: everything below 0.5
    % and above 6 renders as the end colour, so the extremes are not resolvable.
    % Bar is in log10 units, so the scale is symmetric about 0 (= ratio 1, equal
    % numbers of 60 and 90 degree gaps). Ying et al.'s published APP-a and nTG-y
    % values are marked in ratio units alongside their log positions, so the model
    % surface can be read straight against the biomarker range.
    tickR = [BOT 0.2 0.91 3.62 TOP];
    cb = colorbar;  cb.Ticks = log10(tickR);
    % Kept short: longer annotations overflow the figure and push the colourbar
    % label off the canvas. Which group each value belongs to goes in the caption.
    cb.TickLabels = { sprintf('%.2f', log10(BOT)), ...
                      sprintf('%.2f', log10(0.2)), ...
                      sprintf('%.2f  (0.91)', log10(0.91)), ...
                      sprintf('%.2f  (3.62)', log10(3.62)), ...
                      sprintf('%.2f', log10(TOP)) };
    cb.Label.String = 'log_{10} ( 60\circ/90\circ ratio )';

    style_axes(ALPHAS, RS);
    title({'60\circ/90\circ ratio', src}, 'FontSize', 10, 'FontWeight','normal');
end


function style_axes(ALPHAS, RS)
%STYLE_AXES  Shared tick labelling and lambda reference lines.
%   lambda = 13 neurons is the inhibitory-kernel periodicity (beta = 3/lambda^2),
%   i.e. the grid wavelength ON THE NEURAL SHEET; R is in the same units, so these
%   mark integer numbers of sheet periods spanned by the damage disk. Placed by
%   interpolating into imagesc index space, so they land correctly even though the
%   R grid steps by 2 and never samples an odd multiple of 13.
%
%   NB the measured gridness troughs sit at R ~ 19 / 37 / 55, spacing ~18 ~
%   sqrt(2)*lambda -- they do NOT coincide with these lines.
    nA = numel(ALPHAS);  nR = numel(RS);
    xt = unique(round(linspace(1, nA, 6)));
    yt = unique(round(linspace(1, nR, 8)));
    set(gca, 'XTick', xt, 'XTickLabel', compose('%.2f', ALPHAS(xt)), ...
             'YTick', yt, 'YTickLabel', compose('%g', RS(yt)), 'TickDir','out');
    xlabel('\alpha  (severity)'); ylabel('damage radius R  (prevalence)');

    LAMBDA = 13;
    ypos = interp1(RS, 1:nR, LAMBDA:LAMBDA:max(RS));
    ypos = ypos(isfinite(ypos));
    hold on
    for q = 1:numel(ypos)
        yl = yline(ypos(q), '--', sprintf('%d\\lambda', q));
        yl.Color = 'w';  yl.LineWidth = 0.9;  yl.Alpha = 0.65;
        yl.FontSize = 7; yl.Interpreter = 'tex';
        yl.LabelHorizontalAlignment = 'left';
        yl.LabelVerticalAlignment   = 'bottom';
    end
    hold off
    box off
end
