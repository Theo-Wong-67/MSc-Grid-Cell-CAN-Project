

%
% test if 7.5 degree offset of grid axes reported in Stensola et al. 2015 is there for our data

clear 
load('grid_polars_CORRECTED_BAD_CELLS.mat')

wty_data = [wtynormal; wty_data2(:,1:3)];
wta_data = [wtanormal; wta_data2(:,1:3)];
j20y_data = [j20ynormal; j20y_data2(:,1:3)];
j20a_data = [j20anormal; j20a_data2(:,1:3)];

size(wty_data)
size(wta_data)
size(j20y_data)
size(j20a_data)


wtyscores = [wtynormaldir(:,5:9); wtycorrectdir(:,5:9)];
wtascores = [wtanormaldir(:,5:9); wtacorrectdir(:,5:9)];
j20yscores = [j20ynormaldir(:,5:9); j20ycorrectdir(:,5:9)];
j20ascores = [j20anormaldir(:,5:9); j20acorrectdir(:,5:9)];

wtyscores = cell2mat(wtyscores);
wtascores = cell2mat(wtascores);
j20yscores = cell2mat(j20yscores);
j20ascores = cell2mat(j20ascores);

wtyshuffleddir = [wtynormaldir; wtycorrectdir];
wtashuffleddir = [wtanormaldir; wtacorrectdir];
j20yshuffleddir = [j20ynormaldir; j20ycorrectdir];
j20ashuffleddir = [j20anormaldir; j20acorrectdir];

wtyshuffleddata = wty_data;
wtashuffleddata = wta_data;
j20yshuffleddata = j20y_data;
j20ashuffleddata = j20a_data;


%same code for running Fig.2c
wty = [];

for i = 1:size(wty_data,1)
    
    p = wty_data{i,2};
    ac = p(:,2)';
