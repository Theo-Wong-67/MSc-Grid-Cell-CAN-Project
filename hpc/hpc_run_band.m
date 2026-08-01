function hpc_run_band(task)
% HPC_RUN_BAND  High-resolution sweep over the alpha x R plane for Ying's 60/90 ratio.
%
%   Variant of hpc_run_one. Same task-indexing scheme (seed varies fastest,
%   then R, then alpha) and same save/analysis pipeline.
%
%     1. GRID -- full plane at high resolution (was the graded band only):
%           alpha in 0:0.02:1                                     (51)
%           R     in 0:2:90                                       (46)
%        R = 2 steps roughly halves the previous spacing, which is what resolves
%        commensurability against lambda = 13: the horizontal banding in the old
%        phase diagrams was sampled at R steps of 3 and could not be told apart
%        from seed noise. At step 2, adjacent R rows are near-replicates of each
%        other, so the row-to-row scatter doubles as a free seed-noise estimate.
%     2. SEEDS 5 -> 8 (running ratio plateaus by ~6 seeds, so 8 is past it).
%     3. TRACKED POPULATION: instead of 14 core + 16 lattice (30), a dense
%        radial-angular sample across the whole damage disk (~60 neurons). The
%        60/90 ratio is pooled over the DAMAGED (inside-disk) subset, so a bigger
%        interior sample per simulation is the cheapest way to add statistics --
%        the 400k-step sim is shared across all tracked cells.
%
%   => 51*46*8 = 18768 tasks. Submit as a PBS array 1-18768.
%      CHECK THE CLUSTER'S ARRAY-LENGTH CAP FIRST -- this may need splitting into
%      chunks (e.g. -J 1-10000 then -J 10001-18768).
%
%   DEGENERATE EDGES, BY DESIGN. R = 0 applies no damage, so alpha has no effect
%   there; alpha = 1 applies no attenuation, so R has no effect there. Both edges
%   are therefore the healthy network, and about 4% of tasks (768) are replicates
%   of it. That is deliberate: the R = 0 row and the alpha = 1 column must both
%   come out at the healthy value, which is a built-in consistency check on the
%   whole diagram. If they disagree, something is wrong upstream.
%
%   Spectra ARE saved: the baseline-subtracted, PRE-threshold power spectrum per
%   tracked neuron (81x81 single). That is the object the detection threshold
%   acts on, so any threshold, absolute cutoff, or harmonic-rejection rule can be
%   re-applied offline without re-simulating. Costs ~2 MB per task.
%
%   TO RUN: set `home` below to your HPC home, drop this in the code folder, and
%   submit the array. Output lands in output_band3 -- a NEW folder, because the
%   grid changed and a stale file from the old 21x30 grid would silently merge
%   into the new one (alpha = 0.70 and R = 4 are valid points on both).

    if nargin < 1 || isempty(task)
        idx = getenv('PBS_ARRAY_INDEX');
        assert(~isempty(idx), 'no task arg and PBS_ARRAY_INDEX not set');
        task = str2double(idx);
    end
    assert(isfinite(task) && task>=1, 'task must be a positive integer (got %g)', task);
    task = round(task);

    % ---- grid ----
    ALPHAS = 0:0.02:1;                               % 51 -- full range, 0.02 step
    RS     = 0:2:90;                                 % 46 -- step 2 resolves commensurability (lambda = 13)
    NSEED  = 8;                                      % convergence plateaus by ~6, so 8 is plenty
    nA = numel(ALPHAS); nR = numel(RS);
    assert(task <= nA*nR*NSEED, 'task %d exceeds grid size %d', task, nA*nR*NSEED);

    t0   = task - 1;
    seed = mod(t0, NSEED) + 1;   t0 = floor(t0/NSEED);
    ri   = mod(t0, nR) + 1;      t0 = floor(t0/nR);
    alpha = ALPHAS(t0+1);
    R     = RS(ri);

    set(0,'DefaultFigureVisible','off');
    home    = '/rds/general/user/tw2825/home';                % code lives here (small)
    scratch = '/rds/general/user/tw2825/ephemeral';           % big quota -> job output goes here
    addpath(genpath(fullfile(home,'hpc_ying_run','code')));
    outdir  = fullfile(scratch,'hpc_ying_run','output_band3'); % NEW dir: new grid, do not mix
    if ~exist(outdir,'dir'), mkdir(outdir); end
    rng(seed);
    fprintf('[band] task=%d -> alpha=%.2f R=%g seed=%d\n', task, alpha, R, seed);

    % ---- model params (identical to hpc_run_one) ----
    dt=0.5; n=128; tau=10; lambda=13; beta=3/lambda^2;
    alphabar=1.05; abar=1; wtphase=2; steps=400000; eta_0=0.123;   % 400k to match the rest of the project
    THRESH = 0.43;

    % ---- large tracked population: radial-angular sample over the disk ----
    cen = n/2; NANG = 6; radii = [2 4 7 10 14 18 22 28 34 40 46 52 58];  % incl small r for small-R disks
    tracked = [];
    for rr_ = radii
        for a_ = (0:NANG-1)/NANG*2*pi
            px = round(cen + rr_*cos(a_));  py = round(cen + rr_*sin(a_));
            if px>=1 && px<=n && py>=1 && py<=n
                tracked(end+1) = sub2ind([n n], py, px); %#ok<AGROW>  (row=py, col=px)
            end
        end
    end
    tracked = unique(tracked, 'stable');
    [rg,cg] = ndgrid(1:n, 1:n);  radall = hypot(rg-cen, cg-cen);
    radius  = radall(tracked);                 % distance from centre, per tracked neuron
    NTRACK  = numel(tracked);

    % ---- simulate + analyse (production pipeline) ----
    [~,~,rm_smooth,~,rm_raw,dmg] = ...
        gc_periodic_alpha(n,tau,dt,beta,alphabar,abar,wtphase,steps,eta_0, alpha, R);
    inside = ismember(tracked, dmg.idx_damaged(:)');    % damaged cells (disk radius R)

    % spectra = baseline-subtracted power, PRE-threshold, 81x81 x NTRACK single.
    % Capturing vs discarding an output does not change execution, so every other
    % result is bit-identical to the previous run of this file.
    % spectra(:,:,i) corresponds to tracked(i).
    [cc_all, phi_cell, spectra, gridness, lobe_cell] = population_fourier_analysis(rm_raw, rm_smooth, THRESH, tracked);
    counts = cc_all(tracked);
    angles = phi_cell(tracked);      % legacy axis form (mod 180, 10 deg merge)
    lobes  = lobe_cell(tracked);     % <<< ADDED: 0-360 lobe angles -- what Ying count on
    gscore = gridness(tracked);

    % ---- per-run Ying 60/90 over damaged cells (for the log) ----
    % <<< CHANGED: was axis-level on `angles`, with wrap 180-(end-first), a
    %              min(d,180-d) fold this file added on its own, and CLOSED windows.
    %              Ying count LOBES over 0-360, no merging, wrap duplicate at
    %              theta_1+360, OPEN windows. See CAN_ying_implementation_diff.md E.
    % NOTE: at R = 0 no cell is damaged, so `inside` is empty and s60 = s90 = 0.
    %       That is expected, not a failure -- the per-cell arrays are still saved
    %       in full, so every metric remains computable offline for that row.
    s60 = 0; s90 = 0;
    for k = find(inside)
        L = lobes{k};
        if numel(L) >= 2
            d = abs(diff([L(:); L(1)+360]));
            s60 = s60 + sum(d > 50 & d < 70);
            s90 = s90 + sum(d > 80 & d < 100);
        end
    end
    fprintf('[band] a=%.2f R=%g seed=%d: inside=%d 60ct=%d 90ct=%d ratio=%.2f\n', ...
            alpha, R, seed, sum(inside), s60, s90, s60/max(s90,eps));

    % <<< ADDED: keep the tracked cells' rate maps (single, ~0.8 MB/task). The
    %     stored `spectra` are POST baseline-subtraction, so a future change to the
    %     Voronoi baseline cannot be undone offline -- that is exactly what forced
    %     this sweep to be re-simulated rather than re-analysed. Set false only if
    %     ephemeral storage gets tight.
    SAVE_MAPS = true;
    mver = version;                                   % <<< ADDED: provenance -- which MATLAB produced this
    vars = {'alpha','R','seed','task','tracked','radius','inside', ...
            'counts','angles','lobes','gscore','spectra','THRESH','NTRACK','steps', ...
            's60','s90','mver'};
    if SAVE_MAPS
        rm_raw_tr    = single(rm_raw(:,:,tracked));      %#ok<NASGU>
        rm_smooth_tr = single(rm_smooth(:,:,tracked));   %#ok<NASGU>
        vars = [vars, {'rm_raw_tr','rm_smooth_tr'}];
    end

    outfile = fullfile(outdir, sprintf('bd_a%03.0f_R%03.0f_s%02d.mat', alpha*100, R, seed));
    save(outfile, vars{:}, '-v7');
    d_ = dir(outfile);
    fprintf('[band] saved %s  (%.2f MB)\n', outfile, d_.bytes/1e6);
end
