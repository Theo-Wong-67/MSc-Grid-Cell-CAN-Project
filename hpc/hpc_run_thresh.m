function hpc_run_thresh(task)
% HPC_RUN_THRESH  Threshold-sensitivity run for the Ying 60/90 ratio.
%
%   PURPOSE. The main sweep fixed the Fourier detection threshold at 0.43, so its
%   angles cannot be re-analysed at other thresholds after the fact. This run
%   answers the question directly: does the alpha-trend of the 60/90 ratio hold
%   when the detection threshold moves?
%
%   THE TRICK. Rather than saving rate maps and re-analysing later, the SAME
%   simulation is analysed at every threshold in THRESHLIST. The 400k-step
%   simulation is the expensive part; population_fourier_analysis is cheap, so
%   five thresholds cost barely more than one and the files stay a few KB.
%   Every threshold therefore sees an IDENTICAL network realisation, which makes
%   this a properly paired comparison -- differences are the threshold alone,
%   with no seed noise between conditions.
%
%   WHY THIS MATTERS. The offset scheme is asymmetrically fragile. A hexagonal
%   cell keeps reporting 60 deg however many of its three components survive, but
%   a square cell has only two and vanishes entirely if it loses one. So raising
%   the threshold deletes square cells while merely thinning hexagonal ones,
%   which should INFLATE the ratio. Spurious extra peaks do the opposite. The
%   prediction is therefore specific: ratio should rise with THRESH, and the
%   effect should concentrate in the collapsed regime where square cells live.
%   If that is not what comes out, the metric is more robust than feared.
%
%   GRID. Deliberately a subset of the main sweep -- enough to test the trend,
%   not to redo the calibration:
%       alpha in 0.70:-0.05:0.20                 (11)
%       R     in [16 28 40 52 64 76 90]          (7)   spans focal -> global
%       seeds 8
%   => 11*7*8 = 616 tasks. Submit as a PBS array 1-616. About 12% of the main run.
%
%   Also saved per threshold: the per-cell COMPONENT COUNT, so you can see
%   directly whether the cells changing category are the two-component ones.

    if nargin < 1 || isempty(task)
        idx = getenv('PBS_ARRAY_INDEX');
        assert(~isempty(idx), 'no task arg and PBS_ARRAY_INDEX not set');
        task = str2double(idx);
    end
    assert(isfinite(task) && task>=1, 'task must be a positive integer (got %g)', task);
    task = round(task);

    % ---- grid ----
    ALPHAS     = 0.70:-0.05:0.20;                 % 11
    RS         = [16 28 40 52 64 76 90];          % 7
    NSEED      = 8;
    THRESHLIST = [0.30 0.36 0.43 0.50 0.58];      % 0.43 = the main sweep's value
    nA = numel(ALPHAS); nR = numel(RS); nT = numel(THRESHLIST);
    assert(task <= nA*nR*NSEED, 'task %d exceeds grid size %d', task, nA*nR*NSEED);

    t0   = task - 1;
    seed = mod(t0, NSEED) + 1;   t0 = floor(t0/NSEED);
    ri   = mod(t0, nR) + 1;      t0 = floor(t0/nR);
    alpha = ALPHAS(t0+1);
    R     = RS(ri);

    set(0,'DefaultFigureVisible','off');
    home    = '/rds/general/user/tw2825/home';
    scratch = '/rds/general/user/tw2825/ephemeral';
    addpath(genpath(fullfile(home,'hpc_ying_run','code')));
    outdir  = fullfile(scratch,'hpc_ying_run','output_thresh');
    if ~exist(outdir,'dir'), mkdir(outdir); end
    rng(seed);
    fprintf('[thr] task=%d -> alpha=%.2f R=%g seed=%d\n', task, alpha, R, seed);

    % ---- model params (identical to hpc_run_band) ----
    dt=0.5; n=128; tau=10; lambda=13; beta=3/lambda^2;
    alphabar=1.05; abar=1; wtphase=2; steps=400000; eta_0=0.123;

    % ---- same tracked lattice as the main sweep ----
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

    % ---- simulate ONCE ----
    [~,~,rm_smooth,~,rm_raw,dmg] = ...
        gc_periodic_alpha(n,tau,dt,beta,alphabar,abar,wtphase,steps,eta_0, alpha, R);
    inside = ismember(tracked, dmg.idx_damaged(:)');

    % ---- analyse at EVERY threshold, same network realisation ----
    %   CRITICAL: population_fourier_analysis is NOT deterministic. Its Voronoi
    %   baseline (n_shuffle = 50 randomised maps per neuron) sets the noise floor
    %   that is subtracted BEFORE thresholding, and it draws from the global RNG.
    %   Calling it in a loop would therefore give every threshold a different
    %   noise floor, so differences between thresholds would be part threshold,
    %   part reshuffled baseline -- and the 0.43 result would no longer match
    %   hpc_run_band. Capturing the post-simulation RNG state and restoring it
    %   before each call fixes both: the comparison becomes properly paired, and
    %   the 0.43 column reproduces the main sweep exactly.
    rngstate = rng;

    angles_t = cell(1,nT);
    lobes_t  = cell(1,nT);          % <<< ADDED
    counts_t = cell(1,nT);
    gscore_t = cell(1,nT);
    s60_t = zeros(1,nT); s90_t = zeros(1,nT); ncontrib_t = zeros(1,nT);

    for t = 1:nT
        THRESH = THRESHLIST(t);
        rng(rngstate);                 % identical Voronoi shuffles at every threshold
        [cc_all, phi_cell, ~, gridness, lobe_cell] = ...
            population_fourier_analysis(rm_raw, rm_smooth, THRESH, tracked);
        counts_t{t} = cc_all(tracked);
        angles_t{t} = phi_cell(tracked);      % legacy axis form
        lobes_t{t}  = lobe_cell(tracked);     % <<< ADDED: what Ying count on
        gscore_t{t} = gridness(tracked);

        % <<< CHANGED: lobe-level, no merging, wrap duplicate, OPEN windows.
        s60 = 0; s90 = 0; nc = 0;
        for k = find(inside)
            L = lobes_t{t}{k};
            if numel(L) >= 2
                nc = nc + 1;
                d = abs(diff([L(:); L(1)+360]));
                s60 = s60 + sum(d > 50 & d < 70);
                s90 = s90 + sum(d > 80 & d < 100);
            end
        end
        s60_t(t)=s60; s90_t(t)=s90; ncontrib_t(t)=nc;
        fprintf('[thr] a=%.2f R=%g seed=%d THRESH=%.2f: contrib=%d 60ct=%d 90ct=%d ratio=%.2f\n', ...
                alpha, R, seed, THRESH, nc, s60, s90, s60/max(s90,eps));
    end

    % ---- optionally keep the TRACKED cells' rate maps for post-hoc re-analysis ----
    %   rm_raw / rm_smooth are 36 x 36 x 16384 (~170 MB each), far too big to keep
    %   whole. Subset to the 78 tracked cells and store as single: ~0.8 MB per task,
    %   ~0.5 GB across this 616-task run. That buys the ability to re-analyse at ANY
    %   future threshold, component rule, or new metric without re-simulating.
    %   Set false if ephemeral gets tight -- the in-run threshold sweep above does
    %   not depend on this.
    SAVE_MAPS = true;

    vars = {'alpha','R','seed','task','tracked','radius','inside', ...
            'THRESHLIST','angles_t','lobes_t','counts_t','gscore_t', ...
            's60_t','s90_t','ncontrib_t','NTRACK','steps'};   % <<< CHANGED: +lobes_t
    if SAVE_MAPS
        rm_raw_tr    = single(rm_raw(:,:,tracked));      %#ok<NASGU>
        rm_smooth_tr = single(rm_smooth(:,:,tracked));   %#ok<NASGU>
        vars = [vars, {'rm_raw_tr','rm_smooth_tr'}];
    end

    outfile = fullfile(outdir, sprintf('th_a%03.0f_R%03.0f_s%02d.mat', alpha*100, R, seed));
    save(outfile, vars{:}, '-v7');
    d_ = dir(outfile);
    fprintf('[thr] saved %s  (%.2f MB)\n', outfile, d_.bytes/1e6);
end