%     ac = sqrt(ac);
    maxshift = size(ac,2);
    ttt = [];
    
    for ii = 1:maxshift
        c = corrcoef(ac, circshift(ac,ii), 'rows', 'complete');
        ttt = [ttt; c(1,2)];
    end
    
    wty = [wty; ttt']; 
end
[wty, idx] = sortrows(wty,104,'descend'); 
wtyscores = wtyscores(idx,:);
wtyshuffleddir = wtyshuffleddir(idx,:);
wtyshuffleddata = wtyshuffleddata(idx,:);

f = find(isnan(wty(:,104)));
wtyscores(f,:) = [];
wty(f,:) = [];
wtyshuffleddir(f,:) = [];
wtyshuffleddata(f,:) = [];

wta = [];

for i = 1:size(wta_data,1)
    
    p = wta_data{i,2};
    ac = p(:,2)';
%     ac = sqrt(ac);
    maxshift = size(ac,2);
    ttt = [];
    
    for ii = 1:maxshift
        c = corrcoef(ac, circshift(ac,ii), 'rows', 'complete');
        ttt = [ttt; c(1,2)];
    end
    
    wta = [wta; ttt'];
end

[wta, idx] = sortrows(wta,104,'descend');
wtascores = wtascores(idx,:);
wtashuffleddir = wtashuffleddir(idx,:);
wtashuffleddata = wtashuffleddata(idx,:);

f = find(isnan(wta(:,104)));
wtascores(f,:) = [];
wta(f,:) = [];
wtashuffleddir(f,:) = [];
wtashuffleddata(f,:) = [];

j20y = [];

for i = 1:size(j20y_data,1)
    
    p = j20y_data{i,2};
    ac = p(:,2)';
%     ac = sqrt(ac);
    maxshift = size(ac,2);
    ttt = [];
    
    for ii = 1:maxshift
        c = corrcoef(ac, circshift(ac,ii), 'rows', 'complete');
        ttt = [ttt; c(1,2)];
    end
    
    j20y = [j20y; ttt'];
    
end

[j20y, idx] = sortrows(j20y,104,'descend');
j20yscores = j20yscores(idx,:);
j20yshuffleddir = j20yshuffleddir(idx,:);
j20yshuffleddata = j20yshuffleddata(idx,:);

f = find(isnan(j20y(:,104)));
j20yscores(f,:) = [];
j20y(f,:) = [];
j20yshuffleddir(f,:) = [];
j20yshuffleddata(f,:) = [];


j20a = [];
for i = 1:size(j20a_data,1)
    
    p = j20a_data{i,2};
    ac = p(:,2)';
%     ac = sqrt(ac);
    maxshift = size(ac,2);
    ttt = [];
    
    for ii = 1:maxshift
        c = corrcoef(ac, circshift(ac,ii), 'rows', 'complete');
        ttt = [ttt; c(1,2)];
    end
    
    j20a = [j20a; ttt'];
    
end

[j20a, idx] = sortrows(j20a,104,'descend');
j20ascores = j20ascores(idx,:);
j20ashuffleddir = j20ashuffleddir(idx,:);
j20ashuffleddata = j20ashuffleddata(idx,:);

f = find(isnan(j20a(:,104)));
j20ascores(f,:) = [];
j20a(f,:) = [];
j20ashuffleddir(f,:) = [];
j20ashuffleddata(f,:) = [];


%%
wty = wtyshuffleddata(:,1);
for i = 1:size(wty,1)
    wty{i,1} = zscore((wty{i,1}));
end

wty = cell2mat(wty)

imagesc(wty)
colormap jet

wta = wtashuffleddata(:,1);
for i = 1:size(wta,1)
    wta{i,1} = zscore((wta{i,1}));
end

wta = cell2mat(wta)

imagesc(wta)
colormap jet



j20y = j20yshuffleddata(:,1);
for i = 1:size(j20y,1)
    j20y{i,1} = zscore((j20y{i,1}));
end

j20y = cell2mat(j20y)

imagesc(j20y)
colormap jet


j20a = j20ashuffleddata(:,1);
for i = 1:size(j20a,1)
    j20a{i,1} = zscore((j20a{i,1}));
end

j20a = cell2mat(j20a)

imagesc(j20a)
colormap jet
% axis square

%the polar maps 
wty_polars = wtyshuffleddata(:,2);
wta_polars = wtashuffleddata(:,2);
j20y_polars = j20yshuffleddata(:,2);
j20a_polars = j20ashuffleddata(:,2);

subplot(1,4,1)
imagesc(wty)
colormap jet
subplot(1,4,2)
imagesc(wta)
colormap jet
subplot(1,4,3)
imagesc(j20y)
colormap jet
subplot(1,4,4)
imagesc(j20a)
colormap jet

%%

newwtyshuffledir = wtyshuffleddir;
newwtashuffledir = wtashuffleddir;
newj20yshuffledir = j20yshuffleddir;
newj20ashuffledir = j20ashuffleddir;

%% Just like in Fig.3B, we're going to sort cells by their absolute orientations
% This is the exact same code, except this time we're also sorting the
% polar plots. This was not originally done in Fig.3B. 

%points at which the grids stop
s1 = 27;
s2 = 49;
s3 = 23;
s4 = 20;

wtygridhalf = wty(1:s1,:);
wtyrechalf = wty(s1+1:end,:);

wty_polarsgridhalf = wty_polars(1:s1,:);
wty_polarsrechalf = wty_polars(s1+1:end,:);

newwtyshuffledirgridhalf = newwtyshuffledir(1:s1,:);
newwtyshuffledirrechalf = newwtyshuffledir(s1+1:end,:);


%lets work with wty first 
sixtydegreecolumn = [wtygridhalf(:,52), wtygridhalf(:,262), wtygridhalf(:,366), wtygridhalf(:,157), wtygridhalf(:,471)];
%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'descend');

wtygridhalf = wtygridhalf(idx,:);
newwtyshuffledirgridhalf = newwtyshuffledirgridhalf(idx, :);
wty_polarsgridhalf = wty_polarsgridhalf(idx, :);

finalwty = [wtygridhalf;wtyrechalf];
newwtyshuffledir = [newwtyshuffledirgridhalf;newwtyshuffledirrechalf];
wty_polars = [wty_polarsgridhalf; wty_polarsrechalf];

%switch rows 23 with 24
r23 = finalwty(23,:);
r24 = finalwty(24,:);
finalwty(23,:) = r24;
finalwty(24,:) = r23;

r23 = newwtyshuffledir(23,:);
r24 = newwtyshuffledir(24,:);
newwtyshuffledir(23,:) = r24;
newwtyshuffledir(24,:) = r23;

r23 = wty_polars(23,:);
r24 = wty_polars(24,:);
wty_polars(23,:) = r24;
wty_polars(24,:) = r23;

%switch rows 24 with 27
r24 = finalwty(24,:);
r27 = finalwty(27,:);
finalwty(24,:) = r27;
finalwty(27,:) = r24;

r24 = newwtyshuffledir(24,:);
r27 = newwtyshuffledir(27,:);
newwtyshuffledir(24,:) = r27;
newwtyshuffledir(27,:) = r24;

r24 = wty_polars(24,:);
r27 = wty_polars(27,:);
wty_polars(24,:) = r27;
wty_polars(27,:) = r24;

%row 15 can go to end
r15 = finalwty(15,:);
finalwty(15:end-1,:) = finalwty(16:end,:);
finalwty(end,:)= r15;

r15 = newwtyshuffledir(15,:);
newwtyshuffledir(15:end-1,:) = newwtyshuffledir(16:end,:);
newwtyshuffledir(end,:)= r15;

r15 = wty_polars(15,:);
wty_polars(15:end-1,:) = wty_polars(16:end,:);
wty_polars(end,:)= r15;

%switch rows 24 with 25
r24 = finalwty(24,:);
r25 = finalwty(25,:);
finalwty(24,:) = r25;
finalwty(25,:) = r24;

r24 = newwtyshuffledir(24,:);
r25 = newwtyshuffledir(25,:);
newwtyshuffledir(24,:) = r25;
newwtyshuffledir(25,:) = r24;

r24 = wty_polars(24,:);
r25 = wty_polars(25,:);
wty_polars(24,:) = r25;
wty_polars(25,:) = r24;

subplot(1,4,1)
imagesc(finalwty)
colormap jet

% visualize the sorted polar plots if you want
% count = 1;
% for i = 1:60
%     
%     p = wty_polars{i,1};
%     
%     pax = subplot(6,10,count, polaraxes);
%     polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
%     pax.RGrid  = 'off';
%     pax.RTickLabels = [];
%     set(gcf,'color','w');
%     count = count + 1;
% end

%
%
%
%next, wta
wtagridhalf = wta(1:s2,:);
wtarechalf = wta(s2+1:end,:);

wta_polarsgridhalf = wta_polars(1:s2,:);
wta_polarsrechalf = wta_polars(s2+1:end,:);

newwtashuffledirgridhalf = newwtashuffledir(1:s2,:);
newwtashuffledirrechalf = newwtashuffledir(s2+1:end,:);

%lets work with wta first 
sixtydegreecolumn = [wtagridhalf(:,52), wtagridhalf(:,262), wtagridhalf(:,366), wtagridhalf(:,157), wtagridhalf(:,471)];
% sixtydegreecolumn = [wtagridhalf(:,102:106), wtagridhalf(:,207:211), wtagridhalf(:,417:421), wtagridhalf(:,522:526)];

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'descend');

wtagridhalf = wtagridhalf(idx,:);
newwtashuffledirgridhalf = newwtashuffledirgridhalf(idx,:);
wta_polarsgridhalf = wta_polarsgridhalf(idx, :);

finalwta = [wtagridhalf;wtarechalf];
newwtashuffledir = [newwtashuffledirgridhalf;newwtashuffledirrechalf];
wta_polars = [wta_polarsgridhalf; wta_polarsrechalf];

%move 51 and 53 RIGHT after row 27 
r5153 = [finalwta(51,:);finalwta(53,:)];

finalwta(53,:) = [];
finalwta(51,:) = [];

firstwtahalf = finalwta(1:27,:);
secondwtahalf = finalwta(28:end,:);

finalwta = [firstwtahalf; r5153; secondwtahalf];


r5153 = [newwtashuffledir(51,:);newwtashuffledir(53,:)];

newwtashuffledir(53,:) = [];
newwtashuffledir(51,:) = [];

firstwtahalf = newwtashuffledir(1:27,:);
secondwtahalf = newwtashuffledir(28:end,:);

newwtashuffledir = [firstwtahalf; r5153; secondwtahalf];


r5153 = [wta_polars(51,:);wta_polars(53,:)];

wta_polars(53,:) = [];
wta_polars(51,:) = [];

firstwtahalf = wta_polars(1:27,:);
secondwtahalf = wta_polars(28:end,:);

wta_polars = [firstwtahalf; r5153; secondwtahalf];



%switch rows 52 with 53
r52 = finalwta(52,:);
r53 = finalwta(53,:);
finalwta(52,:) = r53;
finalwta(53,:) = r52;

r52 = newwtashuffledir(52,:);
r53 = newwtashuffledir(53,:);
newwtashuffledir(52,:) = r53;
newwtashuffledir(53,:) = r52;

r52 = wta_polars(52,:);
r53 = wta_polars(53,:);
wta_polars(52,:) = r53;
wta_polars(53,:) = r52;

subplot(1,4,2)
imagesc(finalwta)
colormap jet

% visualize the sorted polar plots if you want
% count = 1;
% for i = 1:60
%     
%     p = wta_polars{i,1};
%     
%     pax = subplot(6,10,count, polaraxes);
%     polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
%     pax.RGrid  = 'off';
%     pax.RTickLabels = [];
%     set(gcf,'color','w');
%     count = count + 1;
% end

%
%
%
%
% j20y
%next, wta
j20ygridhalf = j20y(1:s3,:);
j20yrechalf = j20y(s3+1:end,:);

j20y_polarsgridhalf = j20y_polars(1:s3,:);
j20y_polarsrechalf = j20y_polars(s3+1:end,:);

newj20yshuffledirgridhalf = newj20yshuffledir(1:s3,:);
newj20yshuffledirrechalf = newj20yshuffledir(s3+1:end,:);

%lets work with j20y first 
% sixtydegreecolumn = [j20ygridhalf(:,52), j20ygridhalf(:,262), j20ygridhalf(:,366), j20ygridhalf(:,157), j20ygridhalf(:,471)];
sixtydegreecolumn = [j20ygridhalf(:,102:106), j20ygridhalf(:,207:211), j20ygridhalf(:,417:421), j20ygridhalf(:,522:526)];

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'descend');

j20ygridhalf = j20ygridhalf(idx,:);
newj20yshuffledirgridhalf = newj20yshuffledir(idx,:);
j20y_polarsgridhalf = j20y_polarsgridhalf(idx, :);


finalj20y = [j20ygridhalf;j20yrechalf];
newj20yshuffledir = [newj20yshuffledirgridhalf; newj20yshuffledirrechalf];
j20y_polars = [ j20y_polarsgridhalf; j20y_polarsrechalf ];
 
%doing something a little different
%going to group 60 and 30 together
j20y60 = [1,2,3,4,5,6,7,9,10,13,15,17,21,22,23]';
j20y30 = [8,11,12,14,16,18,19,20]';
j20y90 = [24,25,26,27,28,29,30]';

j20y60 = finalj20y(j20y60,:);
j20y30 = finalj20y(j20y30,:);
j20y90 = finalj20y(j20y90,:);

j20y60 = flipud(j20y60);

finalj20y = [j20y30;j20y60;j20y90];

j20y60 = [1,2,3,4,5,6,7,9,10,13,15,17,21,22,23]';
j20y30 = [8,11,12,14,16,18,19,20]';
j20y90 = [24,25,26,27,28,29,30]';

j20y60 = newj20yshuffledir(j20y60,:);
j20y30 = newj20yshuffledir(j20y30,:);
j20y90 = newj20yshuffledir(j20y90,:);

j20y60 = flipud(j20y60);

newj20yshuffledir = [j20y30;j20y60;j20y90];

j20y60 = [1,2,3,4,5,6,7,9,10,13,15,17,21,22,23]';
j20y30 = [8,11,12,14,16,18,19,20]';
j20y90 = [24,25,26,27,28,29,30]';

j20y60 = j20y_polars(j20y60,:);
j20y30 = j20y_polars(j20y30,:);
j20y90 = j20y_polars(j20y90,:);

j20y60 = flipud(j20y60);

j20y_polars = [j20y30;j20y60;j20y90];



subplot(1,4,3)
imagesc(finalj20y)
colormap jet

% visualize the sorted polar plots if you want
% count = 1;
% for i = 1:60
%     
%     p = j20y_polars{i,1};
%     
%     pax = subplot(6,10,count, polaraxes);
%     polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
%     pax.RGrid  = 'off';
%     pax.RTickLabels = [];
%     set(gcf,'color','w');
%     count = count + 1;
% end


%
%
%
% j20a
j20agridhalf = j20a(1:s4,:);
j20arechalf = j20a(s4+1:end,:);

j20a_polarsgridhalf = j20a_polars(1:s4,:);
j20a_polarsrechalf = j20a_polars(s4+1:end,:);

newj20ashuffledirgridhalf = newj20ashuffledir(1:s4,:);
newj20ashuffledirrechalf = newj20ashuffledir(s4+1:end,:);

%lets work with j20a first 
% sixtydegreecolumn = [j20agridhalf(:,52), j20agridhalf(:,262), j20agridhalf(:,366), j20agridhalf(:,157), j20agridhalf(:,471)];
sixtydegreecolumn = [j20agridhalf(:,102:106), j20agridhalf(:,207:211), j20agridhalf(:,417:421), j20agridhalf(:,522:526)];

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'descend');

