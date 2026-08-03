

clear
load('C:\Users\Johnson\Desktop\Code instructions\Figure 1\allcells_col20isgridness.mat')

AnimalsToInclude = [12015,12040,12375,12378,12644,12646,12655,12656,12746,12748,12756,12757, 12758,12759,12784,12785,12786,12787,12788,12790,12791,12792,12794,...
    3530,3532,3534,3601,3630,3631,3683,3781,3782,3783,3784,3791,3792,3794,3795,3798,3799,3827,3828,3884,3885,3894,3895,3927,3928,3931,4012,4014,4015,4020,...
    4117,4118,4125,4574,4593,4598,4599,4623,4754,4756,4757,4847,4849,5035,5036];

Grids = All_DataArray
Genotype = Grids(:,2);
Genotype2 = [];
%0 = J20, 1 = WT

for i=1:length(Genotype)
    if(length(Genotype{i,1})==3)
        Genotype2(i,1) = 0;
    else
        Genotype2(i,1) = 1;
    end
end

Age = cell2mat(Grids(:,3));

%picking out cells in correct age 
wty = Grids((Genotype2==1 & Age>=90 & Age <=135),:); 
finder = ismember(cell2mat(wty(:,1)),AnimalsToInclude);
wty = wty(finder,:);

wta = Grids((Genotype2==1 & Age>135 & Age <=210),:); 
finder = ismember(cell2mat(wta(:,1)),AnimalsToInclude);
wta = wta(finder,:);

j20y = Grids((Genotype2==0 & Age>=90 & Age <=135),:); 
finder = ismember(cell2mat(j20y(:,1)),AnimalsToInclude);
j20y = j20y(finder,:);

j20a = Grids((Genotype2==0 & Age>135 & Age <=210),:); 
finder = ismember(cell2mat(j20a(:,1)),AnimalsToInclude);
j20a = j20a(finder,:);


%
wty_filt999 = wty;
wta_filt999 = wta;
j20y_filt999 = j20y;
j20a_filt999 = j20a;

%% filter out cells based on what we did in prev figure 
load('C:\Users\Johnson\Desktop\Code instructions\Figure 2 - Fourier analysis\1and4components.mat')
load('C:\Users\Johnson\Desktop\Code instructions\Figure 2 - Fourier analysis\emptycells.mat')
load('C:\Users\Johnson\Desktop\Code instructions\Figure 2 - Fourier analysis\removecirclecells.mat')

wta_filt999(wtacircle,:) = [];
j20a_filt999(j20acircle,:) = [];

wty_filt999(wtyempty,:) = [];
wta_filt999(wtaempty,:) = [];
j20y_filt999(j20yempty,:) = [];
j20a_filt999(j20aempty,:) = [];

wty_filt999 = wty_filt999(wtycompo,:);
wta_filt999 = wta_filt999(wtacompo,:);
j20y_filt999 = j20y_filt999(j20ycompo,:);
j20a_filt999 = j20a_filt999(j20acompo,:);

%% reformat things

wty_dir = {};
wta_dir = {};
j20y_dir = {};
j20a_dir = {};

for i = 1:size(wty_filt999)
    wty_dir{i,1} = wty_filt999{i,1};
    wty_dir{i,2} = wty_filt999{i,3};
    wty_dir{i,3} = wty_filt999{i,4}(end-18:end);
    wty_dir{i,4} = [wty_filt999{i,5}, wty_filt999{i,6}];
end
for i = 1:size(wta_filt999)
    wta_dir{i,1} = wta_filt999{i,1};
    wta_dir{i,2} = wta_filt999{i,3};
    wta_dir{i,3} = wta_filt999{i,4}(end-18:end);
    wta_dir{i,4} = [wta_filt999{i,5}, wta_filt999{i,6}];
end
for i = 1:size(j20y_filt999)
    j20y_dir{i,1} = j20y_filt999{i,1};
    j20y_dir{i,2} = j20y_filt999{i,3};
    j20y_dir{i,3} = j20y_filt999{i,4}(end-18:end);
    j20y_dir{i,4} = [j20y_filt999{i,5}, j20y_filt999{i,6}];
