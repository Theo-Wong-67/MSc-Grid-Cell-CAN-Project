
%spatial stability analysis across time
%requires functions in CMBHOME found at https://github.com/hasselmonians/CMBHOME

clear
load('grid_dir_separated_into_hexagonal_and_rectangular.mat')

wty_dir = [wtydir1;wtydir2];
wta_dir = [wtadir1;wtadir2];
j20y_dir = [j20ydir1;j20ydir2];
j20a_dir = [j20adir1;j20adir2];

%% nTG-y

dim = 26;
cc = 1;
wty_drifts = [];
wty_drifts2 = [];

for i = 1:size(wty_dir,1)
    clear root
    load(wty_dir{i,3});
    cel = wty_dir{i,4};
    sprintf('cell %.15g of %.15g',i, size(wty_dir,1))
    
    try 
        
        %first half of rate map
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm1, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        
        %second half of rate map 
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg + seg;
        self.epoch(1) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm2, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        
        for iter = 1:10

            centermask = logical(zeros(dim,dim));
            centermask(iter+1:dim-iter,iter+1:dim-iter) = 1;
            wallmask = logical(ones(dim,dim));
            wallmask(iter+1:dim-iter,iter+1:dim-iter) = 0;
            
            rm1_c = rm1(centermask);
            rm2_c = rm2(centermask);
            rm1_w = rm1(wallmask);
            rm2_w = rm2(wallmask);
            
            wty_drifts(cc,iter) = corr2(rm1_c, rm2_c);
            wty_drifts2(cc,iter) = corr2(rm1_w, rm2_w);
        end
        cc = cc + 1;
    catch
    end
end

%% nTGa

cc = 1;
wta_drifts = [];
wta_drifts2 = [];

for i = 1:size(wta_dir,1)
    clear root
    load(wta_dir{i,3});
    cel = wta_dir{i,4};
    sprintf('cell %.15g of %.15g',i, size(wta_dir,1))
    
    try 
        
        %first half of rate map
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm1, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        
        %second half of rate map 
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg + seg;
        self.epoch(1) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm2, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        
        for iter = 1:10

            centermask = logical(zeros(dim,dim));
            centermask(iter+1:dim-iter,iter+1:dim-iter) = 1;
            wallmask = logical(ones(dim,dim));
            wallmask(iter+1:dim-iter,iter+1:dim-iter) = 0;
            
            rm1_c = rm1(centermask);
            rm2_c = rm2(centermask);
            rm1_w = rm1(wallmask);
            rm2_w = rm2(wallmask);
            
            wta_drifts(cc,iter) = corr2(rm1_c, rm2_c);
            wta_drifts2(cc,iter) = corr2(rm1_w, rm2_w);
        end
        cc = cc + 1;
    catch
    end
end

%% APP-y

cc = 1;
j20y_drifts = [];
j20y_drifts2 = [];

for i = 1:size(j20y_dir,1)
    clear root
    load(j20y_dir{i,3});
    cel = j20y_dir{i,4};
    sprintf('cell %.15g of %.15g',i, size(j20y_dir,1))
    
    try 
        
        %first half of rate map
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm1, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        
        %second half of rate map 
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg + seg;
        self.epoch(1) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm2, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        
        for iter = 1:10

            centermask = logical(zeros(dim,dim));
            centermask(iter+1:dim-iter,iter+1:dim-iter) = 1;
            wallmask = logical(ones(dim,dim));
            wallmask(iter+1:dim-iter,iter+1:dim-iter) = 0;
            
            rm1_c = rm1(centermask);
            rm2_c = rm2(centermask);
            rm1_w = rm1(wallmask);
            rm2_w = rm2(wallmask);
            
            j20y_drifts(cc,iter) = corr2(rm1_c, rm2_c);
            j20y_drifts2(cc,iter) = corr2(rm1_w, rm2_w);
        end
        cc = cc + 1;
    catch
    end
end

%% APP-a

cc = 1;
j20a_drifts = [];
j20a_drifts2 = [];

