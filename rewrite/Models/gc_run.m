function out = gc_run(alpha, R, sigma_v, thresh, seed, noise_law)
%GC_RUN  Simulate one condition and analyse it.
%
%   gc_run()                       healthy baseline
%   gc_run(alpha, R)               synaptic damage, severity alpha on a disc radius R
%   gc_run([], [], sigma_v)        afferent velocity noise, sigma_v in m/s
%   gc_run(alpha, R, sigma_v)      both, via gc_combined
%   gc_run(..., thresh)            power threshold, default 0.43
%   gc_run([], [], sigma_v, thresh, seed, 'sd')

arguments
    alpha   double = []
    R       double = []
    sigma_v double = []
    thresh  double = 0.43
    seed    double = []      % [] leaves the stream alone, as gc_dynamics does
    noise_law (1,:) char {mustBeMember(noise_law, {'const','sd'})} = 'const'
end
assert(isempty(alpha) == isempty(R), 'gc_run:damage', ...
       'synaptic damage needs both alpha and R.');
assert(~(strcmp(noise_law,'sd') && isempty(sigma_v)), 'gc_run:noise_law', ...
       'noise_law = ''sd'' needs a sigma_v; there is no noise to make signal-dependent.');
% The combined + sd path routes to gc_combined_sd, generated from gc_combined
% with ONE dynamical line changed. Verified 2026-08-14: equals gc_combined at
% sigma_v = 0 and gc_sdnoise at alpha = 1, both to max|delta| = 0.
% Burak & Fiete (2009) parameters
p.n = 128;  p.tau = 10;  p.dt = 0.5;  p.lambda = 13;  p.beta = 3/p.lambda^2;
p.alphabar = 1.05;  p.abar = 1;  p.wtphase = 2;
p.steps = 400000;   p.eta_0 = 0.123;
p.mu_v  = 0.4998;   % measured mean speed, m/s
arg = {p.n, p.tau, p.dt, p.beta, p.alphabar, p.abar, p.wtphase, p.steps, p.eta_0};
if ~isempty(seed), rng(seed); end    % reproducible random walk
t0  = tic;
dmg = [];
if ~isempty(alpha) && ~isempty(sigma_v)
    mode = 'combined'; if strcmp(noise_law,'sd'), mode = 'combined_sd'; end
    fprintf('[gc_run] combined | law=%s alpha=%g R=%g sigma_v=%g m/s | %d steps\n', noise_law, ...
            alpha, R, sigma_v, p.steps);
    if strcmp(noise_law, 'sd')
        [rm_raw, rm_smooth, dmg] = gc_combined_sd(arg{:}, alpha, R, sigma_v, p.mu_v);
    else
        [rm_raw, rm_smooth, dmg] = gc_combined(arg{:}, alpha, R, sigma_v);
    end
elseif ~isempty(alpha)
    mode = 'alpha';
    fprintf('[gc_run] damage | alpha=%g R=%g | %d steps\n', alpha, R, p.steps);
    [rm_raw, rm_smooth, dmg] = gc_alpha(arg{:}, alpha, R);
elseif ~isempty(sigma_v) && strcmp(noise_law, 'sd')
    % Signal-dependent: SD scales as sqrt(|v|/mu_v), so accumulated position
    % variance goes with DISTANCE rather than elapsed time (Stangl et al. 2020).
    % Mean noise power is identical to 'const' at the same sigma_v, and both
    % consume one randn(n,n) per step from the same stream -- so a matched-seed
    % pair differs ONLY in the noise law.
    mode = 'noise_sd';
    fprintf('[gc_run] noise (signal-dependent) | sigma_v=%g m/s at mu_v=%g | %d steps\n', ...
            sigma_v, p.mu_v, p.steps);
    [rm_raw, rm_smooth] = gc_sdnoise(arg{:}, sigma_v, p.mu_v);
elseif ~isempty(sigma_v)
    mode = 'noise';
    fprintf('[gc_run] noise | sigma_v=%g m/s | %d steps\n', sigma_v, p.steps);
    [rm_raw, rm_smooth] = gc_noise(arg{:}, sigma_v);
else
    mode = 'baseline';
    fprintf('[gc_run] baseline | %d steps\n', p.steps);
    [rm_raw, rm_smooth] = gc_baseline(arg{:});
end
fprintf('[gc_run] simulated in %.1f min\n', toc(t0)/60);
[tracked, radius] = tracked_subset(p.n);
inside = false(numel(tracked), 1);
if ~isempty(dmg), inside = ismember(tracked(:), dmg.idx_damaged(:)); end
res = population_fourier_analysis(rm_raw, rm_smooth, thresh, tracked);
% No `tracked` or `thresh` field: they are res.subset and res.thresh. No
% stored subgroup ratios either -- they are one division from what is here,
% and a stored copy silently goes stale the moment you re-threshold.
out = struct('mode', mode, 'noise_law', noise_law, 'params', p, 'seed', seed, ...
             'alpha', alpha, 'R', R, 'sigma_v', sigma_v, ...
             'radius', radius(:), 'inside', inside, 'dmg', dmg, 'res', res, ...
             'rm_raw_tr',    single(rm_raw(:,:,tracked)), ...
             'rm_smooth_tr', single(rm_smooth(:,:,tracked)));
% Plain division: Inf means all 60 and no 90, NaN means no qualifying pairs.
fprintf('\n[gc_run] %s | thresh %.2f | %d cells, %d inside the disc\n', ...
        mode, thresh, numel(tracked), sum(inside));
fprintf('  ratio 60:90   all %.3f   inside %.3f   outside %.3f\n', res.ratio_60_90, ...
        sum(res.n60( inside)) / sum(res.n90( inside)), ...
        sum(res.n60(~inside)) / sum(res.n90(~inside)));
end
