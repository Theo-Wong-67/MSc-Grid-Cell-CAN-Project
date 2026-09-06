function figB1_wavelength_vs_ying(mode, outdir)
%FIGB1_WAVELENGTH_VS_YING  Report Figure B1, spatial scale of the model
%   against the recordings of Ying et al. (2023).
%
%   Every smoothed rate map, model and recorded, goes through the same two
%   measurements:
%     wavelength    ac_metrics(rm, bin): autocorrelogram peaks, median of the
%                   six nearest peak distances
%     field radius  zero crossing of the radial profile of the same
%                   autocorrelogram (Giocomo et al. 2011)
%     ratio         wavelength / field radius; Giocomo's control value is
%                   3.26 +/- 0.07
%   Each side keeps its own smoothing (model 5.2 cm, recordings 4 cm).
%
%   Inputs  log/sdn_trial_const.mat                       a healthy model run
%           Code-for-Ying-et-al.-2023-main/grid data/grid_data.mat
%   Needs   Fourier/ac_metrics.m and CMBHOME on the path.
%   Output  figB1_wavelength_vs_ying.pdf and .png in outdir.
%
%   figB1_wavelength_vs_ying('thesis', 'output')
arguments
    mode   (1,:) char {mustBeMember(mode,{'thesis','slide'})} = 'thesis'
    outdir (1,:) char = 'output'
end
root  = fileparts(fileparts(mfilename('fullpath')));
GDATA = fullfile(root,'Code-for-Ying-et-al.-2023-main','grid data','grid_data.mat');
MODEL = fullfile(root,'log','sdn_trial_const.mat');
GIOCOMO = 3.26;  GIOCOMO_SD = 0.07;
addpath(fullfile(root,'Fourier'), fullfile(root,'CMBHOME-master'));
bin = viz.ARENA_CM / viz.NBINS;                       % 75/36 = 2.0833 cm

% five groups as cell arrays of 36 x 36 smoothed rate maps
% (Ying et al. store the smoothed map in column 2 of each *_data cell array)
m = load(MODEL);  fn = fieldnames(m);  m = m.(fn{1});
g = load(GDATA, 'wty_data','wta_data','j20y_data','j20a_data');
maps = { squeeze(num2cell(m.rm_smooth_tr, [1 2])), ...
         g.wty_data(:,2), g.wta_data(:,2), g.j20y_data(:,2), g.j20a_data(:,2) };
name = {'model','nTG-y','nTG-a','APP-y','APP-a'};

[wl, rt] = deal(cell(1,5));
fprintf('\n%-7s %5s %22s %22s\n','group','n','wavelength cm','ratio');
for k = 1:5
    nc = numel(maps{k});
    w = nan(nc,1);  r = nan(nc,1);
    for i = 1:nc
        rm   = double(maps{k}{i});
        w(i) = ac_metrics(rm, bin);
        r(i) = w(i) / fieldRadius(rm, bin);
    end
    ok = isfinite(w) & isfinite(r);                   % same cells in both panels
    wl{k} = w(ok);  rt{k} = r(ok);
    fprintf('%-7s %5d   %5.2f med, %5.2f mean     %5.2f med, %5.2f mean\n', ...
            name{k}, nnz(ok), median(wl{k}), mean(wl{k}), median(rt{k}), mean(rt{k}));
end
fprintf('\nmodel vs stored res.wl_cm: max |diff| = %.3g cm\n', max(abs(wl{1} - m.res.wl_cm(:))));

% figure
TXT = viz.INK;
col = {viz.INK, viz.S1, viz.S2, viz.S3, viz.S4};      % model in ink, groups in slot order
f = viz.figure(7.6, mode);
t = tiledlayout(f, 1, 2, 'Padding','compact', 'TileSpacing','compact');

ax = nexttile(t);
boxSwarm(ax, wl, col, name);
ylabel(ax, 'grid wavelength (cm)');
set(ax, 'XColor', TXT, 'YColor', TXT);

ax = nexttile(t);  hold(ax,'on');
patch(ax, [0.4 5.6 5.6 0.4], GIOCOMO + GIOCOMO_SD*[-1 -1 1 1], viz.S3, ...
      'FaceAlpha',0.15, 'EdgeColor','none');
yline(ax, GIOCOMO, '-', 'Giocomo 3.26', 'Color', TXT, 'LineWidth',1.0, ...
      'FontSize', viz.base(ax)-1, 'LabelHorizontalAlignment','left');
boxSwarm(ax, rt, col, name);
ylabel(ax, 'spacing / field-size (period per radius)');
set(ax, 'XColor', TXT, 'YColor', TXT);

viz.save(f, 'figB1_wavelength_vs_ying', mode, fullfile(root, outdir));
end

function boxSwarm(ax, V, col, tick)
%BOXSWARM  Box for median and IQR with every cell as a point over it.
hold(ax,'on');
for k = 1:numel(V)
    v = V{k};
    boxchart(ax, k*ones(size(v)), v, 'BoxFaceColor', col{k}, 'BoxFaceAlpha', 0.15, ...
             'WhiskerLineColor', col{k}, 'MarkerStyle','none', ...
             'BoxWidth', 0.55, 'LineWidth', 1.1);
    swarmchart(ax, k*ones(size(v)), v, 7, col{k}, 'filled', ...
               'MarkerFaceAlpha', 0.5, 'XJitterWidth', 0.42);
end
set(ax, 'XTick', 1:5, 'XTickLabel', tick, 'XTickLabelRotation', 0);
xlim(ax, [0.4 5.6]);
viz.despine(ax);
end

function ir = fieldRadius(rm, bin)
%FIELDRADIUS  Radius of the central autocorrelogram peak, from the first zero
%   crossing of the radial profile.
ac = viz.moserac(rm);
h  = size(ac,1);  c = ceil(h/2);
[X,Y] = meshgrid(1:h, 1:h);
d  = hypot(X-c, Y-c);
rr = (0:c-1)';
p  = arrayfun(@(k) mean(ac(d >= rr(k)-0.5 & d < rr(k)+0.5 & ~isnan(ac))), 1:numel(rr))';
k  = find(p(1:end-1) > 0 & p(2:end) <= 0, 1);
if isempty(k), ir = NaN; return; end
ir = (rr(k) + p(k)/(p(k)-p(k+1))) * bin;
end
