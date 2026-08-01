function T = validate_against_ying(datapath)
%VALIDATE_AGAINST_YING  Regression check of the pipeline against Ying et al. (2023).
%
%   Run this after ANY change to population_fourier_analysis.m, before trusting
%   a sweep. Takes ~15 min for all 171 cells (the LIVE arm runs a 50-shuffle
%   Voronoi baseline per cell at ~4.1 s/cell since the seeding fix).
%
%   T = validate_against_ying()                % default data path
%   T = validate_against_ying('C:\...\grid_data.mat')
%
%   Reports two arms per group:
%     LIVE  - the pipeline as it stands, own Voronoi shuffle (stochastic).
%     REPRO - detection rebuilt with Ying's OWN recovered per-cell baseline,
%             extracted exactly as (col3 - col4) on surviving pixels. Deterministic.
%             This is the arm that should reproduce their published figures.
%
%   Reference values, all measured 2026-08-01:
%     published        3.62 / 3.61 / 2.48 / 0.91
%     their code       3.55 / 3.59 / 2.55 / 0.91   (their stored col 10)
%     REPRO expected   3.55 / 3.59 / 2.55 / 0.91   -- EXACT, all four groups
%     LIVE  expected   3.690 / ? / ? / ?           (wty measured; others UNMEASURED)
%
%   REPRO reproducing their_code exactly is the pass condition. If it drifts, the
%   detection path has changed. A REPRO of 3.55/3.36/2.55/0.84 specifically means
%   the exact-zero -> NaN behaviour has been lost (see the comment in the loop).
%
%   LIVE runs ~4% above REPRO on wty (3.690 vs 3.5517). That gap is DETERMINISTIC --
%   two independent runs were bit-identical -- and comes from three things that
%   cannot be replicated: they pooled 35 of 50 shuffles for that group, normalised
%   the observed spectrum by temporal rate while normalising the shuffles by the
%   spatial mean, and seeded the tessellation with CMBHOME kernel-2 rather than
%   imgaussfilt(.,0.5). Do NOT tune SEED_SIGMA to close it.
%
%   Watch the "Voronoi seeds/cell" line each group prints. It must sit inside
%   Ying's ~40-140 band (expect ~100). Outside that, the baseline is biased --
%   at 21 seeds it ran 19% low and inflated the ratio to 3.82.
%
%   LIVE differs from REPRO by design: their baseline pooled only 35/51/31/38 of
%   50 shuffles depending on group (the `ii < size(allmaps,1)` guard) and let the
%   real spectrum into nTG-a's own noise floor, and normalised the real map by the
%   temporal firing rate while the shuffles used the spatial mean. Ours does
%   neither. On wty that is worth about +7%.

if nargin < 1 || isempty(datapath)
    here = fileparts(fileparts(mfilename('fullpath')));
    datapath = fullfile(here, 'data', 'ying et al. 2023', 'grid_data.mat');
end
assert(exist(datapath, 'file') == 2, 'grid_data.mat not found at %s', datapath);

THRESH = 0.25;                        % Ying's value; do not use the model's 0.43 here
vars   = {'wty_data','wta_data','j20y_data','j20a_data'};
nm     = {'wty (nTG-y)','wta (nTG-a)','j20y (APP-y)','j20a (APP-a)'};
pub    = [3.62 3.61 2.48 0.91];
theirs = [3.55 3.59 2.55 0.91];

m = matfile(datapath);
live = nan(4,1); repro = nan(4,1); mc_live = nan(4,1); mc_ying = nan(4,1);