end
for i = 1:size(j20a_filt999)
    j20a_dir{i,1} = j20a_filt999{i,1};
    j20a_dir{i,2} = j20a_filt999{i,3};
    j20a_dir{i,3} = j20a_filt999{i,4}(end-18:end);
    j20a_dir{i,4} = [j20a_filt999{i,5}, j20a_filt999{i,6}];
end

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

%going to save this into a mat file so you dont have to re run: 'cell directories.mat'
%%
%% Refer to grid cell version of the script for detailed comments 
clear
load('cell directories.mat')


wty_data = {};

for iii = 1:size(wty_dir,1)
    
    try
    
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
    
    wty_data{iii,1} = alpha1;
    wty_data{iii,2} = finalsignal;
    
    catch
    end
end

%%

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

%%



%% Data that you would obtain from running the above code is in 'ALLCELLS_polar.mat'

clear 
load('ALLCELLS_polar.mat')

%% Figure 2b 
% this will plot cells sorted by 60 degrees, but if you want 90 degrees, comment
% out lines 1206, 1242, 1279, 1317, and uncomment lines 1207, 1243, 1280, 1318
%
% when you plot Figure 3A below, however, you should sort here by 60
% degrees


wtyscores = cell2mat(wty_dir(:,5:9));
wtascores = cell2mat(wta_dir(:,5:9));
j20yscores = cell2mat(j20y_dir(:,5:9));
j20ascores = cell2mat(j20a_dir(:,5:9));

wtyshuffleddir = wty_dir;
wtashuffleddir = wta_dir;
j20yshuffleddir = j20y_dir;
j20ashuffleddir = j20a_dir;

wtyshuffleddata = wty_data;
wtashuffleddata = wta_data;
j20yshuffleddata = j20y_data;
j20ashuffleddata = j20a_data;


wty_data(323,:) = []
wtyscores(323,:) = []
wtyshuffleddir(323,:) = []
wtyshuffleddata(323,:) = []

wty_data(321,:) = []
wtyscores(321,:) = []
wtyshuffleddir(321,:) = []
wtyshuffleddata(321,:) = []

wta_data(461,:) = []
wtascores(461,:) = []
wtashuffleddir(461,:) = []
wtashuffleddata(461,:) = []

j20y_data(554,:) = []
j20yscores(554,:) = []
j20yshuffleddir(554,:) = []
j20yshuffleddata(554,:) = []

j20a_data(200,:) = []
j20ascores(200,:) = []
j20ashuffleddir(200,:) = []
j20ashuffleddata(200,:) = []

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

wty(:,260:360) = 0;
wty(:,1:50) = 0;
wty(:,580:630) = 0;

sixtydegreecolumn = [wty(:,104-4:104+4), wty(:,210-4:210+4), wty(:,421-4:421+4), wty(:,526-4:526+4)]; %60 degrees only
% sixtydegreecolumn = [wty(:,157-4:157+4), wty(:,473-4:473+4)]; %60 degrees only
sixtydegreecolumn = sum(sixtydegreecolumn,2);
[~, idx] = sortrows(sixtydegreecolumn,'descend'); 
wty = wty(idx,:);
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
wta(:,260:360) = 0;
wta(:,1:50) = 0;
wta(:,580:630) = 0;

sixtydegreecolumn = [wta(:,104-4:104+4), wta(:,210-4:210+4), wta(:,421-4:421+4), wta(:,526-4:526+4)]; %60 degrees only
% sixtydegreecolumn = [wta(:,157-4:157+4), wta(:,473-4:473+4)]; %60 degrees only
sixtydegreecolumn = sum(sixtydegreecolumn,2);
[~, idx] = sortrows(sixtydegreecolumn,'descend'); 
wta = wta(idx,:);
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
j20y(:,260:360) = 0;
j20y(:,1:50) = 0;
j20y(:,580:630) = 0;

