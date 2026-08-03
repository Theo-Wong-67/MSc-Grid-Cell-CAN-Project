
clear

%load grid cell directories
%name, age, file name, cel 
wty_dir = {
'12375',111,'2016-10-31_11-37-34', [2,1]
'3630',111,'2017-10-14_18-11-29', [2,1]
'3630',111,'2017-10-14_18-11-29', [2,2]
'3630',111,'2017-10-14_18-11-29', [2,3]
'3630',112,'2017-10-15_14-39-43', [2,3]
'3630',113,'2017-10-16_13-44-27', [2,2]
'3630',113,'2017-10-16_13-44-27', [2,4]
'3630',114,'2017-10-17_10-56-56', [2,2]
'3630',115,'2017-10-18_11-58-36', [2,1]
'3630',115,'2017-10-18_11-58-36', [2,2]
'3630',115,'2017-10-18_11-58-36', [2,5]
'3630',117,'2017-10-20_10-27-02', [2,6]
'3630',117,'2017-10-20_10-27-02', [2,10]
'3630',118,'2017-10-21_12-59-45', [2,2]
'3630',118,'2017-10-21_12-59-45', [2,5]
'3630',123,'2017-10-26_10-48-46', [4,1]
'3630',129,'2017-11-01_14-53-49', [2,5] %%
'3630',129,'2017-11-01_15-23-22', [2,1]
'3630',130,'2017-11-02_13-15-31', [2,1]
'3630',130,'2017-11-02_13-15-31', [2,3]
'3630',130,'2017-11-02_13-15-31', [2,4]
'3630',130,'2017-11-02_13-15-31', [2,9]
'3630',131,'2017-11-03_11-58-06', [2,4]
'3798',81,'2017-10-20_12-15-03', [3,1] %
'3798',92,'2017-10-31_17-34-14', [3,3]
'3798',95,'2017-11-03_13-58-52', [2,1]
'3798',112,'2017-11-21_16-00-47', [3,1]
'3798',113,'2017-11-22_15-30-45', [3,1]
'3884',94,'2017-11-27_12-43-08', [2,1]
'3885',85,'2017-11-18_14-00-00', [4,1]
'3885',87,'2017-11-20_13-38-57', [4,4] %
'3885',89,'2017-11-22_16-29-17', [4,1]
'3885',111,'2017-12-14_11-09-18', [2,1]
'3885',116,'2017-12-19_08-04-59', [2,1]
'3895',97,'2017-12-04_14-53-21', [2,1] %
'4849',100,'2018-05-20_10-21-00', [1,1] %
} 

%name, age, file name, cel 
wta_dir = {
'12746',160,'2017-06-20_11-37-17', [2,2] %
'12746',161,'2017-06-21_09-00-24', [2,1] %
'12748',163,'2017-06-23_08-54-07', [2,1]
'12748',164,'2017-06-24_20-19-29', [1,3]
'12748',164,'2017-06-24_20-19-29', [1,4]
'12748',166,'2017-06-26_15-26-01', [2,1]
'12748',177,'2017-07-07_08-12-32', [2,1]
'12748',180,'2017-07-10_17-59-49', [2,1]
'12748',183,'2017-07-13_14-07-08', [1,1]
'12748',183,'2017-07-13_14-07-08', [2,4]
'12748',187,'2017-07-17_11-30-14', [2,1]
'12748',188,'2017-07-18_16-25-51', [1,1]
'12748',188,'2017-07-18_16-25-51', [2,1]
% '12786',193,'2017-07-25_18-39-46', [3,1] %room 3
% '12787',204,'2017-08-05_17-54-54', [4,4] % room 3
% '12791',206,'2017-08-08_16-48-04', [3,3]   %room 3
'3630',157,'2017-11-29_14-27-14', [2,1]
'3630',157,'2017-11-29_14-27-14', [2,9]
'3630',159,'2017-12-01_10-06-36', [2,1]
'3630',159,'2017-12-01_10-06-36', [2,3]
'3630',159,'2017-12-01_10-06-36', [2,5]
'3630',159,'2017-12-01_10-06-36', [2,6]
'3630',160,'2017-12-02_16-07-12', [2,2]
'3630',160,'2017-12-02_16-07-12', [2,6]
'3630',160,'2017-12-02_16-07-12', [2,10]
'3630',162,'2017-12-04_11-37-16', [2,2]
'3630',162,'2017-12-04_11-37-16', [2,3]
'3630',162,'2017-12-04_11-37-16', [2,4]
'3630',162,'2017-12-04_11-37-16', [2,7]
'3630',164,'2017-12-06_12-43-31', [2,2]
'3630',164,'2017-12-06_12-43-31', [2,5]
'3630',164,'2017-12-06_12-43-31', [2,6]
'3630',164,'2017-12-06_12-43-31', [2,7]
'3630',164,'2017-12-06_12-43-31', [2,8]
'3630',166,'2017-12-08_10-04-20', [2,1]
'3630',166,'2017-12-08_10-04-20', [2,2]
'3630',167,'2017-12-09_09-56-49', [2,1]
'3630',169,'2017-12-11_11-17-41', [2,2]
'3630',169,'2017-12-11_11-17-41', [2,3]
'3630',171,'2017-12-13_08-51-13', [2,1]
'3630',171,'2017-12-13_08-51-13', [2,2]
'3781',175,'2018-01-20_09-46-11', [3,1]
'3781',175,'2018-01-20_09-46-11', [3,2]
'3781',177,'2018-01-22_09-19-56', [3,2]
'3781',178,'2018-01-23_11-14-06', [3,1]
'3782',166,'2018-01-11_09-30-56', [3,1]
'3782',167,'2018-01-12_09-36-37', [3,2]
'3782',167,'2018-01-12_09-36-37', [3,3]
'3782',170,'2018-01-15_10-13-43', [3,4]
'3782',171,'2018-01-16_09-00-39', [3,1]
'3782',171,'2018-01-16_09-00-39', [3,2]
'3782',171,'2018-01-16_09-00-39', [3,3]
'3782',171,'2018-01-16_09-00-39', [3,5]
'3782',172,'2018-01-17_07-35-10', [3,3]
'3782',173,'2018-01-18_06-58-36', [3,2]
'3782',180,'2018-01-25_10-07-42', [3,1]
'3782',184,'2018-01-29_09-44-17', [3,3]
'3782',192,'2018-02-06_10-16-21', [3,1] %%
'3782',193,'2018-02-07_12-06-08', [3,1]
'3783',164,'2018-01-09_06-47-40', [3,1]
'3783',164,'2018-01-09_06-47-40', [3,2]
'3783',164,'2018-01-09_06-47-40', [3,3]
'3783',173,'2018-01-18_08-03-14', [2,1]
'3783',187,'2018-02-01_12-44-37', [4,1]
'3783',187,'2018-02-01_12-44-37', [4,2]
'3784',164,'2018-01-09_08-45-43', [2,2]
'5036',147,'2018-08-01_11-40-28', [2,3]
}

%name, age, file name, cel 
j20y_dir = {
'3532',73,'2017-08-28_17-40-14', [3,1]
'3532',87,'2017-09-11_17-46-00', [3,1]
'3532',89,'2017-09-13_14-20-38', [3,1]
'3532',108,'2017-10-07_19-27-44', [2,1]
'3534',90,'2017-09-14_17-48-46', [2,1] %
'3534',94,'2017-09-18_16-24-43', [2,2]
'3534',96,'2017-09-20_13-14-34', [2,1]
'3534',98,'2017-09-22_08-21-53', [2,2]
'3534',99,'2017-09-23_15-41-23', [2,1]
'3534',101,'2017-09-25_16-05-39', [2,1]
'3534',106,'2017-09-30_09-57-33', [2,2]
'3534',113,'2017-10-07_17-39-21', [2,2]
'3534',123,'2017-10-17_14-13-47', [2,2]
'3534',123,'2017-10-17_14-13-47', [2,3]
'3799',92,'2017-10-31_18-19-37', [2,1]
'3799',94,'2017-11-02_12-13-30', [2,1]
'3799',95,'2017-11-03_12-58-39', [2,1]
'3799',95,'2017-11-03_12-58-39', [2,2]
'3799',95,'2017-11-03_12-58-39', [2,3]
'3799',98,'2017-11-06_15-18-39', [2,2]
'3799',101,'2017-11-09_12-45-59', [2,2]
'3799',105,'2017-11-13_13-21-26', [2,1]
'3799',106,'2017-11-14_12-40-24', [2,1]
'3799',107,'2017-11-15_13-15-46', [2,2]
'4756',105,'2018-05-13_11-08-01', [4,1] %
'4756',109,'2018-05-17_11-39-53', [3,4]
'4756',116,'2018-05-24_11-16-47', [1,2] %
'4757',101,'2018-05-09_14-55-27', [2,2]
'4757',105,'2018-05-13_09-31-04', [2,1]
'4757',116,'2018-05-24_12-07-19', [2,1]
'5035',109,'2018-06-24_10-03-42', [2,1]
'5035',109,'2018-06-24_10-03-42', [2,3]
}

