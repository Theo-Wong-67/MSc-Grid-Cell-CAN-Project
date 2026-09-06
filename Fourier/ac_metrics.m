function [spacing_cm, gridness] = ac_metrics(rm_smooth, bin_cm)
%   AC_METRICS  Grid spacing and gridness from the rate-map autocorrelogram.
%   Requires CMBHOME on the path (moserac, CMBHOME.Utils.extrema2,
%   CMBHOME.Session.Gridness).
    spacing_cm = NaN; gridness = NaN;
    rm = rm_smooth;
    rm(~isfinite(rm)) = 0;
    if max(rm(:)) <= 0, return; end

    ac = CMBHOME.Utils.moserac(rm, rm, 25);   % qualified: not vendored in this repo

    % --- spacing: CMBHOME gridDistance.m, transcribed (Pd = 7, thresh = -Inf) ---
    [~, inds] = CMBHOME.Utils.extrema2(ac);
    if ~isempty(inds)
        [rowInd, colInd] = ind2sub(size(ac), inds);
        [~, ord] = sort(ac(inds), 'descend');
        idelete = false(numel(ord),1);
        for i = 1:numel(ord)                       % drop peaks closer than Pd
            i1 = ord(i);                           % to any taller peak
            for k = 1:i-1
                i2 = ord(k);
                if hypot(rowInd(i1)-rowInd(i2), colInd(i1)-colInd(i2)) < 7
                    idelete(i) = true;
                end
            end
        end
        ord(idelete) = [];
        rowInd = rowInd(ord); colInd = colInd(ord);   % ordered tallest first
        if numel(rowInd) >= 7                         % Input guard
            d = sort(hypot(rowInd - rowInd(1), colInd - colInd(1)));
            spacing_cm = median(d(2:7)) * bin_cm;  % their d(2:7), median taken here to represent neuron
        end
    end

    % --- gridness: CMBHOME's own implementation, called directly ---
    persistent S warned
    if isempty(S), [~] = evalc('S = CMBHOME.Session();'); end
    try
        % evalc, not a bare call: Gridness disp()s "No cells in session object"
        % on every invocation via self.epoch. 78 lines a run here, ~1.4M across
        % a full sweep. Errors still raise -- evalc only swallows stdout.
        [~] = evalc(['gridness = S.Gridness([], ''autocorr'', ac, ''grid3'', 1, ' ...
                     '''rotate_inc'', 30, ''supress_plot'', 1);']);
    catch ME
        gridness = NaN;                            % degenerate autocorrelogram
        if isempty(warned)                         % report once, to stderr:
            warned = true;                         % line 9's warning('off')
            fprintf(2, '[ac_metrics] CMBHOME Gridness failed: %s\n', ME.message);
        end                                        % would swallow a warning()
    end
    if isempty(gridness), gridness = NaN; end
end