j20agridhalf = j20agridhalf(idx,:);
newj20ashuffledirgridhalf = newj20ashuffledir(idx,:);
j20a_polarsgridhalf = j20a_polarsgridhalf(idx, :);

finalj20a = [j20agridhalf;j20arechalf];
newj20ashuffledir = [newj20ashuffledirgridhalf;newj20ashuffledirrechalf];
j20a_polars = [ j20a_polarsgridhalf; j20a_polarsrechalf ];

%doing something a little different
%going to group 60 and 30 together
j20a60 = [1,2,3,5,6,8,17,20]';
j20a30 = [4,9,10,11,12,13,14,15,16,18,19,7]';
j20a90 = [21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37]';

j20a60 = finalj20a(j20a60,:);
j20a30 = finalj20a(j20a30,:);
j20a90 = finalj20a(j20a90,:);

% j20a60 = flipud(j20a60);

finalj20a = [j20a30;j20a60;j20a90];


j20a60 = [1,2,3,5,6,8,17,20]';
j20a30 = [4,9,10,11,12,13,14,15,16,18,19,7]';
j20a90 = [21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37]';

j20a60 = newj20ashuffledir(j20a60,:);
j20a30 = newj20ashuffledir(j20a30,:);
j20a90 = newj20ashuffledir(j20a90,:);

