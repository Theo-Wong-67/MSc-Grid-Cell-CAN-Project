function fig02_healthy_exemplar(mode, outdir, thresh)
%FIG02_HEALTHY_EXEMPLAR  Report Figure 2, the undamaged network.
%   (A) smoothed rate maps and thresholded spectra of two tracked cells,
%   (B) Fourier component count over the 78 tracked cells, (C) histogram of
%   angular differences between adjacent components.
%
%   Input   log/detail/det_dmg_a150_r01_s1.mat, a gc_run output (alpha = 0.15,
%           R = 1, so 5 of 16,384 neurons scaled: the undamaged control).
%   Output  fig02_healthy_exemplar.pdf and .png in outdir.
%
%   fig02_healthy_exemplar('thesis', 'output', 0.43)
    arguments
        mode   (1,:) char {mustBeMember(mode,{'thesis','slide'})} = 'thesis'
        outdir (1,:) char = 'output'
        thresh (1,1) double = 0.43
    end
    root = fileparts(fileparts(mfilename('fullpath')));
    old = cd(root);  cleaner = onCleanup(@() cd(old)); %#ok<NASGU>
    TAG = '';  if abs(thresh - 0.43) > 1e-9, TAG = sprintf('_t%02d', round(thresh*100)); end
    fn = fullfile('log','detail', ['det_dmg_a150_r01_s1' TAG '.mat']);
    assert(isfile(fn), 'fig02:missing', 'no run at %s', fn);
    o = load(fn).out;
    GEO = [60 90];  nK = numel(GEO);
    KS = viz.pickGeometry(o.res);

    f = viz.figure(11, mode);
    FS = 1.15;  b1 = getappdata(f,'vizBase')*FS;  setappdata(f,'vizBase',b1);
    set(f, 'DefaultAxesFontSize', b1, 'DefaultTextFontSize', b1);
    % geometry, cm: image, image, count (square), histogram (wide)
    S  = 3.00;  AW = 6.00;
    LM = 1.45*FS;  RM = 2.00*FS;  TM = 1.15*FS;  BM = 0.90*FS;
    CGV = [0.45 2.75*FS 1.55*FS];  RG = 0.55;
    FW = LM + 3*S + AW + sum(CGV) + RM;
    FH = TM + 2*S + RG + BM;
    fu = f.Units;  f.Units = 'centimeters';  f.Position(3:4) = [FW FH];  f.Units = fu;  drawnow;
    CX = LM + [0, S+CGV(1), 2*S+CGV(1)+CGV(2), 3*S+sum(CGV)];
    Y1 = FH - TM - S;   Y2 = Y1 - S - RG;   YC = (Y1 + Y2)/2;
    mk = @(x,y) axes(f, 'Units','centimeters', 'Position',[x y S S]);

    % columns 1 and 2: rate map and spectrum, one row per cell
    axIm = gobjects(2, nK);
    for c = 1:2
        for j = 1:nK
            YY = [Y1 Y2];
            ax = mk(CX(c), YY(j));  axIm(c,j) = ax;
            if c == 1, viz.ratemap(ax, o.rm_smooth_tr(:,:,KS(j)));
            else,      viz.spectrumCut(ax, o.res.spectra(:,:,KS(j)), [], [], thresh);  end
            set(ax,'XTick',[],'YTick',[]);  xlabel(ax,'');  ylabel(ax,'');
            axis(ax,'square');  box(ax,'on');
        end
    end
    ylabel(axIm(1,1), sprintf('cell %d', KS(1)));
    ylabel(axIm(1,2), sprintf('cell %d', KS(2)));

    % column 3: component count as % of tracked cells
    axB = axes(f, 'Units','centimeters', 'Position',[CX(3) YC S S]);
    cnt = o.res.count(:);  nc = 1:4;
    pct = 100 * arrayfun(@(c) mean(cnt == c), nc);
    bar(axB, nc, pct, 0.6, 'FaceColor', viz.S1, 'EdgeColor', 'none');
    xlim(axB, [0.5 4.5]);  xticks(axB, nc);
    ylim(axB, [0 100]);    yticks(axB, 0:25:100);
    viz.despine(axB);
    ylabel(axB, 'cells %');  xlabel(axB, {'# of Fourier', 'components'});

    % column 4: angular differences between adjacent components
    ax4 = axes(f, 'Units','centimeters', 'Position',[CX(4) YC AW S]);
    g = viz.gapsFromLobes(o.res.lobes);  ed = 0:5:200;
    hc = histcounts(g, ed);
    histogram(ax4,'BinEdges',ed,'BinCounts',hc, 'FaceColor', viz.S2, 'EdgeColor','none');
    hold(ax4,'on');
    HA = {'left','right'};  vv = [60 90];
    for q = 1:2
        xline(ax4, vv(q), ':', sprintf('%d\\circ', vv(q)), 'Color', viz.INK, ...
              'LineWidth', 1.1, 'FontSize', 8.05*FS, 'LabelOrientation','horizontal', ...
              'LabelVerticalAlignment','bottom', 'LabelHorizontalAlignment', HA{q});
    end
    n60 = sum(g>50 & g<70);  n90 = sum(g>80 & g<100);
    if n90 > 0, viz.panelTitle(ax4, sprintf('60:90 = %.2f', n60/n90));
    else,       viz.panelTitle(ax4, sprintf('60:90 = %d:0', n60));  end
    xlim(ax4,[0 200]);  xticks(ax4,[0 100 200]);
    ylim(ax4, [0 10 * ceil(1.1 * max(hc) / 10)]);
    viz.despine(ax4);
    ylabel(ax4, 'count');  xlabel(ax4, 'Angle difference between components (\circ)');

    % headers and panel letters
    HD = {'Rate map','Fourier spectrum'};
    for c = 1:2
        text(axIm(c,1), S/2, S + 0.22, HD{c}, 'Units','centimeters', ...
             'HorizontalAlignment','center', 'VerticalAlignment','bottom', ...
             'Clipping','off', 'Color', viz.INK, 'FontSize', b1);
    end
    lab = @(ax, s) text(ax, -0.45, S + 0.22, s, 'Units','centimeters', 'FontWeight','bold', ...
                        'FontSize', b1 + 3, 'Clipping','off', ...
                        'VerticalAlignment','bottom', 'Color', viz.INK);
    lab(axIm(1,1), 'A');  lab(axB, 'B');  lab(ax4, 'C');

    % colourbar spanning both spectrum rows, scaled to each cell's peak
    pk = axIm(2,2);  pp = pk.Position;
    cb = colorbar(pk);  cb.Ticks = clim(pk);
    cb.TickLabels = {'0','Cell peak'};  cb.Color = viz.INK;  cb.LineWidth = 0.6;  cb.FontSize = b1;
    text(pk, S + 0.20 + 0.24 + 0.95, (2*S + RG)/2, 'Power', 'Units','centimeters', 'Rotation', 90, ...
         'HorizontalAlignment','center', 'VerticalAlignment','middle', 'Clipping','off', ...
         'Color', viz.INK, 'FontSize', b1);
    pk.Units = 'centimeters';  pk.Position = pp;
    cb.Units = 'centimeters';  cb.Position = [CX(2) + S + 0.20, Y2, 0.24, 2*S + RG];

    fprintf('[fig02] wavelength median %.1f cm (IQR %.1f to %.1f), gridness mean %.2f, n = %d cells, 60:90 = %d:%d\n', ...
        median(o.res.wl_cm), prctile(o.res.wl_cm,25), prctile(o.res.wl_cm,75), ...
        mean(o.res.gridness), numel(o.res.wl_cm), n60, n90);
    viz.save(f, 'fig02_healthy_exemplar', mode, outdir);
end