for g = 1:4
    c1 = m.(vars{g})(:,1);  c2 = m.(vars{g})(:,2);
    c3 = m.(vars{g})(:,3);  c4 = m.(vars{g})(:,4);
    c5 = cell2mat(m.(vars{g})(:,5));
    N  = numel(c1);
    raw = zeros(36,36,N); smo = raw;
    for i = 1:N, raw(:,:,i) = double(c1{i}); smo(:,:,i) = double(c2{i}); end

    % ---------- LIVE ----------
    fprintf('[validate] %s LIVE (%d cells, own Voronoi shuffle)...\n', nm{g}, N);
    set(0,'DefaultFigureVisible','off');
    [cc, ~, ~, ~, lobe] = population_fourier_analysis(raw, smo, THRESH, 1:N);
    close all; set(0,'DefaultFigureVisible','on');
    [live(g), a, b] = ying_ratio(lobe, 1:N);
    mc_live(g) = mean(cc(1:N));  mc_ying(g) = mean(c5);
    fprintf('           ratio %.2f  (n60=%d n90=%d)  mean comps %.2f vs Ying %.2f\n', ...
            live(g), a, b, mc_live(g), mc_ying(g));

    % ---------- REPRO (deterministic, their own baseline) ----------
    lob = cell(N,1);
    for i = 1:N
        rm = double(c1{i}); a3 = double(c3{i}); a4 = double(c4{i});
        k = a4 > 0; if nnz(k) == 0, continue; end
        frac = median(a3(k) - a4(k)) / max(a3(:));   % scale-invariant recovered baseline
        mfr = mean(rm(:)); if isnan(mfr) || mfr == 0, mfr = 1; end
        pad = zeros(256); pad(111:146,111:146) = rm;
        imgX = (1/(mfr*36)) * fftshift(fft2(pad));  pw = abs(imgX.^2);
        [rr,cc2] = ndgrid(1:256,1:256); [mr,mcx] = find(ismember(pw, max(pw(:))));
        gg = 1 - exp(-((rr-mr(1)).^2 + (cc2-mcx(1)).^2)./2);  pw = pw .* (gg == 1);
        pc = max(pw - frac*max(pw(:)), 0);
        pc(pc < THRESH*max(pc(:))) = 0;
        pr = regionprops(pc > 0, 'Area','Centroid');  pr = pr([pr.Area] >= 10);
        if isempty(pr), continue; end
        ce = reshape([pr.Centroid],2,[])';
        dx = ce(:,1) - 128.5;  dy = 128.5 - ce(:,2);
        ang = mod(atan2d(-1./dy, 1./dx), 360);
        % Ying normalise v2 = [wx, wy, 0] by its norm before the dot product. When a
        % displacement is exactly zero the corresponding w is Inf, so that component
        % becomes Inf/Inf = NaN and acos returns NaN. Algebraically simplifying the
        % dot product (as atan2 does) yields a finite 0/90/180/270 instead and does
        % NOT reproduce them -- it cost 6.5% on APP-a and 6.4% on nTG-a. Reproduce it.
        ang(dx == 0 | dy == 0) = NaN;
        lob{i} = sort(ang);          % NaN sorts last, exactly as in their code
    end
    [repro(g), a, b] = ying_ratio(lob, 1:N);
    fprintf('           REPRO %.2f  (n60=%d n90=%d)   their code %.2f   published %.2f\n', ...
            repro(g), a, b, theirs(g), pub(g));
end

T = table(nm(:), pub(:), theirs(:), repro, live, mc_ying, mc_live, ...
    'VariableNames', {'group','published','their_code','REPRO','LIVE','meanComp_Ying','meanComp_ours'});
disp(' '); disp(T);
fprintf('REPRO should sit within a few %% of their_code. LIVE is expected to run\n');
fprintf('higher -- that is the shuffle-pooling and normalisation fix, not an error.\n');
end

function [r, n60, n90] = ying_ratio(lobe, idx)
% Ying's Figure 2e-f rule: lobe-level, wrap-around duplicate, OPEN windows.
n60 = 0; n90 = 0;
for k = idx
    L = lobe{k};
    if numel(L) < 2, continue; end
    d = abs(diff([L(:); L(1) + 360]));
    n60 = n60 + sum(d > 50 & d < 70);
    n90 = n90 + sum(d > 80 & d < 100);
end
r = n60 / max(n90, eps);
end
