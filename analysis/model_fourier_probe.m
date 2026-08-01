function model_fourier_probe(alpha, R, steps, nsel, tag)
%MODEL_FOURIER_PROBE  Run the CAN model and analyse it with the Ying-faithful pipeline.
%
%   Exists because nothing in the project currently SAVES model rate maps --
%   sweep outputs store angles/spectra/counts only, so the Voronoi baseline can
%   never be recomputed offline (this is why the 95th -> 75th fix forces a full
%   sweep re-run rather than a re-analysis). This probe saves rm_raw/rm_smooth so
%   that any future analysis change can be applied without re-simulating.
%
%   model_fourier_probe()                     -> healthy, 400k steps, 60 neurons
%   model_fourier_probe(0.30, 64, 400000, 60, 'dmg')
%
%   alpha  synaptic output scaling inside the lesion (1 = healthy)
%   R      lesion radius in neurons (0 = none)
%   steps  simulation steps. USE 400000 -- see the warning below.
%   nsel   number of tracked neurons sampled from the sheet interior
%   tag    filename tag
%
%   WARNING ON `steps`. At 38k steps an UNDAMAGED network measures
%   6.62 components / gridness 0.205 / ratio 1.26; at 400k the same network gives
%   3.01 components and a ratio of 437. Short runs are not a cheap approximation
%   of long ones -- the lattice has not settled and the trajectory has not covered
%   the arena, and both failures mimic damage. Do not calibrate on a short run.

if nargin < 1 || isempty(alpha), alpha = 1.0;    end
if nargin < 2 || isempty(R),     R     = 0;      end
if nargin < 3 || isempty(steps), steps = 400000; end
if nargin < 4 || isempty(nsel),  nsel  = 60;     end
if nargin < 5 || isempty(tag),   tag   = sprintf('a%03.0f_R%03.0f', alpha*100, R); end

% Burak & Fiete (2009) parameters, matching gc_dynamics
n = 128; tau = 10; dt = 0.5; beta = 3/13^2;
alphabar = 1.05; abar = 1; wtphase = 2; eta_0 = 0.123;
THRESH = 0.25;   % 0.25 matches Ying. Raise toward 0.43 only if the second
                 % reciprocal-lattice shell (sqrt(3)x radius, 30 deg offset)
                 % survives thresholding -- it converts every 60 deg gap into
                 % two 30 deg gaps and destroys the statistic.

fprintf('[probe] alpha=%.2f R=%g steps=%d\n', alpha, R, steps);
t0 = tic;
[~, ~, rm_smooth, sNeurons, rm_raw, dmg] = gc_periodic_alpha( ...
    n, tau, dt, beta, alphabar, abar, wtphase, steps, eta_0, alpha, R);
fprintf('[probe] simulation %.1f min\n', toc(t0)/60);

% tracked neurons: an evenly spaced interior grid, avoiding the sheet edge
side = round(sqrt(nsel));
[gx, gy] = meshgrid(round(linspace(24, n-24, side)), round(linspace(24, n-24, side)));
sel = unique(sub2ind([n n], gy(:), gx(:)))';

outdir = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'results', 'model_probe');
if ~exist(outdir, 'dir'), mkdir(outdir); end

% population_fourier_analysis draws three diagnostic figures -- the component-count
% histogram, 25 random neurons (rate map + spectrum), and the wavelength
% distribution. Leave them ON SCREEN and also save them to disk.
figs_before = findobj('Type', 'figure');
[com_count, phi_cell, spectra, gridness, lobe_cell] = ...
    population_fourier_analysis(rm_raw, rm_smooth, THRESH, sel);
new_figs = setdiff(findobj('Type', 'figure'), figs_before);
for i = 1:numel(new_figs)
    nm = get(new_figs(i), 'Name');
    if isempty(nm), nm = sprintf('fig%d', i); end
    nm = regexprep(nm, '[^\w]+', '_');
    exportgraphics(new_figs(i), fullfile(outdir, sprintf('%s_%s.png', tag, nm)), 'Resolution', 150);
end
fprintf('[probe] %d figures drawn and saved to %s\n', numel(new_figs), outdir);

% Ying's 60/90 rule on the lobe angles
n60 = 0; n90 = 0;
for k = sel
    L = lobe_cell{k};
    if numel(L) < 2, continue; end
    d = abs(diff([L(:); L(1) + 360]));
    n60 = n60 + sum(d > 50 & d < 70);
    n90 = n90 + sum(d > 80 & d < 100);
end
ratio = n60 / n90;                 % Inf when n90 == 0 -- expected for a clean lattice
f     = n90 / max(n60 + n90, eps); % bounded alternative, use this for calibration

fprintf('\n[probe] %d neurons | mean components %.2f | median gridness %.3f\n', ...
        numel(sel), mean(com_count(sel)), median(gridness(sel), 'omitnan'));
fprintf('[probe] n60 = %d, n90 = %d -> ratio %.3f, f = %.4f\n', n60, n90, ratio, f);
fprintf('[probe] Ying targets  ratio 3.60 / 2.77 / 2.05 / 0.84   f 0.22 -> 0.52\n');
if n90 == 0
    fprintf('[probe] NOTE n90 = 0: ratio is undefined. Report f, not the ratio.\n');
end

out = fullfile(outdir, sprintf('probe_%s.mat', tag));
save(out, 'rm_raw', 'rm_smooth', 'sel', 'com_count', 'phi_cell', 'lobe_cell', ...
     'spectra', 'gridness', 'n60', 'n90', 'ratio', 'f', 'alpha', 'R', 'steps', ...
     'THRESH', 'dmg', 'sNeurons', '-v7.3');
fprintf('[probe] saved %s\n', out);
end
