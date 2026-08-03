function gc_dynamics(mode, p1, p2)
% GC_DYNAMICS  Run the CAN grid-cell model and analyse the tracked population.
%
%   gc_dynamics()               Intact CAN model
%   gc_dynamics('alpha', a, R)  Zhi & Cox damage: severity a, lesion radius R
%   gc_dynamics('noise', s)     afferent velocity noise, sigma_v = s m/s
%
%   Damage and noise are separate model functions and cannot be combined.
%   Parameters are documented with gc_periodic_alpha / gc_periodic_noise.
%
%   The analysed cells are the same 78 the alpha-R sweep tracks.

    close all;
    if nargin < 1 || isempty(mode), mode = 'baseline'; end

    % Burak & Fiete (2009) implementations
    n = 128;  tau = 10;  dt = 0.5;
    lambda = 13;  beta = 3/lambda^2;
    alphabar = 1.05;  abar = 1;  wtphase = 2;
    steps = 400000;  eta_0 = 0.123;
    THRESH = 0.43;

    dmg = [];
    switch lower(mode)
        case 'baseline'
            fprintf('[gc_dynamics] Running healthy baseline...\n');
            [~,~,rm_smooth,~,rm_raw] = ...
                gc_periodic_baseline(n,tau,dt,beta,alphabar,abar,wtphase,steps,eta_0);
        case 'alpha'
            fprintf('[gc_dynamics] Running synaptic damage: alpha=%g R=%g...\n', p1, p2);
            [~,~,rm_smooth,~,rm_raw,dmg] = ...
                gc_periodic_alpha(n,tau,dt,beta,alphabar,abar,wtphase,steps,eta_0,p1,p2);
        case 'noise'
            fprintf('[gc_dynamics] Running afferent noise: sigma_v=%g m/s...\n', p1);
            [~,~,rm_smooth,~,rm_raw] = ...
                gc_periodic_noise(n,tau,dt,beta,alphabar,abar,wtphase,steps,eta_0,p1);
        otherwise
            error('gc_dynamics:mode', ...
                  'mode must be baseline, alpha or noise (got ''%s'').', mode);
    end

    % Tracked cells: 6 angles at each of 13 radii, as in hpc_run_band.m.
    % Radii are sized for n = 128; all land inside the sheet.
    cen = n/2;  radii = [2 4 7 10 14 18 22 28 34 40 46 52 58];
    tracked = [];
    for rr_ = radii
        for a_ = (0:5)/6*2*pi
            tracked(end+1) = sub2ind([n n], ...
                round(cen + rr_*sin(a_)), round(cen + rr_*cos(a_))); %#ok<AGROW>
        end
    end
    tracked = unique(tracked, 'stable');

    if isempty(dmg) || isempty(dmg.idx_damaged)
        groups = {'ALL TRACKED', tracked, ''};
    else
        groups = {'DAMAGED', dmg.idx_damaged, sprintf('inside R=%g',  dmg.R); ...
                  'HEALTHY', dmg.idx_healthy, sprintf('outside R=%g', dmg.R)};
    end

    for g = 1:size(groups,1)
        idx = intersect(tracked, groups{g,2}(:)', 'stable');
        fprintf('\n[gc_dynamics] ===== %s (%d of %d tracked) %s =====\n', ...
                groups{g,1}, numel(idx), numel(tracked), groups{g,3});
        if isempty(idx), continue; end

        [~,~,~,gr] = population_fourier_analysis(rm_raw, rm_smooth, THRESH, idx);

        % population_fourier_analysis prints gridness only when a 60/90 pair
        % exists, so print it here unconditionally.
        v = gr(idx);  v = v(~isnan(v));
        fprintf('\n[gc_dynamics] Gridness (%s): %d of %d scored', ...
                groups{g,1}, numel(v), numel(idx));
        if isempty(v)
            fprintf(' -- all NaN\n');
        else
            fprintf(' | mean %.4f median %.4f range %.4f to %.4f | >0.54: %d\n', ...
                    mean(v), median(v), min(v), max(v), sum(v > 0.54));
        end
    end
end
