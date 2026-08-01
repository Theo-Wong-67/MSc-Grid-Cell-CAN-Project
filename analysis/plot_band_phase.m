function G = plot_band_phase(outdir, popmode, sqmode)
%PLOT_BAND_PHASE  Phase-diagram panels for the alpha x R synaptic-damage sweep.
%
%   Reproduces the three panels of the progress-report phase diagram, with the
%   y-axis as DAMAGE RADIUS R (linear) rather than % area damaged. % area goes as
%   R^2, so equal steps in R produced a compressed, non-linear axis that squashed
%   the low-damage rows -- which is where the transition edge actually sits.
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
%   popmode  'all'    - metrics over every tracked neuron (matches the old slides)
%            'inside' - only neurons inside the damaged disk (`inside` flag).
%                       More targeted, but at small R only a handful of cells
%                       qualify and at R = 0 none do, so the low-R rows go NaN.
%                       Compare both.
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
        D = load(fn, 'alpha','R','seed','counts','angles','gscore','inside','s60','s90');
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

    fa(f) = D.alpha;  fR(f) = D.R;
    mComp(f) = mean(cnt,'omitnan');  mGrid(f) = mean(gsc,'omitnan');
    n2ax(f) = a2;  nsq(f) = s2;  ncell(f) = numel(cnt);
    v60(f) = D.s60; v90(f) = D.s90;
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
panels = { G.meanComp', 'mean component count',          'components/cell'
           G.sqProp',   '2-axis near-square proportion', 'proportion'
           G.meanGrid', 'mean gridness score',           'gridness' };

xt = unique(round(linspace(1, nA, 6)));
yt = unique(round(linspace(1, nR, 8)));

figure('Color','w','Position',[80 80 1500 460]);
for p = 1:3
    subplot(1,3,p);
    imagesc(1:nA, 1:nR, panels{p,1});                    % rows = R, cols = alpha
    set(gca,'YDir','normal','Color',[0.85 0.85 0.85]);   % NaN renders grey
    colormap(gca, turbo);
    xlabel('\alpha'); ylabel('damage radius R');
    title(panels{p,2}, 'FontWeight','normal');
    set(gca, 'XTick', xt, 'XTickLabel', compose('%.2f', ALPHAS(xt)), ...
             'YTick', yt, 'YTickLabel', compose('%g', RS(yt)), 'TickDir','out');
    cb = colorbar; cb.Label.String = panels{p,3};
    box off
end
sgtitle(sprintf(['Synaptic damage phase diagram  --  population: %s,  square metric: %s' ...
                 '  (%d/%d grid points complete)'], popmode, sqmode, ...
                 nnz(A.n >= NSEED_EXP), nA*nR), 'FontSize', 11);

stem = sprintf('phase_band_%s_%s', popmode, sqmode);
exportgraphics(gcf, [stem '.png'], 'Resolution', 200);
save([stem '.mat'], '-struct', 'G');
fprintf('[phase] wrote %s.{png,mat}\n', stem);

% gridness is "higher is better"; flip its colormap if you prefer red = damaged:
%   colormap(subplot(1,3,3), flipud(turbo))
%
% Sanity checks worth running on the returned struct:
%   G.meanGrid(G.ALPHAS==1, :)   % alpha = 1 column: no damage, should be flat
%   G.meanGrid(:, G.RS==0)       % R = 0 row:       no damage, should match it
end
