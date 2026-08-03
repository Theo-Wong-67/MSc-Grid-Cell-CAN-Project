
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

%% Let's get all the basic information for these cells first

load('allcells_col20isgridness.mat')

% 5 is mean firing
% 6 is peak firing
% 7 is spt info
% 8 is mrl
% 9 is gridness 3

for i = 1:size(wty_dir,1)
    for j = 1:size(All_DataArray,1)
        if strcmp (wty_dir{i,3}, All_DataArray{j,4}(end-18:end))
            if wty_dir{i,4}(1,1) == All_DataArray{j,5}
                if wty_dir{i,4}(1,2) == All_DataArray{j,6}
                    wty_dir{i,5} = All_DataArray{j, 8};
                    wty_dir{i,6} = All_DataArray{j, 9};
                    wty_dir{i,7} = All_DataArray{j, 10};
                    wty_dir{i,8} = All_DataArray{j, 12};
                    wty_dir{i,9} = All_DataArray{j, 20};
                    break;
                end
            end
        end
    end
end
 
for i = 1:size(wta_dir,1)
    for j = 1:size(All_DataArray,1)
        if strcmp (wta_dir{i,3}, All_DataArray{j,4}(end-18:end))
            if wta_dir{i,4}(1,1) == All_DataArray{j,5}
                if wta_dir{i,4}(1,2) == All_DataArray{j,6}
                    wta_dir{i,5} = All_DataArray{j, 8};
                    wta_dir{i,6} = All_DataArray{j, 9};
                    wta_dir{i,7} = All_DataArray{j, 10};
                    wta_dir{i,8} = All_DataArray{j, 12};
                    wta_dir{i,9} = All_DataArray{j, 20};
                    break;
                end
            end
        end
    end
end

for i = 1:size(j20y_dir,1)
    for j = 1:size(All_DataArray,1)
        if strcmp (j20y_dir{i,3}, All_DataArray{j,4}(end-18:end))
            if j20y_dir{i,4}(1,1) == All_DataArray{j,5}
                if j20y_dir{i,4}(1,2) == All_DataArray{j,6}
                    j20y_dir{i,5} = All_DataArray{j, 8};
                    j20y_dir{i,6} = All_DataArray{j, 9};
                    j20y_dir{i,7} = All_DataArray{j, 10};
                    j20y_dir{i,8} = All_DataArray{j, 12};
                    j20y_dir{i,9} = All_DataArray{j, 20};
                    break;
                end
            end
        end
    end
end

for i = 1:size(j20a_dir,1)
    for j = 1:size(All_DataArray,1)
        if strcmp (j20a_dir{i,3}, All_DataArray{j,4}(end-18:end))
            if j20a_dir{i,4}(1,1) == All_DataArray{j,5}
                if j20a_dir{i,4}(1,2) == All_DataArray{j,6}
                    j20a_dir{i,5} = All_DataArray{j, 8};
                    j20a_dir{i,6} = All_DataArray{j, 9};
                    j20a_dir{i,7} = All_DataArray{j, 10};
                    j20a_dir{i,8} = All_DataArray{j, 12};
                    j20a_dir{i,9} = All_DataArray{j, 20};
                    break;
                end
            end
        end
    end
end
    


%% extract some Fourier component information
% similar idea to Figure 2
% only nTG-y loop is properly commented. b/c all other mouse groups use
% exact same code
%
% and the results that you would obtain from running all this is in 'grid_polars.mat'

wty_data = {};

for iii = 1:size(wty_dir,1)
    
    try
    
        %standard code, load cell, create rate map
        disp(iii)
        clear root
        load(wty_dir{iii,3});
        cel = wty_dir{iii,4};
        
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
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
        powr3 = abs(imgX.^2);
        
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
        
        wty_data{iii,3} = powr3; %%%%%%%%%%%%%
        
        %shuffle cell 50 times and find 95th percentile power
        %
        %note, you could also use the shuffled powers from voronoi
        %segmentation in Figure 1, and it would yield same results
        %this is just a faster and simpler implementation
        %
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
            
            M = 36; %original rate map sizes
            N = 36;
            mx = 256; %zero padded rate map sizes
            nx = 256;
            %zero padded rate map
            padsize = (mx-M)/2;
            rate_map_shuf_padded = padarray(rate_map_shuf,[padsize padsize],0,'both');
            
            imgLL = rate_map_shuf_padded;
            
            % and its power spectrum
            imgXX  = coef * fftshift(fft2(imgLL));
            powr22 = (abs(imgXX));
            powr33 = abs(imgXX.^2);
            
            width  = 1;   % width of gaussian
            [x,y]  = ndgrid(1:size(imgLL,1),1:size(imgLL,2));
            [row, col] = find(ismember(powr33, max(powr33(:))));
            gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
            f = gaus2d == 1;
            gaus2d = gaus2d .* f;
            powr33 = powr33 .* gaus2d;
            
            allpowers = [allpowers; reshape(powr33,[],1)];
        end
        prc50 = prctile(allpowers,95); %can adjust this percentile value 
        
        %values lower than 95th percentile will be removed 
        %can also use 75th percentile 
        powr3 = powr3 - prc50;
        f = powr3 > 0;
        powr3 = powr3 .* f;
        maxfpower = nanmax(nanmax(powr3)); 
        threshold = 0.25*maxfpower;
        
        %second round of filtering. values lower than  25% of max value are
        %set to 0
        f = powr3 > threshold;
        powr3 = powr3 .* f;
        
        %create patch map
        patch = zeros(size(powr3,1),size(powr3,2));
        for i = 1:size(powr3,1)
            for j = 1:size(powr3,1)
                if(powr3(i,j) > 0)
                    patch(i,j) = 1;
                end
            end
        end
        
        %identify Fourier components 
        labeled = bwlabel(patch == 1);
        measurements = regionprops(labeled, patch, 'area', 'PixelValues', 'Centroid', 'BoundingBox');
        
        %components with area less than 10 pixels are not considered
        f = [];
        for ii = 1:size(measurements,1)
            if measurements(ii).Area < 10
                f = [f;ii];
            end
        end
        measurements(f) = [];
        numcomp = round(size(measurements,1)/2);
        
        %same code as in Figure 2 to compute polar plots
        disttocenter = [];
        for i = 1:size(measurements,1)
            c = measurements(i).Centroid;
            center = [128.5,128.5];
            dx = (center(1,1) - c(1,1));
            dy = (center(1,2) - c(1,2));
            
            poo = powr3(round(c(1,2)), round(c(1,1)));
            
            disttocenter = [disttocenter; [-dx,dy, poo]]; %arbitrary signs just to visualize easier
        end
        clear i
        % b = 2.08; %in cm. binsize
        b = 0.0208; %in m. binsize
        
        clear i
        kyx = [];
        for ii = 1:size(disttocenter,1)
            dy = disttocenter(ii,2);
            dx = disttocenter(ii,1);
            poo = disttocenter(ii,3);
            
            ky = 2*pi*dy / (M*b);
            kx = 2*pi*dx / (N*b);
            
            kyx = [kyx; [kx,ky,poo]];
        end
        
        waveformyx = [];
        for ii = 1:size(kyx,1)
            wy = 2*pi/kyx(ii,2);
            wx = 2*pi/kyx(ii,1);
            
            poo = kyx(ii,3);
            
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
            
            waveformyx = [waveformyx; [wx,wy,poo,orientation]];
            
        end
        
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
            
        
        %lastly, we will smooth this polar plot and make it more visually
        %appealing
        
        %convert polar plot into a 1d polar plot 
        alpha1 = zeros(629,1); %629 indices for each 0.01 radian unit. i.e. 6.28 will yield 628 values. Plus an extra value for the rad = 0.01 (or 6.29)
        thetarho2 = thetarho;
        for i = 1:size(thetarho2(:,1),1)
            idx = round( 100 * thetarho2(i,1)) + 1;
            
            if isnan(idx)
                continue
            end
            if idx > 629
                break;
            end
            alpha1(idx,1) = thetarho2(i,2);
        end
        
        %run gaussian convolution in both directions of the 1d polar plot
        x = linspace(1,629,629);
        mu = 0;
        sig = 22.69;
        gausss = gaussmf(x,[sig,mu]);
        
        smoothedSignal = conv(alpha1, gausss, 'full'); 
        smoothedSignal = smoothedSignal(1,1:629);
        smoothedSignal = conv(flip(smoothedSignal), gausss, 'full'); 
        smoothedSignal = smoothedSignal(1,1:629);
        alpha1 = smoothedSignal;
        
        %final, smoothed 1d polar plot converted back to [theta,rho] format
        finalsignal = [];
        finalsignal(:,1) = (linspace(1,629,629)-1)/100; %theta 
        finalsignal(end+1,1) = finalsignal(1,1) + 2*pi;
        finalsignal(1:629,2) = smoothedSignal; %rho
        finalsignal(end,2) = finalsignal(1,2);
        
        %store the 1d and 2d polar plots 
        wty_data{iii,1} = alpha1;
        wty_data{iii,2} = finalsignal;
        
    catch
    end