sixtydegreecolumn = [j20y(:,104-4:104+4), j20y(:,210-4:210+4), j20y(:,421-4:421+4), j20y(:,526-4:526+4)];
% sixtydegreecolumn = [j20y(:,157-4:157+4), j20y(:,473-4:473+4)]; %60 degrees only
sixtydegreecolumn = sum(sixtydegreecolumn,2);
[~, idx] = sortrows(sixtydegreecolumn,'descend'); 
j20y = j20y(idx,:);
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
j20a(:,260:360) = 0;
j20a(:,1:50) = 0;
j20a(:,580:630) = 0;

sixtydegreecolumn = [j20a(:,104-4:104+4), j20a(:,210-4:210+4), j20a(:,421-4:421+4), j20a(:,526-4:526+4)];
% sixtydegreecolumn = [j20a(:,157-4:157+4), j20a(:,473-4:473+4)]; %60 degrees only
sixtydegreecolumn = sum(sixtydegreecolumn,2);
[~, idx] = sortrows(sixtydegreecolumn,'descend'); 
j20a = j20a(idx,:);
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
caxis([0,.75])
% axis square
subplot(1,4,2)
imagesc(wta)
colormap jet
caxis([0,.75])
% axis square
subplot(1,4,3)
imagesc(j20y)
colormap jet
caxis([0,.75])
% axis square
subplot(1,4,4)
imagesc(j20a)
colormap jet
caxis([0,.75])
% axis square


wty20 = round(size(wty,1)*0.2)
wta20 = round(size(wta,1)*0.2)
j20y20 = round(size(j20y,1)*0.2)
j20a20 = round(size(j20a,1)*0.2)



% subplot(1,4,1)
% imagesc(wty(1:wty20,:))
% colormap jet
% caxis([0,.75])
% axis square
% subplot(1,4,2)
% imagesc(wta(1:wta20,:))
% colormap jet
% caxis([0,.75])
% axis square
% subplot(1,4,3)
% imagesc(j20y(1:j20y20,:))
% colormap jet
% caxis([0,.75])
% axis square
% subplot(1,4,4)
% imagesc(j20a(1:j20a20,:))
% colormap jet
% caxis([0,.75])
% axis square




%%
%%
%%
%% Figure 3A 

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

%
%points at which the grids stop
s1 = 86;
s2 = 90;
s3 = 63;
s4 = 89;

% % 
% % wtyshuffleddir = wtyshuffleddir(s1+1:end,:);
% % wtashuffleddir = wtashuffleddir(s2+1:end,:);
% % j20yshuffleddir = j20yshuffleddir(s3+1:end,:);
% % j20ashuffleddir = j20ashuffleddir(s4+1:end,:);



wtygridhalf = wty(1:s1,:);
wtyrechalf = wty(s1+1:end,:);

%later for figure 5
wtygriddycells = wtyshuffleddir(1:s1,:);
wtyrectanglecells = wtyshuffleddir(s1+1:end,:);


%lets work with wty first 
sixtydegreecolumn = [wtyrechalf(:,157-6:157+6), wtyrechalf(:,314-6:314+6), wtyrechalf(:,471-6:471+6), wtyrechalf(:,629-6:629)]; %90 degrees only

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = nanmean(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'ascend');

wtyrechalf = wtyrechalf(idx,:);

wtyrectanglecells = wtyrectanglecells(idx,:);


%lets work with wty first 
sixtydegreecolumn = [wtygridhalf(:,52-6:52+6), wtygridhalf(:,262-6:262+6), wtygridhalf(:,366-6:366+6), wtygridhalf(:,157-6:157+6), wtygridhalf(:,471-6:471+6)];
%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'descend');

wtygridhalf = wtygridhalf(idx,:);

wtygriddycells = wtygriddycells(idx,:);

finalwty = [wtygridhalf;wtyrechalf];

%and sort again the 60degree grids 
%62
wtygridhalffirst = wtygridhalf(1:62,:)
wtygridhalfsecond = wtygridhalf(63:end,:)

sixtydegreecolumn = [wtygridhalfsecond(:,105-6:105+6), wtygridhalfsecond(:,210-6:210+6), wtygridhalfsecond(:,315-6:315+6), wtygridhalfsecond(:,421-6:421+6), wtygridhalfsecond(:,526-6:526+6)];
%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'descend');

wtygridhalfsecond = wtygridhalfsecond(idx,:);