% j20a60 = flipud(j20a60);

newj20ashuffledir = [j20a30;j20a60;j20a90];


j20a60 = [1,2,3,5,6,8,17,20]';
j20a30 = [4,9,10,11,12,13,14,15,16,18,19,7]';
j20a90 = [21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37]';

j20a60 = j20a_polars(j20a60,:);
j20a30 = j20a_polars(j20a30,:);
j20a90 = j20a_polars(j20a90,:);

% j20a60 = flipud(j20a60);

j20a_polars = [j20a30;j20a60;j20a90];


subplot(1,4,4)
imagesc(finalj20a)
colormap jet

% visualize the sorted polar plots if you want
% count = 1;
% for i = 1:60
%     
%     p = j20a_polars{i,1};
%     
%     pax = subplot(6,10,count, polaraxes);
%     polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
%     pax.RGrid  = 'off';
%     pax.RTickLabels = [];
%     set(gcf,'color','w');
%     count = count + 1;
% end

%%

%finally, get the directories
wty_filt9999 = newwtyshuffledir;
wta_filt9999 = newwtashuffledir;
j20y_filt9999 = newj20yshuffledir;
j20a_filt9999 = newj20ashuffledir;

subplot(1,4,1)
imagesc(finalwty)
colormap jet
subplot(1,4,2)
imagesc(finalwta)
colormap jet
subplot(1,4,3)
imagesc(finalj20y)
colormap jet
subplot(1,4,4)
imagesc(finalj20a)
colormap jet

%%
% Now that we have sorted all cells and their polar plots, we will test for
% 7.5 degrees

%The way this works is we will separate cells into 30, 60 or 90 degree
%groups based on the sorted graphs above

%Next, the Fourier component orientations will be compared to
%pre-determined reference axes according to whichever group the cell falls
%under 

%determine from the sorted orientation graphs where each group stops in the
%sorted indices 
wty30idxstop = 22;
wty60idxstop = 26;
wty90idxstop = 36;

%template orientations for each cell group in degrees
template30 = [30,90,150,210,270,330];
template60 = [0,60,120,180,240,300];
template90 = [0,90,180,270];