end

%% Repeat procedure for other mouse groups. code not heavily commented here

wta_data = {};

for iii = 1:size(wta_dir,1)
    
    try
    
        disp(iii)
        clear root
        load(wta_dir{iii,3});
        cel = wta_dir{iii,4};
        
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
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
        powr3 = abs(imgX.^2);
        
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
        
        wta_data{iii,3} = powr3; %%%%%%%%%%%%%
        
        %shuffle cell 50 times and find 95th percentile power
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
            
            M = 36; %original rate map sizes
            N = 36;
            mx = 256; %zero padded rate map sizes
            nx = 256;
            %zero padded rate map
            padsize = (mx-M)/2;
            rate_map_shuf_padded = padarray(rate_map_shuf,[padsize padsize],0,'both');
            
            imgLL = rate_map_shuf_padded;
            
            % and its power spectrum
            imgXX  = coef * fftshift(fft2(imgLL));
            powr22 = (abs(imgXX));
            powr33 = abs(imgXX.^2);
            
            width  = 1;   % width of gaussian
            [x,y]  = ndgrid(1:size(imgLL,1),1:size(imgLL,2));
            [row, col] = find(ismember(powr33, max(powr33(:))));
            gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
            f = gaus2d == 1;
            gaus2d = gaus2d .* f;
            powr33 = powr33 .* gaus2d;
            
            allpowers = [allpowers; reshape(powr33,[],1)];
        end
        prc50 = prctile(allpowers,95); %get 95th percentile from all shuffled powers
        
        powr3 = powr3 - prc50;
        f = powr3 > 0;
        powr3 = powr3 .* f;
        maxfpower = nanmax(nanmax(powr3)); %max fourier power...
        threshold = 0.25*maxfpower; %set another threshold to clean the fourier spectrum even further
        
        %clean fourier spectrum
        f = powr3 > threshold;
        powr3 = powr3 .* f;
        
        %create a patch map to pick out individual fourier components
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
        numcomp = round(size(measurements,1)/2); %number of components
        
        %calculate distance from the centroid of each fourier component to the center
        disttocenter = [];
        for i = 1:size(measurements,1)
            c = measurements(i).Centroid;
            center = [128.5,128.5];
            dx = (center(1,1) - c(1,1));
            dy = (center(1,2) - c(1,2));
            
            poo = powr3(round(c(1,2)), round(c(1,1)));
            
            disttocenter = [disttocenter; [-dx,dy, poo]]; %arbitrary signs just to visualize easier
        end
        clear i
        % b = 2.08; %in cm. binsize
        b = 0.0208; %in m. binsize
        
        clear i
        kyx = [];
        for ii = 1:size(disttocenter,1)
            dy = disttocenter(ii,2);
            dx = disttocenter(ii,1);
            poo = disttocenter(ii,3);
            
            ky = 2*pi*dy / (M*b);
            kx = 2*pi*dx / (N*b);
            
            kyx = [kyx; [kx,ky,poo]];
        end
        
        %create polar representation 
        waveformyx = [];
        for ii = 1:size(kyx,1)
            wy = 2*pi/kyx(ii,2);
            wx = 2*pi/kyx(ii,1);
            
            poo = kyx(ii,3);
            
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
            
            waveformyx = [waveformyx; [wx,wy,poo,orientation]];
            
        end
        
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
            
    
    %lastly, compute correlations
    
    %convert into a smoothed and "flattened out" polar plot
    alpha1 = zeros(629,1);
    thetarho2 = thetarho;
    for i = 1:size(thetarho2(:,1),1)
        idx = round( 100 * thetarho2(i,1)) + 1;
        
        if isnan(idx)
            continue
        end
        if idx > 629
            break;
        end
        alpha1(idx,1) = thetarho2(i,2);
    end
    
    x = linspace(1,629,629);
    mu = 0;
    sig = 22.69;
    gausss = gaussmf(x,[sig,mu]); 
    
    smoothedSignal = conv(alpha1, gausss, 'full'); % smoothing
    smoothedSignal = smoothedSignal(1,1:629);
    smoothedSignal = conv(flip(smoothedSignal), gausss, 'full'); % smoothing
    smoothedSignal = smoothedSignal(1,1:629);
    alpha1 = smoothedSignal;
    
    finalsignal = [];
    finalsignal(:,1) = (linspace(1,629,629)-1)/100;
    finalsignal(end+1,1) = finalsignal(1,1) + 2*pi;
    finalsignal(1:629,2) = smoothedSignal;
    finalsignal(end,2) = finalsignal(1,2);
    
    wta_data{iii,1} = alpha1;
    wta_data{iii,2} = finalsignal;
    
    catch
    end
end

%%

j20y_data = {};

