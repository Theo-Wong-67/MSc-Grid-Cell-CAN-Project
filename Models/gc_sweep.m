function gc_sweep(conds, seeds, thresh, outdir, taskIdx, law)
%GC_SWEEP  Run gc_run over a condition grid.
%
%   gc_sweep(conds, seeds, thresh, outdir)           whole grid
%   gc_sweep(conds, seeds, thresh, outdir, taskIdx)  one task, for HPC arrays
%   gc_sweep(..., taskIdx, 'sd')                     signal-dependent noise law
%
%   conds   N x 3, rows of [alpha R sigma_v]. NaN means "not applicable", so
%           every mode is one table:
%               [ NaN  NaN  NaN  ;      baseline
%                 0.5   20  NaN  ;      synaptic damage
%                 NaN  NaN  3.33 ]      afferent noise
%   seeds   vector of rng seeds
%   law     'const' (default) or 'sd', passed to GC_RUN's noise_law. 'sd'
%           needs a sigma_v and is not available with alpha -- gc_run
%           asserts on both, so a bad combination fails before the 13-minute
%           simulation rather than after it.
%

arguments
    conds   double
    seeds   double
    thresh  double = 0.43
    outdir  char   = '.'
    taskIdx double = []
    law     (1,:) char {mustBeMember(law, {'const','sd'})} = 'const'
end

assert(size(conds,2) == 3, 'gc_sweep:conds', 'conds must be N x 3 [alpha R sigma_v].');

nS  = numel(seeds);
nT  = size(conds,1) * nS;
if isempty(taskIdx), taskIdx = 1:nT; end
if ~isfolder(outdir), mkdir(outdir); end

fprintf('[gc_sweep] %d conditions x %d seeds = %d tasks | thresh %.2f | law %s | -> %s\n', ...
        size(conds,1), nS, nT, thresh, law, outdir);

for t = taskIdx(:)'
    c = ceil(t/nS);
    s = t - (c-1)*nS;
    p = num2cell(conds(c,:));
    p(cellfun(@isnan, p)) = {[]};                  % NaN -> [] so gc_run picks the mode
    out = gc_run(p{:}, thresh, seeds(s), law);
    save(fullfile(outdir, sprintf('sw_c%03d_s%03d.mat', c, s)), 'out', '-v7');
    fprintf('[gc_sweep] task %d/%d done (c%d, seed %d, law %s)\n', t, nT, c, seeds(s), law);
end
end
