function hpc_run_noise(task)
% HPC_RUN_NOISE  1-D afferent velocity-noise sweep on a HEALTHY network.
%
%   Companion to hpc_run_band. No synaptic damage (alpha = 1, R = 0): the noise
%   is the ONLY perturbation, so this isolates the velocity-input pathway.
%
%   NOISE MODEL -- Nagaraj & Narayanan (2024) exactly:
%     One independent Gaussian draw per neuron per time step, added to the
%     velocity BEFORE the gain:  B_i = 1 + eta_0 * e_theta_i . (v + eps_i).
%     sigma_v is the per-component SD in m/s -- absolute, so the perturbation
%     persists even at rest. See gc_periodic_noise for the full noise model.
%
%   GRID. sigma is set as a multiple of the realised mean speed mu_v = 0.50 m/s.
%   The first six ratios reproduce N&N's L0-L5; the last four extend past their
%   range to locate where grid firing actually breaks, so a flat 60/90 curve
%   becomes a BOUNDED statement rather than an unqualified null.
%       ratios  0  0.33  0.67  1.00  1.67  3.33  5.00  7.50  10.0  15.0
%       sigma   0  .165  .335  .500  .835  1.665 2.500 3.750 5.000 7.500   (m/s)
%
%   => 10 sigma x 50 seeds = 500 tasks. Submit as a PBS array 1-500.
%   Seed varies fastest, then sigma (same convention as hpc_run_band).
%
%   CROSS-CHECK. The sigma = 0 column must reproduce the healthy runs already in
%   sweep3 (s3_a100_R000.0_s1..s5.mat, alpha = 1, R = 0). If it does not, the
%   noise runner is wrong and the sweep tells you so without extra work.
%
%   50 seeds follows N&N, who show that trajectory-to-trajectory variability
%   makes fewer runs uninterpretable. Convergence is then checked RETROSPECTIVELY
%   by bootstrap-subsampling seeds, so the seed count becomes a measured result.
%
%   METRIC WARNING (measured, not assumed). At alpha = 1 the healthy network
%   produces S90 = 0 EXACTLY: a 78-cell baseline gives s60 = 234, s90 = 0, so the
%   60/90 ratio is Inf and f = 0 identically. f can therefore only move if high
%   sigma actually manufactures 90deg power. The sensitive readouts in this regime
%   are npair (axis-pairs per cell, 3.00 when every cell is a clean hexagon) and
%   median gridness -- both of which degrade continuously. Treat f as the
%   'did any square symmetry appear at all' indicator, not the primary curve.
%
%   Output lands in output_noise/ so it cannot touch existing sweep results.

    if nargin < 1 || isempty(task)
        idx = getenv('PBS_ARRAY_INDEX');
        assert(~isempty(idx), 'no task arg and PBS_ARRAY_INDEX not set');
        task = str2double(idx);
    end
    assert(isfinite(task) && task>=1, 'task must be a positive integer (got %g)', task);
    task = round(task);

    % ---- grid ----
    MU_V   = 0.50;                                          % measured mean speed, m/s
    RATIOS = [0 0.33 0.67 1.00 1.67 3.33 5.00 7.50 10.0 15.0];
    SIGMAS = RATIOS * MU_V;
    NSEED  = 50;
    nS = numel(SIGMAS);
    assert(task <= nS*NSEED, 'task %d exceeds grid size %d', task, nS*NSEED);

    t0   = task - 1;
    seed = mod(t0, NSEED) + 1;   t0 = floor(t0/NSEED);
    si   = t0 + 1;
    sigma_v = SIGMAS(si);   ratio = RATIOS(si);

    set(0,'DefaultFigureVisible','off');
    home    = '/rds/general/user/tw2825/home';
    scratch = '/rds/general/user/tw2825/ephemeral';
    addpath(genpath(fullfile(home,'hpc_ying_run','code')));
    outdir  = fullfile(scratch,'hpc_ying_run','output_noise');
    if ~exist(outdir,'dir'), mkdir(outdir); end
    rng(seed);
    fprintf('[noise] task=%d -> sigma=%.4f (ratio %.2f) seed=%d\n', task, sigma_v, ratio, seed);

    % ---- model params (identical to hpc_run_band) ----
    dt=0.5; n=128; tau=10; lambda=13; beta=3/lambda^2;
    alphabar=1.05; abar=1; wtphase=2; steps=400000; eta_0=0.123;
    THRESH = 0.43;
    ALPHA = 1; R = 0;    % recorded in the output for provenance; gc_periodic_noise has no damage terms

    % ---- tracked population (same lattice as hpc_run_band; R-independent) ----
    cen = n/2; NANG = 6; radii = [2 4 7 10 14 18 22 28 34 40 46 52 58];
    tracked = [];
    for rr_ = radii
        for a_ = (0:NANG-1)/NANG*2*pi
            px = round(cen + rr_*cos(a_));  py = round(cen + rr_*sin(a_));
            if px>=1 && px<=n && py>=1 && py<=n
                tracked(end+1) = sub2ind([n n], py, px); %#ok<AGROW>
            end
        end
    end
    tracked = unique(tracked, 'stable');
    [rg,cg] = ndgrid(1:n, 1:n);  radall = hypot(rg-cen, cg-cen);
    radius  = radall(tracked);
    NTRACK  = numel(tracked);

    % ---- simulate ----
    [px_,py_,rm_smooth,~,rm_raw] = gc_periodic_noise(n,tau,dt,beta,alphabar,abar,wtphase, ...
        steps, eta_0, sigma_v);
    vbar = mean(hypot(diff(px_),diff(py_))) * (1/100) / (dt/1000);   % realised mean speed, m/s

    [cc_all, phi_cell, spectra, gridness, lobe_cell] = population_fourier_analysis(rm_raw, rm_smooth, THRESH, tracked);
    counts = cc_all(tracked);
    angles = phi_cell(tracked);      % legacy axis form (mod 180, 10 deg merge)
    lobes  = lobe_cell(tracked);     % <<< ADDED: 0-360 lobe angles -- what Ying count on
    gscore = gridness(tracked);

    % ---- Ying 60/90 over ALL tracked cells (no lesion => no inside/outside split) ----
    % <<< CHANGED: lobe-level, no merging, wrap duplicate, OPEN windows (was
    %              axis-level with a min(d,180-d) fold and closed windows).
    s60 = 0; s90 = 0;
    for k = 1:NTRACK
        L = lobes{k};
        if numel(L) >= 2
            d = abs(diff([L(:); L(1)+360]));
            s60 = s60 + sum(d > 50 & d < 70);
            s90 = s90 + sum(d > 80 & d < 100);
        end
    end
    f_sq = s90 / max(s60+s90, eps);          % square fraction: bounded, no singularity
    % <<< CHANGED: with lobe counting a clean hexagon yields 6 diffs, not 3, so the
    %     "3.00 = clean hexagon" calibration in this file's header is now 6.00.
    npair = (s60 + s90) / NTRACK;                     % oriented lobe-pairs per cell (6 = clean hexagon)
    nhex  = mean(cellfun(@(a) numel(a) >= 6, lobes)); % <<< CHANGED: >=6 lobes == >=3 axes
    fprintf('[noise] sigma=%.4f seed=%d: 60ct=%d 90ct=%d f_sq=%.4f npair=%.2f nhex=%.2f medgrid=%.3f vbar=%.3f\n', ...
            sigma_v, seed, s60, s90, f_sq, npair, nhex, median(gscore,'omitnan'), vbar);

    % <<< ADDED: keep the tracked cells' rate maps -- `spectra` are POST
    %     baseline-subtraction, so a baseline change cannot be undone offline.
    SAVE_MAPS = true;
    vars = {'sigma_v','ratio','MU_V','vbar','seed','task','tracked','radius', ...
            'counts','angles','lobes','gscore','spectra','THRESH','NTRACK','steps', ...
            'ALPHA','R','s60','s90','f_sq','npair','nhex'};
    if SAVE_MAPS
        rm_raw_tr    = single(rm_raw(:,:,tracked));      %#ok<NASGU>
        rm_smooth_tr = single(rm_smooth(:,:,tracked));   %#ok<NASGU>
        vars = [vars, {'rm_raw_tr','rm_smooth_tr'}];
    end

    outfile = fullfile(outdir, sprintf('nz_r%04.0f_s%02d.mat', ratio*100, seed));
    save(outfile, vars{:}, '-v7');
    d_ = dir(outfile);
    fprintf('[noise] saved %s  (%.2f MB)\n', outfile, d_.bytes/1e6);
end