for iii = 1:size(j20y_dir,1)
    
    try
    
        disp(iii)
        clear root
        load(j20y_dir{iii,3});
        cel = j20y_dir{iii,4};
        
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
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
        powr3 = abs(imgX.^2);
        
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
        
        j20y_data{iii,3} = powr3; %%%%%%%%%%%%%
        
        %shuffle cell 50 times and find 50th percentile power
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
            
            M = 36; %original rate map sizes
            N = 36;
            mx = 256; %zero padded rate map sizes
            nx = 256;
            %zero padded rate map
            padsize = (mx-M)/2;
            rate_map_shuf_padded = padarray(rate_map_shuf,[padsize padsize],0,'both');
            
            imgLL = rate_map_shuf_padded;
            
            % and its power spectrum
            imgXX  = coef * fftshift(fft2(imgLL));
            powr22 = (abs(imgXX));
            powr33 = abs(imgXX.^2);
            
            width  = 1;   % width of gaussian
            [x,y]  = ndgrid(1:size(imgLL,1),1:size(imgLL,2));
            [row, col] = find(ismember(powr33, max(powr33(:))));
            gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
            f = gaus2d == 1;
            gaus2d = gaus2d .* f;
            powr33 = powr33 .* gaus2d;
            
            allpowers = [allpowers; reshape(powr33,[],1)];
        end
        prc50 = prctile(allpowers,95);
        
        powr3 = powr3 - prc50;
        f = powr3 > 0;
        powr3 = powr3 .* f;
        maxfpower = nanmax(nanmax(powr3)); %max fourier power...
        threshold = 0.25*maxfpower;
        
        f = powr3 > threshold;
        powr3 = powr3 .* f;
        
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
        
        disttocenter = [];
        for i = 1:size(measurements,1)
            c = measurements(i).Centroid;
            center = [128.5,128.5];
            dx = (center(1,1) - c(1,1));
            dy = (center(1,2) - c(1,2));
            
            poo = powr3(round(c(1,2)), round(c(1,1)));
            
            disttocenter = [disttocenter; [-dx,dy, poo]]; %arbitrary signs just to visualize easier
        end
        clear i
        % b = 2.08; %in cm. binsize
        b = 0.0208; %in m. binsize
        
        clear i
        kyx = [];
        for ii = 1:size(disttocenter,1)
            dy = disttocenter(ii,2);
            dx = disttocenter(ii,1);
            poo = disttocenter(ii,3);
            
            ky = 2*pi*dy / (M*b);
            kx = 2*pi*dx / (N*b);
            
            kyx = [kyx; [kx,ky,poo]];
        end
        
        waveformyx = [];
        for ii = 1:size(kyx,1)
            wy = 2*pi/kyx(ii,2);
            wx = 2*pi/kyx(ii,1);
            
            poo = kyx(ii,3);
            
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
            
            waveformyx = [waveformyx; [wx,wy,poo,orientation]];
            
        end
        
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
            
    
    %lastly, compute correlations
    
    %convert into standard orientation curve with all orientation values
    alpha1 = zeros(629,1);
    thetarho2 = thetarho;
    for i = 1:size(thetarho2(:,1),1)
        idx = round( 100 * thetarho2(i,1)) + 1;
        
        if isnan(idx)
            continue
        end
        if idx > 629
            break;
        end
        alpha1(idx,1) = thetarho2(i,2);
    end
    
    x = linspace(1,629,629);
    mu = 0;
    sig = 22.69;
    gausss = gaussmf(x,[sig,mu]); 
    
    smoothedSignal = conv(alpha1, gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    smoothedSignal = conv(flip(smoothedSignal), gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    alpha1 = smoothedSignal;
    
    finalsignal = [];
    finalsignal(:,1) = (linspace(1,629,629)-1)/100;
    finalsignal(end+1,1) = finalsignal(1,1) + 2*pi;
    finalsignal(1:629,2) = smoothedSignal;
    finalsignal(end,2) = finalsignal(1,2);
    
    j20y_data{iii,1} = alpha1;
    j20y_data{iii,2} = finalsignal;
    
    catch
    end
end

%%

j20a_data = {};

for iii = 1:size(j20a_dir,1)
    
    try
    
        disp(iii)
        clear root
        load(j20a_dir{iii,3});
        cel = j20a_dir{iii,4};
        
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
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
        powr3 = abs(imgX.^2);
        
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
        
        j20a_data{iii,3} = powr3; %%%%%%%%%%%%%
        
        %shuffle cell 50 times and find 50th percentile power
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
            
            M = 36; %original rate map sizes
            N = 36;
            mx = 256; %zero padded rate map sizes
            nx = 256;
            %zero padded rate map
            padsize = (mx-M)/2;
            rate_map_shuf_padded = padarray(rate_map_shuf,[padsize padsize],0,'both');
            
            imgLL = rate_map_shuf_padded;
            
            % and its power spectrum
            imgXX  = coef * fftshift(fft2(imgLL));
            powr22 = (abs(imgXX));
            powr33 = abs(imgXX.^2);
            
            width  = 1;   % width of gaussian
            [x,y]  = ndgrid(1:size(imgLL,1),1:size(imgLL,2));
            [row, col] = find(ismember(powr33, max(powr33(:))));
            gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
            f = gaus2d == 1;
            gaus2d = gaus2d .* f;
            powr33 = powr33 .* gaus2d;
            
            allpowers = [allpowers; reshape(powr33,[],1)];
        end
        prc50 = prctile(allpowers,95);
        
        powr3 = powr3 - prc50;
        f = powr3 > 0;
        powr3 = powr3 .* f;
        maxfpower = nanmax(nanmax(powr3)); %max fourier power...
        threshold = 0.25*maxfpower;
        
        f = powr3 > threshold;
        powr3 = powr3 .* f;
        
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
        
        disttocenter = [];
        for i = 1:size(measurements,1)
            c = measurements(i).Centroid;
            center = [128.5,128.5];
            dx = (center(1,1) - c(1,1));
            dy = (center(1,2) - c(1,2));
            
            poo = powr3(round(c(1,2)), round(c(1,1)));
            
            disttocenter = [disttocenter; [-dx,dy, poo]]; %arbitrary signs just to visualize easier
        end
        clear i
        % b = 2.08; %in cm. binsize
        b = 0.0208; %in m. binsize
        
        clear i
        kyx = [];
        for ii = 1:size(disttocenter,1)
            dy = disttocenter(ii,2);
            dx = disttocenter(ii,1);
            poo = disttocenter(ii,3);
            
            ky = 2*pi*dy / (M*b);
            kx = 2*pi*dx / (N*b);
            
            kyx = [kyx; [kx,ky,poo]];
        end
        
        waveformyx = [];
        for ii = 1:size(kyx,1)
            wy = 2*pi/kyx(ii,2);
            wx = 2*pi/kyx(ii,1);
            
            poo = kyx(ii,3);
            
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
            
            waveformyx = [waveformyx; [wx,wy,poo,orientation]];
            
        end
        
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
            
    
    %lastly, compute correlations
    
    %convert into standard orientation curve with all orientation values
    alpha1 = zeros(629,1);
    thetarho2 = thetarho;
    for i = 1:size(thetarho2(:,1),1)
        idx = round( 100 * thetarho2(i,1)) + 1;
        
        if isnan(idx)
            continue
        end
        if idx > 629
            break;
        end
        alpha1(idx,1) = thetarho2(i,2);
    end
    
    x = linspace(1,629,629);
    mu = 0;
    sig = 22.69;
    gausss = gaussmf(x,[sig,mu]); 
    
    smoothedSignal = conv(alpha1, gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    smoothedSignal = conv(flip(smoothedSignal), gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    alpha1 = smoothedSignal;
    
    finalsignal = [];
    finalsignal(:,1) = (linspace(1,629,629)-1)/100;
    finalsignal(end+1,1) = finalsignal(1,1) + 2*pi;
    finalsignal(1:629,2) = smoothedSignal;
    finalsignal(end,2) = finalsignal(1,2);
    
    j20a_data{iii,1} = alpha1;
    j20a_data{iii,2} = finalsignal;
    
    catch
    end
end

%% The results that you should obtain from running the above code are provided in 'grid_polars.mat'

clear
load('grid_polars.mat')

%% Figure 2b - visualize polarplots 

%polar plots
count = 1;
for i = 1:60
    
    p = wty_data{i,2};
%     p = wta_data{i,2};
%     p = j20y_data{i,2};
%     p = j20a_data{i,2};
    
    pax = subplot(6,10,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
    pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    count = count + 1;
end

%fourier spectrms
count = 1;
for i = 1:60
    padsize = 110;
    
    p = wty_data{i,3};
    p = wta_data{i,3};
    p = j20y_data{i,3};
    p = j20a_data{i,3};
    
    subplot(6,10,count);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;
end

%% Next, we will retrieve falsely identified 1- or 2- component grid cells 
% 
%%
wtyscores = cell2mat(wty_dir(:,5:9));
wtascores = cell2mat(wta_dir(:,5:9));
j20yscores = cell2mat(j20y_dir(:,5:9));
j20ascores = cell2mat(j20a_dir(:,5:9));

%%
wtyshuffleddir = wty_dir;
wtashuffleddir = wta_dir;
j20yshuffleddir = j20y_dir;
j20ashuffleddir = j20a_dir;
%% 
wtyshuffleddata = wty_data;
wtashuffleddata = wta_data;
j20yshuffleddata = j20y_data;
j20ashuffleddata = j20a_data;

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

subplot(1,4,1)
imagesc(wty)
colormap jet
caxis([0,1])
axis square
subplot(1,4,2)
imagesc(wta)
colormap jet
caxis([0,1])
axis square
subplot(1,4,3)
imagesc(j20y)
colormap jet
caxis([0,1])
axis square
subplot(1,4,4)
imagesc(j20a)
colormap jet
caxis([0,1])
axis square

%This is Figure 3C with UNCORRECTED grid cells
%We will run a correction procedure below to retrive 3-component grid cells
%from 1- and 2- component grid cells 
%
%The correction procedure below is a mix of unbiased and biased threshold
%selections. For completely unbiased corrections, refer to the 'Correction
%threshold' folder for an iterative procedure where threshold was varied by
%increments of 3%. 

%%

%end indices for hexagonally modulated grid cells
s1 = 22;
s2 = 38;
s3 = 17;
s4 = 10;

%if you want to further correct these...
wtynormal = wtyshuffleddata(1:s1,:);
wtanormal = wtashuffleddata(1:s2,:);
j20ynormal = j20yshuffleddata(1:s3,:);
j20anormal = j20ashuffleddata(1:s4,:);

wtycorrect = wtyshuffleddata(s1+1:end,:);
wtacorrect = wtashuffleddata(s2+1:end,:);
j20ycorrect = j20yshuffleddata(s3+1:end,:);
j20acorrect = j20ashuffleddata(s4+1:end,:);

wtynormaldir = wtyshuffleddir(1:s1,:);
wtanormaldir = wtashuffleddir(1:s2,:);
j20ynormaldir = j20yshuffleddir(1:s3,:);
j20anormaldir = j20ashuffleddir(1:s4,:);

wtycorrectdir = wtyshuffleddir(s1+1:end,:);
wtacorrectdir = wtashuffleddir(s2+1:end,:);
j20ycorrectdir = j20yshuffleddir(s3+1:end,:);
j20acorrectdir = j20ashuffleddir(s4+1:end,:);

%% Run correction procedure
% code is same as above, with exception that I manually selected higher
% image thresholds to be considerd a Fourier comonent

wty_data2 = {};

for iii = 1:size(wtycorrectdir,1)
    
    try
    
        disp(iii)
        clear root
        load(wtycorrectdir{iii,3});
        cel = wtycorrectdir{iii,4};
        
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
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
        powr3 = abs(imgX.^2);
        
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
        
        wty_data2{iii,3} = powr3; %%%%%%%%%%%%%
        
        %shuffle cell 50 times and find 50th percentile power
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
            
            M = 36; %original rate map sizes
            N = 36;
            mx = 256; %zero padded rate map sizes
            nx = 256;
            %zero padded rate map
            padsize = (mx-M)/2;
            rate_map_shuf_padded = padarray(rate_map_shuf,[padsize padsize],0,'both');
            
            imgLL = rate_map_shuf_padded;
            
            % and its power spectrum
            imgXX  = coef * fftshift(fft2(imgLL));
            powr22 = (abs(imgXX));
            powr33 = abs(imgXX.^2);
            
            width  = 1;   % width of gaussian
            [x,y]  = ndgrid(1:size(imgLL,1),1:size(imgLL,2));
            [row, col] = find(ismember(powr33, max(powr33(:))));
            gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
            f = gaus2d == 1;
            gaus2d = gaus2d .* f;
            powr33 = powr33 .* gaus2d;
            
            allpowers = [allpowers; reshape(powr33,[],1)];
        end
        prc50 = prctile(allpowers,95);
        
        powr3 = powr3 - prc50;
        f = powr3 > 0;
        powr3 = powr3 .* f;
        maxfpower = nanmax(nanmax(powr3)); %max fourier power...
%         threshold = 0.25*maxfpower;
        threshold = 0.5*maxfpower;
        
        f = powr3 > threshold;
        powr3 = powr3 .* f;
        
        
        if iii == 13 %special case
            threshold = 0.7*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        
        
        
        wty_data2{iii,4} = powr3; %%%%%%%%%%%%%
        
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
        
        
%         f = []; %dont want to get rid of really small areas anymore...
%         for ii = 1:size(measurements,1)
%             if measurements(ii).Area < 10
%                 f = [f;ii];
%             end
%         end
%         measurements(f) = [];
        numcomp = round(size(measurements,1)/2);
        
        disttocenter = [];
        for i = 1:size(measurements,1)
            c = measurements(i).Centroid;
            center = [128.5,128.5];
            dx = (center(1,1) - c(1,1));
            dy = (center(1,2) - c(1,2));
            
            poo = powr3(round(c(1,2)), round(c(1,1)));
            
            disttocenter = [disttocenter; [-dx,dy, poo]]; %arbitrary signs just to visualize easier
        end
        clear i
        % b = 2.08; %in cm. binsize
        b = 0.0208; %in m. binsize
        
        clear i
        kyx = [];
        for ii = 1:size(disttocenter,1)
            dy = disttocenter(ii,2);
            dx = disttocenter(ii,1);
            poo = disttocenter(ii,3);
            
            ky = 2*pi*dy / (M*b);
            kx = 2*pi*dx / (N*b);
            
            kyx = [kyx; [kx,ky,poo]];
        end
        
        waveformyx = [];
        for ii = 1:size(kyx,1)
            wy = 2*pi/kyx(ii,2);
            wx = 2*pi/kyx(ii,1);
            
            poo = kyx(ii,3);
            
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
            
            waveformyx = [waveformyx; [wx,wy,poo,orientation]];
            
        end
        
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
            
    
    %lastly, compute correlations
    
    %convert into standard orientation curve with all orientation values
    alpha1 = zeros(629,1);
    thetarho2 = thetarho;
    for i = 1:size(thetarho2(:,1),1)
        idx = round( 100 * thetarho2(i,1)) + 1;
        
        if isnan(idx)
            continue
        end
        if idx > 629
            break;
        end
        alpha1(idx,1) = thetarho2(i,2);
    end
    
    x = linspace(1,629,629);
    mu = 0;
    sig = 22.69;
    gausss = gaussmf(x,[sig,mu]); 
    
    smoothedSignal = conv(alpha1, gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    smoothedSignal = conv(flip(smoothedSignal), gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    alpha1 = smoothedSignal;
    
    finalsignal = [];
    finalsignal(:,1) = (linspace(1,629,629)-1)/100;
    finalsignal(end+1,1) = finalsignal(1,1) + 2*pi;
    finalsignal(1:629,2) = smoothedSignal;
    finalsignal(end,2) = finalsignal(1,2);
    
    wty_data2{iii,1} = alpha1;
    wty_data2{iii,2} = finalsignal;
    
    catch
    end
end

%%

wta_data2 = {};

for iii = 1:size(wtacorrectdir,1)
    
    try
    
        disp(iii)
        clear root
        load(wtacorrectdir{iii,3});
        cel = wtacorrectdir{iii,4};
        
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
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
        powr3 = abs(imgX.^2);
        
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
        
        wta_data2{iii,3} = powr3; %%%%%%%%%%%%%
        
        %shuffle cell 50 times and find 50th percentile power
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
            
            M = 36; %original rate map sizes
            N = 36;
            mx = 256; %zero padded rate map sizes
            nx = 256;
            %zero padded rate map
            padsize = (mx-M)/2;
            rate_map_shuf_padded = padarray(rate_map_shuf,[padsize padsize],0,'both');
            
            imgLL = rate_map_shuf_padded;
            
            % and its power spectrum
            imgXX  = coef * fftshift(fft2(imgLL));
            powr22 = (abs(imgXX));
            powr33 = abs(imgXX.^2);
            
            width  = 1;   % width of gaussian
            [x,y]  = ndgrid(1:size(imgLL,1),1:size(imgLL,2));
            [row, col] = find(ismember(powr33, max(powr33(:))));
            gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
            f = gaus2d == 1;
            gaus2d = gaus2d .* f;
            powr33 = powr33 .* gaus2d;
            
            allpowers = [allpowers; reshape(powr33,[],1)];
        end
        prc50 = prctile(allpowers,95);
        
        powr3 = powr3 - prc50;
        f = powr3 > 0;
        powr3 = powr3 .* f;
        maxfpower = nanmax(nanmax(powr3)); %max fourier power...
%         threshold = 0.25*maxfpower;
        
        if iii == 11 || iii == 22
            threshold = 0.35*maxfpower;
        else
            threshold = 0.45*maxfpower;
        end
        
        f = powr3 > threshold;
        powr3 = powr3 .* f;
        
        
        if iii == 9 %special case
            threshold = 0.6*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 10 %special case
            threshold = 0.7*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 13 %special case
            threshold = 0.5*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 17 %special case
            threshold = 0.5*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 24 %special case
            threshold = 0.65*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        
        
        wta_data2{iii,4} = powr3; %%%%%%%%%%%%%
        
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
        
        
%         f = []; %dont want to get rid of really small areas anymore...
%         for ii = 1:size(measurements,1)
%             if measurements(ii).Area < 10
%                 f = [f;ii];
%             end
%         end
%         measurements(f) = [];
        numcomp = round(size(measurements,1)/2);
        
        disttocenter = [];
        for i = 1:size(measurements,1)
            c = measurements(i).Centroid;
            center = [128.5,128.5];
            dx = (center(1,1) - c(1,1));
            dy = (center(1,2) - c(1,2));
            
            poo = powr3(round(c(1,2)), round(c(1,1)));
            
            disttocenter = [disttocenter; [-dx,dy, poo]]; %arbitrary signs just to visualize easier
        end
        clear i
        % b = 2.08; %in cm. binsize
        b = 0.0208; %in m. binsize
        
        clear i
        kyx = [];
        for ii = 1:size(disttocenter,1)
            dy = disttocenter(ii,2);
            dx = disttocenter(ii,1);
            poo = disttocenter(ii,3);
            
            ky = 2*pi*dy / (M*b);
            kx = 2*pi*dx / (N*b);
            
            kyx = [kyx; [kx,ky,poo]];
        end
        
        waveformyx = [];
        for ii = 1:size(kyx,1)
            wy = 2*pi/kyx(ii,2);
            wx = 2*pi/kyx(ii,1);
            
            poo = kyx(ii,3);
            
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
            
            waveformyx = [waveformyx; [wx,wy,poo,orientation]];
            
        end
        
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
            
    
    %lastly, compute correlations
    
    %convert into standard orientation curve with all orientation values
    alpha1 = zeros(629,1);
    thetarho2 = thetarho;
    for i = 1:size(thetarho2(:,1),1)
        idx = round( 100 * thetarho2(i,1)) + 1;
        
        if isnan(idx)
            continue
        end
        if idx > 629
            break;
        end
        alpha1(idx,1) = thetarho2(i,2);
    end
    
    x = linspace(1,629,629);
    mu = 0;
    sig = 22.69;
    gausss = gaussmf(x,[sig,mu]); 
    
    smoothedSignal = conv(alpha1, gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    smoothedSignal = conv(flip(smoothedSignal), gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    alpha1 = smoothedSignal;
    
    finalsignal = [];
    finalsignal(:,1) = (linspace(1,629,629)-1)/100;
    finalsignal(end+1,1) = finalsignal(1,1) + 2*pi;
    finalsignal(1:629,2) = smoothedSignal;
    finalsignal(end,2) = finalsignal(1,2);
    
    wta_data2{iii,1} = alpha1;
    wta_data2{iii,2} = finalsignal;
    
    catch
    end
end

%%

j20y_data2 = {};

for iii = 1:size(j20ycorrectdir,1)
    
    try
    
        disp(iii)
        clear root
        load(j20ycorrectdir{iii,3});
        cel = j20ycorrectdir{iii,4};
        
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
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
        powr3 = abs(imgX.^2);
        
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
        
        j20y_data2{iii,3} = powr3; %%%%%%%%%%%%%
        
        %shuffle cell 50 times and find 50th percentile power
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
            
            M = 36; %original rate map sizes
            N = 36;
            mx = 256; %zero padded rate map sizes
            nx = 256;
            %zero padded rate map
            padsize = (mx-M)/2;
            rate_map_shuf_padded = padarray(rate_map_shuf,[padsize padsize],0,'both');
            
            imgLL = rate_map_shuf_padded;
            
            % and its power spectrum
            imgXX  = coef * fftshift(fft2(imgLL));
            powr22 = (abs(imgXX));
            powr33 = abs(imgXX.^2);
            
            width  = 1;   % width of gaussian
            [x,y]  = ndgrid(1:size(imgLL,1),1:size(imgLL,2));
            [row, col] = find(ismember(powr33, max(powr33(:))));
            gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
            f = gaus2d == 1;
            gaus2d = gaus2d .* f;
            powr33 = powr33 .* gaus2d;
            
            allpowers = [allpowers; reshape(powr33,[],1)];
        end
        prc50 = prctile(allpowers,95);
        
        powr3 = powr3 - prc50;
        f = powr3 > 0;
        powr3 = powr3 .* f;
        maxfpower = nanmax(nanmax(powr3)); %max fourier power...
%         threshold = 0.25*maxfpower;

        threshold = 0.45*maxfpower;
        
        f = powr3 > threshold;
        powr3 = powr3 .* f;
        
        
        if iii == 2 %special case
            threshold = 0.7*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 8 %special case
            threshold = 0.55*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        
        
        j20y_data2{iii,4} = powr3; %%%%%%%%%%%%%
        
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
        
        
%         f = []; %dont want to get rid of really small areas anymore...
%         for ii = 1:size(measurements,1)
%             if measurements(ii).Area < 10
%                 f = [f;ii];
%             end
%         end
%         measurements(f) = [];
        numcomp = round(size(measurements,1)/2);
        
        disttocenter = [];
        for i = 1:size(measurements,1)
            c = measurements(i).Centroid;
            center = [128.5,128.5];
            dx = (center(1,1) - c(1,1));
            dy = (center(1,2) - c(1,2));
            
            poo = powr3(round(c(1,2)), round(c(1,1)));
            
            disttocenter = [disttocenter; [-dx,dy, poo]]; %arbitrary signs just to visualize easier
        end
        clear i
        % b = 2.08; %in cm. binsize
        b = 0.0208; %in m. binsize
        
        clear i
        kyx = [];
        for ii = 1:size(disttocenter,1)
            dy = disttocenter(ii,2);
            dx = disttocenter(ii,1);
            poo = disttocenter(ii,3);
            
            ky = 2*pi*dy / (M*b);
            kx = 2*pi*dx / (N*b);
            
            kyx = [kyx; [kx,ky,poo]];
        end
        
        waveformyx = [];
        for ii = 1:size(kyx,1)
            wy = 2*pi/kyx(ii,2);
            wx = 2*pi/kyx(ii,1);
            
            poo = kyx(ii,3);
            
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
            
            waveformyx = [waveformyx; [wx,wy,poo,orientation]];
            
        end
        
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
            
    
    %lastly, compute correlations
    
    %convert into standard orientation curve with all orientation values
    alpha1 = zeros(629,1);
    thetarho2 = thetarho;
    for i = 1:size(thetarho2(:,1),1)
        idx = round( 100 * thetarho2(i,1)) + 1;
        
        if isnan(idx)
            continue
        end
        if idx > 629
            break;
        end
        alpha1(idx,1) = thetarho2(i,2);
    end
    
    x = linspace(1,629,629);
    mu = 0;
    sig = 22.69;
    gausss = gaussmf(x,[sig,mu]); 
    
    smoothedSignal = conv(alpha1, gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    smoothedSignal = conv(flip(smoothedSignal), gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    alpha1 = smoothedSignal;
    
    finalsignal = [];
    finalsignal(:,1) = (linspace(1,629,629)-1)/100;
    finalsignal(end+1,1) = finalsignal(1,1) + 2*pi;
    finalsignal(1:629,2) = smoothedSignal;
    finalsignal(end,2) = finalsignal(1,2);
    
    j20y_data2{iii,1} = alpha1;
    j20y_data2{iii,2} = finalsignal;
    
    catch
    end
end



%%

j20a_data2 = {};

for iii = 1:size(j20acorrectdir,1)
    
    try
    
        disp(iii)
        clear root
        load(j20acorrectdir{iii,3});
        cel = j20acorrectdir{iii,4};
        
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
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
        powr3 = abs(imgX.^2);
        
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
        
        j20a_data2{iii,3} = powr3; %%%%%%%%%%%%%
        
        %shuffle cell 50 times and find 50th percentile power
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = root.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(root.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
            
            M = 36; %original rate map sizes
            N = 36;
            mx = 256; %zero padded rate map sizes
            nx = 256;
            %zero padded rate map
            padsize = (mx-M)/2;
            rate_map_shuf_padded = padarray(rate_map_shuf,[padsize padsize],0,'both');
            
            imgLL = rate_map_shuf_padded;
            
            % and its power spectrum
            imgXX  = coef * fftshift(fft2(imgLL));
            powr22 = (abs(imgXX));
            powr33 = abs(imgXX.^2);
            
            width  = 1;   % width of gaussian
            [x,y]  = ndgrid(1:size(imgLL,1),1:size(imgLL,2));
            [row, col] = find(ismember(powr33, max(powr33(:))));
            gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
            f = gaus2d == 1;
            gaus2d = gaus2d .* f;
            powr33 = powr33 .* gaus2d;
            
            allpowers = [allpowers; reshape(powr33,[],1)];
        end
        prc50 = prctile(allpowers,95);
        
        powr3 = powr3 - prc50;
        f = powr3 > 0;
        powr3 = powr3 .* f;
        maxfpower = nanmax(nanmax(powr3)); %max fourier power...
%         threshold = 0.25*maxfpower;
        
        if iii == 5
            threshold = 0.27*maxfpower;
        else
            threshold = 0.45*maxfpower;
        end
        f = powr3 > threshold;
        powr3 = powr3 .* f;
        
        
        if iii == 7 %special case
            threshold = 0.65*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 16 %special case
            threshold = 0.7*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end

        
        j20a_data2{iii,4} = powr3; %%%%%%%%%%%%%
        
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
        
        
%         f = []; %dont want to get rid of really small areas anymore...
%         for ii = 1:size(measurements,1)
%             if measurements(ii).Area < 10
%                 f = [f;ii];
%             end
%         end
%         measurements(f) = [];
        numcomp = round(size(measurements,1)/2);
        
        disttocenter = [];
        for i = 1:size(measurements,1)
            c = measurements(i).Centroid;
            center = [128.5,128.5];
            dx = (center(1,1) - c(1,1));
            dy = (center(1,2) - c(1,2));
            
            poo = powr3(round(c(1,2)), round(c(1,1)));
            
            disttocenter = [disttocenter; [-dx,dy, poo]]; %arbitrary signs just to visualize easier
        end
        clear i
        % b = 2.08; %in cm. binsize
        b = 0.0208; %in m. binsize
        
        clear i
        kyx = [];
        for ii = 1:size(disttocenter,1)
            dy = disttocenter(ii,2);
            dx = disttocenter(ii,1);
            poo = disttocenter(ii,3);
            
            ky = 2*pi*dy / (M*b);
            kx = 2*pi*dx / (N*b);
            
            kyx = [kyx; [kx,ky,poo]];
        end
        
        waveformyx = [];
        for ii = 1:size(kyx,1)
            wy = 2*pi/kyx(ii,2);
            wx = 2*pi/kyx(ii,1);
            
            poo = kyx(ii,3);
            
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
            
            waveformyx = [waveformyx; [wx,wy,poo,orientation]];
            
        end
        
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]];
            
    
    %lastly, compute correlations
    
    %convert into standard orientation curve with all orientation values
    alpha1 = zeros(629,1);
    thetarho2 = thetarho;
    for i = 1:size(thetarho2(:,1),1)
        idx = round( 100 * thetarho2(i,1)) + 1;
        
        if isnan(idx)
            continue
        end
        if idx > 629
            break;
        end
        alpha1(idx,1) = thetarho2(i,2);
    end
    
    x = linspace(1,629,629);
    mu = 0;
    sig = 22.69;
    gausss = gaussmf(x,[sig,mu]); 
    
    smoothedSignal = conv(alpha1, gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    smoothedSignal = conv(flip(smoothedSignal), gausss, 'full'); % or whatever
    smoothedSignal = smoothedSignal(1,1:629);
    alpha1 = smoothedSignal;
    
    finalsignal = [];
    finalsignal(:,1) = (linspace(1,629,629)-1)/100;
    finalsignal(end+1,1) = finalsignal(1,1) + 2*pi;
    finalsignal(1:629,2) = smoothedSignal;
    finalsignal(end,2) = finalsignal(1,2);
    
    j20a_data2{iii,1} = alpha1;
    j20a_data2{iii,2} = finalsignal;
    
    catch
    end
end


%% FYI, I visualized the polar plots and Fourier spectrums of each cell to determine what was a suitable manual image threshold to use 
% 
% count = 1;
% for i = 1:60
%     
%     p = wty_data2{i,2};
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
% count = 1;
% for i = 1:60
%     padsize = 110;
%     p = wty_data2{i,3};
%     
%     subplot(6,10,count);
%     imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
%     colormap jet
%     axis square
%     count = count + 1;
% end
% 
% count = 1;
% for i = 1:60
%     padsize = 110;
%     p = wty_data2{i,4};
%     
%     subplot(6,10,count);
%     imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
%     colormap jet
%     axis square
%     count = count + 1;
% end
% 
% %wta
% %9, 10, 11, 13, 16, 17, 18, 19, 20, 21,22,23,24,25,26
% %needs manual threshold 9,10,11,13,17,22,24,
% count = 1;
% for i = 1:60
%     
%     p = wta_data2{i,2};
%     
%     pax = subplot(6,10,count, polaraxes);
%     polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
%     pax.RGrid  = 'off';
%     pax.RTickLabels = [];
%     set(gcf,'color','w');
%     count = count + 1;
%     title(i)
% end
% 
% count = 1;
% for i = 1:60
%     padsize = 110;
%     p = wta_data2{i,3};
%     
%     subplot(6,10,count);
%     imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
%     colormap jet
%     axis square
%     count = count + 1;
% end
% 
% count = 1;
% for i = 1:60
%     padsize = 110;
%     p = wta_data2{i,4};
%     
%     subplot(6,10,count);
%     imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
%     colormap jet
%     axis square
%     count = count + 1;
% end
% 
% 
% %j20y
% %2,8,9,10,12,13
% %needs manual threshold 2,8
% count = 1;
% for i = 1:60
%     
%     p = j20y_data2{i,2};
%     
%     pax = subplot(6,10,count, polaraxes);
%     polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
%     pax.RGrid  = 'off';
%     pax.RTickLabels = [];
%     set(gcf,'color','w');
%     count = count + 1;
%     title(i)
% end
% 
% count = 1;
% for i = 1:60
%     padsize = 110;
%     p = j20y_data2{i,3};
%     
%     subplot(6,10,count);
%     imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
%     colormap jet
%     axis square
%     count = count + 1;
% end
% 
% count = 1;
% for i = 1:60
%     padsize = 110;
%     p = j20y_data2{i,4};
%     
%     subplot(6,10,count);
%     imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
%     colormap jet
%     axis square
%     count = count + 1;
% end
% 
% 
% %j20a
% %5,7,9,11,16,17,18,19,23
% %needs manual threshold 5,7,16
% count = 1;
% for i = 1:60
%     
%     p = j20a_data2{i,2};
%     
%     pax = subplot(6,10,count, polaraxes);
%     polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
%     pax.RGrid  = 'off';
%     pax.RTickLabels = [];
%     set(gcf,'color','w');
%     count = count + 1;
%     title(i)
% end
% 
% count = 1;
% for i = 1:60
%     padsize = 110;
%     p = j20a_data2{i,3};
%     
%     subplot(6,10,count);
%     imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
%     colormap jet
%     axis square
%     count = count + 1;
% end
% 
% count = 1;
% for i = 1:60
%     padsize = 110;
%     p = j20a_data2{i,4};
%     
%     subplot(6,10,count);
%     imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
%     colormap jet
%     axis square
%     count = count + 1;
% end

%% now... add these corrected cells back to originally good cells data 

wty_data = [wtynormal; wty_data2(:,1:3)];
wta_data = [wtanormal; wta_data2(:,1:3)];
j20y_data = [j20ynormal; j20y_data2(:,1:3)];
j20a_data = [j20anormal; j20a_data2(:,1:3)];

% If you ran this code properly, you should obtain the results found in 
%'grid_polars_CORRECTED_BAD_CELLS'

clear 
load('grid_polars_CORRECTED_BAD_CELLS.mat')

%% Figure 3C

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

%Figure 3C
subplot(1,4,1)
imagesc(wty)
colormap jet
caxis([0,1])
axis square
subplot(1,4,2)
imagesc(wta)
colormap jet
caxis([0,1])
axis square
subplot(1,4,3)
imagesc(j20y)
colormap jet
caxis([0,1])
axis square
subplot(1,4,4)
imagesc(j20a)
colormap jet
caxis([0,1])
axis square

%Figure 2C - gridness scores 
s1 = 26;
s2 = 48;
s3 = 23;
s4 = 18;

id = 1; %mean firing
id = 2; %peak firing
id = 3; %spt info
id = 4; %MRL
id = 5; % gridness

wty = (wtyscores(1:s1,id));
wty2 = (wtyscores(s1+1:end,id));

wta = (wtascores(1:s2,id));
wta2 = (wtascores(s2+1:end,id));

j20y = (j20yscores(1:s3,id));
j20y2 = (j20yscores(s3+1:end,id));

j20a = (j20ascores(1:s4,id));
j20a2 = (j20ascores(s4+1:end,id));

% % % wty_filt9999 = wtyshuffleddir(s1+1:end,:)
% % % wta_filt9999 = wtashuffleddir(s2+1:end,:)
% % % j20y_filt9999 = j20yshuffleddir(s3+1:end,:)
% % % j20a_filt9999 = j20ashuffleddir(s4+1:end,:)
% % % 
% % % wty_filt9999 = wtyshuffleddir(1:s1,:)
% % % wta_filt9999 = wtashuffleddir(1:s2,:)
% % % j20y_filt9999 = j20yshuffleddir(1:s3,:)
% % % j20a_filt9999 = j20ashuffleddir(1:s4,:)
% % % 
% % % %if you want to further correct these...
% % % wtynormal = wtyshuffleddata(1:s1,:);
% % % wtanormal = wtashuffleddata(1:s2,:);
% % % j20ynormal = j20yshuffleddata(1:s3,:);
% % % j20anormal = j20ashuffleddata(1:s4,:);
% % % 
% % % wtycorrect = wtyshuffleddata(s1+1:end,:);
% % % wtacorrect = wtashuffleddata(s2+1:end,:);
% % % j20ycorrect = j20yshuffleddata(s3+1:end,:);
% % % j20acorrect = j20ashuffleddata(s4+1:end,:);
% % % 
% % % %if you want to further correct these...
% % % wtynormaldir = wtyshuffleddir(1:s1,:);
% % % wtanormaldir = wtashuffleddir(1:s2,:);
% % % j20ynormaldir = j20yshuffleddir(1:s3,:);
% % % j20anormaldir = j20ashuffleddir(1:s4,:);
% % % 
% % % wtycorrectdir = wtyshuffleddir(s1+1:end,:);
% % % wtacorrectdir = wtashuffleddir(s2+1:end,:);
% % % j20ycorrectdir = j20yshuffleddir(s3+1:end,:);
% % % j20acorrectdir = j20ashuffleddir(s4+1:end,:);

subplot(1,4,1)
scatter(linspace(1,length(wtyscores(:,id)), length(wtyscores(:,id))), wtyscores(:,id),8,'k','filled')
axis square
title(s1/length(wtyscores(:,id)))
xline(s1)
subplot(1,4,2)
scatter(linspace(1,length(wtascores(:,id)), length(wtascores(:,id))),wtascores(:,id),8,'k','filled')
axis square
title(s2/length(wtascores(:,id)))
xline(s2)
subplot(1,4,3)
scatter(linspace(1,length(j20yscores(:,id)), length(j20yscores(:,id))),j20yscores(:,id),8,'k','filled')
axis square
title(s3/length(j20yscores(:,id)))
xline(s3)
subplot(1,4,4)
scatter(linspace(1,length(j20ascores(:,id)), length(j20ascores(:,id))),j20ascores(:,id),8,'k','filled')
axis square
xline(s4)
title(s4/length(j20ascores(:,id)))

ranksum(wty,wty2)
ranksum(wta,wta2)
ranksum(j20y,j20y2)
ranksum(j20a,j20a2)

[k,pval] = kstest2(wty,wty2)
[k,pval] = kstest2(wta,wta2)
[k,pval] = kstest2(j20y,j20y2)
[k,pval] = kstest2(j20a,j20a2)

%% Figure 3B 
%
wty = wtyshuffleddata(:,1);
for i = 1:size(wty,1)
    wty{i,1} = zscore((wty{i,1}));
end

wty = cell2mat(wty)

wta = wtashuffleddata(:,1);
for i = 1:size(wta,1)
    wta{i,1} = zscore((wta{i,1}));
end

wta = cell2mat(wta)

j20y = j20yshuffleddata(:,1);
for i = 1:size(j20y,1)
    j20y{i,1} = zscore((j20y{i,1}));
end

j20y = cell2mat(j20y)

j20a = j20ashuffleddata(:,1);
for i = 1:size(j20a,1)
    j20a{i,1} = zscore((j20a{i,1}));
end

j20a = cell2mat(j20a)


%These are the absolute orientations of cells sorted by their degree of
%hexagonal or rectangular modulation 

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

% We will now organize them by 30, 60, or 90 orientation
% Note, this process was mostly automatic, except I did change the order of
% certain cells based on visual inspection

newwtyshuffledir = wtyshuffleddir;
newwtashuffledir = wtashuffleddir;
newj20yshuffledir = j20yshuffleddir;
newj20ashuffledir = j20ashuffleddir;

%% run the entire block of code here
%points at which the grids stop
s1 = 27;
s2 = 49;
s3 = 23;
s4 = 20;

wtygridhalf = wty(1:s1,:);
wtyrechalf = wty(s1+1:end,:);

newwtyshuffledirgridhalf = newwtyshuffledir(1:s1,:);
newwtyshuffledirrechalf = newwtyshuffledir(s1+1:end,:);

%lets work with wty first 
sixtydegreecolumn = [wtygridhalf(:,52), wtygridhalf(:,262), wtygridhalf(:,366), wtygridhalf(:,157), wtygridhalf(:,471)];
%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'descend');

wtygridhalf = wtygridhalf(idx,:);
newwtyshuffledirgridhalf = newwtyshuffledirgridhalf(idx, :);

finalwty = [wtygridhalf;wtyrechalf];
newwtyshuffledir = [newwtyshuffledirgridhalf;newwtyshuffledirrechalf];

%switch rows 23 with 24
r23 = finalwty(23,:);
r24 = finalwty(24,:);
finalwty(23,:) = r24;
finalwty(24,:) = r23;

r23 = newwtyshuffledir(23,:);
r24 = newwtyshuffledir(24,:);
newwtyshuffledir(23,:) = r24;
newwtyshuffledir(24,:) = r23;


%switch rows 24 with 27
r24 = finalwty(24,:);
r27 = finalwty(27,:);
finalwty(24,:) = r27;
finalwty(27,:) = r24;

r24 = newwtyshuffledir(24,:);
r27 = newwtyshuffledir(27,:);
newwtyshuffledir(24,:) = r27;
newwtyshuffledir(27,:) = r24;

%row 15 can go to end
r15 = finalwty(15,:);
finalwty(15:end-1,:) = finalwty(16:end,:);
finalwty(end,:)= r15;

r15 = newwtyshuffledir(15,:);
newwtyshuffledir(15:end-1,:) = newwtyshuffledir(16:end,:);
newwtyshuffledir(end,:)= r15;

%switch rows 24 with 25
r24 = finalwty(24,:);
r25 = finalwty(25,:);
finalwty(24,:) = r25;
finalwty(25,:) = r24;

r24 = newwtyshuffledir(24,:);
r25 = newwtyshuffledir(25,:);
newwtyshuffledir(24,:) = r25;
newwtyshuffledir(25,:) = r24;

subplot(1,4,1)
imagesc(finalwty)
colormap jet

%
%
%next, wta
wtagridhalf = wta(1:s2,:);
wtarechalf = wta(s2+1:end,:);

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

finalwta = [wtagridhalf;wtarechalf];
newwtashuffledir = [newwtashuffledirgridhalf;newwtashuffledirrechalf];

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


%switch rows 52 with 53
r52 = finalwta(52,:);
r53 = finalwta(53,:);
finalwta(52,:) = r53;
finalwta(53,:) = r52;

r52 = newwtashuffledir(52,:);
r53 = newwtashuffledir(53,:);
newwtashuffledir(52,:) = r53;
newwtashuffledir(53,:) = r52;

subplot(1,4,2)
imagesc(finalwta)
colormap jet

%
%
%
%
% j20y
%next, wta
j20ygridhalf = j20y(1:s3,:);
j20yrechalf = j20y(s3+1:end,:);

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

finalj20y = [j20ygridhalf;j20yrechalf];
newj20yshuffledir = [newj20yshuffledirgridhalf; newj20yshuffledirrechalf];

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



subplot(1,4,3)
imagesc(finalj20y)
colormap jet

%
%
%
% j20a
j20agridhalf = j20a(1:s4,:);
j20arechalf = j20a(s4+1:end,:);

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

finalj20a = [j20agridhalf;j20arechalf];
newj20ashuffledir = [newj20ashuffledirgridhalf;newj20ashuffledirrechalf];

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

subplot(1,4,4)
imagesc(finalj20a)
colormap jet

%%
%finally, get the directories
wty_filt9999 = newwtyshuffledir;
wta_filt9999 = newwtashuffledir;
j20y_filt9999 = newj20yshuffledir;
j20a_filt9999 = newj20ashuffledir;

%extra plotting 
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

subplot(1,4,1)
imagesc(finalwty)
colormap jet
xline(104,'r')
xline(209,'r')
xline(314,'r')
xline(419,'r')
xline(524,'r')
xline(629,'r')
subplot(1,4,2)
imagesc(finalwta)
colormap jet
xline(104,'r')
xline(209,'r')
xline(314,'r')
xline(419,'r')
xline(524,'r')
xline(629,'r')
subplot(1,4,3)
imagesc(finalj20y)
colormap jet
xline(104,'r')
xline(209,'r')
xline(314,'r')
xline(419,'r')
xline(524,'r')
xline(629,'r')
subplot(1,4,4)
imagesc(finalj20a)
colormap jet
xline(104,'r')
xline(209,'r')
xline(314,'r')
xline(419,'r')
xline(524,'r')
xline(629,'r')




subplot(1,4,1)
imagesc(finalwty)
colormap jet
xline(52,'r')
xline(157,'r')
xline(262,'r')
xline(366,'r')
xline(471,'r')
xline(576,'r')

xline(157,'g')
xline(314,'g')
xline(471,'g')
xline(629,'g')
subplot(1,4,2)
imagesc(finalwta)
colormap jet
xline(52,'r')
xline(157,'r')
xline(262,'r')
xline(366,'r')
xline(471,'r')
xline(576,'r')

xline(157,'g')
xline(314,'g')
xline(471,'g')
xline(629,'g')
subplot(1,4,3)
imagesc(finalj20y)
colormap jet
xline(52,'r')
xline(157,'r')
xline(262,'r')
xline(366,'r')
xline(471,'r')
xline(576,'r')

xline(157,'g')
xline(314,'g')
xline(471,'g')
xline(629,'g')
subplot(1,4,4)
imagesc(finalj20a)
colormap jet
xline(52,'r')
xline(157,'r')
xline(262,'r')
xline(366,'r')
xline(471,'r')
xline(576,'r')

xline(157,'g')
xline(314,'g')
xline(471,'g')
xline(629,'g')

%%
%pie charts

X = [10,26];
subplot(1,4,1)
pie(X)
colormap([0 0 0 ; 1 1 1])

X = [12,52];
subplot(1,4,2)
pie(X)
colormap([0 0 0 ; 1 1 1])

X = [7,23];
subplot(1,4,3)
pie(X)
colormap([0 0 0 ; 1 1 1])

X = [17,20];
subplot(1,4,4)
pie(X)
colormap([0 0 0 ; 1 1 1])



%Chi squared tests 
n1 = 10;
n2 = 36;
n3 = 12;
n4 = 64;
n5 = 7;
n6 = 30;
n7 = 17;
n8 = 37;

HexaRec = [zeros(n1,1)+1; zeros(n2-n1,1)+2;zeros(n3,1)+1; zeros(n4-n3,1)+2;zeros(n5,1)+1; zeros(n6-n5,1)+2;zeros(n7,1)+1; zeros(n8-n7,1)+2];
Group = [zeros(n2,1)+1; zeros(n4,1)+2;zeros(n6,1)+3;zeros(n8,1)+4];

[tbl,chi2stat,pval] = crosstab(HexaRec,Group)


%One tailed t-test for proportions p values (uncorrected, apply Bonferroni holms)
% nTG-y vs nTG-a: 0.149
% nTG-y vs APP-y: 0.3412
% APP-y vs APP-a: 0.0297
% nTG-a vs APP-a: 0.0022





