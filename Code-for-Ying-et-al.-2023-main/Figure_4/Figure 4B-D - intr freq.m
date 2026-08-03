


clear
load('grid_dir_separated_into_hexagonal_and_rectangular.mat')


%compute intrinsic frequencies for hexagonal and quadrant-like grid cells

wty1 = [];
for i = 1:size(wtydir1,1)
   clear root
   load(wtydir1{i,3})
   cel = wtydir1{i,4};
   [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
   wty1 = [wty1; [F, power_ratio]];
end
wty2 = [];
for i = 1:size(wtydir2,1)
   clear root
   load(wtydir2{i,3})
   cel = wtydir2{i,4};
   [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
   wty2 = [wty2; [F, power_ratio]];
end
wta1 = [];
for i = 1:size(wtadir1,1)
   clear root
   load(wtadir1{i,3})
   cel = wtadir1{i,4};
   [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
   wta1 = [wta1; [F, power_ratio]];
end
wta2 = [];
for i = 1:size(wtadir2,1)
   clear root
   load(wtadir2{i,3})
   cel = wtadir2{i,4};
   [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
   wta2 = [wta2; [F, power_ratio]];
end
j20y1 = [];
for i = 1:size(j20ydir1,1)
   clear root
   load(j20ydir1{i,3})
   cel = j20ydir1{i,4};
   [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
   j20y1 = [j20y1; [F, power_ratio]];
end
j20y2 = [];
for i = 1:size(j20ydir2,1)
   clear root
   load(j20ydir2{i,3})
   cel = j20ydir2{i,4};
   [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
   j20y2 = [j20y2; [F, power_ratio]];
end
j20a1 = [];
for i = 1:size(j20adir1,1)
   clear root
   load(j20adir1{i,3})
   cel = j20adir1{i,4};
   [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
   j20a1 = [j20a1; [F, power_ratio]];
end
j20a2 = [];
for i = 1:size(j20adir2,1)
   clear root
   load(j20adir2{i,3})
   cel = j20adir2{i,4};
   [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
   j20a2 = [j20a2; [F, power_ratio]];
end

%place holder
wty1place = wty1;
wty2place = wty2;
wta1place = wta1;
wta2place = wta2;
j20y1place = j20y1;
j20y2place = j20y2;
j20a1place = j20a1;
j20a2place = j20a2;


%% theta modulation ratio 
wty1 = wty1place(:,2)
wta1 = wta1place(:,2)
j20y1 = j20y1place(:,2)
j20a1 = j20a1place(:,2)
wty2 = wty2place(:,2)
wta2 = wta2place(:,2)
j20y2 = j20y2place(:,2)
j20a2 = j20a2place(:,2)



%find proportion of significantly theta modulated HEXAGONAL grids
length(find(wty1(:,1)>=4))
length(find(wta1(:,1)>=4))
length(find(j20y1(:,1)>=4))
length(find(j20a1(:,1)>=4))

length(find(wty1(:,1)>=4))/length(wty1)
length(find(wta1(:,1)>=4))/length(wta1)
length(find(j20y1(:,1)>=4))/length(j20y1)
length(find(j20a1(:,1)>=4))/length(j20a1)


%find proportion of significantly theta modulated QUADRANT-LIKE grids
length(find(wty2(:,1)>=4))
length(find(wta2(:,1)>=4))
length(find(j20y2(:,1)>=4))
length(find(j20a2(:,1)>=4))

length(find(wty2(:,1)>=4))/length(wty2)
length(find(wta2(:,1)>=4))/length(wta2)
length(find(j20y2(:,1)>=4))/length(j20y2)
length(find(j20a2(:,1)>=4))/length(j20a2)


%chi squared tests
%hexagonal
n1 = length(find(wty1(:,1)>=4));
n2 = length(wty1);
n3 = length(find(wta1(:,1)>=4));
n4 = length(wta1);
n5 = length(find(j20y1(:,1)>=4));
n6 = length(j20y1);
n7 = length(find(j20a1(:,1)>=4));
n8 = length(j20a1);

HexaRec = [zeros(n1,1)+1; zeros(n2-n1,1)+2;zeros(n3,1)+1; zeros(n4-n3,1)+2;zeros(n5,1)+1; zeros(n6-n5,1)+2;zeros(n7,1)+1; zeros(n8-n7,1)+2];
Group = [zeros(n2,1)+1; zeros(n4,1)+2;zeros(n6,1)+3;zeros(n8,1)+4];

[tbl,chi2stat,pval] = crosstab(HexaRec,Group)

%quadrant-like
n1 = length(find(wty2(:,1)>=4));
n2 = length(wty2);
n3 = length(find(wta2(:,1)>=4));
n4 = length(wta2);
n5 = length(find(j20y2(:,1)>=4));
n6 = length(j20y2);
n7 = length(find(j20a2(:,1)>=4));
n8 = length(j20a2);

HexaRec = [zeros(n1,1)+1; zeros(n2-n1,1)+2;zeros(n3,1)+1; zeros(n4-n3,1)+2;zeros(n5,1)+1; zeros(n6-n5,1)+2;zeros(n7,1)+1; zeros(n8-n7,1)+2];
Group = [zeros(n2,1)+1; zeros(n4,1)+2;zeros(n6,1)+3;zeros(n8,1)+4];

[tbl,chi2stat,pval] = crosstab(HexaRec,Group)


%bar charts 

bar([length(find(wty1(:,1)>=4))/length(wty1), length(find(wty2(:,1)>=4))/length(wty2),... 
    length(find(wta1(:,1)>=4))/length(wta1), length(find(wta2(:,1)>=4))/length(wta2),...
    length(find(j20y1(:,1)>=4))/length(j20y1), length(find(j20y2(:,1)>=4))/length(j20y2),...
    length(find(j20a1(:,1)>=4))/length(j20a1), length(find(j20a2(:,1)>=4))/length(j20a2)])
axis square
ylim([0,1])


% hexaavg = (length(find(wty1(:,1)>=4))/length(wty1) + length(find(wta1(:,1)>=4))/length(wta1) + length(find(j20y1(:,1)>=4))/length(j20y1) + length(find(j20a1(:,1)>=4))/length(j20a1))/4
% recavg = (length(find(wty2(:,1)>=4))/length(wty2) + length(find(wta2(:,1)>=4))/length(wta2) + length(find(j20y2(:,1)>=4))/length(j20y2) + length(find(j20a2(:,1)>=4))/length(j20a2))/4

% %%


nanmedian(wty1)
nanmedian(wty2)
nanmedian(wta1)
nanmedian(wta2)
nanmedian(j20y1)
nanmedian(j20y2)
nanmedian(j20a1)
nanmedian(j20a2)


% more stats

%stats on hexagonal cells
wty = wty1
wta = wta1
j20y = j20y1
j20a = j20a1

%stats on quadrant-like cells
wty = wty2
wta = wta2
j20y = j20y2
j20a = j20a2

%cdf plot
cdfplot(wty)
hold on
cdfplot(wta)
hold on
cdfplot(j20y)
hold on 
cdfplot(j20a)
axis square

%bar plot
wty_med = nanmedian(wty)
wto_med = nanmedian(wta)
j20y_med = nanmedian(j20y)
j20o_med = nanmedian(j20a)

wty25 = prctile(wty,25)
wty75 = prctile(wty,75)
wto25 = prctile(wta,25)
wto75 = prctile(wta,75)
j20y25 = prctile(j20y,25)
j20y75 = prctile(j20y,75)
j20o25 = prctile(j20a,25)
j20o75 = prctile(j20a,75)

medianvalues = [wty_med;wto_med;j20y_med;j20o_med];

figure
bar(medianvalues,'k', 'FaceAlpha',0.2)
hold on
line([1 1], [wty25 wty75]);
hold on
line([2 2], [wto25 wto75]);
hold on
line([3 3], [j20y25 j20y75]);
hold on
line([4 4], [j20o25 j20o75]);
hold on

ranksum(wty,wta)
ranksum(wty,j20y)
ranksum(j20y,j20a)
ranksum(wta,j20a)

% 2-way ANOVA for grid score (or any other metric) 

grid = [wty;wta;j20y;j20a];

sizeWTy = size(wty); sizeWTy = sizeWTy(1,1);
sizeWTa = size(wta); sizeWTa = sizeWTa(1,1);
sizeJ20y = size(j20y); sizeJ20y = sizeJ20y(1,1);
sizeJ20a = size(j20a); sizeJ20a = sizeJ20a(1,1);

A = repmat('young',sizeWTy,1);
B = repmat('aged ',sizeWTa,1);
C = repmat('young',sizeJ20y,1);
D = repmat('aged ',sizeJ20a,1);

Ages =[A;B;C;D];

A = repmat('b_nTG',sizeWTy,1);
B = repmat('b_nTG',sizeWTa,1);
C = repmat('a_J20',sizeJ20y,1);
D = repmat('a_J20',sizeJ20a,1);

Genotype2 =[A;B;C;D];

[p,tbl,stats] = anovan(grid,{Ages Genotype2},'model',2,'varnames',{'Age','Genotype'})


%%%%%%
%%%%%%
% vary time bin size and see how that affects everything 

% t_bin = .001; % 1 ms bin width
% t_bin = .002; % 2 ms bin width
% t_bin = .003; % 2 ms bin width
% t_bin = .004; % 4 ms bin width
% t_bin = .005; % 5 ms bin width
% t_bin = .006; % 6 ms bin width
% t_bin = .007; % 7 ms bin width
% t_bin = .008; % 8 ms bin width
% t_bin = .009; % 9 ms bin width
% t_bin = .010; % 10 ms bin width

t_bins = [0.001,0.002,0.003,0.004,0.005,0.006,0.007,0.008,0.009,0.010];

hexagonalpowers = [];
hexagonalavgpowers = [];
hexagonalchisquared = [];

recpowers = [];
recavgpowers = [];
recchisquared = [];

for ii = 1:10

    t_bin = t_bins(1,ii);
    
    %compute intrinsic frequencies
    wty1 = [];
    for i = 1:size(wtydir1,1)
       clear root
       load(wtydir1{i,3})
       cel = wtydir1{i,4};
       [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],t_bin);
       wty1 = [wty1; [F, power_ratio]];
    end
    wty2 = [];
    for i = 1:size(wtydir2,1)
       clear root
       load(wtydir2{i,3})
       cel = wtydir2{i,4};
       [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],t_bin);
       wty2 = [wty2; [F, power_ratio]];
    end
    wta1 = [];
    for i = 1:size(wtadir1,1)
       clear root
       load(wtadir1{i,3})
       cel = wtadir1{i,4};
       [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],t_bin);
       wta1 = [wta1; [F, power_ratio]];
    end
    wta2 = [];
    for i = 1:size(wtadir2,1)
       clear root
       load(wtadir2{i,3})
       cel = wtadir2{i,4};
       [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],t_bin);
       wta2 = [wta2; [F, power_ratio]];
    end
    j20y1 = [];
    for i = 1:size(j20ydir1,1)
       clear root
       load(j20ydir1{i,3})
       cel = j20ydir1{i,4};
       [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],t_bin);
       j20y1 = [j20y1; [F, power_ratio]];
    end
    j20y2 = [];
    for i = 1:size(j20ydir2,1)
       clear root
       load(j20ydir2{i,3})
       cel = j20ydir2{i,4};
       [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],t_bin);
       j20y2 = [j20y2; [F, power_ratio]];
    end
    j20a1 = [];
    for i = 1:size(j20adir1,1)
       clear root
       load(j20adir1{i,3})
       cel = j20adir1{i,4};
       [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],t_bin);
       j20a1 = [j20a1; [F, power_ratio]];
    end
    j20a2 = [];
    for i = 1:size(j20adir2,1)
       clear root
       load(j20adir2{i,3})
       cel = j20adir2{i,4};
       [F, power_ratio] = root.IntrinsicFrequency(cel, 0, [-1 -1],t_bin);
       j20a2 = [j20a2; [F, power_ratio]];
    end


    wty1place = wty1;
    wty2place = wty2;
    wta1place = wta1;
    wta2place = wta2;
    j20y1place = j20y1;
    j20y2place = j20y2;
    j20a1place = j20a1;
    j20a2place = j20a2;

    %retrieve power ratios 
    wty1 = wty1place(:,2);
    wta1 = wta1place(:,2);
    j20y1 = j20y1place(:,2);
    j20a1 = j20a1place(:,2);
    wty2 = wty2place(:,2);
    wta2 = wta2place(:,2);
    j20y2 = j20y2place(:,2);
    j20a2 = j20a2place(:,2);


    % length(find(wty1(:,1)>=4))
    % length(find(wta1(:,1)>=4))
    % length(find(j20y1(:,1)>=4))
    % length(find(j20a1(:,1)>=4))

    hexagonalpowers(:,ii) = [length(find(wty1(:,1)>=4))/length(wty1); length(find(wta1(:,1)>=4))/length(wta1);length(find(j20y1(:,1)>=4))/length(j20y1);length(find(j20a1(:,1)>=4))/length(j20a1)];

    % length(find(wty2(:,1)>=4))
    % length(find(wta2(:,1)>=4))
    % length(find(j20y2(:,1)>=4))
    % length(find(j20a2(:,1)>=4))
    
    recpowers(:,ii) = [length(find(wty2(:,1)>=4))/length(wty2);length(find(wta2(:,1)>=4))/length(wta2);length(find(j20y2(:,1)>=4))/length(j20y2);length(find(j20a2(:,1)>=4))/length(j20a2)];


    hexaavg = (length(find(wty1(:,1)>=4))/length(wty1) + length(find(wta1(:,1)>=4))/length(wta1) + length(find(j20y1(:,1)>=4))/length(j20y1) + length(find(j20a1(:,1)>=4))/length(j20a1))/4
    hexagonalavgpowers(1,ii) = hexaavg;

    recavg = (length(find(wty2(:,1)>=4))/length(wty2) + length(find(wta2(:,1)>=4))/length(wta2) + length(find(j20y2(:,1)>=4))/length(j20y2) + length(find(j20a2(:,1)>=4))/length(j20a2))/4
    recavgpowers(1,ii) = recavg;

    %chi squared    
    n1 = length(find(wty1(:,1)>=4));
    n2 = length(wty1);
    n3 = length(find(wta1(:,1)>=4));
    n4 = length(wta1);
    n5 = length(find(j20y1(:,1)>=4));
    n6 = length(j20y1);
    n7 = length(find(j20a1(:,1)>=4));
    n8 = length(j20a1);

    HexaRec = [zeros(n1,1)+1; zeros(n2-n1,1)+2;zeros(n3,1)+1; zeros(n4-n3,1)+2;zeros(n5,1)+1; zeros(n6-n5,1)+2;zeros(n7,1)+1; zeros(n8-n7,1)+2];
    Group = [zeros(n2,1)+1; zeros(n4,1)+2;zeros(n6,1)+3;zeros(n8,1)+4];

    [tbl,chi2stat,pval] = crosstab(HexaRec,Group);
    hexagonalchisquared(ii,1) = chi2stat;
    hexagonalchisquared(ii,2) = pval;
    


    n1 = length(find(wty2(:,1)>=4));
    n2 = length(wty2);
    n3 = length(find(wta2(:,1)>=4));
    n4 = length(wta2);
    n5 = length(find(j20y2(:,1)>=4));
    n6 = length(j20y2);
    n7 = length(find(j20a2(:,1)>=4));
    n8 = length(j20a2);

    HexaRec = [zeros(n1,1)+1; zeros(n2-n1,1)+2;zeros(n3,1)+1; zeros(n4-n3,1)+2;zeros(n5,1)+1; zeros(n6-n5,1)+2;zeros(n7,1)+1; zeros(n8-n7,1)+2];
    Group = [zeros(n2,1)+1; zeros(n4,1)+2;zeros(n6,1)+3;zeros(n8,1)+4];

    [tbl,chi2stat,pval] = crosstab(HexaRec,Group);
    recchisquared(ii,1) = chi2stat;
    recchisquared(ii,2) = pval;
end

subplot(1,2,1)
plot(hexagonalpowers(1,:),'r')
hold on
scatter( linspace(1,length(hexagonalpowers(1,:)), length(hexagonalpowers(1,:))), hexagonalpowers(1,:), 50,'r')
hold on 
plot(hexagonalpowers(2,:),'b')
hold on
scatter( linspace(1,length(hexagonalpowers(2,:)), length(hexagonalpowers(2,:))), hexagonalpowers(2,:), 50,'b')
hold on 
plot(hexagonalpowers(3,:),'g')
hold on
scatter( linspace(1,length(hexagonalpowers(3,:)), length(hexagonalpowers(3,:))), hexagonalpowers(3,:), 50,'g')
hold on 
plot(hexagonalpowers(4,:),'k')
hold on
scatter( linspace(1,length(hexagonalpowers(4,:)), length(hexagonalpowers(4,:))), hexagonalpowers(4,:), 50,'k')
hold on 
ylim([0,1])
axis square
hold on 
plot(hexagonalavgpowers(1,:),'c')
hold on



subplot(1,2,2)
plot(recpowers(1,:),'r')
hold on
scatter( linspace(1,length(recpowers(1,:)), length(recpowers(1,:))), recpowers(1,:), 50,'r')
hold on 
plot(recpowers(2,:),'b')
hold on
scatter( linspace(1,length(recpowers(2,:)), length(recpowers(2,:))), recpowers(2,:), 50,'b')
hold on 
plot(recpowers(3,:),'g')
hold on
scatter( linspace(1,length(recpowers(3,:)), length(recpowers(3,:))), recpowers(3,:), 50,'g')
hold on 
plot(recpowers(4,:),'k')
hold on
scatter( linspace(1,length(recpowers(4,:)), length(recpowers(4,:))), recpowers(4,:), 50,'k')
hold on 
ylim([0,1])
axis square
hold on 
plot(recavgpowers(1,:),'c')
hold on

