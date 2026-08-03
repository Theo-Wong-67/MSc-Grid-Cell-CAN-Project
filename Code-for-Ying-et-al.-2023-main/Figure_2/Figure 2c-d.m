
%% Figure 2C and 2D 
%% plot components of cells

%LOAD ALL CELLS

clear
load('allcells_workspace.mat')

load('1and4components.mat')
load('emptycells.mat')
load('removecirclecells.mat')

%remove bad cells
wta_data(wtacircle,:) = [];
j20a_data(j20acircle,:) = [];

wty_data(wtyempty,:) = [];
wta_data(wtaempty,:) = [];
j20y_data(j20yempty,:) = [];
j20a_data(j20aempty,:) = [];

wty_data = wty_data(wtycompo,:);
wta_data = wta_data(wtacompo,:);
j20y_data = j20y_data(j20ycompo,:);
j20a_data = j20a_data(j20acompo,:);



%col. 5 is the # of Fourier components for each cell 
wtycomcount2 = cell2mat(wty_data(:,5));
wtacomcount2 = cell2mat(wta_data(:,5));
j20ycomcount2 = cell2mat(j20y_data(:,5));
j20acomcount2 = cell2mat(j20a_data(:,5));

%remove the rest to save RAM usage if you want
clear wty_data
clear wta_data
clear j20y_data
clear j20a_data


% NOW LOAD GRID CELLS 
load('grid_data.mat')

%col. 5 is the # of Fourier components for each cell 
wtycomcount = cell2mat(wty_data(:,5));
wtacomcount = cell2mat(wta_data(:,5));
j20ycomcount = cell2mat(j20y_data(:,5));
j20acomcount = cell2mat(j20a_data(:,5));

%remove the rest to save RAM usage if you want
clear wty_data
clear wta_data
clear j20y_data
clear j20a_data

%remove cells with less than 1 component or more than 4
f = find(wtycomcount(:,1)<1);
wtycomcount(f,:) = [];

f = find(wtycomcount(:,1)>4);
wtycomcount(f,:) = [];
f = find(wtacomcount(:,1)>4);
wtacomcount(f,:) = [];
f = find(j20ycomcount(:,1)>4);
j20ycomcount(f,:) = [];
f = find(j20acomcount(:,1)>4);
j20acomcount(f,:) = [];


%% Compare component percentages between nongrid and grids 

% convert to percentages
wtybar = [length(find(wtycomcount(:,1)==1))/length(wtycomcount) * 100; length(find(wtycomcount(:,1)==2))/length(wtycomcount) * 100; length(find(wtycomcount(:,1)==3))/length(wtycomcount) * 100; length(find(wtycomcount(:,1)==4))/length(wtycomcount) * 100];
wtabar = [length(find(wtacomcount(:,1)==1))/length(wtacomcount) * 100; length(find(wtacomcount(:,1)==2))/length(wtacomcount) * 100; length(find(wtacomcount(:,1)==3))/length(wtacomcount) * 100; length(find(wtacomcount(:,1)==4))/length(wtacomcount) * 100];
j20ybar = [length(find(j20ycomcount(:,1)==1))/length(j20ycomcount) * 100; length(find(j20ycomcount(:,1)==2))/length(j20ycomcount) * 100; length(find(j20ycomcount(:,1)==3))/length(j20ycomcount) * 100; length(find(j20ycomcount(:,1)==4))/length(j20ycomcount) * 100];
j20abar = [length(find(j20acomcount(:,1)==1))/length(j20acomcount) * 100; length(find(j20acomcount(:,1)==2))/length(j20acomcount) * 100; length(find(j20acomcount(:,1)==3))/length(j20acomcount) * 100; length(find(j20acomcount(:,1)==4))/length(j20acomcount) * 100];