finalwty = [wtygridhalffirst;wtygridhalfsecond;wtyrechalf];


subplot(1,4,1)
imagesc(finalwty)
colormap jet

%
%
%next, wta

wtagridhalf = wta(1:s1,:);
wtarechalf = wta(s1+1:end,:);

wtagriddycells = wtashuffleddir(1:s1,:);
wtarectanglecells = wtashuffleddir(s1+1:end,:);

%lets work with wta first 
sixtydegreecolumn = [wtarechalf(:,157-6:157+6), wtarechalf(:,314-6:314+6), wtarechalf(:,471-6:471+6), wtarechalf(:,629-6:629)]

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = nanmean(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'ascend');

wtarechalf = wtarechalf(idx,:);

wtarectanglecells = wtarectanglecells(idx,:);

%lets work with wta first 
sixtydegreecolumn = [wtagridhalf(:,52), wtagridhalf(:,262), wtagridhalf(:,366), wtagridhalf(:,157), wtagridhalf(:,471)];
% sixtydegreecolumn = [wtagridhalf(:,102:106), wtagridhalf(:,207:211), wtagridhalf(:,417:421), wtagridhalf(:,522:526)];

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'descend');

wtagridhalf = wtagridhalf(idx,:);

wtagriddycells = wtagriddycells(idx,:);

finalwta = [wtagridhalf;wtarechalf];


subplot(1,4,2)
imagesc(finalwta)
colormap jet

%
%
% j20y
%next, wta

j20ygridhalf = j20y(1:s1,:);
j20yrechalf = j20y(s1+1:end,:);

j20ygriddycells = j20yshuffleddir(1:s1,:);
j20yrectanglecells = j20yshuffleddir(s1+1:end,:);

%lets work with j20y first 
sixtydegreecolumn = [j20yrechalf(:,157), j20yrechalf(:,314), j20yrechalf(:,471), j20yrechalf(:,629)]; %90 degrees only

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'ascend');

j20yrechalf = j20yrechalf(idx,:);

j20yrectanglecells = j20yrectanglecells(idx,:);


%lets work with j20y first 
% sixtydegreecolumn = [j20ygridhalf(:,52), j20ygridhalf(:,262), j20ygridhalf(:,366), j20ygridhalf(:,157), j20ygridhalf(:,471)];
sixtydegreecolumn = [j20ygridhalf(:,100:108), j20ygridhalf(:,205:213), j20ygridhalf(:,415:423), j20ygridhalf(:,520:528)];

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'ascend');

j20ygridhalf = j20ygridhalf(idx,:);

j20ygriddycells = j20ygriddycells(idx,:);

finalj20y = [j20ygridhalf;j20yrechalf];


%take block 43-53 and move this after row 86
takeout = finalj20y(43:53,:)
finalj20y2 = finalj20y;
after87 = finalj20y2(87:end,:)
before87 = finalj20y2(1:86,:)
before87(43:53,:) = []
before87 = [before87; takeout]
finalj20y = [before87;after87]

%rows 76-80 and 82-86 move after 123
takeout = [finalj20y(76:80,:); finalj20y(82:86,:)];
finalj20y2 = finalj20y;
after124 = finalj20y2(124:end,:);
before124 = finalj20y2(1:123,:);
before124(82:86,:) = []
before124(76:80,:) = []
before124 = [before124; takeout]
finalj20y = [before124;after124]


%rows 114-123 and move after 138
takeout = [finalj20y(114:123,:)];
finalj20y2 = finalj20y;
after138 = finalj20y2(139:end,:);
before138 = finalj20y2(1:138,:);
before138(114:123,:) = []
before138 = [before138; takeout]
finalj20y = [before138;after138]



subplot(1,4,3)
imagesc(finalj20y)
colormap jet

%
%
%
% j20a

j20agridhalf = j20a(1:s1,:);
j20arechalf = j20a(s1+1:end,:);

j20agriddycells = j20ashuffleddir(1:s1,:);
j20arectanglecells = j20ashuffleddir(s1+1:end,:);

%lets work with j20a first 
sixtydegreecolumn = [j20arechalf(:,157), j20arechalf(:,314), j20arechalf(:,471), j20arechalf(:,629)]; %90 degrees only

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'ascend');

