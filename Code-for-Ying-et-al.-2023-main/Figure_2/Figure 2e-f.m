



%% if you want to work with all cells

clear
load('allcells_workspace.mat')

load('1and4components.mat')
load('emptycells.mat')
load('removecirclecells.mat')


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


%col. 10
wtythetarho = wty_data(:,10);
wtathetarho = wta_data(:,10);
j20ythetarho = j20y_data(:,10);
j20athetarho = j20a_data(:,10);


%remove the rest to save RAM usage if you want
clear wty_data
clear wta_data
clear j20y_data
clear j20a_data


%% if you want to work with grid cells

clear
load('grid_data.mat')

wtythetarho = wty_data(:,10);
wtathetarho = wta_data(:,10);
j20ythetarho = j20y_data(:,10);
j20athetarho = j20a_data(:,10);

clear wty_data
clear wta_data
clear j20y_data
clear j20a_data

%% Figure 2e

%nTG-y
wtyorientationdiff = [];

for i = 1:size(wtythetarho,1)  
    cel = wtythetarho{i,1};
    f = find(cel(:,2) == 0); %these 0s are not real, they were only there for nicer polar plots
    cel(f,:) = [];
    
    for j = 1:size(cel,1)-1
        wtyorientationdiff = [wtyorientationdiff; abs(rad2deg(cel(j,1))-rad2deg(cel(j+1,1)))]; %calculate angular diff between components
    end
end

%do the same for the other groups
wtaorientationdiff = [];

for i = 1:size(wtathetarho,1)  
    cel = wtathetarho{i,1};
    f = find(cel(:,2) == 0);
    cel(f,:) = [];
    
    for j = 1:size(cel,1)-1
        wtaorientationdiff = [wtaorientationdiff; abs(rad2deg(cel(j,1))-rad2deg(cel(j+1,1)))];
    end
end

j20yorientationdiff = [];

for i = 1:size(j20ythetarho,1)  
    cel = j20ythetarho{i,1};
    f = find(cel(:,2) == 0);
    cel(f,:) = [];
    
    for j = 1:size(cel,1)-1
        j20yorientationdiff = [j20yorientationdiff; abs(rad2deg(cel(j,1))-rad2deg(cel(j+1,1)))];
    end
end

j20aorientationdiff = [];

for i = 1:size(j20athetarho,1)  
    cel = j20athetarho{i,1};
    f = find(cel(:,2) == 0);
    cel(f,:) = [];
    
    for j = 1:size(cel,1)-1
        j20aorientationdiff = [j20aorientationdiff; abs(rad2deg(cel(j,1))-rad2deg(cel(j+1,1)))];
    end
end



%plot this for all cells 
subplot(1,4,1)
[h,j] = hist(wtyorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,28])
xline(9,'r')
xline(13,'r')
axis square
ylim([0, 0.3])
subplot(1,4,2)
[h,j] = hist(wtaorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,28])
axis square
xline(9,'r')
xline(13,'r')
ylim([0, 0.3])
subplot(1,4,3)
[h,j] = hist(j20yorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,28])
axis square
xline(9,'r')
xline(13,'r')
ylim([0, 0.3])
subplot(1,4,4)
[h,j] = hist(j20aorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,28])
axis square
xline(9,'r')
xline(13,'r')
ylim([0, 0.3])




% %plot this for grid cells 
% subplot(1,4,1)
% hist(wtyorientationdiff,50)
% axis square
% xlim([0,200])
% % xlim([0,30])
% subplot(1,4,2)
% hist(wtaorientationdiff,50)
% axis square
% xlim([0,200])
% subplot(1,4,3)
% hist(j20yorientationdiff,50)
% axis square
% xlim([0,200])
% subplot(1,4,4)
% hist(j20aorientationdiff,50)
% axis square
% xlim([0,200])


