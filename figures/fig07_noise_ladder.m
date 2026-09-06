function fig07_noise_ladder(mode, outdir)
%FIG07_NOISE_LADDER  Report Figure 7, f60 against velocity noise, both laws.
%   The line is the mean of per-run f60 over the 50 runs at each level, runs
%   with no 60 or 90 degree gap (0/0) excluded. Shading spans the 10th to 90th
%   percentile of per-run f60. (A) full range, (B) transition band with the
%   f60 equivalents of the Ying et al. (2023) group ratios as dashed lines.
%
%   Inputs  agg_noise.mat, agg_constband.mat    GWN, 50 levels 0 to 15 and the band
%           agg_noise_sd.mat, agg_sdband.mat    SDN, same grids
%           Levels present in both sweeps (same seeds) are printed as a
%           consistency check; the band value is plotted.
%   Output  fig07_noise_ladder.pdf and .png in outdir.
%
%   fig07_noise_ladder('thesis', 'output')
arguments
    mode   (1,:) char {mustBeMember(mode,{'thesis','slide'})} = 'thesis'
    outdir (1,:) char = 'output'
end
root = fileparts(fileparts(mfilename('fullpath')));

laws = struct( ...
    'name', {'GWN','SDN'}, ...
    'files',{{'agg_noise.mat','agg_constband.mat'}, {'agg_noise_sd.mat','agg_sdband.mat'}}, ...
    'col',  {viz.S1, viz.S2}, ...
    'mk',   {'o','s'});

D = struct('name',{},'r',{},'y',{},'lo',{},'hi',{},'col',{},'mk',{});
for i = 1:numel(laws)
    R=[]; Y=[]; SRC=[]; LO=[]; HI=[];
    for j = 1:2
        p = fullfile(root, laws(i).files{j});
        if ~isfile(p), fprintf('[skip] %s not present\n', laws(i).files{j}); continue; end
        a = load(p).agg;
        r = a.ratio(:);
        Fr = a.s60./(a.s60+a.s90);  Fr(~isfinite(Fr)) = NaN;   % per-run f60
        y = mean(Fr,2,'omitnan');  y(all(isnan(Fr),2)) = NaN;
        lo = prctile(Fr,10,2);  hi = prctile(Fr,90,2);
        R=[R;r]; Y=[Y;y]; LO=[LO;lo]; HI=[HI;hi]; SRC=[SRC;j*ones(size(r))]; %#ok<AGROW>
    end
    if isempty(R), continue; end

    [u,~,ic] = uniquetol(R,1e-9);
    dup = find(accumarray(ic,1) > 1);
    if ~isempty(dup)
        fprintf('\n[%s] levels measured by both sweeps, same 50 seeds\n', laws(i).name);
        fprintf('   %8s %10s %10s %10s\n','ratio','default','band','difference');
        for k = dup(:)'
            m = find(ic==k); a1 = m(SRC(m)==1); a2 = m(SRC(m)==2);
            if isempty(a1)||isempty(a2), continue; end
            fprintf('   %8.2f %10.4f %10.4f %+10.4f\n', u(k), Y(a1(1)), Y(a2(1)), Y(a2(1))-Y(a1(1)));
        end
    end
    keep = false(size(R));                             % band wins a tie
    for k = 1:numel(u)
        m = find(ic==k); b = m(SRC(m)==2);
        if isempty(b), keep(m(1)) = true; else, keep(b(1)) = true; end
    end
    [rs,ord] = sort(R(keep)); Yk = Y(keep); Lk = LO(keep); Hk = HI(keep);
    D(end+1) = struct('name',laws(i).name,'r',rs,'y',Yk(ord), ...
                      'lo',Lk(ord),'hi',Hk(ord), ...
                      'col',laws(i).col,'mk',laws(i).mk); %#ok<AGROW>
    fprintf('[%s] %d levels %.2f to %.2f, f60 %.3f to %.3f\n', ...
            laws(i).name, numel(rs), min(rs), max(rs), max(Yk), min(Yk));
end
assert(~isempty(D), 'no ladder aggregates found in %s', root);

% where each curve crosses the f60 equivalent of each Ying et al. group ratio
YR = viz.YING_V(:);  YF = YR./(1+YR);  YL = viz.YING_L;
for i = 1:numel(D)
    fprintf('[%s] crossings of the Ying et al. f60 equivalents\n', D(i).name);
    for y = 1:numel(YF)
        r = D(i).r(:); v = D(i).y(:); c = NaN;
        for k = 1:numel(r)-1
            if v(k) >= YF(y) && v(k+1) < YF(y), c = r(k) + (v(k)-YF(y))/(v(k)-v(k+1))*(r(k+1)-r(k)); break; end
        end
        fprintf('   %-6s f60 %.3f  sigma_v/mu_v %.3f\n', YL{y}, YF(y), c);
    end
end

% figure
TXT = viz.INK;  ZOOM = [4.40 5.50];
f = viz.figure(5.8, mode);
t = tiledlayout(f,1,2,'Padding','compact','TileSpacing','compact');
for panel = 1:2
    ax = nexttile(t); hold(ax,'on');
    if panel==2
        for y = 1:numel(YF)
            yline(ax, YF(y), '--', YL{y}, 'Color', viz.MUTED, 'LineWidth',0.8, ...
                  'FontSize', viz.base(ax)-2, 'LabelHorizontalAlignment','right', ...
                  'LabelVerticalAlignment','bottom');
        end
    end
    for i = 1:numel(D)                     % percentile band behind the lines
        xx = D(i).r(:); ll = D(i).lo(:); hh = D(i).hi(:);
        g = ~isnan(ll) & ~isnan(hh);
        if any(g)
            fill(ax, [xx(g); flipud(xx(g))], [ll(g); flipud(hh(g))], D(i).col, ...
                 'FaceAlpha',0.16, 'EdgeColor','none', 'HandleVisibility','off');
        end
    end
    h = gobjects(1,0); lab = {};
    for i = 1:numel(D)
        h(end+1) = plot(ax, D(i).r, D(i).y, [D(i).mk '-'], 'Color', D(i).col, ...
                        'MarkerFaceColor', D(i).col, 'MarkerSize',3.2, 'LineWidth',1.6); %#ok<AGROW>
        lab{end+1} = D(i).name; %#ok<AGROW>
    end
    ylim(ax,[-0.03 1.05]); xlabel(ax,'\sigma_v / \mu_v');
    if panel==1
        xlim(ax,[0 max(arrayfun(@(d) max(d.r), D))]);
        ylabel(ax,'f_{60}');
        legend(ax,h,lab,'Box','off','TextColor',TXT,'Location','northeast','FontSize',viz.base(ax)-2);
    else
        xlim(ax,ZOOM); xticks(ax,4.4:0.2:5.4);
    end
    text(ax,0.02,0.98,char('A'+panel-1),'Units','normalized','FontWeight','bold', ...
         'FontSize',viz.base(ax)+2,'HorizontalAlignment','left','VerticalAlignment','top','Color',TXT);
    viz.despine(ax); set(ax,'XColor',TXT,'YColor',TXT);
end
viz.save(f, 'fig07_noise_ladder', mode, fullfile(root, outdir));
end