j20arechalf = j20arechalf(idx,:);

j20arectanglecells = j20arectanglecells(idx,:);


%lets work with j20a first 
% sixtydegreecolumn = [j20agridhalf(:,52), j20agridhalf(:,262), j20agridhalf(:,366), j20agridhalf(:,157), j20agridhalf(:,471)];
sixtydegreecolumn = [j20agridhalf(:,102:106), j20agridhalf(:,207:211), j20agridhalf(:,417:421), j20agridhalf(:,522:526)];

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'ascend');

j20agridhalf = j20agridhalf(idx,:);

j20agriddycells = j20agriddycells(idx,:);

finalj20a = [j20agridhalf;j20arechalf];



%take rows 42-45, 48,52, 54-63, and move after row 82
takeout = [finalj20a(42:45,:);finalj20a(48:52,:); finalj20a(54:63,:)];
finalj20a2 = finalj20a;
after83 = finalj20a2(83:end,:)
before83 = finalj20a2(1:83,:)

before83(54:63,:) = []
before83(48:52,:) = []
before83(42:45,:) = []

before83 = [before83; takeout]
finalj20a = [before83;after83]



%rows 65-83 and move after 159
takeout = [finalj20a(65:83,:)];
finalj20a2 = finalj20a;
after159 = finalj20a2(160:end,:);
before159 = finalj20a2(1:159,:);
before159(65:83,:) = []
before159 = [before159; takeout]
finalj20a = [before159;after159]


subplot(1,4,4)
imagesc(finalj20a)
colormap jet

%% Figure 3A

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

%top 20% of cells
subplot(1,4,1)
imagesc(finalwty(1:wty20,:))
title('nTG-y')
colormap jet
subplot(1,4,2)
imagesc(finalwta(1:wta20,:))
colormap jet
title('nTG-a')
subplot(1,4,3)
imagesc(finalj20y(1:j20y20,:))
title('APP-y')
colormap jet
subplot(1,4,4)
imagesc(finalj20a(1:j20a20,:))
title('APP-a')
colormap jet


% subplot(1,4,1)
% imagesc(wtyrechalf)
% colormap jet
% subplot(1,4,2)
% imagesc(wtarechalf)
% colormap jet
% subplot(1,4,3)
% imagesc(j20yrechalf)
% colormap jet
% subplot(1,4,4)
% imagesc(j20arechalf)
% colormap jet

%point at which clear rectangular modulation stops
ss1 = 9;
ss2 = 5;
ss3 = 2;
ss4 = 27;

wtyrectanglecells2 = wtyrectanglecells(ss1+1:end,:);
wtarectanglecells2 = wtarectanglecells(ss2+1:end,:);
j20yrectanglecells2 = j20yrectanglecells(ss3+1:end,:);
j20arectanglecells2 = j20arectanglecells(ss4+1:end,:);

% %add some cells from the hex group into rec group for j20a
% subplot(1,4,1)
% imagesc(wtygridhalf)
% colormap jet
% subplot(1,4,2)
% imagesc(wtagridhalf)
% colormap jet
% subplot(1,4,3)
% imagesc(j20ygridhalf)
% colormap jet
% subplot(1,4,4)
% imagesc(j20agridhalf)
% colormap jet






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



%Running stats on clear rectangular cells only 

%new updated version
wtyrecstart = 146
wtarecstart = 183
j20yrecstart = 129
j20arecstart = 141

wtyrecamount = size(wty,1) - wtyrecstart
wtarecamount = size(wta,1) - wtarecstart
j20yrecamount = size(j20y,1) - j20yrecstart
j20arecamount = size(j20a,1) - j20arecstart

wtyrecproportion = wtyrecamount/size(wty,1) 
wtarecproportion = wtarecamount/size(wta,1) 
j20yrecproportion = j20yrecamount/size(j20y,1) 
j20arecproportion = j20arecamount/size(j20a,1) 

%binomial test
avg = (wtyrecproportion + wtarecproportion + j20yrecproportion + j20arecproportion)/4