for i = 1:size(j20a_dir,1)
    clear root
    load(j20a_dir{i,3});
    cel = j20a_dir{i,4};
    sprintf('cell %.15g of %.15g',i, size(j20a_dir,1))
    
    try 
        
        %first half of rate map
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm1, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        
        %second half of rate map 
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg + seg;
        self.epoch(1) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm2, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        
        for iter = 1:10

            centermask = logical(zeros(dim,dim));
            centermask(iter+1:dim-iter,iter+1:dim-iter) = 1;
            wallmask = logical(ones(dim,dim));
            wallmask(iter+1:dim-iter,iter+1:dim-iter) = 0;
            
            rm1_c = rm1(centermask);
            rm2_c = rm2(centermask);
            rm1_w = rm1(wallmask);
            rm2_w = rm2(wallmask);
            
            j20a_drifts(cc,iter) = corr2(rm1_c, rm2_c);
            j20a_drifts2(cc,iter) = corr2(rm1_w, rm2_w);
        end
        cc = cc + 1;
    catch
    end
end

%%

allwtydrift1 = wty_drifts;
allwtydrift2 = wty_drifts2;

allwtadrift1 = wta_drifts;
allwtadrift2 = wta_drifts2;

allj20ydrift1 = j20y_drifts;
allj20ydrift2 = j20y_drifts2;

allj20adrift1 = j20a_drifts;
allj20adrift2 = j20a_drifts2;


%% stats 

%Figure 1

%center
cdfplot(wty_drifts(:,4))
hold on
cdfplot(wta_drifts(:,4))
hold on
cdfplot(j20y_drifts(:,4))
hold on
cdfplot(j20a_drifts(:,4))
hold on
axis square

%wall
cdfplot(wty_drifts2(:,4))
hold on
cdfplot(wta_drifts2(:,4))
hold on
cdfplot(j20y_drifts2(:,4))
hold on
cdfplot(j20a_drifts2(:,4))
hold on
axis square

%working with center stats
wty = wty_drifts(:,4)
wta = wta_drifts(:,4)
j20y = j20y_drifts(:,4)
j20a = j20a_drifts(:,4)

%working with wall stats
wty = wty_drifts2(:,4)
wta = wta_drifts2(:,4)
j20y = j20y_drifts2(:,4)
j20a = j20a_drifts2(:,4)



%2 way anova
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

multcompare(stats, "Dimension",[1 2])

%ranksum comparisons (dont forget to apply the Bonferonni holms correction manually)
ranksum(wty,wta)
ranksum(wty,j20y)
ranksum(j20y,j20a)
ranksum(wta,j20a)






%All remaining code is for the unbiased center-wall analysis in Figure S2
wty_avg = nanmedian(wty_drifts,1);
wta_avg = nanmedian(wta_drifts,1);
j20y_avg = nanmedian(j20y_drifts,1);
j20a_avg = nanmedian(j20a_drifts,1);

wty_avg2 = nanmedian(wty_drifts2,1);
wta_avg2 = nanmedian(wta_drifts2,1);
j20y_avg2 = nanmedian(j20y_drifts2,1);
j20a_avg2 = nanmedian(j20a_drifts2,1);

subplot(2,1,1)
plot(linspace(1,10,10), wty_avg(1,:),'r')
hold on
plot(linspace(1,10,10), wta_avg(1,:),'b')
hold on
plot(linspace(1,10,10), j20y_avg(1,:),'g')
hold on
plot(linspace(1,10,10), j20a_avg(1,:),'k')
hold on
scatter(linspace(1,10,10), wty_avg(1,:),'r')
hold on
scatter(linspace(1,10,10), wta_avg(1,:),'b')
hold on
scatter(linspace(1,10,10), j20y_avg(1,:),'g')
hold on
scatter(linspace(1,10,10), j20a_avg(1,:),'k')
axis square
% ylim([0.3, 0.8])
xlim([0,11])

subplot(2,1,2)
plot(linspace(1,10,10), wty_avg2(1,:),'r')
hold on
plot(linspace(1,10,10), wta_avg2(1,:),'b')
hold on
plot(linspace(1,10,10), j20y_avg2(1,:),'g')
hold on
plot(linspace(1,10,10), j20a_avg2(1,:),'k')
hold on
scatter(linspace(1,10,10), wty_avg2(1,:),'r')
hold on
scatter(linspace(1,10,10), wta_avg2(1,:),'b')
hold on
scatter(linspace(1,10,10), j20y_avg2(1,:),'g')
hold on
scatter(linspace(1,10,10), j20a_avg2(1,:),'k')
axis square
% ylim([0.3, 0.8])
xlim([0,11])