wtybar2 = [length(find(wtycomcount2(:,1)==1))/length(wtycomcount2) * 100; length(find(wtycomcount2(:,1)==2))/length(wtycomcount2) * 100; length(find(wtycomcount2(:,1)==3))/length(wtycomcount2) * 100; length(find(wtycomcount2(:,1)==4))/length(wtycomcount2) * 100];
wtabar2 = [length(find(wtacomcount2(:,1)==1))/length(wtacomcount2) * 100; length(find(wtacomcount2(:,1)==2))/length(wtacomcount2) * 100; length(find(wtacomcount2(:,1)==3))/length(wtacomcount2) * 100; length(find(wtacomcount2(:,1)==4))/length(wtacomcount2) * 100];
j20ybar2 = [length(find(j20ycomcount2(:,1)==1))/length(j20ycomcount2) * 100; length(find(j20ycomcount2(:,1)==2))/length(j20ycomcount2) * 100; length(find(j20ycomcount2(:,1)==3))/length(j20ycomcount2) * 100; length(find(j20ycomcount2(:,1)==4))/length(j20ycomcount2) * 100];
j20abar2 = [length(find(j20acomcount2(:,1)==1))/length(j20acomcount2) * 100; length(find(j20acomcount2(:,1)==2))/length(j20acomcount2) * 100; length(find(j20acomcount2(:,1)==3))/length(j20acomcount2) * 100; length(find(j20acomcount2(:,1)==4))/length(j20acomcount2) * 100];

% Figure 2C
subplot(2,4,1)
bar(wtybar)
axis square
ylim([0,60])
subplot(2,4,2)
bar(wtabar)
axis square
ylim([0,60])
subplot(2,4,3)
bar(j20ybar)
axis square
ylim([0,60])
subplot(2,4,4)
bar(j20abar)
axis square
ylim([0,60])

subplot(2,4,5)
bar(wtybar2)
axis square
ylim([0,60])
subplot(2,4,6)
bar(wtabar2)
axis square
ylim([0,60])
subplot(2,4,7)
bar(j20ybar2)
axis square
ylim([0,60])
subplot(2,4,8)
bar(j20abar2)
axis square
ylim([0,60])


% Figure 2D
threecomponent = [length(find(wtycomcount(:,1)==3))/length(wtycomcount) * 100; length(find(wtycomcount2(:,1)==3))/length(wtycomcount2) * 100; ...
    length(find(wtacomcount(:,1)==3))/length(wtacomcount) * 100; length(find(wtacomcount2(:,1)==3))/length(wtacomcount2) * 100; ...
    length(find(j20ycomcount(:,1)==3))/length(j20ycomcount) * 100; length(find(j20ycomcount2(:,1)==3))/length(j20ycomcount2) * 100; ...
    length(find(j20acomcount(:,1)==3))/length(j20acomcount) * 100; length(find(j20acomcount2(:,1)==3))/length(j20acomcount2) * 100];

twocomponent = [length(find(wtycomcount(:,1)==2))/length(wtycomcount) * 100; length(find(wtycomcount2(:,1)==2))/length(wtycomcount2) * 100; ...
    length(find(wtacomcount(:,1)==2))/length(wtacomcount) * 100; length(find(wtacomcount2(:,1)==2))/length(wtacomcount2) * 100; ...
    length(find(j20ycomcount(:,1)==2))/length(j20ycomcount) * 100; length(find(j20ycomcount2(:,1)==2))/length(j20ycomcount2) * 100; ...
    length(find(j20acomcount(:,1)==2))/length(j20acomcount) * 100; length(find(j20acomcount2(:,1)==2))/length(j20acomcount2) * 100];

subplot(2,1,1)
bar(threecomponent)
axis square
ylim([0,65])
subplot(2,1,2)
bar(twocomponent)
axis square
ylim([0,65])

%% stats
%p values from the 1-tailed t-test for proportions between all cells vs. grid cells for the 3 component cells 
% nTG-y: 0.0003
% nTG-a: 0.024
% APP-y: 0.0097
% APP-a: 0.1384

%1-tailed t-test for proportions between all cells vs. grid cells for the 2 component cells 
% nTG-y: 0.0027
% nTG-a: 0.0995
% APP-y: 0.0154
% APP-a: 0.4656



