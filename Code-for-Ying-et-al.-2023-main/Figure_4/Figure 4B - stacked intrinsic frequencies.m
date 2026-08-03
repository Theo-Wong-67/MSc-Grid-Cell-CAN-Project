

clear
load('grid_dir_separated_into_hexagonal_and_rectangular.mat')


%compute intrinsic frequencies
wty1 = [];
for i = 1:size(wtydir1,1)
   clear root
   load(wtydir1{i,3})
   cel = wtydir1{i,4};
   [F, power_ratio,SS] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
    SS = SS(122:end,:);
    SS = zscore(SS);
    wty1 = [wty1; SS'];
end

wty2 = [];
for i = 1:size(wtydir2,1)
   clear root
   load(wtydir2{i,3})
   cel = wtydir2{i,4};
   [F, power_ratio,SS] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
    SS = SS(122:end,:);
    SS = zscore(SS);
    wty2 = [wty2; SS'];
end

wta1 = [];
for i = 1:size(wtadir1,1)
   clear root
   load(wtadir1{i,3})
   cel = wtadir1{i,4};
   [F, power_ratio,SS] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
    SS = SS(122:end,:);
    SS = zscore(SS);
    wta1 = [wta1; SS'];
end

wta2 = [];
for i = 1:size(wtadir2,1)
   clear root
   load(wtadir2{i,3})
   cel = wtadir2{i,4};
   [F, power_ratio,SS] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
    SS = SS(122:end,:);
    SS = zscore(SS);
    wta2 = [wta2; SS'];
end


j20y1 = [];
for i = 1:size(j20ydir1,1)
   clear root
   load(j20ydir1{i,3})
   cel = j20ydir1{i,4};
   [F, power_ratio,SS] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
    SS = SS(122:end,:);
    SS = zscore(SS);
    j20y1 = [j20y1; SS'];
end

j20y2 = [];
for i = 1:size(j20ydir2,1)
   clear root
   load(j20ydir2{i,3})
   cel = j20ydir2{i,4};
   [F, power_ratio,SS] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
    SS = SS(122:end,:);
    SS = zscore(SS);
    j20y2 = [j20y2; SS'];
end

j20a1 = [];
for i = 1:size(j20adir1,1)
   clear root
   load(j20adir1{i,3})
   cel = j20adir1{i,4};
   [F, power_ratio,SS] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
    SS = SS(122:end,:);
    SS = zscore(SS);
    j20a1 = [j20a1; SS'];
end

j20a2 = [];
for i = 1:size(j20adir2,1)
   clear root
   load(j20adir2{i,3})
   cel = j20adir2{i,4};
   [F, power_ratio,SS] = root.IntrinsicFrequency(cel, 0, [-1 -1],0.005);
    SS = SS(122:end,:);
    SS = zscore(SS);
    j20a2 = [j20a2; SS'];
end


llim = 204 %8hz
hlim = 286 %10hz

wtymean = nanmean(wty1(:,llim:hlim),2);
wtamean = nanmean(wta1(:,llim:hlim),2);
j20ymean = nanmean(j20y1(:,llim:hlim),2);
j20amean = nanmean(j20a1(:,llim:hlim),2);


[m,idx] = sortrows(wtymean, 'descend');
wty1 = wty1(idx,:);
[m,idx] = sortrows(wtamean, 'descend');
wta1 = wta1(idx,:);
[m,idx] = sortrows(j20ymean, 'descend');
j20y1 = j20y1(idx,:);
[m,idx] = sortrows(j20amean, 'descend');
j20a1 = j20a1(idx,:);

%can do mean
summedwty1 = sum(wty1,1)/size(wty1,1)
summedwty2 = sum(wty2,1)/size(wty2,1)
summedwta1 = sum(wta1,1)/size(wta1,1)
summedwta2 = sum(wta2,1)/size(wta2,1)
summedj20y1 = sum(j20y1,1)/size(j20y1,1)
summedj20y2 = sum(j20y2,1)/size(j20y2,1)
summedj20a1 = sum(j20a1,1)/size(j20a1,1)
summedj20a2 = sum(j20a2,1)/size(j20a2,1)

% %alternative, can also try median
% summedwty1 = nanmedian(wty1,1)
% summedwty2 = nanmedian(wty2,1)
% summedwta1 = nanmedian(wta1,1)
% summedwta2 = nanmedian(wta2,1)
% summedj20y1 = nanmedian(j20y1,1)
% summedj20y2 = nanmedian(j20y2,1)
% summedj20a1 = nanmedian(j20a1,1)
% summedj20a2 = nanmedian(j20a2,1)




%plot

subplot(4,4,1)
imagesc(wty1)
colormap hot
% axis square
caxis([1,10])
xlim([0, 696])
% colorbar
subplot(4,4,5)
plot(summedwty1)
% axis square
xlim([0, 696])
ylim([0,8])
xline(245.82,'r')

subplot(4,4,9)
imagesc(wty2)
colormap hot
% axis square
caxis([0,10])
xlim([0, 696])
subplot(4,4,13)
plot(summedwty2)
% axis square
xlim([0, 696])
ylim([0,8])
xline(245.82,'r')

subplot(4,4,2)
imagesc(wta1)
colormap hot
% axis square
caxis([1,10])
xlim([0, 696])
subplot(4,4,6)
plot(summedwta1)
% axis square
xlim([0, 696])
ylim([0,8])
xline(245.82,'r')

subplot(4,4,10)
imagesc(wta2)
colormap hot
% axis square
caxis([1,10])
xlim([0, 696])
subplot(4,4,14)
plot(summedwta2)
% axis square
xlim([0, 696])
ylim([0,8])
xline(245.82,'r')

subplot(4,4,3)
imagesc(j20y1)
colormap hot
% axis square
caxis([1,10])
xlim([0, 696])
subplot(4,4,7)
plot(summedj20y1)
% axis square
xlim([0, 696])
ylim([0,8])
xline(245.82,'r')

subplot(4,4,11)
imagesc(j20y2)
colormap hot
% axis square
caxis([1,10])
xlim([0, 696])
subplot(4,4,15)
plot(summedj20y2)
% axis square
xlim([0, 696])
ylim([0,8])
xline(245.82,'r')

subplot(4,4,4)
imagesc(j20a1)
colormap hot
% axis square
caxis([1,10])
xlim([0, 696])
subplot(4,4,8)
plot(summedj20a1)
% axis square
xlim([0, 696])
ylim([0,8])
xline(245.82,'r')

subplot(4,4,12)
imagesc(j20a2)
colormap hot
% axis square
caxis([1,10])
xlim([0, 696])
subplot(4,4,16)
plot(summedj20a2)
% axis square
xlim([0, 696])
ylim([0,8])
xline(245.82,'r')