%extract cells 
wty30polars = wty_polars(1:wty30idxstop,1);
wty60polars = wty_polars(wty30idxstop+1:wty60idxstop,1);
wty90polars = wty_polars(wty60idxstop+1:wty90idxstop,1);

i = 1;

i = i + 1;
p = wty30polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles - each cell was manually visualized using above code (lines 677-694). The
% orientation with local maxima of Fourier power were selected to be the
% true orientations. These values are recorded below

wty30polaridx = [51,144,254,362,463,559;...
    43,150,268,354,471,574;...
    42,149,256,352,469,562;...
    45,144,255,356,464,561;...
    44,148,254,355,468,560;...
    39,146,259,350,466,565;...
    37,142,264,348,462,570;... %7
    37,148,nan,348,467,nan;... %8
    38,142,252,348,462,557;...
    34,142,255,345,462,561;... %10
    59,175,273,371,484,583;...
    33,138,260,343,458,566;...
    40,137,252,351,456,557;...
    34,139,254,344,459,559;...
    36,133,259,347,451,565;... %15
    40,136,256,351,454,562;...
    23,138,260,332,459,556;...
    33,138,253,342,458,558;...
    33,132,263,344,451,569;...
    31,134,252,341,454,557;... %20
    30,134,251,341,453,557;...
    32,128,243,339,449,543];

%convert radians to degres
wty30polaridx = wty30polaridx.* (360/630)

%find angular difference between true orientations and reference orientations
wty30anglediff = wty30polaridx - repmat(template30,22,1)

wty30anglediff = reshape(wty30anglediff,[],1);
wty30anglediff = abs(wty30anglediff); %convert to absolute values

%60 deg 

i = 1;

i = i + 1;
p = wty60polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
wty60polaridx = [20,107,224,326,426,525;...
    610,89,195,304,404,501;...
    616,100,180,311,417,487;...
    616,86,164,312,400,485;...
];

wty60polaridx = wty60polaridx.* (360/630)

wty60anglediff = wty60polaridx - repmat(template60,4,1)

wty60anglediff = reshape(wty60anglediff,[],1);
f = find(wty60anglediff(:,1) > 250);
wty60anglediff(f,1) = wty60anglediff(f,1) - 360;
wty60anglediff = abs(wty60anglediff);

nanmean(wty60anglediff)

wtygridanglediff = [wty30anglediff ; wty60anglediff];

%90 deg 

i = 1;

i = i + 1;
p = wty90polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
wty90polaridx = [619,154,nan,nan;...
    613,163,309,496;...
    616,nan,312,nan;...
    21,165,327,nan;...
    619,173,311,481;... %5
    608,158,304,nan;...
    nan,153,nan,458;...
    nan,149,nan,471;...
    36,159,310,477;...
    600,160,296,480];

wty90polaridx = wty90polaridx.* (360/630)

wty90anglediff = wty90polaridx - repmat(template90,10,1)

wty90anglediff = reshape(wty90anglediff,[],1);
f = find(wty90anglediff(:,1) > 250);
wty90anglediff(f,1) = wty90anglediff(f,1) - 360;
wty90anglediff = abs(wty90anglediff);


f = isnan(wty90anglediff(:,1)); %remove nans
wty90anglediff(f) = [];

wtygridanglediffall = [wty30anglediff ; wty60anglediff; wty90anglediff]; %concatenate angular differences across all cells together

f = isnan(wtygridanglediffall(:,1)); %remove nans
wtygridanglediffall(f) = [];

nanmedian(wtygridanglediffall) %this is reported value in paper. the median
rad2deg(circ_median(deg2rad(wtygridanglediffall)))


%medians for individual groups 
nanmedian(wty30anglediff)
nanmedian(wty60anglediff)
nanmedian(wty90anglediff)

%circular medians for individual groups
rad2deg(circ_median(deg2rad(wty30anglediff)))
rad2deg(circ_median(deg2rad(wty60anglediff)))
rad2deg(circ_median(deg2rad(wty90anglediff)))

%% And repeat the same procedure for other mouse groups. code follows same logic as above and therefore not commented in detail. 
% There were a couple of instances where I manually sorted cells around due
% to visual inspection (i.e. some 30 degree cells were actually 60 degrees)

wta30idxstop = 27;
wta60idxstop = 52;
wta90idxstop = 64;

template30 = [30,90,150,210,270,330];
template60 = [0,60,120,180,240,300];
template90 = [0,90,180,270];

wta30polars = wta_polars(1:wta30idxstop,1);
wta60polars = wta_polars(wta30idxstop+1:wta60idxstop,1);
wta90polars = wta_polars(wta60idxstop+1:wta90idxstop,1);

%special case, cell2 in the 60 degree group is actually a 30 
wta30polars{end+1,1} = wta60polars{2,1};
wta60polars(2,:) = []; %... 

%AGAIN special case, cell2 in the 60 degree group is actually a 30 
wta30polars{end+1,1} = wta60polars{2,1};
wta60polars(2,:) = []; %... 

i = 1;

