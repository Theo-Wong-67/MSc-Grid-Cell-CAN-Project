

clear
load('grid_dir_separated_into_hexagonal_and_rectangular.mat')


%compute intrinsic frequencies
wty1 = [];
for i = 1:size(wtydir1,1)
   clear root
   load(wtydir1{i,3})
   cel = wtydir1{i,4};
   
   ts1 = root.spike(cel(1), cel(2)).ts;
   ts2 = ts1;
   [acor, lag] = CMBHOME.Spike.CrossCorr(ts1,ts2);
   acor = zscore(acor(1:80,1));
   
   wty1(i,:) = acor;
end
%compute intrinsic frequencies
wty2 = [];
for i = 1:size(wtydir2,1)
   clear root
   load(wtydir2{i,3})
   cel = wtydir2{i,4};
   
   ts1 = root.spike(cel(1), cel(2)).ts;
   ts2 = ts1;
   [acor, lag] = CMBHOME.Spike.CrossCorr(ts1,ts2);
   acor = zscore(acor(1:80,1));
   
   wty2(i,:) = acor;
end
%compute intrinsic frequencies
wta1 = [];
for i = 1:size(wtadir1,1)
   clear root
   load(wtadir1{i,3})
   cel = wtadir1{i,4};
   
   ts1 = root.spike(cel(1), cel(2)).ts;
   ts2 = ts1;
   [acor, lag] = CMBHOME.Spike.CrossCorr(ts1,ts2);
   acor = zscore(acor(1:80,1));
   
   wta1(i,:) = acor;
end
%compute intrinsic frequencies
wta2 = [];
for i = 1:size(wtadir2,1)
   clear root
   load(wtadir2{i,3})
   cel = wtadir2{i,4};
   
   ts1 = root.spike(cel(1), cel(2)).ts;
   ts2 = ts1;
   [acor, lag] = CMBHOME.Spike.CrossCorr(ts1,ts2);
   acor = zscore(acor(1:80,1));
   
   wta2(i,:) = acor;
end
%APP
j20y1 = [];
for i = 1:size(j20ydir1,1)
   clear root
   load(j20ydir1{i,3})
   cel = j20ydir1{i,4};
   
   ts1 = root.spike(cel(1), cel(2)).ts;
   ts2 = ts1;
   [acor, lag] = CMBHOME.Spike.CrossCorr(ts1,ts2);
   acor = zscore(acor(1:80,1));
   
   j20y1(i,:) = acor;
end
%compute intrinsic frequencies
j20y2 = [];
for i = 1:size(j20ydir2,1)
   clear root
   load(j20ydir2{i,3})
   cel = j20ydir2{i,4};
   
   ts1 = root.spike(cel(1), cel(2)).ts;
   ts2 = ts1;
   [acor, lag] = CMBHOME.Spike.CrossCorr(ts1,ts2);
   acor = zscore(acor(1:80,1));
   
   j20y2(i,:) = acor;
end
%compute intrinsic frequencies
j20a1 = [];
for i = 1:size(j20adir1,1)
   clear root
   load(j20adir1{i,3})
   cel = j20adir1{i,4};
   
   ts1 = root.spike(cel(1), cel(2)).ts;
   ts2 = ts1;
   [acor, lag] = CMBHOME.Spike.CrossCorr(ts1,ts2);
   acor = zscore(acor(1:80,1));
   
   j20a1(i,:) = acor;
end
%compute intrinsic frequencies
j20a2 = [];
for i = 1:size(j20adir2,1)
   clear root
   load(j20adir2{i,3})
   cel = j20adir2{i,4};
   
   ts1 = root.spike(cel(1), cel(2)).ts;
   ts2 = ts1;
   [acor, lag] = CMBHOME.Spike.CrossCorr(ts1,ts2);
   acor = zscore(acor(1:80,1));
   
   j20a2(i,:) = acor;
end



wtymean = nanmean(wty1(:,40:41),2);
wtamean = nanmean(wta1(:,40:41),2);
j20ymean = nanmean(j20y1(:,40:41),2);
j20amean = nanmean(j20a1(:,40:41),2);

