function fig04_damage_plane(mode, outdir)
%FIG04_DAMAGE_PLANE  Report Figure 4, synaptic damage alone (sigma_v = 0).
%   Mean f60 over eight runs on the alpha x R plane, dashed lines at integer
%   multiples of the lattice wavelength. Also prints the smallest R at which
%   any alpha drives f60 below 0.5, and alpha_c per R.
%
%   Input   agg_merged_run1.mat, the noise-free plane, 38 alpha x 46 R x 8 runs.
%   Output  fig04_damage_plane.pdf and .png in outdir.
%
%   fig04_damage_plane('thesis', 'output')
    arguments
        mode   (1,:) char {mustBeMember(mode,{'thesis','slide'})} = 'thesis'
        outdir (1,:) char = 'output'
    end
    root = fileparts(fileparts(mfilename('fullpath')));
    old = cd(root);  cleaner = onCleanup(@() cd(old)); %#ok<NASGU>

    d0 = load('agg_merged_run1.mat').agg;
    F0m = mean(1 - d0.f_square, 3, 'omitnan');      % mean f60 over runs
    al0 = d0.alpha(:);  R0 = d0.R(:);
    minF = min(F0m, [], 1, 'omitnan').';             % worst alpha, per R
    acR = nan(numel(R0),1);                          % alpha_c: 0.5 crossing, scanning alpha downward
    for j = 1:numel(R0)
        fj = F0m(:,j);  k = find(fj < 0.5, 1, 'last');
        if ~isempty(k) && k < numel(al0)
            y1 = fj(k);  y2 = fj(k+1);
            if y2 == y1, acR(j) = al0(k);
            else,        acR(j) = al0(k) + (0.5-y1)*(al0(k+1)-al0(k))/(y2-y1);
            end
        end
    end
    Rc = R0(find(minF < 0.5, 1, 'first'));

    f = viz.figure(7.4, mode);
    fu = f.Units;  f.Units = 'centimeters';  f.Position(3) = 8.5;  f.Units = fu;
    ax = axes(f);
    viz.phase(ax, F0m, d0.alpha, d0.R, 'lo', '', 'f_{60}', [0 1]);
    viz.save(f, 'fig04_damage_plane', mode, outdir);

    fprintf('[fig04] smallest R that collapses f60 below 0.5: %g (%.2f lambda)\n', Rc, Rc/viz.LAMBDA);
    fprintf('[fig04] alpha_c undefined for R = %s\n', mat2str(R0(isnan(acR))'));
    fprintf('[fig04] alpha_c max %.3f at R = %g, R = %g gives %.3f\n', ...
            max(acR), R0(find(acR == max(acR),1)), R0(end), acR(end));
end