i = i + 1;
p = wta30polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
wta30polaridx = [42,155,253,353,471,559;...
    41,151,261,352,471,567;...
    43,148,255,354,468,560;...
    42,147,261,353,467,567;...
    48,146,250,359,466,556;... %5
    45,145,nan,354,467,nan;... %6
    40,143,261,351,463,567;...
    37,170,262,347,476,568;...
    35,168,257,344,473,562;...
    32,150,253,341,472,558;... %10
    38,142,258,348,462,563;...
    39,148,248,350,463,553;...
    27,147,252,337,468,558;...
    40,143,250,350,462,556;...
    47,175,269,357,482,573;... %15
    33,143,255,343,463,561;...
    35,141,258,346,461,564;...
    35,144,253,345,464,558;...
    34,142,253,344,462,559;...
    26,143,255,335,464,560;... %20
    28,144,253,337,464,560;...
    66,177,279,379,483,584;...
    33,138,253,343,458,556;...
    37,156,253,348,nan,558;...
    28,138,253,337,458,557;... %25
    26,138,250,333,460,550;...
    30,135,251,340,454,555;...
    nan,156,276,nan,nan,575;...
    73,179,283,386,484,587];

wta30polaridx = wta30polaridx.* (360/630)

wta30anglediff = wta30polaridx - repmat(template30,29,1)

wta30anglediff = reshape(wta30anglediff,[],1);
wta30anglediff = abs(wta30anglediff);

%60 deg 

i = 1;

i = i + 1;
p = wta60polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
wta60polaridx = [33,153,280,344,460,584;...
    609,98,172,300,413,476;...
    611,75,185,308,388,490;...
    601,87,182,298,402,486;...
    608,81,186,305,395,488;... %5
    578,102,183,279,417,492;...
    605,93,181,300,409,488;...
    628,102,227,nan,418,532;...
    623,101,186,296,416,495;...
    626,106,232,nan,423,536;... %10
    624,109,210,nan,426,515;...
    628,114,225,nan,432,529;...
    9,107,220,317,424,525;...
    623,105,213,nan,422,517;...
    626,96,221,nan,411,526;... %15
    626,100,212,nan,416,516;...
    16,105,228,324,422,532;...
    628,105,216,nan,421,523;...
    9,111,222,316,428,525;...
    628,98,226,316,414,531;... %20
    622,91,224,314,407,529;...
    627,100,220,317,417,525;...
    615,108,234,308,426,538];

wta60polaridx = wta60polaridx.* (360/630)

wta60anglediff = wta60polaridx - repmat(template60,23,1)

wta60anglediff = reshape(wta60anglediff,[],1);
f = find(wta60anglediff(:,1) > 250);
wta60anglediff(f,1) = wta60anglediff(f,1) - 360;
wta60anglediff = abs(wta60anglediff);

wtagridanglediff = [wta30anglediff ; wta60anglediff];
nanmean(wtagridanglediff)

%90 deg 

i = 1;

i = i + 1;
p = wta90polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
wta90polaridx = [9,149,nan,nan;...
    56,183,367,485;...
    60,190,372,493;...
    604,162,300,nan;...
    625,162,nan,nan;... %5
    625,157,nan,nan;...
    622,159,nan,nan;...
    591,146,288,468;...
    36,nan,344,nan;...
    628,148,nan,471;... %10
    41,183,350,489;...
    625,142,314,465];

wta90polaridx = wta90polaridx.* (360/630)

wta90anglediff = wta90polaridx - repmat(template90,12,1)

wta90anglediff = reshape(wta90anglediff,[],1);
f = find(wta90anglediff(:,1) > 250);
wta90anglediff(f,1) = wta90anglediff(f,1) - 360;
wta90anglediff = abs(wta90anglediff);



f = isnan(wta30anglediff(:,1));
wta30anglediff(f) = [];
f = isnan(wta60anglediff(:,1));
wta60anglediff(f) = [];
f = isnan(wta90anglediff(:,1));
wta90anglediff(f) = [];



wtagridanglediffall = [wta30anglediff ; wta60anglediff; wta90anglediff];

f = isnan(wtagridanglediffall(:,1));
wtagridanglediffall(f) = [];

nanmedian(wtagridanglediffall)
rad2deg(circ_median(deg2rad(wtagridanglediffall)))

nanmedian(wta30anglediff)
nanmedian(wta60anglediff)
nanmedian(wta90anglediff)


%circular medians for individual groups
f = isnan(wta30anglediff(:,1));
wta30anglediff(f) = [];
f = isnan(wta60anglediff(:,1));
wta60anglediff(f) = [];
f = isnan(wta90anglediff(:,1));
wta90anglediff(f) = [];


rad2deg(circ_median(deg2rad(wta30anglediff)))
rad2deg(circ_median(deg2rad(wta60anglediff)))
rad2deg(circ_median(deg2rad(wta90anglediff)))

%%

j20y30idxstop = 8;
j20y60idxstop = 23;
j20y90idxstop = 30;

template30 = [30,90,150,210,270,330];
template60 = [0,60,120,180,240,300];
template90 = [0,90,180,270];

j20y30polars = j20y_polars(1:j20y30idxstop,1);
j20y60polars = j20y_polars(j20y30idxstop+1:j20y60idxstop,1);
j20y90polars = j20y_polars(j20y60idxstop+1:j20y90idxstop,1);

% %special case, cell 1 in the 60 degree group is actually a 30 
j20y30polars{end+1,1} = j20y60polars{1,1};
j20y60polars(1,:) = []; %... 
% 
% %AGAIN special case, cell 1 in the 30 degree group is actually a 60 
j20y60polars{end+1,1} = j20y30polars{1,1};
j20y30polars(1,:) = []; %... 