[m,idx] = sortrows(wtymean, 'descend');
wty1 = wty1(idx,:);
[m,idx] = sortrows(wtamean, 'descend');
wta1 = wta1(idx,:);
[m,idx] = sortrows(j20ymean, 'descend');
j20y1 = j20y1(idx,:);
[m,idx] = sortrows(j20amean, 'descend');
j20a1 = j20a1(idx,:);

wtymean = nanmean(wty2(:,40:41),2);
wtamean = nanmean(wta2(:,40:41),2);
j20ymean = nanmean(j20y2(:,40:41),2);
j20amean = nanmean(j20a2(:,40:41),2);

[m,idx] = sortrows(wtymean, 'descend');
wty2 = wty2(idx,:);
[m,idx] = sortrows(wtamean, 'descend');
wta2 = wta2(idx,:);
[m,idx] = sortrows(j20ymean, 'descend');
j20y2 = j20y2(idx,:);
[m,idx] = sortrows(j20amean, 'descend');
j20a2 = j20a2(idx,:);



wtymean = nanmean(wty1(:,27:33),2);
wtamean = nanmean(wta1(:,27:33),2);
j20ymean = nanmean(j20y1(:,27:33),2);
j20amean = nanmean(j20a1(:,27:33),2);

[m,idx] = sortrows(wtymean, 'descend');
wty1 = wty1(idx,:);
[m,idx] = sortrows(wtamean, 'descend');
wta1 = wta1(idx,:);
[m,idx] = sortrows(j20ymean, 'descend');
j20y1 = j20y1(idx,:);
[m,idx] = sortrows(j20amean, 'descend');
j20a1 = j20a1(idx,:);

wtymean = nanmean(wty2(:,27:33),2);
wtamean = nanmean(wta2(:,27:33),2);
j20ymean = nanmean(j20y2(:,27:33),2);
j20amean = nanmean(j20a2(:,27:33),2);

[m,idx] = sortrows(wtymean, 'descend');
wty2 = wty2(idx,:);
[m,idx] = sortrows(wtamean, 'descend');
wta2 = wta2(idx,:);
[m,idx] = sortrows(j20ymean, 'descend');
j20y2 = j20y2(idx,:);
[m,idx] = sortrows(j20amean, 'descend');
j20a2 = j20a2(idx,:);






summedwty1 = sum(wty1,1)/size(wty1,1)
summedwty2 = sum(wty2,1)/size(wty2,1)
summedwta1 = sum(wta1,1)/size(wta1,1)
summedwta2 = sum(wta2,1)/size(wta2,1)
summedj20y1 = sum(j20y1,1)/size(j20y1,1)
summedj20y2 = sum(j20y2,1)/size(j20y2,1)
summedj20a1 = sum(j20a1,1)/size(j20a1,1)
summedj20a2 = sum(j20a2,1)/size(j20a2,1)

subplot(4,4,1)
imagesc(wty1)
colormap hot
axis square
caxis([-1.2,4])
colorbar
subplot(4,4,2)
plot(summedwty1)
axis square
ylim([-1,3])
subplot(4,4,3)
imagesc(wty2)
colormap hot
axis square
caxis([-1.2,4])
subplot(4,4,4)
plot(summedwty2)
axis square
ylim([-1,1.5])

subplot(4,4,5)
imagesc(wta1)
colormap hot
axis square
caxis([-1.2,4])
subplot(4,4,6)
plot(summedwta1)
axis square
ylim([-1,3])
subplot(4,4,7)
imagesc(wta2)
colormap hot
axis square
caxis([-1.2,4])
subplot(4,4,8)
plot(summedwta2)
axis square
ylim([-1,1.5])

subplot(4,4,9)
imagesc(j20y1)
colormap hot
axis square
caxis([-1.2,4])
subplot(4,4,10)
plot(summedj20y1)
axis square
ylim([-1,3])
subplot(4,4,11)
imagesc(j20y2)
colormap hot
axis square
caxis([-1.2,4])
subplot(4,4,12)
plot(summedj20y2)
axis square
ylim([-1,1.5])

subplot(4,4,13)
imagesc(j20a1)
colormap hot
axis square
caxis([-1.2,4])
subplot(4,4,14)
plot(summedj20a1)
axis square
ylim([-1,3])
subplot(4,4,15)
imagesc(j20a2)
colormap hot
axis square
caxis([-1.2,4])
subplot(4,4,16)
plot(summedj20a2)
axis square
ylim([-1,1.5])