subplot(2,1,1)
plot(linspace(1,10,10), wty_avg(1,:),'r')
hold on
plot(linspace(1,10,10), wta_avg(1,:),'b')
hold on
plot(linspace(1,10,10), j20y_avg(1,:),'g')
hold on
plot(linspace(1,10,10), j20a_avg(1,:),'k')
hold on
scatter(linspace(1,10,10), wty_avg(1,:),'r')
hold on
scatter(linspace(1,10,10), wta_avg(1,:),'b')
hold on
scatter(linspace(1,10,10), j20y_avg(1,:),'g')
hold on
scatter(linspace(1,10,10), j20a_avg(1,:),'k')
axis square
ylim([0.2, 0.9])
xlim([0,11])

subplot(2,1,2)
plot(linspace(1,10,10), wty_avg2(1,:),'r')
hold on
plot(linspace(1,10,10), wta_avg2(1,:),'b')
hold on
plot(linspace(1,10,10), j20y_avg2(1,:),'g')
hold on
plot(linspace(1,10,10), j20a_avg2(1,:),'k')
hold on
scatter(linspace(1,10,10), wty_avg2(1,:),'r')
hold on
scatter(linspace(1,10,10), wta_avg2(1,:),'b')
hold on
scatter(linspace(1,10,10), j20y_avg2(1,:),'g')
hold on
scatter(linspace(1,10,10), j20a_avg2(1,:),'k')
axis square
ylim([0.2, 0.9])
xlim([0,11])


%%
centerstats = [];
wallstats = [];

for i = 1:10
    
    centerstats(1,i) = ranksum(wty_drifts(:,i), wta_drifts(:,i));
    centerstats(2,i) = ranksum(wty_drifts(:,i), j20y_drifts(:,i));
    centerstats(3,i) = ranksum(j20y_drifts(:,i), j20a_drifts(:,i));
    centerstats(4,i) = ranksum(wta_drifts(:,i), j20a_drifts(:,i));

    wallstats(1,i) = ranksum(wty_drifts2(:,i), wta_drifts2(:,i));
    wallstats(2,i) = ranksum(wty_drifts2(:,i), j20y_drifts2(:,i));
    wallstats(3,i) = ranksum(j20y_drifts2(:,i), j20a_drifts2(:,i));
    wallstats(4,i) = ranksum(wta_drifts2(:,i), j20a_drifts2(:,i));
    
end

wallstats
centerstats




for i=1:10
    
    centermask = logical(zeros(dim,dim));
    centermask(i+1:dim-i,i+1:dim-i) = 1;
    
    wty = wty_drifts(:,i);
    wta = wta_drifts(:,i);
    j20y = j20y_drifts(:,i);
    j20a = j20a_drifts(:,i);
    
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
    
    subplot(3,10,i)
    imagesc(centermask)
    colormap(flipud(gray))
    axis square
    box on
    grid off
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    
    subplot(3,10,i+10)
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
    axis square
    axis off
    box off
    grid off
    ylim([0,1])
    
    wty = wty_drifts2(:,i);
    wta = wta_drifts2(:,i);
    j20y = j20y_drifts2(:,i);
    j20a = j20a_drifts2(:,i);
    
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
    
    subplot(3,10,i+20)
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
    axis square
    axis off
    box off
    grid off
    ylim([0,1])
end


%% Figure S2 C and D
%lastly, do center vs edge within group

ranksum(wty_drifts(:,1), wty_drifts2(:,1))
ranksum(wty_drifts(:,2), wty_drifts2(:,2))
ranksum(wty_drifts(:,3), wty_drifts2(:,3))
ranksum(wty_drifts(:,4), wty_drifts2(:,4))
ranksum(wty_drifts(:,5), wty_drifts2(:,5))
ranksum(wty_drifts(:,6), wty_drifts2(:,6))
ranksum(wty_drifts(:,7), wty_drifts2(:,7))
ranksum(wty_drifts(:,8), wty_drifts2(:,8))
ranksum(wty_drifts(:,9), wty_drifts2(:,9))
ranksum(wty_drifts(:,10), wty_drifts2(:,10))