% %AGAIN special case, cell 2 in the 30 degree group is actually a 60 
j20y60polars{end+1,1} = j20y30polars{2,1};
j20y30polars(2,:) = []; %... 

% %AGAIN special case, cell 2 in the 30 degree group is actually a 60 
j20y60polars{end+1,1} = j20y30polars{1,1};
j20y30polars(1,:) = []; %... 

i = 1;

i = i + 1;
p = j20y30polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
j20y30polaridx = [76,194,296,390,500,603;...
    76,195,294,390,500,601;...
    81,186,294,395,492,600;...
    75,189,277,389,496,584;...
    76,183,291,389,490,598;... %5
    24,147,265,332,469,570];

j20y30polaridx = j20y30polaridx.* (360/630)

j20y30anglediff = j20y30polaridx - repmat(template30,6,1)

j20y30anglediff = reshape(j20y30anglediff,[],1);
j20y30anglediff = abs(j20y30anglediff);


%60 deg 

i = 1;

i = i + 1;
p = j20y60polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
j20y60polaridx = [16,148,239,322,468,543;...
    24,133,255,334,453,560;...
    613,135,222,309,454,529;...
    20,129,237,327,448,541;...
    27,129,232,336,448,536;... %5
    20,126,230,328,445,534;...
    12,120,236,320,439,539;...
    33,127,217,344,445,524;...
    13,106,230,321,423,534;...
    618,113,224,312,431,528;... %10
    18,109,227,326,426,530;...
    13,113,223,320,431,527;...
    15,113,206,321,431,509;...
    11,111,219,318,429,523;...
    610,87,194,304,401,499;... %15
    605,78,198,298,392,503;...
    607,79,194,300,393,500];

j20y60polaridx = j20y60polaridx.* (360/630)

j20y60anglediff = j20y60polaridx - repmat(template60,17,1)

j20y60anglediff = reshape(j20y60anglediff,[],1);
f = find(j20y60anglediff(:,1) > 250);
j20y60anglediff(f,1) = j20y60anglediff(f,1) - 360;
j20y60anglediff = abs(j20y60anglediff);

j20ygridanglediff = [j20y30anglediff ; j20y60anglediff];
nanmean(j20ygridanglediff)

%90 deg 

i = 1;

i = i + 1;
p = j20y90polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
j20y90polaridx = [25,159,332,nan;...
    nan,153,nan,471;...
    607,nan,304,nan;...
    20,nan,326,nan;...
    12,150,318,nan;... %5
    23,147,330,470;...
    625,133,315,455];

j20y90polaridx = j20y90polaridx.* (360/630)

j20y90anglediff = j20y90polaridx - repmat(template90,7,1)

j20y90anglediff = reshape(j20y90anglediff,[],1);
f = find(j20y90anglediff(:,1) > 250);
j20y90anglediff(f,1) = j20y90anglediff(f,1) - 360;
j20y90anglediff = abs(j20y90anglediff);

f = isnan(j20y30anglediff(:,1));
j20y30anglediff(f) = [];
f = isnan(j20y60anglediff(:,1));
j20y60anglediff(f) = [];
f = isnan(j20y90anglediff(:,1));
j20y90anglediff(f) = [];


j20ygridanglediffall = [j20y30anglediff ; j20y60anglediff; j20y90anglediff];

f = isnan(j20ygridanglediffall(:,1));
j20ygridanglediffall(f) = [];

nanmedian(j20ygridanglediffall)
rad2deg(circ_median(deg2rad(j20ygridanglediffall)))

nanmedian(j20y30anglediff)
nanmedian(j20y60anglediff)
nanmedian(j20y90anglediff)


%circular medians for individual groups
rad2deg(circ_median(deg2rad(j20y30anglediff)))
rad2deg(circ_median(deg2rad(j20y60anglediff)))
rad2deg(circ_median(deg2rad(j20y90anglediff)))



%%

j20a30idxstop = 12;
j20a60idxstop = 20;
j20a90idxstop = 37;

template30 = [30,90,150,210,270,330];
template60 = [0,60,120,180,240,300];
template90 = [0,90,180,270];

j20a30polars = j20a_polars(1:j20a30idxstop,1);
j20a60polars = j20a_polars(j20a30idxstop+1:j20a60idxstop,1);
j20a90polars = j20a_polars(j20a60idxstop+1:j20a90idxstop,1);

% % %special case, cell 5-8 in the 60 degree group is actually a 30 
j20a30polars{end+1,1} = j20a60polars{5,1};
j20a30polars{end+1,1} = j20a60polars{6,1};
j20a30polars{end+1,1} = j20a60polars{7,1};
j20a30polars{end+1,1} = j20a60polars{8,1};
j20a60polars(5:8,:) = []; %... 

i = 1;

i = i + 1;
p = j20a30polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
j20a30polaridx = [39,133,233,347,454,533;...
    38,135,246,348,455,549;...
    27,134,253,336,453,557;...
    30,160,265,340,nan,571;...
    67,159,269,380,nan,573;... %5
    74,145,271,387,468,571;...
    46,176,262,356,482,568;...
    40,148,250,349,470,555;...
    52,169,252,363,476,556;...
    50,156,270,362,nan,574;... %10
    49,169,268,361,474,574;...
    44,156,262,354,463,569;...
    77,184,273,391,492,580;...
    86,178,297,401,486,604;...
    61,163,291,373,480,595;...
    67,169,276,379,476,580];