%name, age, file name, cel 
j20a_dir = {
'12040',189,'2016-06-23_09-46-05', [1,3]
'12758',197,'2017-07-28_10-58-12', [1,1] % 
% '12784',189,'2017-07-21_09-48-54', [1,4] %
'12785',199,'2017-07-31_13-46-28', [4,1] %%
'12790',202,'2017-08-02_14-00-01', [1,1]
'12790',223,'2017-08-23_15-59-11', [2,3]
'12792',222,'2017-08-22_09-28-08', [2,1]
'3683',167,'2017-12-22_10-09-34', [2,1]
'3828',183,'2018-02-07_10-32-05', [2,3] %
'3828',191,'2018-02-15_10-38-44', [4,2]
'3828',193,'2018-02-17_11-31-56', [4,1]
'3828',193,'2018-02-17_11-31-56', [4,2]
'3828',193,'2018-02-17_11-31-56', [4,3]
'3828',195,'2018-02-19_07-09-35', [4,1]
'3828',195,'2018-02-19_07-09-35', [4,2]
'3894',207,'2018-03-24_13-57-16', [3,2]
'3894',208,'2018-03-25_11-59-44', [3,3]
'3931',188,'2018-03-07_15-31-00', [2,1]
'4014',182,'2018-03-22_09-53-04', [1,2]
'4118',170,'2018-04-12_08-58-34', [2,1]
'4118',175,'2018-04-17_11-13-55', [2,1]
'4118',175,'2018-04-17_11-13-55', [2,2]
'4118',179,'2018-04-21_14-28-21', [2,1]
'4118',179,'2018-04-21_14-28-21', [2,2]
'4118',180,'2018-04-22_10-38-42', [2,2]
'4125',167,'2018-04-09_07-50-41', [2,3]
'4125',168,'2018-04-10_09-55-44', [2,1]
'4125',168,'2018-04-10_09-55-44', [2,3]
'4125',171,'2018-04-13_07-56-17', [2,1]
'4125',171,'2018-04-13_07-56-17', [2,3]
'4125',175,'2018-04-17_10-14-48', [2,1]
'4125',178,'2018-04-20_12-41-05', [2,2]
'4125',178,'2018-04-20_12-41-05', [2,3]
'4593',203,'2018-07-25_11-14-43', [1,2]
'4593',206,'2018-07-28_08-02-42', [1,1]
'4593',211,'2018-08-02_07-57-28', [1,4]
'4599',207,'2018-07-29_08-45-08', [2,4]
'4623',208,'2018-08-02_08-38-32', [1,2]
'4754',157,'2018-07-04_11-04-48', [3,3] %
'4757',182,'2018-07-29_10-34-37', [2,4]
}

%% The code has 2 parts: 
% 1. Voronoi segmentation, and extracting all Fourier components, to be later used in step 2
% 2. Extracting Fourier components 

%% 1. Voronoi segmentation
% 2 giant loops, 1 for voronoi segmentation (to keep this analysis consistent with Krupic et al. 2012), 
% and 1 for extracting the Fourier powers. 
%
% These 2 loops repeat for each animal group
% Since these are the same code,  only nTG-y code is commended in detail


allwtymaps = {};

