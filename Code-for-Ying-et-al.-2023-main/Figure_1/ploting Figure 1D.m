

clear
load('grid_dir_separated_into_hexagonal_and_rectangular.mat')

%making a couple little changes

wtydir2(end+1,:) = wtydir1(end,:);
wtydir1(end,:) = [];

wtadir1(end+1,:) = wtadir2(1,:);
wtadir1(end+1,:) = wtadir2(2,:);
wtadir1(end+1,:) = wtadir2(3,:);
wtadir2(1:3,:) = [];

wty_dir = {};
wta_dir = {};
j20y_dir = {};
j20a_dir = {};

wty_dir = [wtydir1;wtydir2];
wta_dir = [wtadir1;wtadir2];
j20y_dir = [j20ydir1;j20ydir2];
j20a_dir = [j20adir1;j20adir2];




% first, do a correlation only analysis 

dim = 26;
cc = 1;
wtydata = {}; 

for i = 1:size(wty_dir,1)
    clear root
    load(wty_dir{i,3});
    cel = wty_dir{i,4};
    sprintf('cell %.15g of %.15g',i, size(wty_dir,1))
    
    try 
        
        %first half of rate map
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [fullratemap, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        wtydata{cc,1} = fullratemap;
        
        
        clear root
        load(wty_dir{i,3});
        cel = wty_dir{i,4};
        
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm1, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [rm11, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        
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
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [rm22, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        wtydata{cc,2} = rm11;
        wtydata{cc,3} = rm22;
        
        iter = 4;
        
        centermask = logical(zeros(dim,dim));
        centermask(iter+1:dim-iter,iter+1:dim-iter) = 1;
        wallmask = logical(ones(dim,dim));
        wallmask(iter+1:dim-iter,iter+1:dim-iter) = 0;
        
        rm1_c = rm1(centermask);
        rm2_c = rm2(centermask);
        rm1_w = rm1(wallmask);
        rm2_w = rm2(wallmask);
        
        wtydata{cc,4} = corr2(rm1_c, rm2_c);
        wtydata{cc,5} = corr2(rm1_w, rm2_w);
        wtydata{cc,6} = wtydata{cc,4} - wtydata{cc,5};
        
        cc = cc + 1;
    catch
    end
end

%

dim = 26;
cc = 1;
wtadata = {}; 

for i = 1:size(wta_dir,1)
    clear root
    load(wta_dir{i,3});
    cel = wta_dir{i,4};
    sprintf('cell %.15g of %.15g',i, size(wta_dir,1))
    
    try 
        
        %first half of rate map
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [fullratemap, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        wtadata{cc,1} = fullratemap;
        
        
        clear root
        load(wta_dir{i,3});
        cel = wta_dir{i,4};
        
        
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm1, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [rm11, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        
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
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [rm22, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        wtadata{cc,2} = rm11;
        wtadata{cc,3} = rm22;
        
        iter = 4;
        
        centermask = logical(zeros(dim,dim));
        centermask(iter+1:dim-iter,iter+1:dim-iter) = 1;
        wallmask = logical(ones(dim,dim));
        wallmask(iter+1:dim-iter,iter+1:dim-iter) = 0;
        
        rm1_c = rm1(centermask);
        rm2_c = rm2(centermask);
        rm1_w = rm1(wallmask);
        rm2_w = rm2(wallmask);
        
        wtadata{cc,4} = corr2(rm1_c, rm2_c);
        wtadata{cc,5} = corr2(rm1_w, rm2_w);
        wtadata{cc,6} = wtadata{cc,4} - wtadata{cc,5};
        
        cc = cc + 1;
    catch
    end
end

%

dim = 26;
cc = 1;
j20ydata = {}; 

for i = 1:size(j20y_dir,1)
    clear root
    load(j20y_dir{i,3});
    cel = j20y_dir{i,4};
    sprintf('cell %.15g of %.15g',i, size(j20y_dir,1))
    
    try 
        
        %first half of rate map
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [fullratemap, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        j20ydata{cc,1} = fullratemap;
        
        
        clear root
        load(j20y_dir{i,3});
        cel = j20y_dir{i,4};
        
        
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm1, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [rm11, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        
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
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [rm22, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        j20ydata{cc,2} = rm11;
        j20ydata{cc,3} = rm22;
        
        iter = 4;
        
        centermask = logical(zeros(dim,dim));
        centermask(iter+1:dim-iter,iter+1:dim-iter) = 1;
        wallmask = logical(ones(dim,dim));
        wallmask(iter+1:dim-iter,iter+1:dim-iter) = 0;
        
        rm1_c = rm1(centermask);
        rm2_c = rm2(centermask);
        rm1_w = rm1(wallmask);
        rm2_w = rm2(wallmask);
        
        j20ydata{cc,4} = corr2(rm1_c, rm2_c);
        j20ydata{cc,5} = corr2(rm1_w, rm2_w);
        j20ydata{cc,6} = j20ydata{cc,4} - j20ydata{cc,5};
        
        cc = cc + 1;
    catch
    end
end

%

dim = 26;
cc = 1;
j20adata = {}; 

for i = 1:size(j20a_dir,1)
    clear root
    load(j20a_dir{i,3});
    cel = j20a_dir{i,4};
    sprintf('cell %.15g of %.15g',i, size(j20a_dir,1))
    
    try 
        
        %first half of rate map
        self = root;
        self.epoch(2) = self.epoch(1) + 1800;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [fullratemap, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        j20adata{cc,1} = fullratemap;
        
        
        clear root
        load(j20a_dir{i,3});
        cel = j20a_dir{i,4};
        
        
        self.epoch(2) = self.epoch(1) + 1800;
        len = self.epoch(2) - self.epoch(1);
        seg = round(len/2);
        
        self.epoch(2) = self.epoch(1) + seg;
        [oc, xdim, ydim] = self.Occupancy();  %get xdim and ydim
        
        xdim2 = linspace(xdim(1), xdim(end), dim); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim);
        [rm1, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 3, 'std_smooth_kernel', 3);
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [rm11, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        
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
        xdim2 = linspace(xdim(1), xdim(end), dim+10); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), dim+10);
        [rm22, ~, ~, occupancy1, occupancy2] = self.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        j20adata{cc,2} = rm11;
        j20adata{cc,3} = rm22;
        
        iter = 4;
        
        centermask = logical(zeros(dim,dim));
        centermask(iter+1:dim-iter,iter+1:dim-iter) = 1;
        wallmask = logical(ones(dim,dim));
        wallmask(iter+1:dim-iter,iter+1:dim-iter) = 0;
        
        rm1_c = rm1(centermask);
        rm2_c = rm2(centermask);
        rm1_w = rm1(wallmask);
        rm2_w = rm2(wallmask);
        
        j20adata{cc,4} = corr2(rm1_c, rm2_c);
        j20adata{cc,5} = corr2(rm1_w, rm2_w);
        j20adata{cc,6} = j20adata{cc,4} - j20adata{cc,5};
        
        cc = cc + 1;
    catch
    end
end





myColorMap = jet(256);
myColorMap(1,:) = 1;

%% sort cells by the wall correlation scores

[~,X1] = sort(cell2mat(wtydata(:,5)), 'descend');
wtydata = wtydata(X1,:);

[~,X2] = sort(cell2mat(wtadata(:,5)), 'descend');
wtadata = wtadata(X2,:);

[~,X3] = sort(cell2mat(j20ydata(:,5)), 'descend');
j20ydata = j20ydata(X3,:);

[~,X4] = sort(cell2mat(j20adata(:,5)), 'descend');
j20adata = j20adata(X4,:);


%RUN THIS TO GET WALL MAPS
cc = 1;
for i = 1:15
    
    wallmask = zeros(36,36)+1;
    wallmask = logical(wallmask);
    wallmask(7:30,7:30) = 0;
    
    wallmask2 = zeros(36,36);
    wallmask2(7:30,7:30) = -10;
    
    decimalmask = zeros(36,36)+0.2;
    
    subplot(8,15,cc)
    imagesc((imgaussfilt(wtydata{i,2},1.05) .* wallmask + decimalmask) .* wallmask)    
    axis square
    colormap(myColorMap);
    caxis([ min(min(wtydata{i,1})), max(max(wtydata{i,1}))])
    title(round(wtydata{i,5},2))
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    
    subplot(8,15,cc+15)
    imagesc((imgaussfilt(wtydata{i,3},1.05) .* wallmask + decimalmask) .* wallmask)      
    axis square
    colormap(myColorMap);
    caxis([ min(min(wtydata{i,1})), max(max(wtydata{i,1}))])
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    %wta
    subplot(8,15,cc+30)
    imagesc((imgaussfilt(wtadata{i,2},1.05) .* wallmask + decimalmask) .* wallmask)    
    axis square
    colormap(myColorMap);
    caxis([ min(min(wtadata{i,1})), max(max(wtadata{i,1}))])
    title(round(wtadata{i,5},2))
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    subplot(8,15,cc+15+30)
    imagesc((imgaussfilt(wtadata{i,3},1.05) .* wallmask + decimalmask) .* wallmask)   
    axis square
    colormap(myColorMap);
    caxis([ min(min(wtadata{i,1})), max(max(wtadata{i,1}))])
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    %j20y
    subplot(8,15,cc+60)
    imagesc((imgaussfilt(j20ydata{i,2},1.05) .* wallmask + decimalmask) .* wallmask)   
    axis square
    colormap(myColorMap);
    caxis([ min(min(j20ydata{i,1})), max(max(j20ydata{i,1}))])
    title(round(j20ydata{i,5},2))    
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    
    subplot(8,15,cc+15+60)
    imagesc((imgaussfilt(j20ydata{i,3},1.05) .* wallmask + decimalmask) .* wallmask)    
    axis square
    colormap(myColorMap);
    caxis([ min(min(j20ydata{i,1})), max(max(j20ydata{i,1}))])
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    %j20a
    subplot(8,15,cc+90)
    imagesc((imgaussfilt(j20adata{i,2},1.05) .* wallmask + decimalmask) .* wallmask)  
    axis square
    colormap(myColorMap);
    caxis([ min(min(j20adata{i,1})), max(max(j20adata{i,1}))])
    title(round(j20adata{i,5},2))    
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    subplot(8,15,cc+15+90)
    imagesc((imgaussfilt(j20adata{i,3},1.05) .* wallmask + decimalmask) .* wallmask)    
    axis square
    colormap(myColorMap);
    caxis([ min(min(j20adata{i,1})), max(max(j20adata{i,1}))])
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    cc = cc + 1; 
end


%RUN THIS TO GET CENTER MAPS  
cc = 1;
for i = 1:15
    
    wallmask = zeros(36,36);
    wallmask = logical(wallmask);
    wallmask(7:30,7:30) = 1;
    
    wallmask2 = zeros(36,36)-10;
    wallmask2(7:30,7:30) = 0;
    
    decimalmask = zeros(36,36)+0.1;
    
    subplot(8,15,cc)
    imagesc((imgaussfilt(wtydata{i,2},1.05) .* wallmask + decimalmask) .* wallmask)    
    axis square
    colormap(myColorMap);
    caxis([ min(min(wtydata{i,1})), max(max(wtydata{i,1}))])
    title(round(wtydata{i,4},2))
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    
    subplot(8,15,cc+15)
    imagesc((imgaussfilt(wtydata{i,3},1.05) .* wallmask + decimalmask) .* wallmask)      
    axis square
    colormap(myColorMap);
    caxis([ min(min(wtydata{i,1})), max(max(wtydata{i,1}))])
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    %wta
    subplot(8,15,cc+30)
    imagesc((imgaussfilt(wtadata{i,2},1.05) .* wallmask + decimalmask) .* wallmask)    
    axis square
    colormap(myColorMap);
    caxis([ min(min(wtadata{i,1})), max(max(wtadata{i,1}))])
    title(round(wtadata{i,4},2))
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    subplot(8,15,cc+15+30)
    imagesc((imgaussfilt(wtadata{i,3},1.05) .* wallmask + decimalmask) .* wallmask)   
    axis square
    colormap(myColorMap);
    caxis([ min(min(wtadata{i,1})), max(max(wtadata{i,1}))])
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    %j20y
    subplot(8,15,cc+60)
    imagesc((imgaussfilt(j20ydata{i,2},1.05) .* wallmask + decimalmask) .* wallmask)   
    axis square
    colormap(myColorMap);
    caxis([ min(min(j20ydata{i,1})), max(max(j20ydata{i,1}))])
    title(round(j20ydata{i,4},2))    
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    
    subplot(8,15,cc+15+60)
    imagesc((imgaussfilt(j20ydata{i,3},1.05) .* wallmask + decimalmask) .* wallmask)    
    axis square
    colormap(myColorMap);
    caxis([ min(min(j20ydata{i,1})), max(max(j20ydata{i,1}))])
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    %j20a
    subplot(8,15,cc+90)
    imagesc((imgaussfilt(j20adata{i,2},1.05) .* wallmask + decimalmask) .* wallmask)  
    axis square
    colormap(myColorMap);
    caxis([ min(min(j20adata{i,1})), max(max(j20adata{i,1}))])
    title(round(j20adata{i,4},2))    
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    subplot(8,15,cc+15+90)
    imagesc((imgaussfilt(j20adata{i,3},1.05) .* wallmask + decimalmask) .* wallmask)    
    axis square
    colormap(myColorMap);
    caxis([ min(min(j20adata{i,1})), max(max(j20adata{i,1}))])
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    cc = cc + 1; 
end