ranksum(wta_drifts(:,1), wta_drifts2(:,1))
ranksum(wta_drifts(:,2), wta_drifts2(:,2))
ranksum(wta_drifts(:,3), wta_drifts2(:,3))
ranksum(wta_drifts(:,4), wta_drifts2(:,4))
ranksum(wta_drifts(:,5), wta_drifts2(:,5))
ranksum(wta_drifts(:,6), wta_drifts2(:,6))
ranksum(wta_drifts(:,7), wta_drifts2(:,7))
ranksum(wta_drifts(:,8), wta_drifts2(:,8))
ranksum(wta_drifts(:,9), wta_drifts2(:,9))
ranksum(wta_drifts(:,10), wta_drifts2(:,10))


ranksum(j20y_drifts(:,1), j20y_drifts2(:,1))
ranksum(j20y_drifts(:,2), j20y_drifts2(:,2))
ranksum(j20y_drifts(:,3), j20y_drifts2(:,3))
ranksum(j20y_drifts(:,4), j20y_drifts2(:,4))
ranksum(j20y_drifts(:,5), j20y_drifts2(:,5))
ranksum(j20y_drifts(:,6), j20y_drifts2(:,6))
ranksum(j20y_drifts(:,7), j20y_drifts2(:,7))
ranksum(j20y_drifts(:,8), j20y_drifts2(:,8))
ranksum(j20y_drifts(:,9), j20y_drifts2(:,9))
ranksum(j20y_drifts(:,10), j20y_drifts2(:,10))

ranksum(j20a_drifts(:,1), j20a_drifts2(:,1))
ranksum(j20a_drifts(:,2), j20a_drifts2(:,2))
ranksum(j20a_drifts(:,3), j20a_drifts2(:,3))
ranksum(j20a_drifts(:,4), j20a_drifts2(:,4))
ranksum(j20a_drifts(:,5), j20a_drifts2(:,5))
ranksum(j20a_drifts(:,6), j20a_drifts2(:,6))
ranksum(j20a_drifts(:,7), j20a_drifts2(:,7))
ranksum(j20a_drifts(:,8), j20a_drifts2(:,8))
ranksum(j20a_drifts(:,9), j20a_drifts2(:,9))
ranksum(j20a_drifts(:,10), j20a_drifts2(:,10))




subplot(1,4,1)
plot(linspace(1,10,10), wty_avg(1,:),'r')
hold on
plot(linspace(1,10,10), wty_avg2(1,:),'b')
hold on
scatter(linspace(1,10,10), wty_avg(1,:),'r')
hold on
scatter(linspace(1,10,10), wty_avg2(1,:),'b')
axis square
ylim([0.3,0.8])
subplot(1,4,2)
plot(linspace(1,10,10), wta_avg(1,:),'r')
hold on
plot(linspace(1,10,10), wta_avg2(1,:),'b')
hold on
scatter(linspace(1,10,10), wta_avg(1,:),'r')
hold on
scatter(linspace(1,10,10), wta_avg2(1,:),'b')
axis square
ylim([0.3,0.8])
subplot(1,4,3)
plot(linspace(1,10,10), j20y_avg(1,:),'r')
hold on
plot(linspace(1,10,10), j20y_avg2(1,:),'b')
hold on
scatter(linspace(1,10,10), j20y_avg(1,:),'r')
hold on
scatter(linspace(1,10,10), j20y_avg2(1,:),'b')
axis square
ylim([0.3,0.8])
subplot(1,4,4)
plot(linspace(1,10,10), j20a_avg(1,:),'r')
hold on
plot(linspace(1,10,10), j20a_avg2(1,:),'b')
hold on
scatter(linspace(1,10,10), j20a_avg(1,:),'r')
hold on
scatter(linspace(1,10,10), j20a_avg2(1,:),'b')
axis square
ylim([0.3,0.8])