for celliter = 1:size(wty_dir,1)
    disp(celliter)
    
    clear root
    %load cell
    load(wty_dir{celliter,3});
    cel = wty_dir{celliter,4};
    
    wtymaps = {};
    
    [oc, xdim, ydim] = root.Occupancy();
    xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
    ydim2 = linspace(ydim(1), ydim(end), 36);
    
    %create smoothed and unsmoothed rate maps
    [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
    [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 2, 'std_smooth_kernel', 2);
    
    img = rate_map1;
    img = double(img);
    
    imgo = rate_map2;
    imgo = double(imgo);
    
    % find regional max
    imgPros = imregionalmax(imgo,4);
    
    % get centroids of regional max
    objects = regionprops(imgPros,{'Centroid', 'BoundingBox','Image'});
    
    % save centroids to array
    centroids = nan([numel(objects),2]);
    for i = 1:numel(objects)
        centroids(i,:) = objects(i).Centroid;
    end
              
    for iiii = 1:50

        %get vertices of all segments
        [V,C,XY]=VoronoiLimit(centroids(:,1),centroids(:,2));

        %now, cycle through all rows of R, and draw a specific polygon for each set of vertices
        allPoly = [];
        for it = 1:size(C,1)
            indx = C{it};
            coords = V(indx,:);
            %     coords(end+1,:) = coords(1,:);
            %
            %     if(sum(isinf(coords))>1)
            %         continue
            %     end
            allPoly(:,:,it) = poly2mask(coords(:,1),coords(:,2),size(imgo,1),size(imgo,2));
        end


        %ok, now we need to work with a virtual environment
        virtual = zeros(size(img,1)*3, size(img,2)*3);
        virtual(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2) = img;

        %and we have to place all of our created polygons into this virtual environment too
        allPoly2 = [];
        for it = 1:size(allPoly,3)
            m = zeros(size(img,1)*3, size(img,2)*3);
            m(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2) = allPoly(:,:,it);
            allPoly2(:,:,it) = m;
        end
        % imagesc(virtual)




        %now, get the truncated polys
        allPoly3 = [];
        for it = 1:size(allPoly,3)
            trun = allPoly2(:,:,it) .* virtual;
            allPoly3(:,:,it) = trun;
        end



        % ROTATE IT !!!!!
        newcentroids = []; %remember, we have to convert the original centroids to the same scale as the virtual environment
        newcentroids(:,1) = centroids(:,1) + size(img,1);
        newcentroids(:,2) = centroids(:,2) + size(img,2);
        allPoly4 = [];
        for it = 1:size(allPoly3,3)

            pointX = newcentroids(it,1); %this is column
            pointY = newcentroids(it,2); %this is row
            dd = randi([-180 180]);
            rotated = rotateAround(allPoly3(:,:,it), pointY, pointX, dd);
            allPoly4(:,:,it) = rotated;
        end


        % assign new centers to each segment
        allPoly5 = [];
        newcentroids2 = [];
        padsize = 300;
        for it = 1:size(newcentroids,1)
            newrow = randi([size(img,1)+1, size(img,1)*2]);
            newcol = randi([size(img,2)+1, size(img,2)*2]);

            xdiff = round(newrow - newcentroids(it,1));
            ydiff = round(newcol - newcentroids(it,2));

            %lazy implementation b/c ... lazy
            poly_padded = padarray(allPoly4(:,:,it),[padsize padsize],0,'both');

            %original size of virtual map
            %poly_padded(padsize+1: end-300, padsize+1: end-300)

            %incorporate the shift in x and y
            shifted = poly_padded(padsize+1 - ydiff: end-300 - ydiff,      padsize+1 - xdiff: end-300 - xdiff); %FLIPPED. careful of how you index...
            allPoly5(:,:,it) = shifted;
        end


        %now, add all the segments
        %for overlapping bins, the new polygons value replace the old one (would need a zero mask for each new addition)
        %also store bins that escape the virtual arena
        %those truncated bins will be randomly assigned to resulting empty bins of the virtual arena
        %also gotta work with the unsmoothed rate map in this case...

        final_map = zeros(size(virtual,1), size(virtual,2));
        alltruncatedbins = [];
        for it = 1:size(allPoly5,3)

            currZeroMask = allPoly5(:,:,it)>0;
            currZeroMask = ~logical(currZeroMask);

            final_map = final_map .* currZeroMask; %gotta make any overlapping bins 0
            final_map = final_map + allPoly5(:,:,it);

            %determine which bins are truncated and store them
            trueEnv = zeros(size(virtual,1), size(virtual,2)) + 1;
            trueEnv(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 ) = 0;
            outsideEnv = final_map .* trueEnv;

            [row, column, dataValues] = find(outsideEnv ~= 0);

            if(isempty(row))
                continue;
            end

            q = row';
            p = column';
            idx=sub2ind(size(outsideEnv),q,p);
            out=outsideEnv(idx)';
            alltruncatedbins = [alltruncatedbins; out];

            %lastly, replace the truncated bins outside of the final map with 0
            lastfilter = zeros(size(virtual,1), size(virtual,2));
            lastfilter(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 ) = 1;
            final_map = final_map .* lastfilter;

        end

        finalfinalmap = final_map(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 );

        %fill in empty spots with truncated bins
        [row, column, dataValues] = find(finalfinalmap == 0);

        alltruncatedbins = alltruncatedbins(randperm(length(alltruncatedbins)));
        alltruncatedbins = alltruncatedbins';

        ml = length(alltruncatedbins);

        rc = [row,column];
        rc = rc(randperm(size(rc, 1)), :);

        idx = sub2ind(size(finalfinalmap),rc(1:ml,1),rc(1:ml,2)) ;
        finalfinalmap(idx) = alltruncatedbins ;

    %     wtymaps{iiii,1} = finalfinalmap;
        wtymaps{iiii,1} = imgaussfilt(finalfinalmap,1.25);
        wtymaps{iiii,2} = finalfinalmap;

        wtymaps{iiii,3} = size(C,1);
    end
    wtymaps{end+1,1} = rate_map2;
    wtymaps{end,2} = rate_map1;
    
    allwtymaps{celliter,1} = wtymaps;
    
end

%see how many voronoi segments per map
wtyvoronoisegments = [];
for i = 1:size(allwtymaps,1)
    wtyvoronoisegments = [wtyvoronoisegments; allwtymaps{i, 1}{1, 3} ];
end

hist(wtyvoronoisegments,10)



allwtypowers = {}; 

for celliter = 1:size(allwtymaps,1)
    disp(celliter)
    wtypowers = {}; 
    
    currentcell = allwtymaps{celliter,1};
    
    allpowersforcurrent = [];
    
    for ii = 1:size(currentcell,1)

        map = currentcell{ii,2};    

        fr = nanmean(nanmean(map)); %firing rate 
        M = 36; %original rate map sizes
        N = 36;
        mx = 256; %zero padded rate map sizes
        nx = 256;

        %zero padded rate map
        padsize = (mx-M)/2;
        rate_map1_padded = padarray(map,[padsize padsize],0,'both');
        coef = 1/(fr * sqrt(M*N)); 

        imgL = rate_map1_padded;
        wtypowers{ii,1} = imgL; 

        imgX  = coef * fftshift(fft2(imgL));

    %     powr3 = (abs(imgX));
        powr3 = (abs(imgX.^2));

        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;

        maxfpower = nanmax(nanmax(powr3)); %max fourier power... 
        wtypowers{ii,2} = powr3; 
        wtypowers{ii,3} = maxfpower; 
        wtypowers{ii,4} = fr; 
        
        if ii < size(allwtymaps,1)
            allpowersforcurrent = [allpowersforcurrent; reshape(powr3,[],1)];
        end
    end

%     allwtypowers{celliter,1} = wtypowers;
    allwtypowers{celliter,2} = prctile(cell2mat(wtypowers(1:end-1,3)),95);
    allwtypowers{celliter,3} = prctile(cell2mat(wtypowers(1:end-1,3)),75);
    allwtypowers{celliter,4} = max(max(wtypowers{end,2}));
    allwtypowers{celliter,5} = max(max(wtypowers{end,2})) >= prctile(cell2mat(wtypowers(1:end-1,3)),95);
    allwtypowers{celliter,6} = max(max(wtypowers{end,2})) >= prctile(cell2mat(wtypowers(1:end-1,3)),90);
    allwtypowers{celliter,7} = max(max(wtypowers{end,2})) >= prctile(cell2mat(wtypowers(1:end-1,3)),85);
    allwtypowers{celliter,8} = max(max(wtypowers{end,2})) >= prctile(cell2mat(wtypowers(1:end-1,3)),80);
    
    allwtypowers{celliter,9} = prctile(allpowersforcurrent,50); %50th percentile power of shuffled data 
    allwtypowers{celliter,10} = prctile(allpowersforcurrent,75); %75th percentile power of shuffled data 
    allwtypowers{celliter,11} = prctile(allpowersforcurrent,95); %95th percentile power of shuffled data 
    allwtypowers{celliter,12} = prctile(allpowersforcurrent,99); %99th percentile power of shuffled data 
end


%% nTG-A
allwtamaps = {};

for celliter = 1:size(wta_dir,1)
    disp(celliter)
    
    clear root
    load(wta_dir{celliter,3});
    cel = wta_dir{celliter,4};
    
    wtamaps = {};
    
    [oc, xdim, ydim] = root.Occupancy();
    xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
    ydim2 = linspace(ydim(1), ydim(end), 36);
    
    [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
    [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 2, 'std_smooth_kernel', 2);
    
    img = rate_map1;
    img = double(img);
    
    imgo = rate_map2;
    imgo = double(imgo);
    
    % find regional max
    imgPros = imregionalmax(imgo,4);
    
    % get centroids of regional max
    objects = regionprops(imgPros,{'Centroid', 'BoundingBox','Image'});
    
    % save centroids to array
    centroids = nan([numel(objects),2]);
    for i = 1:numel(objects)
        centroids(i,:) = objects(i).Centroid;
    end
              
    for iiii = 1:50

        %get vertices of all segments
        [V,C,XY]=VoronoiLimit(centroids(:,1),centroids(:,2));

        %now, cycle through all rows of R, and draw a specific polygon for each set of vertices
        allPoly = [];
        for it = 1:size(C,1)
            indx = C{it};
            coords = V(indx,:);
            %     coords(end+1,:) = coords(1,:);
            %
            %     if(sum(isinf(coords))>1)
            %         continue
            %     end
            allPoly(:,:,it) = poly2mask(coords(:,1),coords(:,2),size(imgo,1),size(imgo,2));
        end


        %ok, now we need to work with a virtual environment
        virtual = zeros(size(img,1)*3, size(img,2)*3);
        virtual(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2) = img;

        %and we have to place all of our created polygons into this virtual environment too
        allPoly2 = [];
        for it = 1:size(allPoly,3)
            m = zeros(size(img,1)*3, size(img,2)*3);
            m(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2) = allPoly(:,:,it);
            allPoly2(:,:,it) = m;
        end
        % imagesc(virtual)




        %now, get the truncated polys
        allPoly3 = [];
        for it = 1:size(allPoly,3)
            trun = allPoly2(:,:,it) .* virtual;
            allPoly3(:,:,it) = trun;
        end



        % ROTATE IT !!!!!
        newcentroids = []; %remember, we have to convert the original centroids to the same scale as the virtual environment
        newcentroids(:,1) = centroids(:,1) + size(img,1);
        newcentroids(:,2) = centroids(:,2) + size(img,2);
        allPoly4 = [];
        for it = 1:size(allPoly3,3)

            pointX = newcentroids(it,1); %this is column
            pointY = newcentroids(it,2); %this is row
            dd = randi([-180 180]);
            rotated = rotateAround(allPoly3(:,:,it), pointY, pointX, dd);
            allPoly4(:,:,it) = rotated;
        end


        % assign new centers to each segment
        allPoly5 = [];
        newcentroids2 = [];
        padsize = 300;
        for it = 1:size(newcentroids,1)
            newrow = randi([size(img,1)+1, size(img,1)*2]);
            newcol = randi([size(img,2)+1, size(img,2)*2]);

            xdiff = round(newrow - newcentroids(it,1));
            ydiff = round(newcol - newcentroids(it,2));

            %lazy implementation b/c ... lazy
            poly_padded = padarray(allPoly4(:,:,it),[padsize padsize],0,'both');

            %original size of virtual map
            %poly_padded(padsize+1: end-300, padsize+1: end-300)

            %incorporate the shift in x and y
            shifted = poly_padded(padsize+1 - ydiff: end-300 - ydiff,      padsize+1 - xdiff: end-300 - xdiff); %FLIPPED. careful of how you index...
            allPoly5(:,:,it) = shifted;
        end


        %now, add all the segments
        %for overlapping bins, the new polygons value replace the old one (would need a zero mask for each new addition)
        %also store bins that escape the virtual arena
        %those truncated bins will be randomly assigned to resulting empty bins of the virtual arena
        %also gotta work with the unsmoothed rate map in this case...

        final_map = zeros(size(virtual,1), size(virtual,2));
        alltruncatedbins = [];
        for it = 1:size(allPoly5,3)

            currZeroMask = allPoly5(:,:,it)>0;
            currZeroMask = ~logical(currZeroMask);

            final_map = final_map .* currZeroMask; %gotta make any overlapping bins 0
            final_map = final_map + allPoly5(:,:,it);

            %determine which bins are truncated and store them
            trueEnv = zeros(size(virtual,1), size(virtual,2)) + 1;
            trueEnv(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 ) = 0;
            outsideEnv = final_map .* trueEnv;

            [row, column, dataValues] = find(outsideEnv ~= 0);

            if(isempty(row))
                continue;
            end

            q = row';
            p = column';
            idx=sub2ind(size(outsideEnv),q,p);
            out=outsideEnv(idx)';
            alltruncatedbins = [alltruncatedbins; out];

            %lastly, replace the truncated bins outside of the final map with 0
            lastfilter = zeros(size(virtual,1), size(virtual,2));
            lastfilter(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 ) = 1;
            final_map = final_map .* lastfilter;

        end

        finalfinalmap = final_map(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 );

        %fill in empty spots with truncated bins
        [row, column, dataValues] = find(finalfinalmap == 0);

        alltruncatedbins = alltruncatedbins(randperm(length(alltruncatedbins)));
        alltruncatedbins = alltruncatedbins';

        ml = length(alltruncatedbins);

        rc = [row,column];
        rc = rc(randperm(size(rc, 1)), :);

        idx = sub2ind(size(finalfinalmap),rc(1:ml,1),rc(1:ml,2)) ;
        finalfinalmap(idx) = alltruncatedbins ;

    %     wtamaps{iiii,1} = finalfinalmap;
        wtamaps{iiii,1} = imgaussfilt(finalfinalmap,1.25);
        wtamaps{iiii,2} = finalfinalmap;

        wtamaps{iiii,3} = size(C,1);
    end
    wtamaps{end+1,1} = rate_map2;
    wtamaps{end,2} = rate_map1;
    
    allwtamaps{celliter,1} = wtamaps;
    
end

%see how many voronoi segments per map
wtavoronoisegments = [];
for i = 1:size(allwtamaps,1)
    wtavoronoisegments = [wtavoronoisegments; allwtamaps{i, 1}{1, 3} ];
end

hist(wtavoronoisegments,10)

allwtapowers = {}; 

for celliter = 1:size(allwtamaps,1)
    disp(celliter)
    wtapowers = {}; 
    
    currentcell = allwtamaps{celliter,1};
    
    allpowersforcurrent = [];
    
    for ii = 1:size(currentcell,1)

        map = currentcell{ii,2};    

        fr = nanmean(nanmean(map)); %firing rate 
        M = 36; %original rate map sizes
        N = 36;
        mx = 256; %zero padded rate map sizes
        nx = 256;

        %zero padded rate map
        padsize = (mx-M)/2;
        rate_map1_padded = padarray(map,[padsize padsize],0,'both');
        coef = 1/(fr * sqrt(M*N)); 

        imgL = rate_map1_padded;
        wtapowers{ii,1} = imgL; 

        imgX  = coef * fftshift(fft2(imgL));

    %     powr3 = (abs(imgX));
        powr3 = (abs(imgX.^2));

        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;

        maxfpower = nanmax(nanmax(powr3)); %max fourier power... 
        wtapowers{ii,2} = powr3; 
        wtapowers{ii,3} = maxfpower; 
        wtapowers{ii,4} = fr; 
        
        if ii < size(allwtamaps,1)
            allpowersforcurrent = [allpowersforcurrent; reshape(powr3,[],1)];
        end
    end

%     allwtapowers{celliter,1} = wtapowers;
    allwtapowers{celliter,2} = prctile(cell2mat(wtapowers(1:end-1,3)),95);
    allwtapowers{celliter,3} = prctile(cell2mat(wtapowers(1:end-1,3)),75);
    allwtapowers{celliter,4} = max(max(wtapowers{end,2}));
    allwtapowers{celliter,5} = max(max(wtapowers{end,2})) >= prctile(cell2mat(wtapowers(1:end-1,3)),95);
    allwtapowers{celliter,6} = max(max(wtapowers{end,2})) >= prctile(cell2mat(wtapowers(1:end-1,3)),90);
    allwtapowers{celliter,7} = max(max(wtapowers{end,2})) >= prctile(cell2mat(wtapowers(1:end-1,3)),85);
    allwtapowers{celliter,8} = max(max(wtapowers{end,2})) >= prctile(cell2mat(wtapowers(1:end-1,3)),80);
    
    allwtapowers{celliter,9} = prctile(allpowersforcurrent,50); %50th percentile power of shuffled data 
    allwtapowers{celliter,10} = prctile(allpowersforcurrent,75); %75th percentile power of shuffled data 
    allwtapowers{celliter,11} = prctile(allpowersforcurrent,95); %95th percentile power of shuffled data 
    allwtapowers{celliter,12} = prctile(allpowersforcurrent,99); %99th percentile power of shuffled data 
end

%%

allj20ymaps = {};

for celliter = 1:size(j20y_dir,1)
    disp(celliter)
    
    clear root
    load(j20y_dir{celliter,3});
    cel = j20y_dir{celliter,4};
    
    j20ymaps = {};
    
    [oc, xdim, ydim] = root.Occupancy();
    xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
    ydim2 = linspace(ydim(1), ydim(end), 36);
    
    [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
    [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 2, 'std_smooth_kernel', 2);
    
    img = rate_map1;
    img = double(img);
    
    imgo = rate_map2;
    imgo = double(imgo);
    
    % find regional max
    imgPros = imregionalmax(imgo,4);
    
    % get centroids of regional max
    objects = regionprops(imgPros,{'Centroid', 'BoundingBox','Image'});
    
    % save centroids to array
    centroids = nan([numel(objects),2]);
    for i = 1:numel(objects)
        centroids(i,:) = objects(i).Centroid;
    end
              
    for iiii = 1:50

        %get vertices of all segments
        [V,C,XY]=VoronoiLimit(centroids(:,1),centroids(:,2));

        %now, cycle through all rows of R, and draw a specific polygon for each set of vertices
        allPoly = [];
        for it = 1:size(C,1)
            indx = C{it};
            coords = V(indx,:);
            %     coords(end+1,:) = coords(1,:);
            %
            %     if(sum(isinf(coords))>1)
            %         continue
            %     end
            allPoly(:,:,it) = poly2mask(coords(:,1),coords(:,2),size(imgo,1),size(imgo,2));
        end


        %ok, now we need to work with a virtual environment
        virtual = zeros(size(img,1)*3, size(img,2)*3);
        virtual(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2) = img;

        %and we have to place all of our created polygons into this virtual environment too
        allPoly2 = [];
        for it = 1:size(allPoly,3)
            m = zeros(size(img,1)*3, size(img,2)*3);
            m(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2) = allPoly(:,:,it);
            allPoly2(:,:,it) = m;
        end
        % imagesc(virtual)




        %now, get the truncated polys
        allPoly3 = [];
        for it = 1:size(allPoly,3)
            trun = allPoly2(:,:,it) .* virtual;
            allPoly3(:,:,it) = trun;
        end



        % ROTATE IT !!!!!
        newcentroids = []; %remember, we have to convert the original centroids to the same scale as the virtual environment
        newcentroids(:,1) = centroids(:,1) + size(img,1);
        newcentroids(:,2) = centroids(:,2) + size(img,2);
        allPoly4 = [];
        for it = 1:size(allPoly3,3)

            pointX = newcentroids(it,1); %this is column
            pointY = newcentroids(it,2); %this is row
            dd = randi([-180 180]);
            rotated = rotateAround(allPoly3(:,:,it), pointY, pointX, dd);
            allPoly4(:,:,it) = rotated;
        end


        % assign new centers to each segment
        allPoly5 = [];
        newcentroids2 = [];
        padsize = 300;
        for it = 1:size(newcentroids,1)
            newrow = randi([size(img,1)+1, size(img,1)*2]);
            newcol = randi([size(img,2)+1, size(img,2)*2]);

            xdiff = round(newrow - newcentroids(it,1));
            ydiff = round(newcol - newcentroids(it,2));

            %lazy implementation b/c ... lazy
            poly_padded = padarray(allPoly4(:,:,it),[padsize padsize],0,'both');

            %original size of virtual map
            %poly_padded(padsize+1: end-300, padsize+1: end-300)

            %incorporate the shift in x and y
            shifted = poly_padded(padsize+1 - ydiff: end-300 - ydiff,      padsize+1 - xdiff: end-300 - xdiff); %FLIPPED. careful of how you index...
            allPoly5(:,:,it) = shifted;
        end


        %now, add all the segments
        %for overlapping bins, the new polygons value replace the old one (would need a zero mask for each new addition)
        %also store bins that escape the virtual arena
        %those truncated bins will be randomly assigned to resulting empty bins of the virtual arena
        %also gotta work with the unsmoothed rate map in this case...

        final_map = zeros(size(virtual,1), size(virtual,2));
        alltruncatedbins = [];
        for it = 1:size(allPoly5,3)

            currZeroMask = allPoly5(:,:,it)>0;
            currZeroMask = ~logical(currZeroMask);

            final_map = final_map .* currZeroMask; %gotta make any overlapping bins 0
            final_map = final_map + allPoly5(:,:,it);

            %determine which bins are truncated and store them
            trueEnv = zeros(size(virtual,1), size(virtual,2)) + 1;
            trueEnv(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 ) = 0;
            outsideEnv = final_map .* trueEnv;

            [row, column, dataValues] = find(outsideEnv ~= 0);

            if(isempty(row))
                continue;
            end

            q = row';
            p = column';
            idx=sub2ind(size(outsideEnv),q,p);
            out=outsideEnv(idx)';
            alltruncatedbins = [alltruncatedbins; out];

            %lastly, replace the truncated bins outside of the final map with 0
            lastfilter = zeros(size(virtual,1), size(virtual,2));
            lastfilter(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 ) = 1;
            final_map = final_map .* lastfilter;

        end

        finalfinalmap = final_map(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 );

        %fill in empty spots with truncated bins
        [row, column, dataValues] = find(finalfinalmap == 0);

        alltruncatedbins = alltruncatedbins(randperm(length(alltruncatedbins)));
        alltruncatedbins = alltruncatedbins';

        ml = length(alltruncatedbins);

        rc = [row,column];
        rc = rc(randperm(size(rc, 1)), :);

        idx = sub2ind(size(finalfinalmap),rc(1:ml,1),rc(1:ml,2)) ;
        finalfinalmap(idx) = alltruncatedbins ;

    %     j20ymaps{iiii,1} = finalfinalmap;
        j20ymaps{iiii,1} = imgaussfilt(finalfinalmap,1.25);
        j20ymaps{iiii,2} = finalfinalmap;

        j20ymaps{iiii,3} = size(C,1);
    end
    j20ymaps{end+1,1} = rate_map2;
    j20ymaps{end,2} = rate_map1;
    
    allj20ymaps{celliter,1} = j20ymaps;
    
end

%see how many voronoi segments per map
j20yvoronoisegments = [];
for i = 1:size(allj20ymaps,1)
    j20yvoronoisegments = [j20yvoronoisegments; allj20ymaps{i, 1}{1, 3} ];
end

hist(j20yvoronoisegments,15)

allj20ypowers = {}; 

for celliter = 1:size(allj20ymaps,1)
    disp(celliter)
    j20ypowers = {}; 
    
    currentcell = allj20ymaps{celliter,1};
    
    allpowersforcurrent = [];
    
    for ii = 1:size(currentcell,1)

        map = currentcell{ii,2};    

        fr = nanmean(nanmean(map)); %firing rate 
        M = 36; %original rate map sizes
        N = 36;
        mx = 256; %zero padded rate map sizes
        nx = 256;

        %zero padded rate map
        padsize = (mx-M)/2;
        rate_map1_padded = padarray(map,[padsize padsize],0,'both');
        coef = 1/(fr * sqrt(M*N)); 

        imgL = rate_map1_padded;
        j20ypowers{ii,1} = imgL; 

        imgX  = coef * fftshift(fft2(imgL));

    %     powr3 = (abs(imgX));
        powr3 = (abs(imgX.^2));

        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;

        maxfpower = nanmax(nanmax(powr3)); %max fourier power... 
        j20ypowers{ii,2} = powr3; 
        j20ypowers{ii,3} = maxfpower; 
        j20ypowers{ii,4} = fr; 
        
        if ii < size(allj20ymaps,1)
            allpowersforcurrent = [allpowersforcurrent; reshape(powr3,[],1)];
        end
    end

%     allj20ypowers{celliter,1} = j20ypowers;
    allj20ypowers{celliter,2} = prctile(cell2mat(j20ypowers(1:end-1,3)),95);
    allj20ypowers{celliter,3} = prctile(cell2mat(j20ypowers(1:end-1,3)),75);
    allj20ypowers{celliter,4} = max(max(j20ypowers{end,2}));
    allj20ypowers{celliter,5} = max(max(j20ypowers{end,2})) >= prctile(cell2mat(j20ypowers(1:end-1,3)),95);
    allj20ypowers{celliter,6} = max(max(j20ypowers{end,2})) >= prctile(cell2mat(j20ypowers(1:end-1,3)),90);
    allj20ypowers{celliter,7} = max(max(j20ypowers{end,2})) >= prctile(cell2mat(j20ypowers(1:end-1,3)),85);
    allj20ypowers{celliter,8} = max(max(j20ypowers{end,2})) >= prctile(cell2mat(j20ypowers(1:end-1,3)),80);
    
    allj20ypowers{celliter,9} = prctile(allpowersforcurrent,50); %50th percentile power of shuffled data 
    allj20ypowers{celliter,10} = prctile(allpowersforcurrent,75); %75th percentile power of shuffled data 
    allj20ypowers{celliter,11} = prctile(allpowersforcurrent,95); %95th percentile power of shuffled data 
    allj20ypowers{celliter,12} = prctile(allpowersforcurrent,99); %99th percentile power of shuffled data 
end

%% APP-a

allj20amaps = {};

for celliter = 1:size(j20a_dir,1)
    disp(celliter)
    
    clear root
    load(j20a_dir{celliter,3});
    cel = j20a_dir{celliter,4};
    
    j20amaps = {};
    
    [oc, xdim, ydim] = root.Occupancy();
    xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
    ydim2 = linspace(ydim(1), ydim(end), 36);
    
    [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
    [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 2, 'std_smooth_kernel', 2);
    
    img = rate_map1;
    img = double(img);
    
    imgo = rate_map2;
    imgo = double(imgo);
    
    % find regional max
    imgPros = imregionalmax(imgo,4);
    
    % get centroids of regional max
    objects = regionprops(imgPros,{'Centroid', 'BoundingBox','Image'});
    
    % save centroids to array
    centroids = nan([numel(objects),2]);
    for i = 1:numel(objects)
        centroids(i,:) = objects(i).Centroid;
    end
              
    for iiii = 1:50

        %get vertices of all segments
        [V,C,XY]=VoronoiLimit(centroids(:,1),centroids(:,2));

        %now, cycle through all rows of R, and draw a specific polygon for each set of vertices
        allPoly = [];
        for it = 1:size(C,1)
            indx = C{it};
            coords = V(indx,:);
            %     coords(end+1,:) = coords(1,:);
            %
            %     if(sum(isinf(coords))>1)
            %         continue
            %     end
            allPoly(:,:,it) = poly2mask(coords(:,1),coords(:,2),size(imgo,1),size(imgo,2));
        end


        %ok, now we need to work with a virtual environment
        virtual = zeros(size(img,1)*3, size(img,2)*3);
        virtual(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2) = img;

        %and we have to place all of our created polygons into this virtual environment too
        allPoly2 = [];
        for it = 1:size(allPoly,3)
            m = zeros(size(img,1)*3, size(img,2)*3);
            m(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2) = allPoly(:,:,it);
            allPoly2(:,:,it) = m;
        end
        % imagesc(virtual)




        %now, get the truncated polys
        allPoly3 = [];
        for it = 1:size(allPoly,3)
            trun = allPoly2(:,:,it) .* virtual;
            allPoly3(:,:,it) = trun;
        end



        % ROTATE IT !!!!!
        newcentroids = []; %remember, we have to convert the original centroids to the same scale as the virtual environment
        newcentroids(:,1) = centroids(:,1) + size(img,1);
        newcentroids(:,2) = centroids(:,2) + size(img,2);
        allPoly4 = [];
        for it = 1:size(allPoly3,3)

            pointX = newcentroids(it,1); %this is column
            pointY = newcentroids(it,2); %this is row
            dd = randi([-180 180]);
            rotated = rotateAround(allPoly3(:,:,it), pointY, pointX, dd);
            allPoly4(:,:,it) = rotated;
        end


        % assign new centers to each segment
        allPoly5 = [];
        newcentroids2 = [];
        padsize = 300;
        for it = 1:size(newcentroids,1)
            newrow = randi([size(img,1)+1, size(img,1)*2]);
            newcol = randi([size(img,2)+1, size(img,2)*2]);

            xdiff = round(newrow - newcentroids(it,1));
            ydiff = round(newcol - newcentroids(it,2));

            %lazy implementation b/c ... lazy
            poly_padded = padarray(allPoly4(:,:,it),[padsize padsize],0,'both');

            %original size of virtual map
            %poly_padded(padsize+1: end-300, padsize+1: end-300)

            %incorporate the shift in x and y
            shifted = poly_padded(padsize+1 - ydiff: end-300 - ydiff,      padsize+1 - xdiff: end-300 - xdiff); %FLIPPED. careful of how you index...
            allPoly5(:,:,it) = shifted;
        end


        %now, add all the segments
        %for overlapping bins, the new polygons value replace the old one (would need a zero mask for each new addition)
        %also store bins that escape the virtual arena
        %those truncated bins will be randomly assigned to resulting empty bins of the virtual arena
        %also gotta work with the unsmoothed rate map in this case...

        final_map = zeros(size(virtual,1), size(virtual,2));
        alltruncatedbins = [];
        for it = 1:size(allPoly5,3)

            currZeroMask = allPoly5(:,:,it)>0;
            currZeroMask = ~logical(currZeroMask);

            final_map = final_map .* currZeroMask; %gotta make any overlapping bins 0
            final_map = final_map + allPoly5(:,:,it);

            %determine which bins are truncated and store them
            trueEnv = zeros(size(virtual,1), size(virtual,2)) + 1;
            trueEnv(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 ) = 0;
            outsideEnv = final_map .* trueEnv;

            [row, column, dataValues] = find(outsideEnv ~= 0);

            if(isempty(row))
                continue;
            end

            q = row';
            p = column';
            idx=sub2ind(size(outsideEnv),q,p);
            out=outsideEnv(idx)';
            alltruncatedbins = [alltruncatedbins; out];

            %lastly, replace the truncated bins outside of the final map with 0
            lastfilter = zeros(size(virtual,1), size(virtual,2));
            lastfilter(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 ) = 1;
            final_map = final_map .* lastfilter;

        end

        finalfinalmap = final_map(size(img,1)+1: size(img,1)*2, size(img,2)+1:size(img,2)*2 );

        %fill in empty spots with truncated bins
        [row, column, dataValues] = find(finalfinalmap == 0);

        alltruncatedbins = alltruncatedbins(randperm(length(alltruncatedbins)));
        alltruncatedbins = alltruncatedbins';

        ml = length(alltruncatedbins);

        rc = [row,column];
        rc = rc(randperm(size(rc, 1)), :);

        idx = sub2ind(size(finalfinalmap),rc(1:ml,1),rc(1:ml,2)) ;
        finalfinalmap(idx) = alltruncatedbins ;

    %     j20amaps{iiii,1} = finalfinalmap;
        j20amaps{iiii,1} = imgaussfilt(finalfinalmap,1.25);
        j20amaps{iiii,2} = finalfinalmap;

        j20amaps{iiii,3} = size(C,1);
    end
    j20amaps{end+1,1} = rate_map2;
    j20amaps{end,2} = rate_map1;
    
    allj20amaps{celliter,1} = j20amaps;
    
end

%see how many voronoi segments per map
j20avoronoisegments = [];
for i = 1:size(allj20amaps,1)
    j20avoronoisegments = [j20avoronoisegments; allj20amaps{i, 1}{1, 3} ];
end

hist(j20avoronoisegments,10)

allj20apowers = {}; 

for celliter = 1:size(allj20amaps,1)
    disp(celliter)
    j20apowers = {}; 
    
    currentcell = allj20amaps{celliter,1};
    
    allpowersforcurrent = [];
    
    for ii = 1:size(currentcell,1)

        map = currentcell{ii,2};    

        fr = nanmean(nanmean(map)); %firing rate 
        M = 36; %original rate map sizes
        N = 36;
        mx = 256; %zero padded rate map sizes
        nx = 256;

        %zero padded rate map
        padsize = (mx-M)/2;
        rate_map1_padded = padarray(map,[padsize padsize],0,'both');
        coef = 1/(fr * sqrt(M*N)); 

        imgL = rate_map1_padded;
        j20apowers{ii,1} = imgL; 

        imgX  = coef * fftshift(fft2(imgL));

    %     powr3 = (abs(imgX));
        powr3 = (abs(imgX.^2));

        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;

        maxfpower = nanmax(nanmax(powr3)); %max fourier power... 
        j20apowers{ii,2} = powr3; 
        j20apowers{ii,3} = maxfpower; 
        j20apowers{ii,4} = fr; 
        
        if ii < size(allj20amaps,1)
            allpowersforcurrent = [allpowersforcurrent; reshape(powr3,[],1)];
        end
    end

%     allj20apowers{celliter,1} = j20apowers;
    allj20apowers{celliter,2} = prctile(cell2mat(j20apowers(1:end-1,3)),95);
    allj20apowers{celliter,3} = prctile(cell2mat(j20apowers(1:end-1,3)),75);
    allj20apowers{celliter,4} = max(max(j20apowers{end,2}));
    allj20apowers{celliter,5} = max(max(j20apowers{end,2})) >= prctile(cell2mat(j20apowers(1:end-1,3)),95);
    allj20apowers{celliter,6} = max(max(j20apowers{end,2})) >= prctile(cell2mat(j20apowers(1:end-1,3)),90);
    allj20apowers{celliter,7} = max(max(j20apowers{end,2})) >= prctile(cell2mat(j20apowers(1:end-1,3)),85);
    allj20apowers{celliter,8} = max(max(j20apowers{end,2})) >= prctile(cell2mat(j20apowers(1:end-1,3)),80);
    
    allj20apowers{celliter,9} = prctile(allpowersforcurrent,50); %50th percentile power of shuffled data 
    allj20apowers{celliter,10} = prctile(allpowersforcurrent,75); %75th percentile power of shuffled data 
    allj20apowers{celliter,11} = prctile(allpowersforcurrent,95); %95th percentile power of shuffled data 
    allj20apowers{celliter,12} = prctile(allpowersforcurrent,99); %99th percentile power of shuffled data 
end

%%

%% see all voronoi segments at once

wtyvoronoisegments = [];
for i = 1:size(allwtymaps,1)
    wtyvoronoisegments = [wtyvoronoisegments; allwtymaps{i, 1}{1, 3} ];
end
wtavoronoisegments = [];
for i = 1:size(allwtamaps,1)
    wtavoronoisegments = [wtavoronoisegments; allwtamaps{i, 1}{1, 3} ];
end
j20yvoronoisegments = [];
for i = 1:size(allj20ymaps,1)
    j20yvoronoisegments = [j20yvoronoisegments; allj20ymaps{i, 1}{1, 3} ];
end
j20avoronoisegments = [];
for i = 1:size(allj20amaps,1)
    j20avoronoisegments = [j20avoronoisegments; allj20amaps{i, 1}{1, 3} ];
end

subplot(1,4,1)
hist(wtyvoronoisegments,10)
axis square
xlim([40, 140])
title(round(nanmean(wtyvoronoisegments)))
subplot(1,4,2)
hist(wtavoronoisegments,10)
axis square
xlim([40, 140])
title(round(nanmean(wtavoronoisegments)))
subplot(1,4,3)
hist(j20yvoronoisegments,6)
axis square
xlim([40, 140])
title(round(nanmean(j20yvoronoisegments)))
subplot(1,4,4)
hist(j20avoronoisegments,6)
axis square
xlim([40, 140])
title(round(nanmean(j20avoronoisegments)))

%% 2. extract all Fourier components
% Code only commented in detail for nTG-y mice
% The workspace which you would obtain is provided: 'grid_data.mat'

wty_data = {};

for iii = 1:size(wty_dir)
    %%
    disp(iii)
    load(wty_dir{iii,3});
    cel = wty_dir{iii,4};
    
    [oc, xdim, ydim] = root.Occupancy();
    xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
    ydim2 = linspace(ydim(1), ydim(end), 36);
    
    %create smoothed and unsmoothed rate maps
    [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
    [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
    
    wty_data{iii,1} = rate_map1; %%%%%%%%%%%
    wty_data{iii,2} = rate_map2; %%%%%%%%%%%
    
    import CMBHOME.Utils.*
    
    fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
    M = 36; %original rate map sizes
    N = 36;
    mx = 256; %zero padded rate map sizes
    nx = 256;
    %zero padded rate map
    padsize = (mx-M)/2;
    rate_map1_padded = padarray(rate_map1,[padsize padsize],0,'both');
    
    coef = 1/(fr * sqrt(M*N));
    clear i
    
    %%
    imgL = rate_map1_padded;

    % and its power spectrum
    imgX  = coef * fftshift(fft2(imgL));
    % imgX(121:136,121:136) = 0;
    % powr2 = (abs(imgX));
    
    % powr3 = imgX;
    % for nn = 1:nx
    %     for mm = 1:mx
    %         powr3(mm,nn) = sqrt((real(imgX(mm,nn))^2) + (imag(imgX(mm,nn))^2));
    %     end
    % end
    % maxfpower = nanmax(nanmax(powr3)); %max fourier power...
    
    % powr3 = (abs(imgX));
    
    powr3 = abs(imgX.^2);
    
    
    width  = 1;   % width of gaussian
    [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
    [row, col] = find(ismember(powr3, max(powr3(:))));
    gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
    f = gaus2d == 1;
    gaus2d = gaus2d .* f;
    powr3 = powr3 .* gaus2d;
    
    wty_data{iii,3} = powr3; %%%%%%%%%%%%%
    
    
    
    
    % retrieve the top 75th percentile from the original shuffled voronoi maps
%     prc50 = allwtypowers{iii,9}; %50th percentile
    prc50 = allwtypowers{iii,10}; %75th percentile
    
    powr3 = powr3 - prc50;
    f = powr3 > 0;
    powr3 = powr3 .* f;
    maxfpower = nanmax(nanmax(powr3)); %max fourier power...
%     threshold = 0.10*maxfpower;
    threshold = 0.25*maxfpower;
    
    f = powr3 > threshold;
    powr3 = powr3 .* f; %all values that don't pass threshold get set to 0
    
    wty_data{iii,4} = powr3; %store filtered power spectrum
    
    %create a patch map to identify each components.  
    patch = zeros(size(powr3,1),size(powr3,2));
    for i = 1:size(powr3,1)
        for j = 1:size(powr3,1)
            if(powr3(i,j) > 0)
                patch(i,j) = 1;
            end
        end
    end
    
    labeled = bwlabel(patch == 1);
    measurements = regionprops(labeled, patch, 'area', 'PixelValues', 'Centroid', 'BoundingBox');

    %all components with an area smaller than 10 pixels get thrown out
    f = [];
    for ii = 1:size(measurements,1)
        if measurements(ii).Area < 10
            f = [f;ii];
        end
    end
    measurements(f) = [];
    numcomp = round(size(measurements,1)/2); % the number of components
    
    wty_data{iii,5} = numcomp; %store number of components 
    
    %distance of each component to the center of the Fourier spectrum 
    disttocenter = [];
    for i = 1:size(measurements,1)
        c = measurements(i).Centroid;
        center = [128.5,128.5];
        dx = (center(1,1) - c(1,1));
        dy = (center(1,2) - c(1,2));
        
        disttocenter = [disttocenter; [-dx,dy]]; %arbitrary signs just to visualize easier
    end
    clear i
    % b = 2.08; %in cm. binsize
    b = 0.0208; %in m. binsize
    
    wty_data{iii,6} = disttocenter; %store distances
    
    %calculate wavelengths (method used in Krupic et al.2012 see Star Methods)
    clear i
    kyx = [];
    for ii = 1:size(disttocenter,1)
        dy = disttocenter(ii,2);
        dx = disttocenter(ii,1);
        
        ky = 2*pi*dy / (M*b);
        kx = 2*pi*dx / (N*b);
        
        kyx = [kyx; [kx,ky]];
    end
    
    wty_data{iii,7} = kyx;
    
    waveformyx = [];
    for ii = 1:size(kyx,1)
        wy = 2*pi/kyx(ii,2);
        wx = 2*pi/kyx(ii,1);
        
        overall = sqrt(wy^2 + wx^2);
        %     orientation = atan(kyx(ii,2)/kyx(ii,1));
        
        %     orientation = rad2deg(orientation);
        %     if(orientation<0)
        %         orientation = 360 + orientation;
        %     end
        x1 = 0;
        y1 = 0;
        x2 = 1000;
        y2 = 0;
        x3 = wx;
        y3 = wy;
        
        v_1 = [x2,y2,0] - [x1,y1,0]; %a reference vector
        v_2 = [x3,y3,0] - [x1,y1,0]; %vector of interest 
        %        orientation = atan2(norm(cross(v_1, v_2)), dot(v_1, v_2));
        orientation = acos(dot(v_1 / norm(v_1), v_2 / norm(v_2)));
        
        %depending on which quadrant v_2 is in, the orientation will change
        if x3 > 0 & y3 > 0 %if signs seem weird, draw it out on a circle with 4 quadrants
            orientation = orientation;
        end
        if x3 < 0 & y3 > 0
            orientation = orientation;
        end
        if x3 < 0 & y3 < 0
            orientation = 2*pi - orientation;
        end
        if x3 > 0 & y3 < 0
            orientation = 2*pi - orientation;
        end
        
        waveformyx = [waveformyx; [wx,wy,overall,orientation]];
        
    end
    
    wty_data{iii,8} = waveformyx; %store wavelength info [x distance, y distance, theta(magnitude), rho(angle)]
    
    %sorted wavelengths in ascending order by rho
    waveformyx = sortrows(waveformyx,4,'ascend');
    waveformyx(end+1,:) = waveformyx(1,:);
    waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
    
    wty_data{iii,9} = waveformyx;
   
    %just adding 0s between rows to make it suitable for polar plots 
    thetarho = [];
    for ii = 1:size(waveformyx,1)-1
        thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
        btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
        thetarho = [thetarho;[btwn, 0]];
    end
    thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
    
    wty_data{iii,10} = thetarho; %store value
    
    %another version of thetarho with linearly interpolated values between real values and 0s 
    %only purpose is to make polar plots nicer
    thetarho2 = [];
    for ii = 1:size(thetarho,1)-1
        thetarho2 = [thetarho2;[thetarho(ii,1), thetarho(ii,2)]];
        
        interptheta = linspace(thetarho(ii,1), thetarho(ii+1,1), 30)';
        interprho = linspace(thetarho(ii,2), thetarho(ii+1,2), 30)';
        
        btwn = [interptheta,interprho];
        
        thetarho2 = [thetarho2;btwn];
    end
    
    wty_data{iii,11} = thetarho2;
    
    %%finally, write code to extract individual components
    
    wty_data{iii,12} = imgX;
    
    centroids = [];
    for ii = 1:size(measurements,1)
        centroids = [centroids; measurements(ii).Centroid];
    end
    
    gaussians = [];
    for ii = 1:size(centroids,1)
        gaussians(:,:,ii) = exp(-((x-centroids(ii,2)).^2 + (y-centroids(ii,1)).^2) ./ (2*width^2)); %careful with x and y. centroid(ii,2} is actually the column coordinate
    end
    
    wty_data{iii,13} = centroids;
    wty_data{iii,14} = gaussians;

    wty_data{iii,15} = nanmean(gaussians,3);
    wty_data{iii,16} = abs((imgX.*nanmean(gaussians,3)).^2);
    
    %all individual components re-visualized as images of spatially periodic bands
    %using the inverse Fourier transform function
    allcomponents = {};
    
    for ii = 1:size(centroids,1)
        imgrecon = real(ifft2( imgX.*gaussians(:,:,ii) ));
        imgrecon2 = real(ifft2(fftshift( imgX.*gaussians(:,:,ii) )));
        
        allcomponents{1,ii} = imgrecon;
        allcomponents{2,ii} = imgrecon2;
        
    end
    
    %% COMMENT THIS OUT IF YOU WANT TO SAVE RAM AND DONT NEED THIS
    wty_data{iii,17} = allcomponents; %stores all individual components re-visualized as images of spatially periodic bands 
    
end

%% nTG-a

wta_data = {};

for iii = 1:size(wta_dir)
    %%
    disp(iii)
    load(wta_dir{iii,3});
    cel = wta_dir{iii,4};
    
    [oc, xdim, ydim] = root.Occupancy();
    xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
    ydim2 = linspace(ydim(1), ydim(end), 36);
    
    [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
    [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
    
    wta_data{iii,1} = rate_map1; %%%%%%%%%%%
    wta_data{iii,2} = rate_map2; %%%%%%%%%%%
    
    import CMBHOME.Utils.*
    
    fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
    M = 36; %original rate map sizes
    N = 36;
    mx = 256; %zero padded rate map sizes
    nx = 256;
    %zero padded rate map
    padsize = (mx-M)/2;
    rate_map1_padded = padarray(rate_map1,[padsize padsize],0,'both');
    
    coef = 1/(fr * sqrt(M*N));
    clear i
    
    %%
    imgL = rate_map1_padded;

    % and its power spectrum
    imgX  = coef * fftshift(fft2(imgL));
    % imgX(121:136,121:136) = 0;
    % powr2 = (abs(imgX));
    
    % powr3 = imgX;
    % for nn = 1:nx
    %     for mm = 1:mx
    %         powr3(mm,nn) = sqrt((real(imgX(mm,nn))^2) + (imag(imgX(mm,nn))^2));
    %     end
    % end
    % maxfpower = nanmax(nanmax(powr3)); %max fourier power...
    
    % powr3 = (abs(imgX));
    
    powr3 = abs(imgX.^2);
    
    
    width  = 1;   % width of gaussian
    [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
    [row, col] = find(ismember(powr3, max(powr3(:))));
    gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
    f = gaus2d == 1;
    gaus2d = gaus2d .* f;
    powr3 = powr3 .* gaus2d;
    
    wta_data{iii,3} = powr3; %%%%%%%%%%%%%
    
    
    
    
    % retrieve the top 50 percentile from the original shuffled voronoi maps
%     prc50 = allwtapowers{iii,9};
    prc50 = allwtapowers{iii,10};
    
    powr3 = powr3 - prc50;
    f = powr3 > 0;
    powr3 = powr3 .* f;
    maxfpower = nanmax(nanmax(powr3)); %max fourier power...
%     threshold = 0.10*maxfpower;
    threshold = 0.25*maxfpower;
    
    f = powr3 > threshold;
    powr3 = powr3 .* f;
    
    wta_data{iii,4} = powr3;    %%%%%%%%%%%%%%%%%
    
    patch = zeros(size(powr3,1),size(powr3,2));
    for i = 1:size(powr3,1)
        for j = 1:size(powr3,1)
            if(powr3(i,j) > 0)
                patch(i,j) = 1;
            end
        end
    end
    
    labeled = bwlabel(patch == 1);
    measurements = regionprops(labeled, patch, 'area', 'PixelValues', 'Centroid', 'BoundingBox');

    f = [];
    for ii = 1:size(measurements,1)
        if measurements(ii).Area < 10
            f = [f;ii];
        end
    end
    measurements(f) = [];
    numcomp = round(size(measurements,1)/2);
    
    wta_data{iii,5} = numcomp; %%%%%%%%%%%%%%%%%%%%%%%
    
    disttocenter = [];
    for i = 1:size(measurements,1)
        c = measurements(i).Centroid;
        center = [128.5,128.5];
        dx = (center(1,1) - c(1,1));
        dy = (center(1,2) - c(1,2));
        
        disttocenter = [disttocenter; [-dx,dy]]; %arbitrary signs just to visualize easier
    end
    clear i
    % b = 2.08; %in cm. binsize
    b = 0.0208; %in m. binsize
    
    wta_data{iii,6} = disttocenter;
    
    clear i
    kyx = [];
    for ii = 1:size(disttocenter,1)
        dy = disttocenter(ii,2);
        dx = disttocenter(ii,1);
        
        ky = 2*pi*dy / (M*b);
        kx = 2*pi*dx / (N*b);
        
        kyx = [kyx; [kx,ky]];
    end
    
    wta_data{iii,7} = kyx;
    
    waveformyx = [];
    for ii = 1:size(kyx,1)
        wy = 2*pi/kyx(ii,2);
        wx = 2*pi/kyx(ii,1);
        
        overall = sqrt(wy^2 + wx^2);
        %     orientation = atan(kyx(ii,2)/kyx(ii,1));
        
        %     orientation = rad2deg(orientation);
        %     if(orientation<0)
        %         orientation = 360 + orientation;
        %     end
        x1 = 0;
        y1 = 0;
        x2 = 1000;
        y2 = 0;
        x3 = wx;
        y3 = wy;
        
        v_1 = [x2,y2,0] - [x1,y1,0];
        v_2 = [x3,y3,0] - [x1,y1,0];
        %        orientation = atan2(norm(cross(v_1, v_2)), dot(v_1, v_2));
        orientation = acos(dot(v_1 / norm(v_1), v_2 / norm(v_2)));
        if x3 > 0 & y3 > 0 %the signs are kind of weird.. but draw it out
            orientation = orientation;
        end
        if x3 < 0 & y3 > 0
            orientation = orientation;
        end
        if x3 < 0 & y3 < 0
            orientation = 2*pi - orientation;
        end
        if x3 > 0 & y3 < 0
            orientation = 2*pi - orientation;
        end
        
        waveformyx = [waveformyx; [wx,wy,overall,orientation]];
        
    end
    
    wta_data{iii,8} = waveformyx;
    
    
    waveformyx = sortrows(waveformyx,4,'ascend');
    waveformyx(end+1,:) = waveformyx(1,:);
    waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
    
    wta_data{iii,9} = waveformyx;
    
    thetarho = [];
    for ii = 1:size(waveformyx,1)-1
        thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
        btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
        thetarho = [thetarho;[btwn, 0]];
    end
    thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
    
    wta_data{iii,10} = thetarho;
    
    thetarho2 = [];
    for ii = 1:size(thetarho,1)-1
        thetarho2 = [thetarho2;[thetarho(ii,1), thetarho(ii,2)]];
        
        interptheta = linspace(thetarho(ii,1), thetarho(ii+1,1), 30)';
        interprho = linspace(thetarho(ii,2), thetarho(ii+1,2), 30)';
        
        btwn = [interptheta,interprho];
        
        thetarho2 = [thetarho2;btwn];
    end
    
    wta_data{iii,11} = thetarho2;
    
    %%finally, write code to extract individual components
    
    wta_data{iii,12} = imgX;
    
    centroids = [];
    for ii = 1:size(measurements,1)
        centroids = [centroids; measurements(ii).Centroid];
    end
    
    gaussians = [];
    for ii = 1:size(centroids,1)
        gaussians(:,:,ii) = exp(-((x-centroids(ii,2)).^2 + (y-centroids(ii,1)).^2) ./ (2*width^2)); %careful with x and y. centroid(ii,2} is actually the column coordinate
    end
    
    wta_data{iii,13} = centroids;
    wta_data{iii,14} = gaussians;

    wta_data{iii,15} = nanmean(gaussians,3);
    wta_data{iii,16} = abs((imgX.*nanmean(gaussians,3)).^2);
    
    allcomponents = {};
    
    for ii = 1:size(centroids,1)
        imgrecon = real(ifft2( imgX.*gaussians(:,:,ii) ));
        imgrecon2 = real(ifft2(fftshift( imgX.*gaussians(:,:,ii) )));
        
        allcomponents{1,ii} = imgrecon;
        allcomponents{2,ii} = imgrecon2;
        
    end
    
    wta_data{iii,17} = allcomponents;
    
end

%% APP-y


j20y_data = {};

for iii = 1:size(j20y_dir)
    %%
    disp(iii)
    load(j20y_dir{iii,3});
    cel = j20y_dir{iii,4};
    
    [oc, xdim, ydim] = root.Occupancy();
    xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
    ydim2 = linspace(ydim(1), ydim(end), 36);
    
    [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
    [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
    
    j20y_data{iii,1} = rate_map1; %%%%%%%%%%%
    j20y_data{iii,2} = rate_map2; %%%%%%%%%%%
    
    import CMBHOME.Utils.*
    
    fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
    M = 36; %original rate map sizes
    N = 36;
    mx = 256; %zero padded rate map sizes
    nx = 256;
    %zero padded rate map
    padsize = (mx-M)/2;
    rate_map1_padded = padarray(rate_map1,[padsize padsize],0,'both');
    
    coef = 1/(fr * sqrt(M*N));
    clear i
    
    %%
    imgL = rate_map1_padded;

    % and its power spectrum
    imgX  = coef * fftshift(fft2(imgL));
    % imgX(121:136,121:136) = 0;
    % powr2 = (abs(imgX));
    
    % powr3 = imgX;
    % for nn = 1:nx
    %     for mm = 1:mx
    %         powr3(mm,nn) = sqrt((real(imgX(mm,nn))^2) + (imag(imgX(mm,nn))^2));
    %     end
    % end
    % maxfpower = nanmax(nanmax(powr3)); %max fourier power...
    
    % powr3 = (abs(imgX));
    
    powr3 = abs(imgX.^2);
    
    
    width  = 1;   % width of gaussian
    [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
    [row, col] = find(ismember(powr3, max(powr3(:))));
    gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
    f = gaus2d == 1;
    gaus2d = gaus2d .* f;
    powr3 = powr3 .* gaus2d;
    
    j20y_data{iii,3} = powr3; %%%%%%%%%%%%%
    
    
    
    
    % retrieve the top 50 percentile from the original shuffled voronoi maps
%     prc50 = allj20ypowers{iii,9};
    prc50 = allj20ypowers{iii,10};
    
    powr3 = powr3 - prc50;
    f = powr3 > 0;
    powr3 = powr3 .* f;
    maxfpower = nanmax(nanmax(powr3)); %max fourier power...
%     threshold = 0.10*maxfpower;
    threshold = 0.25*maxfpower;
    
    f = powr3 > threshold;
    powr3 = powr3 .* f;
    
    j20y_data{iii,4} = powr3;    %%%%%%%%%%%%%%%%%
    
    patch = zeros(size(powr3,1),size(powr3,2));
    for i = 1:size(powr3,1)
        for j = 1:size(powr3,1)
            if(powr3(i,j) > 0)
                patch(i,j) = 1;
            end
        end
    end
    
    labeled = bwlabel(patch == 1);
    measurements = regionprops(labeled, patch, 'area', 'PixelValues', 'Centroid', 'BoundingBox');

    f = [];
    for ii = 1:size(measurements,1)
        if measurements(ii).Area < 10
            f = [f;ii];
        end
    end
    measurements(f) = [];
    numcomp = round(size(measurements,1)/2);
    
    j20y_data{iii,5} = numcomp; %%%%%%%%%%%%%%%%%%%%%%%
    
    disttocenter = [];
    for i = 1:size(measurements,1)
        c = measurements(i).Centroid;
        center = [128.5,128.5];
        dx = (center(1,1) - c(1,1));
        dy = (center(1,2) - c(1,2));
        
        disttocenter = [disttocenter; [-dx,dy]]; %arbitrary signs just to visualize easier
    end
    clear i
    % b = 2.08; %in cm. binsize
    b = 0.0208; %in m. binsize
    
    j20y_data{iii,6} = disttocenter;
    
    clear i
    kyx = [];
    for ii = 1:size(disttocenter,1)
        dy = disttocenter(ii,2);
        dx = disttocenter(ii,1);
        
        ky = 2*pi*dy / (M*b);
        kx = 2*pi*dx / (N*b);
        
        kyx = [kyx; [kx,ky]];
    end
    
    j20y_data{iii,7} = kyx;
    
    waveformyx = [];
    for ii = 1:size(kyx,1)
        wy = 2*pi/kyx(ii,2);
        wx = 2*pi/kyx(ii,1);
        
        overall = sqrt(wy^2 + wx^2);
        %     orientation = atan(kyx(ii,2)/kyx(ii,1));
        
        %     orientation = rad2deg(orientation);
        %     if(orientation<0)
        %         orientation = 360 + orientation;
        %     end
        x1 = 0;
        y1 = 0;
        x2 = 1000;
        y2 = 0;
        x3 = wx;
        y3 = wy;
        
        v_1 = [x2,y2,0] - [x1,y1,0];
        v_2 = [x3,y3,0] - [x1,y1,0];
        %        orientation = atan2(norm(cross(v_1, v_2)), dot(v_1, v_2));
        orientation = acos(dot(v_1 / norm(v_1), v_2 / norm(v_2)));
        if x3 > 0 & y3 > 0 %the signs are kind of weird.. but draw it out
            orientation = orientation;
        end
        if x3 < 0 & y3 > 0
            orientation = orientation;
        end
        if x3 < 0 & y3 < 0
            orientation = 2*pi - orientation;
        end
        if x3 > 0 & y3 < 0
            orientation = 2*pi - orientation;
        end
        
        waveformyx = [waveformyx; [wx,wy,overall,orientation]];
        
    end
    
    j20y_data{iii,8} = waveformyx;
    
    
    waveformyx = sortrows(waveformyx,4,'ascend');
    waveformyx(end+1,:) = waveformyx(1,:);
    waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
    
    j20y_data{iii,9} = waveformyx;
    
    thetarho = [];
    for ii = 1:size(waveformyx,1)-1
        thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
        btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
        thetarho = [thetarho;[btwn, 0]];
    end
    thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
    
    j20y_data{iii,10} = thetarho;
    
    thetarho2 = [];
    for ii = 1:size(thetarho,1)-1
        thetarho2 = [thetarho2;[thetarho(ii,1), thetarho(ii,2)]];
        
        interptheta = linspace(thetarho(ii,1), thetarho(ii+1,1), 30)';
        interprho = linspace(thetarho(ii,2), thetarho(ii+1,2), 30)';
        
        btwn = [interptheta,interprho];
        
        thetarho2 = [thetarho2;btwn];
    end
    
    j20y_data{iii,11} = thetarho2;
    
    %%finally, write code to extract individual components
    
    j20y_data{iii,12} = imgX;
    
    centroids = [];
    for ii = 1:size(measurements,1)
        centroids = [centroids; measurements(ii).Centroid];
    end
    
    gaussians = [];
    for ii = 1:size(centroids,1)
        gaussians(:,:,ii) = exp(-((x-centroids(ii,2)).^2 + (y-centroids(ii,1)).^2) ./ (2*width^2)); %careful with x and y. centroid(ii,2} is actually the column coordinate
    end
    
    j20y_data{iii,13} = centroids;
    j20y_data{iii,14} = gaussians;

    j20y_data{iii,15} = nanmean(gaussians,3);
    j20y_data{iii,16} = abs((imgX.*nanmean(gaussians,3)).^2);
    
    allcomponents = {};
    
    for ii = 1:size(centroids,1)
        imgrecon = real(ifft2( imgX.*gaussians(:,:,ii) ));
        imgrecon2 = real(ifft2(fftshift( imgX.*gaussians(:,:,ii) )));
        
        allcomponents{1,ii} = imgrecon;
        allcomponents{2,ii} = imgrecon2;
        
    end
    
    j20y_data{iii,17} = allcomponents;
    
end

%% APP-a

j20a_data = {};

for iii = 1:size(j20a_dir)
    %%
    disp(iii)
    load(j20a_dir{iii,3});
    cel = j20a_dir{iii,4};
    
    [oc, xdim, ydim] = root.Occupancy();
    xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
    ydim2 = linspace(ydim(1), ydim(end), 36);
    
    [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
    [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
    
    j20a_data{iii,1} = rate_map1; %%%%%%%%%%%
    j20a_data{iii,2} = rate_map2; %%%%%%%%%%%
    
    import CMBHOME.Utils.*
    
    fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
    M = 36; %original rate map sizes
    N = 36;
    mx = 256; %zero padded rate map sizes
    nx = 256;
    %zero padded rate map
    padsize = (mx-M)/2;
    rate_map1_padded = padarray(rate_map1,[padsize padsize],0,'both');
    
    coef = 1/(fr * sqrt(M*N));
    clear i
    
    %%
    imgL = rate_map1_padded;

    % and its power spectrum
    imgX  = coef * fftshift(fft2(imgL));
    % imgX(121:136,121:136) = 0;
    % powr2 = (abs(imgX));
    
    % powr3 = imgX;
    % for nn = 1:nx
    %     for mm = 1:mx
    %         powr3(mm,nn) = sqrt((real(imgX(mm,nn))^2) + (imag(imgX(mm,nn))^2));
    %     end
    % end
    % maxfpower = nanmax(nanmax(powr3)); %max fourier power...
    
    % powr3 = (abs(imgX));
    
    powr3 = abs(imgX.^2);
    
    
    width  = 1;   % width of gaussian
    [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
    [row, col] = find(ismember(powr3, max(powr3(:))));
    gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
    f = gaus2d == 1;
    gaus2d = gaus2d .* f;
    powr3 = powr3 .* gaus2d;
    
    j20a_data{iii,3} = powr3; %%%%%%%%%%%%%
    
    
    
    
    % retrieve the top 50 percentile from the original shuffled voronoi maps
%     prc50 = allj20apowers{iii,9};
    prc50 = allj20apowers{iii,10};
    
    powr3 = powr3 - prc50;
    f = powr3 > 0;
    powr3 = powr3 .* f;
    maxfpower = nanmax(nanmax(powr3)); %max fourier power...
%     threshold = 0.10*maxfpower;
    threshold = 0.25*maxfpower;
    
    f = powr3 > threshold;
    powr3 = powr3 .* f;
    
    j20a_data{iii,4} = powr3;    %%%%%%%%%%%%%%%%%
    
    patch = zeros(size(powr3,1),size(powr3,2));
    for i = 1:size(powr3,1)
        for j = 1:size(powr3,1)
            if(powr3(i,j) > 0)
                patch(i,j) = 1;
            end
        end
    end
    
    labeled = bwlabel(patch == 1);
    measurements = regionprops(labeled, patch, 'area', 'PixelValues', 'Centroid', 'BoundingBox');

    f = [];
    for ii = 1:size(measurements,1)
        if measurements(ii).Area < 10
            f = [f;ii];
        end
    end
    measurements(f) = [];
    numcomp = round(size(measurements,1)/2);
    
    j20a_data{iii,5} = numcomp; %%%%%%%%%%%%%%%%%%%%%%%
    
    disttocenter = [];
    for i = 1:size(measurements,1)
        c = measurements(i).Centroid;
        center = [128.5,128.5];
        dx = (center(1,1) - c(1,1));
        dy = (center(1,2) - c(1,2));
        
        disttocenter = [disttocenter; [-dx,dy]]; %arbitrary signs just to visualize easier
    end
    clear i
    % b = 2.08; %in cm. binsize
    b = 0.0208; %in m. binsize
    
    j20a_data{iii,6} = disttocenter;
    
    clear i
    kyx = [];
    for ii = 1:size(disttocenter,1)
        dy = disttocenter(ii,2);
        dx = disttocenter(ii,1);
        
        ky = 2*pi*dy / (M*b);
        kx = 2*pi*dx / (N*b);
        
        kyx = [kyx; [kx,ky]];
    end
    
    j20a_data{iii,7} = kyx;
    
    waveformyx = [];
    for ii = 1:size(kyx,1)
        wy = 2*pi/kyx(ii,2);
        wx = 2*pi/kyx(ii,1);
        
        overall = sqrt(wy^2 + wx^2);
        %     orientation = atan(kyx(ii,2)/kyx(ii,1));
        
        %     orientation = rad2deg(orientation);
        %     if(orientation<0)
        %         orientation = 360 + orientation;
        %     end
        x1 = 0;
        y1 = 0;
        x2 = 1000;
        y2 = 0;
        x3 = wx;
        y3 = wy;
        
        v_1 = [x2,y2,0] - [x1,y1,0];
        v_2 = [x3,y3,0] - [x1,y1,0];
        %        orientation = atan2(norm(cross(v_1, v_2)), dot(v_1, v_2));
        orientation = acos(dot(v_1 / norm(v_1), v_2 / norm(v_2)));
        if x3 > 0 & y3 > 0 %the signs are kind of weird.. but draw it out
            orientation = orientation;
        end
        if x3 < 0 & y3 > 0
            orientation = orientation;
        end
        if x3 < 0 & y3 < 0
            orientation = 2*pi - orientation;
        end
        if x3 > 0 & y3 < 0
            orientation = 2*pi - orientation;
        end
        
        waveformyx = [waveformyx; [wx,wy,overall,orientation]];
        
    end
    
    j20a_data{iii,8} = waveformyx;
    
    
    waveformyx = sortrows(waveformyx,4,'ascend');
    waveformyx(end+1,:) = waveformyx(1,:);
    waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
    
    j20a_data{iii,9} = waveformyx;
    
    thetarho = [];
    for ii = 1:size(waveformyx,1)-1
        thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
        btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
        thetarho = [thetarho;[btwn, 0]];
    end
    thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
    
    j20a_data{iii,10} = thetarho;
    
    thetarho2 = [];
    for ii = 1:size(thetarho,1)-1
        thetarho2 = [thetarho2;[thetarho(ii,1), thetarho(ii,2)]];
        
        interptheta = linspace(thetarho(ii,1), thetarho(ii+1,1), 30)';
        interprho = linspace(thetarho(ii,2), thetarho(ii+1,2), 30)';
        
        btwn = [interptheta,interprho];
        
        thetarho2 = [thetarho2;btwn];
    end
    
    j20a_data{iii,11} = thetarho2;
    
    %%finally, write code to extract individual components
    
    j20a_data{iii,12} = imgX;
    
    centroids = [];
    for ii = 1:size(measurements,1)
        centroids = [centroids; measurements(ii).Centroid];
    end
    
    gaussians = [];
    for ii = 1:size(centroids,1)
        gaussians(:,:,ii) = exp(-((x-centroids(ii,2)).^2 + (y-centroids(ii,1)).^2) ./ (2*width^2)); %careful with x and y. centroid(ii,2} is actually the column coordinate
    end
    
    j20a_data{iii,13} = centroids;
    j20a_data{iii,14} = gaussians;

    j20a_data{iii,15} = nanmean(gaussians,3);
    j20a_data{iii,16} = abs((imgX.*nanmean(gaussians,3)).^2);
    
    allcomponents = {};
    
    for ii = 1:size(centroids,1)
        imgrecon = real(ifft2( imgX.*gaussians(:,:,ii) ));
        imgrecon2 = real(ifft2(fftshift( imgX.*gaussians(:,:,ii) )));
        
        allcomponents{1,ii} = imgrecon;
        allcomponents{2,ii} = imgrecon2;
        
    end
    
    j20a_data{iii,17} = allcomponents;
    
end

%%

%the 'grid_data.mat' file will contain all the extracted Fourier
%information that you will obtain from running this script. Use
%'grid_data.mat' for plotting figures



