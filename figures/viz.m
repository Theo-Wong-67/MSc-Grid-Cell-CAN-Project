classdef viz
%VIZ  Shared colours, panel primitives and file output for the report figures.
%
%   Image panels (rate maps, spectra, alpha x R planes) use JET. Two output
%   targets: thesis (17 cm wide, vector PDF + PNG) and slide (16:9 PNG).
%   viz.nosave(true) stops every figure script writing to disk.
    properties (Constant)
        SURF  = [1 1 1]                % figure and axes background
        INK   = [0 0 0]                % all text
        MUTED = [0 0 0]                % tick labels and reference lines
        GRIDC = [225 224 217]/255
        % categorical colours, in slot order
        S1 = [ 42 120 214]/255         % blue
        S2 = [235 104  52]/255         % orange
        S3 = [ 27 175 122]/255         % aqua
        S4 = [237 161   0]/255         % yellow
        % geometry of the analysis
        LAMBDA   = 13                  % lattice wavelength, neurons
        THRESH   = 0.43                % fourier_power threshold, fraction of peak
        MIN_AREA = 10                  % fourier_power minimum blob area, px
        ARENA_CM = 75                  % square arena side, cm
        NBINS    = 36                  % rate map bins per side
        PAD      = 256                 % fourier_power zero-pad width
        % Ying et al. (2023) group 60:90 ratios
        YING_V = [3.62 2.48 0.91]
        YING_L = {'nTG-y', 'APP-y', 'APP-a'}
        THESIS_W = 17.0                % cm
        SLIDE_W  = 33.87
    end
    methods (Static)
    % ---------------------------------------------------------------- colour
    function m = map(n)
        if nargin < 1, n = 256; end
        m = jet(n);
    end
    function m = phaseLo(n)
    %PHASELO  alpha x R map where LOW = damaged (f60): red at 0, blue at 1.
        if nargin < 1, n = 256; end
        m = flipud(jet(n));
    end
    function m = phaseHi(n)
        if nargin < 1, n = 256; end
        m = jet(n);
    end
    function m = div(n)
    %DIV  Diverging blue to red for signed difference maps.
        if nargin < 1, n = 256; end
        m = viz.ramp(viz.hex2rgb({'0d366b','2a78d6','9ec5f4','f0efec', ...
            'f0a29f','e34948','7a1f1e'}), n);
    end
    % ------------------------------------------------------- figure and output
    function f = figure(height_cm, mode)
    %FIGURE  New figure sized for the target, with the house type size.
        if nargin < 2 || isempty(mode), mode = 'thesis'; end
        if strcmp(mode,'slide')
            w = viz.SLIDE_W;  height_cm = min(height_cm, 19.0);
        else
            w = viz.THESIS_W;
        end
        f = figure('Units','centimeters', 'Position',[2 2 w height_cm], ...
                   'Color', viz.SURF, 'PaperUnits','centimeters', ...
                   'PaperPositionMode','auto', 'InvertHardcopy','off');
        base = 10.35;  if strcmp(mode,'slide'), base = 14.95; end
        set(f, 'DefaultAxesFontName','Helvetica', 'DefaultAxesFontSize', base, ...
               'DefaultAxesColor', viz.SURF, ...
               'DefaultAxesXColor', viz.MUTED, 'DefaultAxesYColor', viz.MUTED, ...
               'DefaultAxesLineWidth', 0.8, 'DefaultAxesTickDir','out', ...
               'DefaultTextFontName','Helvetica', 'DefaultTextFontSize', base, ...
               'DefaultTextColor', viz.INK, 'DefaultLineLineWidth', 1.8);
        setappdata(f,'vizMode',mode);  setappdata(f,'vizBase',base);
    end
    function b = base(ax)
    %BASE  Type size of the figure this axes belongs to.
        b = 10.35;
        try, b = getappdata(ancestor(ax,'figure'),'vizBase'); end %#ok<TRYNC>
        if isempty(b), b = 10.35; end
    end
    function despine(ax)
        box(ax,'off');
        ax.XColor = viz.MUTED;  ax.YColor = viz.MUTED;  ax.Color = viz.SURF;
        ax.TickDir = 'out';
    end
    function tf = nosave(set_to)
    %NOSAVE  Global write switch, default TRUE. viz.nosave(false) to write files.
        if nargin > 0
            setappdata(groot, 'vizNoSave', logical(set_to));
        end
        tf = getappdata(groot, 'vizNoSave');
        if isempty(tf), tf = true; end
    end
    function p = save(f, stem, mode, outdir)
    %SAVE  thesis: vector PDF and 200 dpi PNG. slide: PNG only.
        if nargin < 3 || isempty(mode), mode = getappdata(f,'vizMode'); end
        if isempty(mode), mode = 'thesis'; end
        if nargin < 4 || isempty(outdir), outdir = pwd; end
        if viz.nosave
            p = '';
            fprintf('[viz] NOSAVE, not writing %s (viz.nosave(false) to resume)\n', stem);
            return
        end
        if ~isfolder(outdir), mkdir(outdir); end
        if strcmp(mode,'slide')
            p = fullfile(outdir,[stem '_slide.png']);
            exportgraphics(f, p, 'Resolution',200, 'BackgroundColor', viz.SURF);
        else
            p = fullfile(outdir,[stem '.pdf']);
            exportgraphics(f, p, 'ContentType','vector', 'BackgroundColor', viz.SURF);
            exportgraphics(f, fullfile(outdir,[stem '.png']), ...
                           'Resolution',200, 'BackgroundColor', viz.SURF);
        end
        fprintf('[viz] wrote %s\n', p);
    end
    % ----------------------------------------------------------- image panels
    function ratemap(ax, m, ttl)
    %RATEMAP  Rate map in cm, colour scaled to the map's own peak.
        m = double(m);
        x = linspace(0, viz.ARENA_CM, size(m,1));
        imagesc(ax, x, x, m.');
        set(ax,'YDir','normal');  axis(ax,'image');
        colormap(ax, viz.map());
        xticks(ax,[0 25 50 75]);  yticks(ax,[0 25 50 75]);
        xlabel(ax,'x  (cm)');  ylabel(ax,'y  (cm)');
        viz.despine(ax);
        if nargin > 2 && ~isempty(ttl), viz.panelTitle(ax, ttl); end
    end
    function A = moserac(X, thresh)
    %MOSERAC  Pearson autocorrelogram, 2N-1. Uses CMBHOME.Utils.moserac when
    %   on the path (bit-identical to ac_metrics); otherwise the same formula.
        if nargin < 2, thresh = 25; end
        X = double(X);
        if ~isempty(which('CMBHOME.Utils.moserac'))
            A = CMBHOME.Utils.moserac(X, X, thresh);  return
        end
        o = ones(size(X));  n = conv2(o,o,'full');  Xr = rot90(X,2);
        num = n.*conv2(X,Xr,'full') - conv2(X,o,'full').*conv2(Xr,o,'full');
        d1  = sqrt(max(n.*conv2(X.^2,o,'full') - conv2(X,o,'full').^2, 0));
        d2  = sqrt(max(n.*conv2(Xr.^2,o,'full') - conv2(Xr,o,'full').^2, 0));
        A = num./(d1.*d2);  A(n < thresh) = NaN;
    end
    function [mask, cents, cut, pk] = thresholdSpectrum(S, thresh, minArea)
    %THRESHOLDSPECTRUM  fourier_power thresholding on a stored spectrum:
    %   keep S >= thresh * peak, 8-connected blobs under minArea discarded.
        if nargin < 2 || isempty(thresh),  thresh  = viz.THRESH;   end
        if nargin < 3 || isempty(minArea), minArea = viz.MIN_AREA; end
        S = double(S);
        pk = max(S(:),[],'omitnan');
        if ~isfinite(pk) || pk <= 0
            mask = false(size(S));  cents = zeros(0,2);  cut = NaN;  return
        end
        cut  = thresh*pk;
        mask = S >= cut;
        cc = bwconncomp(mask, 8);
        st = regionprops(cc,'Area','Centroid');
        small = [st.Area] < minArea;
        mask(vertcat(cc.PixelIdxList{small})) = false;
        st = st(~small);
        if isempty(st), cents = zeros(0,2); else, cents = vertcat(st.Centroid); end
    end
    function [ang, gaps] = blobGaps(cents, sz, minR, dedup)
    %BLOBGAPS  Adjacent angular gaps between blobs, folded to [0,180). Drawing only.
        if nargin < 3 || isempty(minR),  minR  = 2; end
        if nargin < 4 || isempty(dedup), dedup = 8; end
        c0 = [(sz(2)+1)/2, (sz(1)+1)/2];
        ang = [];
        for i = 1:size(cents,1)
            d = cents(i,:) - c0;
            if hypot(d(1),d(2)) < minR, continue; end
            ang(end+1) = mod(atan2d(d(2),d(1)),180); %#ok<AGROW>
        end
        ang = sort(ang);
        if numel(ang) > 1, ang = ang([true, diff(ang) > dedup]); end
        if numel(ang) > 1 && (ang(1) + 180 - ang(end)) <= dedup, ang(end) = []; end
        if numel(ang) < 2, gaps = []; return; end
        gaps = diff([ang, ang(1)+180]);
    end
    function [cents, gaps] = spectrumCut(ax, S, ttl, halfWidth, thresh)
    %SPECTRUMCUT  Thresholded power spectrum, linear scale, axes in cycles/m.
        if nargin < 4 || isempty(halfWidth), halfWidth = 40; end
        if nargin < 5 || isempty(thresh), thresh = viz.THRESH; end
        S = double(S);
        [mask, cents] = viz.thresholdSpectrum(S, thresh);
        [~, gaps] = viz.blobGaps(cents, size(S));
        [k, r] = viz.kaxis(S, halfWidth);
        T = S;  T(~mask) = 0;  T = T(r,r);
        cb = [0 max(T(:), [], 'all')];
        if ~all(isfinite(cb)) || cb(2) <= cb(1), cb = [0 1]; end
        imagesc(ax, k, k, T.', cb);
        set(ax,'YDir','normal');  axis(ax,'image');
        colormap(ax, viz.map());
        xlabel(ax,'k_x  (cycles m^{-1})');  ylabel(ax,'k_y  (cycles m^{-1})');
        viz.despine(ax);
        if nargin > 2 && ~isempty(ttl), viz.panelTitle(ax, ttl); end
    end
    function [k, r, W, h, df] = kaxis(S, halfWidth)
    %KAXIS  Spatial-frequency axis of a stored spectrum crop, cycles/m.
        n = size(S,1);  h = floor(n/2)+1;  W = min(halfWidth, h-1);
        r = h-W : h+W;
        bin = viz.ARENA_CM/viz.NBINS;
        df  = 100/(viz.PAD*bin);
        k   = (-W:W)*df;
    end
    % --------------------------------------------------------- alpha x R maps
    function im = phase(ax, M, alpha, R, kind, ttl, cblabel, lims)
    %PHASE  alpha x R map, R inverted on y. kind: 'lo' (low = damaged),
    %   'hi' (high = damaged) or 'diff' (signed). Red is always degraded.
        if nargin < 8, lims = []; end
        M = double(M);
        im = imagesc(ax, alpha, R, M.');
        set(im,'AlphaData', ~isnan(M.'));
        set(ax,'YDir','reverse');
        switch kind
            case 'lo',   colormap(ax, viz.phaseLo());
            case 'hi',   colormap(ax, viz.phaseHi());
            case 'diff', colormap(ax, viz.div());
                         if isempty(lims), lims = viz.sym(M)*[-1 1]; end
            otherwise,   error('viz:phase','kind must be lo, hi or diff');
        end
        if ~isempty(lims), clim(ax, lims); end
        axis(ax,'tight');
        xlabel(ax,'\alpha   (severity)');
        ylabel(ax,'damage radius R   (prevalence)');
        viz.panelTitle(ax, ttl);
        set(ax,'YTick',[1 13 26 39 52 65 78 91],'XTick',[0.1 0.3 0.5 0.7 1.0]);
        viz.lambdaRules(ax, max(R), 'y');
        cb = colorbar(ax);
        cb.Label.String = cblabel;  cb.Label.Color = viz.INK;
        cb.Color = viz.MUTED;  cb.LineWidth = 0.6;
    end
    function lambdaRules(ax, Rmax, which_, col)
    %LAMBDARULES  Dashed rules at integer multiples of lambda.
        if nargin < 3 || isempty(which_), which_ = 'y'; end
        if nargin < 4 || isempty(col), col = [1 1 1]; end
        for k = 1:7
            v = k*viz.LAMBDA;
            if v > Rmax, break; end
            if strcmp(which_,'y')
                yline(ax, v, '--', sprintf('%d\\lambda',k), 'Color', col, ...
                      'LineWidth',1.0, 'FontSize',7.5, ...
                      'LabelHorizontalAlignment','left', ...
                      'LabelVerticalAlignment','bottom', 'Alpha',0.85);
            else
                xline(ax, v, '--', sprintf('%d\\lambda',k), 'Color', col, ...
                      'LineWidth',1.0, 'FontSize',8.05, 'Alpha',0.85);
            end
        end
    end
    function v = sym(M)
        v = max(abs(double(M(:))),[],'omitnan');
        if ~isfinite(v) || v <= 0, v = 1e-9; end
    end
    % ------------------------------------------------------------------ text
    function panelTitle(ax, str, col)
        if nargin < 3 || isempty(col), col = viz.INK; end
        title(ax, str, 'Color', col, 'FontWeight','normal', ...
              'FontSize', viz.base(ax), 'Interpreter','tex');
    end
    function corner(ax, str, where)
    %CORNER  Small annotation inside the axes.
        switch where
            case 'nw', x=0.03; y=0.97; va='top';    ha='left';
            case 'sw', x=0.03; y=0.03; va='bottom'; ha='left';
            case 's',  x=0.50; y=0.03; va='bottom'; ha='center';
            otherwise, x=0.03; y=0.97; va='top';    ha='left';
        end
        text(ax, x, y, str, 'Units','normalized', ...
             'FontSize', viz.base(ax)-2.4, 'Color', viz.INK, ...
             'VerticalAlignment',va, 'HorizontalAlignment',ha, ...
             'BackgroundColor', viz.SURF, 'Margin', 1.0);
    end
    % ------------------------------------------------------------- internals
    function m = ramp(ctrl, n)
        if nargin < 2 || isempty(n), n = 256; end
        x = linspace(0, 1, size(ctrl,1));
        m = interp1(x, ctrl, linspace(0, 1, n), 'pchip');
        m = min(1, max(0, m));
    end
    function c = hex2rgb(h)
        if ischar(h) || isstring(h), h = cellstr(h); end
        c = zeros(numel(h), 3);
        for k = 1:numel(h)
            s = char(h{k});
            s = s(s ~= '#');
            c(k,:) = [hex2dec(s(1:2)), hex2dec(s(3:4)), hex2dec(s(5:6))] / 255;
        end
    end
    function s = thousands(n)
    %THOUSANDS  Integer with comma separators: 97888 -> '97,888'.
        s = sprintf('%d', round(n));
        neg = startsWith(s, '-');  if neg, s = s(2:end); end
        for k = numel(s)-3 : -3 : 1
            s = [s(1:k) ',' s(k+1:end)];
        end
        if neg, s = ['-' s]; end
    end
    function [ks, ok] = pickGeometry(res)
    %PICKGEOMETRY  Index of the cell that best exemplifies 60-degree
    %   separation and of the one that best exemplifies 90, for the exemplar
    %   figures. A candidate must have the separation it is meant to show;
    %   ok(j) is false when no cell in the run does, in which case the index
    %   comes from the unrestricted ranking and the caller labels it as such.
        n60 = res.n60(:);  n90 = res.n90(:);
        ok  = [any(n60 > 0), any(n90 > 0)];
        ks  = [rank(n60, n90, n60 > 0), rank(n90, n60, n90 > 0)];
        function k = rank(want, other, pool)
            if ~any(pool), pool = true(size(want)); end
            idx = find(pool);
            [~, o] = sortrows([-(want(idx) - other(idx)), -want(idx), idx]);
            k = idx(o(1));
        end
    end
    function [gaps, lb] = gapsFromLobes(lobes)
    %GAPSFROMLOBES  Adjacent angular gaps from res.lobes, per cell, using the
    %   rule of Ying et al. (2023): sort the component angles on 0 to 360,
    %   close the circle and difference. lb gives the cell index of each gap.
        gaps = [];  lb = [];
        for k = 1:numel(lobes)
            a = lobes{k};
            if isempty(a), continue; end
            a = mod(double(a(:)), 360);
            a = sort(a(~isnan(a)));
            if numel(a) < 2, continue; end
            d = diff([a; a(1) + 360]);
            gaps = [gaps; d];                        %#ok<AGROW>
            lb   = [lb;   repmat(k, numel(d), 1)];   %#ok<AGROW>
        end
    end
    end
end