binopdf(wtyrecamount, size(wty,1), avg)
binopdf(wtarecamount, size(wta,1), avg)
binopdf(j20yrecamount, size(j20y,1), avg)
binopdf(j20arecamount, size(j20a,1), avg)


bar([wtyrecproportion , wtarecproportion , j20yrecproportion , j20arecproportion])
axis square
ylim([0.7,0.9])
yline(avg,'r')

%Chi squared test
n1 = wtyrecamount;
n2 = size(wty,1);
n3 = wtarecamount;
n4 = size(wta,1);
n5 = j20yrecamount;
n6 =  size(j20y,1);
n7 = j20arecamount;
n8 = size(j20a,1);

HexaRec = [zeros(n1,1)+1; zeros(n2-n1,1)+2;zeros(n3,1)+1; zeros(n4-n3,1)+2;zeros(n5,1)+1; zeros(n6-n5,1)+2;zeros(n7,1)+1; zeros(n8-n7,1)+2];
Group = [zeros(n2,1)+1; zeros(n4,1)+2;zeros(n6,1)+3;zeros(n8,1)+4];

[tbl,chi2stat,pval] = crosstab(HexaRec,Group)


%%
%pie charts

X = [wtyrecamount,wtyrecstart];
subplot(1,4,1)
pie(X)
colormap([0 0 0 ; 1 1 1])

X = [wtarecamount,wtarecstart];
subplot(1,4,2)
pie(X)
colormap([0 0 0 ; 1 1 1])

X = [j20yrecamount,j20yrecstart];
subplot(1,4,3)
pie(X)
colormap([0 0 0 ; 1 1 1])

X = [j20arecamount,j20arecstart];
subplot(1,4,4)
pie(X)
colormap([0 0 0 ; 1 1 1])






%%%%%% same but for hexagonal ends

%points at which the hex ends

wtyhexstart = 81
wtahexstart = 86
j20yhexstart = 76
j20ahexstart = 64

wtyhexproportion = wtyhexstart/size(wty,1) 
wtahexproportion = wtahexstart/size(wta,1) 
j20yhexproportion = j20yhexstart/size(j20y,1) 
j20ahexproportion = j20ahexstart/size(j20a,1) 

%binomial test
avg = (wtyhexproportion + wtahexproportion + j20yhexproportion + j20ahexproportion)/4

binopdf(wtyhexstart, size(wty,1), avg)
binopdf(wtahexstart, size(wta,1), avg)
binopdf(j20yhexstart, size(j20y,1), avg)
binopdf(j20ahexstart, size(j20a,1), avg)


bar([wtyhexproportion , wtahexproportion , j20yhexproportion , j20ahexproportion])
axis square
% ylim([0.7,0.9])
yline(avg,'r')


%Chi squared test
n1 = wtyhexstart;
n2 = size(wty,1);
n3 = wtahexstart;
n4 = size(wta,1);
n5 = j20yhexstart;
n6 =  size(j20y,1);
n7 = j20ahexstart;
n8 = size(j20a,1);

HexaRec = [zeros(n1,1)+1; zeros(n2-n1,1)+2;zeros(n3,1)+1; zeros(n4-n3,1)+2;zeros(n5,1)+1; zeros(n6-n5,1)+2;zeros(n7,1)+1; zeros(n8-n7,1)+2];
Group = [zeros(n2,1)+1; zeros(n4,1)+2;zeros(n6,1)+3;zeros(n8,1)+4];

[tbl,chi2stat,pval] = crosstab(HexaRec,Group)


%%
%pie charts

X = [wtyhexstart,size(wty,1) - wtyhexstart];
subplot(1,4,1)
pie(X)
colormap([1 1 1; 0 0 0])

X = [wtahexstart,size(wta,1) - wtahexstart];
subplot(1,4,2)
pie(X)
colormap([1 1 1; 0 0 0])

X = [j20yhexstart,size(j20y,1) - j20yhexstart];
subplot(1,4,3)
pie(X)
colormap([1 1 1; 0 0 0])

X = [j20ahexstart,size(j20a,1) - j20ahexstart];
subplot(1,4,4)
pie(X)
colormap([1 1 1; 0 0 0])