j20a30polaridx = j20a30polaridx.* (360/630)

j20a30anglediff = j20a30polaridx - repmat(template30,16,1)

j20a30anglediff = reshape(j20a30anglediff,[],1);
j20a30anglediff = abs(j20a30anglediff);

%60 deg 

i = 1;

i = i + 1;
p = j20a60polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
j20a60polaridx = [25,114,208,332,432,511;...
    12,108,201,318,425,505;...
    601,83,197,295,398,504;...
    590,88,188,283,402,496];

j20a60polaridx = j20a60polaridx.* (360/630)

j20a60anglediff = j20a60polaridx - repmat(template60,4,1)

j20a60anglediff = reshape(j20a60anglediff,[],1);
f = find(j20a60anglediff(:,1) > 250);
j20a60anglediff(f,1) = j20a60anglediff(f,1) - 360;
j20a60anglediff = abs(j20a60anglediff);

j20agridanglediff = [j20a30anglediff ; j20a60anglediff];
nanmean(j20agridanglediff)

%90 deg 

i = 1;

i = i + 1;
p = j20a90polars{i,1};

pax = subplot(1,2,1, polaraxes);
polarplot(p(:,1), p(:,2),'k','LineWidth',2)
pax.ThetaGrid  = 'off';
pax.RGrid  = 'off';
pax.RTickLabels = [];
set(gcf,'color','w');
count = count + 1;

subplot(1,2,2)
plot(p(:,2),'k')
title(i)
hold on
scatter(linspace(1,length(p(:,2)),length(p(:,2))),  p(:,2), 5, 'k')

% find where the angles 
j20a90polaridx = [626,156,nan,nan;...
    602,171,299,475;...
    627,164,nan,nan;...
    628,160,nan,nan;...
    12,nan,317,nan;... %5
    605,159,301,nan;...
    616,167,311,nan;...
    602,nan,300,nan;...
    583,nan,278,nan;...
    nan,85,nan,399;... %10
    nan,174,nan,477;...
    628,179,nan,483;...
    615,150,311,nan;...
    8,147,315,470;...
    599,140,296,462;... %15
    614,140, 310, 463;...
    55,213,366,515];
    
j20a90polaridx = j20a90polaridx.* (360/630)

j20a90anglediff = j20a90polaridx - repmat(template90,17,1)

j20a90anglediff = reshape(j20a90anglediff,[],1);
f = find(j20a90anglediff(:,1) > 250);
j20a90anglediff(f,1) = j20a90anglediff(f,1) - 360;
j20a90anglediff = abs(j20a90anglediff);

f = isnan(j20a30anglediff(:,1));
j20a30anglediff(f) = [];
f = isnan(j20a60anglediff(:,1));
j20a60anglediff(f) = [];
f = isnan(j20a90anglediff(:,1));
j20a90anglediff(f) = [];


j20agridanglediffall = [j20a30anglediff ; j20a60anglediff; j20a90anglediff];

f = isnan(j20agridanglediffall(:,1));
j20agridanglediffall(f) = [];

nanmedian(j20agridanglediffall)
rad2deg(circ_median(deg2rad(j20agridanglediffall)))

nanmedian(j20a30anglediff)
nanmedian(j20a60anglediff)
nanmedian(j20a90anglediff)

%
rad2deg(circ_median(deg2rad(j20a30anglediff)))
rad2deg(circ_median(deg2rad(j20a60anglediff)))
rad2deg(circ_median(deg2rad(j20a90anglediff)))
%%

subplot(1,4,1)
hist(wtygridanglediffall,20)
axis square
xline(nanmedian(wtygridanglediffall))
xlim([0,30])
subplot(1,4,2)
hist(wtagridanglediffall,30)
axis square
xline(nanmedian(wtagridanglediffall))
xlim([0,30])
subplot(1,4,3)
hist(j20ygridanglediffall,20)
xline(nanmedian(j20ygridanglediffall))
axis square
xlim([0,30])
ylim([0,20])
subplot(1,4,4)
hist(j20agridanglediffall,30)
axis square
xline(nanmedian(j20agridanglediffall))
xlim([0,30])


nanmean(wtygridanglediffall)
nanmedian(wtygridanglediffall)

nanmean(wtagridanglediffall)
nanmedian(wtagridanglediffall)

nanmean(j20ygridanglediffall)
nanmedian(j20ygridanglediffall)

nanmean(j20agridanglediffall)
nanmedian(j20agridanglediffall)


nanmedian(wty30anglediff)
nanmedian(wty60anglediff)
nanmedian(wty90anglediff)

nanmedian(wta30anglediff)
nanmedian(wta60anglediff)
nanmedian(wta90anglediff)

nanmedian(j20y30anglediff)
nanmedian(j20y60anglediff)
nanmedian(j20y90anglediff)

nanmedian(j20a30anglediff)
nanmedian(j20a60anglediff)
nanmedian(j20a90anglediff)




nanmean(j20y30anglediff)
nanmean(j20y60anglediff)
nanmean(j20y90anglediff)


nanstd( wtygridanglediffall ) / sqrt( length(wtygridanglediffall) )
nanstd( wtagridanglediffall ) / sqrt( length(wtagridanglediffall) )
nanstd( j20ygridanglediffall ) / sqrt( length(j20ygridanglediffall) )
nanstd( j20agridanglediffall ) / sqrt( length(j20agridanglediffall) )