%plot this for grid cells 
subplot(1,4,1)
[h,j] = hist(wtyorientationdiff,25)
h = h/sum(h)
bar(h)
xlim([0,28])
xline(9,'r')
xline(13,'r')
axis square
ylim([0, 0.2])
subplot(1,4,2)
[h,j] = hist(wtaorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,29])
axis square
xline(9,'r')
xline(13,'r')
ylim([0, 0.2])
subplot(1,4,3)
[h,j] = hist(j20yorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,28])
axis square
xline(9,'r')
xline(13,'r')
ylim([0, 0.2])
subplot(1,4,4)
[h,j] = hist(j20aorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,28])
axis square
xline(9,'r')
xline(13,'r')
ylim([0, 0.2])

sum(h(1:26))


%calculating ratios of 60/90
wtyorientation6090 = length(find(wtyorientationdiff(:,1) >50 & wtyorientationdiff(:,1) <70)) / length(find(wtyorientationdiff(:,1) >80 & wtyorientationdiff(:,1) <100))
wtaorientation6090 = length(find(wtaorientationdiff(:,1) >50 & wtaorientationdiff(:,1) <70)) / length(find(wtaorientationdiff(:,1) >80 & wtaorientationdiff(:,1) <100))
j20yorientation6090 = length(find(j20yorientationdiff(:,1) >50 & j20yorientationdiff(:,1) <70)) / length(find(j20yorientationdiff(:,1) >80 & j20yorientationdiff(:,1) <100))
j20aorientation6090 = length(find(j20aorientationdiff(:,1) >50 & j20aorientationdiff(:,1) <70)) / length(find(j20aorientationdiff(:,1) >80 & j20aorientationdiff(:,1) <100))


wtyorientation60 = length(find(wtyorientationdiff(:,1) >50 & wtyorientationdiff(:,1) <70)) / length(wtyorientationdiff)
wtaorientation60 = length(find(wtaorientationdiff(:,1) >50 & wtaorientationdiff(:,1) <70)) / length(wtaorientationdiff)
j20yorientation60 = length(find(j20yorientationdiff(:,1) >50 & j20yorientationdiff(:,1) <70)) / length(j20yorientationdiff)
j20aorientation60 = length(find(j20aorientationdiff(:,1) >50 & j20aorientationdiff(:,1) <70)) / length(j20aorientationdiff)

wtyorientation90 = length(find(wtyorientationdiff(:,1) >80 & wtyorientationdiff(:,1) <100)) / length(wtyorientationdiff)
wtaorientation90 = length(find(wtaorientationdiff(:,1) >80 & wtaorientationdiff(:,1) <100)) / length(wtaorientationdiff)
j20yorientation90 = length(find(j20yorientationdiff(:,1) >80 & j20yorientationdiff(:,1) <100)) / length(j20yorientationdiff)
j20aorientation90 = length(find(j20aorientationdiff(:,1) >80 & j20aorientationdiff(:,1) <100)) / length(j20aorientationdiff)


%binomial tests 
avg = (wtyorientation60 + wtaorientation60 + j20yorientation60 + j20aorientation60) / 4

binopdf(length(find(wtyorientationdiff(:,1) >50 & wtyorientationdiff(:,1) <70)), length(wtyorientationdiff), avg)
binopdf(length(find(wtaorientationdiff(:,1) >50 & wtaorientationdiff(:,1) <70)), length(wtaorientationdiff), avg)
binopdf(length(find(j20yorientationdiff(:,1) >50 & j20yorientationdiff(:,1) <70)), length(j20yorientationdiff), avg)
binopdf(length(find(j20aorientationdiff(:,1) >50 & j20aorientationdiff(:,1) <70)), length(j20aorientationdiff), avg)


%binomial tests
avg = (wtyorientation90 + wtaorientation90 + j20yorientation90 + j20aorientation90) / 4

binopdf(length(find(wtyorientationdiff(:,1) >80 & wtyorientationdiff(:,1) <100)), length(wtyorientationdiff), avg)
binopdf(length(find(wtaorientationdiff(:,1) >80 & wtaorientationdiff(:,1) <100)), length(wtaorientationdiff), avg)
binopdf(length(find(j20yorientationdiff(:,1) >80 & j20yorientationdiff(:,1) <100)), length(j20yorientationdiff), avg)
binopdf(length(find(j20aorientationdiff(:,1) >80 & j20aorientationdiff(:,1) <100)), length(j20aorientationdiff), avg)



%bar graph
bar( [wtyorientation60;wtaorientation60;j20yorientation60;j20aorientation60;wtyorientation90;wtaorientation90;j20yorientation90;j20aorientation90])
ylim([0, 0.45])
avg = (wtyorientation60 + wtaorientation60 + j20yorientation60 + j20aorientation60) / 4
yline(avg)
avg = (wtyorientation90 + wtaorientation90 + j20yorientation90 + j20aorientation90) / 4
yline(avg)
axis square


subplot(1,2,1)
bar( [wtyorientation60;wtaorientation60;j20yorientation60;j20aorientation60])
% ylim([0, 0.08])
avg = (wtyorientation60 + wtaorientation60 + j20yorientation60 + j20aorientation60) / 4
yline(avg)
xlim([0,5])
axis square
subplot(1,2,2)
bar( [wtyorientation90;wtaorientation90;j20yorientation90;j20aorientation90])
% ylim([0, 0.3])
avg = (wtyorientation90 + wtaorientation90 + j20yorientation90 + j20aorientation90) / 4
yline(avg)
xlim([0,5])
axis square



%chi squared test for the 60 degrees 
n1 = length(find(wtyorientationdiff(:,1) >50 & wtyorientationdiff(:,1) <70));
n2 = length(wtyorientationdiff);
n3 = length(find(wtaorientationdiff(:,1) >50 & wtaorientationdiff(:,1) <70));
n4 = length(wtaorientationdiff);
n5 = length(find(j20yorientationdiff(:,1) >50 & j20yorientationdiff(:,1) <70));
n6 = length(j20yorientationdiff);
n7 = length(find(j20aorientationdiff(:,1) >50 & j20aorientationdiff(:,1) <70));
n8 = length(j20aorientationdiff);

HexaRec = [zeros(n1,1)+1; zeros(n2-n1,1)+2;zeros(n3,1)+1; zeros(n4-n3,1)+2;zeros(n5,1)+1; zeros(n6-n5,1)+2;zeros(n7,1)+1; zeros(n8-n7,1)+2];
Group = [zeros(n2,1)+1; zeros(n4,1)+2;zeros(n6,1)+3;zeros(n8,1)+4];

[tbl,chi2stat,pval] = crosstab(HexaRec,Group)



%chi squared test for the 90 degrees 
n1 = length(find(wtyorientationdiff(:,1) >80 & wtyorientationdiff(:,1) <100));
n2 = length(wtyorientationdiff);
n3 = length(find(wtaorientationdiff(:,1) >80 & wtaorientationdiff(:,1) <100));
n4 = length(wtaorientationdiff);
n5 = length(find(j20yorientationdiff(:,1) >80 & j20yorientationdiff(:,1) <100));
n6 = length(j20yorientationdiff);
n7 = length(find(j20aorientationdiff(:,1) >80 & j20aorientationdiff(:,1) <100));
n8 = length(j20aorientationdiff);

HexaRec = [zeros(n1,1)+1; zeros(n2-n1,1)+2;zeros(n3,1)+1; zeros(n4-n3,1)+2;zeros(n5,1)+1; zeros(n6-n5,1)+2;zeros(n7,1)+1; zeros(n8-n7,1)+2];
Group = [zeros(n2,1)+1; zeros(n4,1)+2;zeros(n6,1)+3;zeros(n8,1)+4];

[tbl,chi2stat,pval] = crosstab(HexaRec,Group)




