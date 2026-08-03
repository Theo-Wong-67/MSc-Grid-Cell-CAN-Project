
%Load grid cell data
clear 
load('C:\Users\Johnson\Desktop\moto\2d spatial fourier\rotation fourier verification\griddata.mat')


%% extract some Fourier component information
% similar idea to Figure 2

wty_dir = wtyshuffleddir;
wty_data = {};

for iii = 1:size(wty_dir,1)
    
    try
    
        %standard code, load cell, create rate map
        disp(iii)
        clear root
        load(wty_dir{iii,3});
        cel = wty_dir{iii,4};

        %create a rotated version of the rate map 
        modded = root;
        newposx = root.x;
        newposy = root.y;
        
        %rotate trajectories
        theta = 45; % to rotate 45 counterclockwise
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

        points = [newposx' ; newposy'];
        rotpoint = R*points;
        
        newposx = rotpoint(1,:)';
        newposy = rotpoint(2,:)';
        %new ts
        newts = root.ts;
        
        %modify self to reflect these new changes 
        modded.b_x = newposx;
        modded.b_y = newposy;
        
        %next, modify cell spike times in this root. object to match the new changes 
        spikei = root.spike(cel(1),cel(2)).i;
        newspikei = spikei;
        newspikets = root.ts(newspikei);
        
        newnewspikei = [];
        
        for i = 1:size(newspikets,1)
            for j =1:size(newts,1)
                if newts(j) == newspikets(i)
                    newnewspikei = [newnewspikei; j];
                    continue;
                end
            end
        end
                    
        modded.spike(cel(1),cel(2)).i = newnewspikei;
        modded.spike(cel(1),cel(2)).ts = newspikets;

        
        [oc, xdim, ydim] = modded.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        import CMBHOME.Utils.*
        
        fr = length(modded.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
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
        %
        %note, you could also use the shuffled powers from voronoi
        %segmentation in Figure 1, and it would yield same results
        %
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
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
        
        %same code as in Figure 1 to compute polar plots
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

%% now repeat for other 3 mouse groups

wta_dir = wtashuffleddir;
wta_data = {};

for iii = 1:size(wta_dir,1)
    
    try
    
        %standard code, load cell, create rate map
        disp(iii)
        clear root
        load(wta_dir{iii,3});
        cel = wta_dir{iii,4};

        %create a rotated version of the rate map 
        modded = root;
        newposx = root.x;
        newposy = root.y;
        
        %rotate trajectories
        theta = 45; % to rotate 45 counterclockwise
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

        points = [newposx' ; newposy'];
        rotpoint = R*points;
        
        newposx = rotpoint(1,:)';
        newposy = rotpoint(2,:)';
        %new ts
        newts = root.ts;
        
        %modify self to reflect these new changes 
        modded.b_x = newposx;
        modded.b_y = newposy;
        
        %next, modify cell spike times in this root. object to match the new changes 
        spikei = root.spike(cel(1),cel(2)).i;
        newspikei = spikei;
        newspikets = root.ts(newspikei);
        
        newnewspikei = [];
        
        for i = 1:size(newspikets,1)
            for j =1:size(newts,1)
                if newts(j) == newspikets(i)
                    newnewspikei = [newnewspikei; j];
                    continue;
                end
            end
        end
                    
        modded.spike(cel(1),cel(2)).i = newnewspikei;
        modded.spike(cel(1),cel(2)).ts = newspikets;

        
        [oc, xdim, ydim] = modded.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        import CMBHOME.Utils.*
        
        fr = length(modded.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
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
        %
        %note, you could also use the shuffled powers from voronoi
        %segmentation in Figure 1, and it would yield same results
        %
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
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
        
        %same code as in Figure 1 to compute polar plots
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
        wta_data{iii,1} = alpha1;
        wta_data{iii,2} = finalsignal;
        
    catch
    end
end

%% APP-y

j20y_dir = j20yshuffleddir;
j20y_data = {};

for iii = 1:size(j20y_dir,1)
    
    try
    
        %standard code, load cell, create rate map
        disp(iii)
        clear root
        load(j20y_dir{iii,3});
        cel = j20y_dir{iii,4};

        %create a rotated version of the rate map 
        modded = root;
        newposx = root.x;
        newposy = root.y;
        
        %rotate trajectories
        theta = 45; % to rotate 45 counterclockwise
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

        points = [newposx' ; newposy'];
        rotpoint = R*points;
        
        newposx = rotpoint(1,:)';
        newposy = rotpoint(2,:)';
        %new ts
        newts = root.ts;
        
        %modify self to reflect these new changes 
        modded.b_x = newposx;
        modded.b_y = newposy;
        
        %next, modify cell spike times in this root. object to match the new changes 
        spikei = root.spike(cel(1),cel(2)).i;
        newspikei = spikei;
        newspikets = root.ts(newspikei);
        
        newnewspikei = [];
        
        for i = 1:size(newspikets,1)
            for j =1:size(newts,1)
                if newts(j) == newspikets(i)
                    newnewspikei = [newnewspikei; j];
                    continue;
                end
            end
        end
                    
        modded.spike(cel(1),cel(2)).i = newnewspikei;
        modded.spike(cel(1),cel(2)).ts = newspikets;

        
        [oc, xdim, ydim] = modded.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        import CMBHOME.Utils.*
        
        fr = length(modded.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
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
        %
        %note, you could also use the shuffled powers from voronoi
        %segmentation in Figure 1, and it would yield same results
        %
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
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
        
        %same code as in Figure 1 to compute polar plots
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
        j20y_data{iii,1} = alpha1;
        j20y_data{iii,2} = finalsignal;
        
    catch
    end
end

%% APP-a

j20a_dir = j20ashuffleddir;
j20a_data = {};

for iii = 1:size(j20a_dir,1)
    
    try
    
        %standard code, load cell, create rate map
        disp(iii)
        clear root
        load(j20a_dir{iii,3});
        cel = j20a_dir{iii,4};

        %create a rotated version of the rate map 
        modded = root;
        newposx = root.x;
        newposy = root.y;
        
        %rotate trajectories
        theta = 45; % to rotate 45 counterclockwise
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

        points = [newposx' ; newposy'];
        rotpoint = R*points;
        
        newposx = rotpoint(1,:)';
        newposy = rotpoint(2,:)';
        %new ts
        newts = root.ts;
        
        %modify self to reflect these new changes 
        modded.b_x = newposx;
        modded.b_y = newposy;
        
        %next, modify cell spike times in this root. object to match the new changes 
        spikei = root.spike(cel(1),cel(2)).i;
        newspikei = spikei;
        newspikets = root.ts(newspikei);
        
        newnewspikei = [];
        
        for i = 1:size(newspikets,1)
            for j =1:size(newts,1)
                if newts(j) == newspikets(i)
                    newnewspikei = [newnewspikei; j];
                    continue;
                end
            end
        end
                    
        modded.spike(cel(1),cel(2)).i = newnewspikei;
        modded.spike(cel(1),cel(2)).ts = newspikets;

        
        [oc, xdim, ydim] = modded.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        import CMBHOME.Utils.*
        
        fr = length(modded.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
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
        %
        %note, you could also use the shuffled powers from voronoi
        %segmentation in Figure 1, and it would yield same results
        %
        allpowers = [];
        for iter = 1:50
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
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
        
        %same code as in Figure 1 to compute polar plots
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
        j20a_data{iii,1} = alpha1;
        j20a_data{iii,2} = finalsignal;
        
    catch
    end
end

%% visualize polar plots and fourier spectrums
% note the 45 degree counterclockwise rotation 

%polar plots
count = 1;
for i = 1:60
    
%     p = wty_data{i,2};
%     p = wta_data{i,2};
%     p = j20y_data{i,2};
    p = j20a_data{i,2};

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
    
%     p = wty_data{i,3};
%     p = wta_data{i,3};
%     p = j20y_data{i,3};
    p = j20a_data{i,3};

    subplot(6,10,count);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;
end

% For later reference, I saved into workspace a .mat workspace called 'grid_polar_rotation'. Msg me if you require this file

%%


clear
load('grid_polar_rotation.mat')

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

%%

%end indices for hexagonally modulated grid cells
s1 = 22;
s2 = 35;
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
% image thresholds of what should be considerd a Fourier component

wty_data2 = {};

for iii = 1:size(wtycorrectdir,1)
    
    try
    
        disp(iii)
        clear root
        load(wtycorrectdir{iii,3});
        cel = wtycorrectdir{iii,4};
        
        %create a rotated version of the rate map 
        modded = root;
        newposx = root.x;
        newposy = root.y;
        
        %rotate trajectories
        theta = 45; % to rotate 45 counterclockwise
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

        points = [newposx' ; newposy'];
        rotpoint = R*points;
        
        newposx = rotpoint(1,:)';
        newposy = rotpoint(2,:)';
        %new ts
        newts = root.ts;
        
        %modify self to reflect these new changes 
        modded.b_x = newposx;
        modded.b_y = newposy;
        
        %next, modify cell spike times in this root. object to match the new changes 
        spikei = root.spike(cel(1),cel(2)).i;
        newspikei = spikei;
        newspikets = root.ts(newspikei);
        
        newnewspikei = [];
        
        for i = 1:size(newspikets,1)
            for j =1:size(newts,1)
                if newts(j) == newspikets(i)
                    newnewspikei = [newnewspikei; j];
                    continue;
                end
            end
        end
                    
        modded.spike(cel(1),cel(2)).i = newnewspikei;
        modded.spike(cel(1),cel(2)).ts = newspikets;


        [oc, xdim, ydim] = modded.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        import CMBHOME.Utils.*
        
        fr = length(modded.spike(cel(1), cel(2)).i)/(length(root.ts)/29.97);  %mean firing rate
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
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(modded.spike(cel(1), cel(2)).i)/(length(modded.ts)/29.97);  %mean firing rate
            
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
        
        if iii == 4 %special case
            threshold = 0.45*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        elseif iii == 6 %special case
            threshold = 0.45*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        elseif iii == 7 %special case
            threshold = 0.65*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        else
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
        
        %create a rotated version of the rate map 
        modded = root;
        newposx = root.x;
        newposy = root.y;
        
        %rotate trajectories
        theta = 45; % to rotate 45 counterclockwise
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

        points = [newposx' ; newposy'];
        rotpoint = R*points;
        
        newposx = rotpoint(1,:)';
        newposy = rotpoint(2,:)';
        %new ts
        newts = root.ts;
        
        %modify self to reflect these new changes 
        modded.b_x = newposx;
        modded.b_y = newposy;
        
        %next, modify cell spike times in this root. object to match the new changes 
        spikei = root.spike(cel(1),cel(2)).i;
        newspikei = spikei;
        newspikets = root.ts(newspikei);
        
        newnewspikei = [];
        
        for i = 1:size(newspikets,1)
            for j =1:size(newts,1)
                if newts(j) == newspikets(i)
                    newnewspikei = [newnewspikei; j];
                    continue;
                end
            end
        end
                    
        modded.spike(cel(1),cel(2)).i = newnewspikei;
        modded.spike(cel(1),cel(2)).ts = newspikets;


        [oc, xdim, ydim] = modded.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        import CMBHOME.Utils.*
        
        fr = length(modded.spike(cel(1), cel(2)).i)/(length(modded.ts)/29.97);  %mean firing rate
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
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(modded.spike(cel(1), cel(2)).i)/(length(modded.ts)/29.97);  %mean firing rate
            
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
        
%         if iii == 11 || iii == 22
%             threshold = 0.35*maxfpower;
%         else
            threshold = 0.45*maxfpower;
%         end
        
        f = powr3 > threshold;
        powr3 = powr3 .* f;
        
        
        if iii == 5 %special case
            threshold = 0.6*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 7 %special case
            threshold = 0.75*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 16 %special case
            threshold = 0.60*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 19 %special case
            threshold = 0.5*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 21 %special case
            threshold = 0.75*maxfpower;
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
        
        %create a rotated version of the rate map 
        modded = root;
        newposx = root.x;
        newposy = root.y;
        
        %rotate trajectories
        theta = 45; % to rotate 45 counterclockwise
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

        points = [newposx' ; newposy'];
        rotpoint = R*points;
        
        newposx = rotpoint(1,:)';
        newposy = rotpoint(2,:)';
        %new ts
        newts = root.ts;
        
        %modify self to reflect these new changes 
        modded.b_x = newposx;
        modded.b_y = newposy;
        
        %next, modify cell spike times in this root. object to match the new changes 
        spikei = root.spike(cel(1),cel(2)).i;
        newspikei = spikei;
        newspikets = root.ts(newspikei);
        
        newnewspikei = [];
        
        for i = 1:size(newspikets,1)
            for j =1:size(newts,1)
                if newts(j) == newspikets(i)
                    newnewspikei = [newnewspikei; j];
                    continue;
                end
            end
        end
                    
        modded.spike(cel(1),cel(2)).i = newnewspikei;
        modded.spike(cel(1),cel(2)).ts = newspikets;


        [oc, xdim, ydim] = modded.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        import CMBHOME.Utils.*
        
        fr = length(modded.spike(cel(1), cel(2)).i)/(length(modded.ts)/29.97);  %mean firing rate
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
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(modded.spike(cel(1), cel(2)).i)/(length(modded.ts)/29.97);  %mean firing rate
            
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
            threshold = 0.56*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 5 %special case
            threshold = 0.7*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end        
        if iii == 6 %special case
            threshold = 0.55*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 8 %special case
            threshold = 0.65*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 10 %special case
            threshold = 0.65*maxfpower;
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

% for iii = 1:size(j20acorrectdir,1)
for iii = 3:3
    try
    
        disp(iii)
        clear root
        load(j20acorrectdir{iii,3});
        cel = j20acorrectdir{iii,4};
        
        %create a rotated version of the rate map 
        modded = root;
        newposx = root.x;
        newposy = root.y;
        
        %rotate trajectories
        theta = 45; % to rotate 45 counterclockwise
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

        points = [newposx' ; newposy'];
        rotpoint = R*points;
        
        newposx = rotpoint(1,:)';
        newposy = rotpoint(2,:)';
        %new ts
        newts = root.ts;
        
        %modify self to reflect these new changes 
        modded.b_x = newposx;
        modded.b_y = newposy;
        
        %next, modify cell spike times in this root. object to match the new changes 
        spikei = root.spike(cel(1),cel(2)).i;
        newspikei = spikei;
        newspikets = root.ts(newspikei);
        
        newnewspikei = [];
        
        for i = 1:size(newspikets,1)
            for j =1:size(newts,1)
                if newts(j) == newspikets(i)
                    newnewspikei = [newnewspikei; j];
                    continue;
                end
            end
        end
                    
        modded.spike(cel(1),cel(2)).i = newnewspikei;
        modded.spike(cel(1),cel(2)).ts = newspikets;

        [oc, xdim, ydim] = modded.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making bins bigger
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        [rate_map1, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0);
        [rate_map2, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 4, 'std_smooth_kernel', 4);
        
        import CMBHOME.Utils.*
        
        fr = length(modded.spike(cel(1), cel(2)).i)/(length(modded.ts)/29.97);  %mean firing rate
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

        if(iii==9 || iii == 24)
            width = 2;
        end

        if(iii==2 || iii == 3 || iii == 25)
            width = 1.5;
        end

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
            [rate_map_shuf, ~, ~, occupancy1, occupancy2] = modded.RateMap(cel, 'xdim', xdim2, 'ydim', ydim2, 'binside', 0, 'std_smooth_kernel', 0, 'do_shuffled',logical(1));
            fr = length(modded.spike(cel(1), cel(2)).i)/(length(modded.ts)/29.97);  %mean firing rate
            
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
        
        if iii == 3 || iii == 9 || iii == 12
            threshold = 0.27*maxfpower;
        elseif iii == 10
            threshold = 0.30*maxfpower;
        else
            threshold = 0.45*maxfpower;
        end
        f = powr3 > threshold;
        powr3 = powr3 .* f;
        
        

        if iii == 3 %special case
            threshold = 0.5*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end

        if iii == 5 %special case
            threshold = 0.7*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end

        if iii == 11 %special case
            threshold = 0.60*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 15 %special case
            threshold = 0.55*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end        
        if iii == 19 %special case
            threshold = 0.60*maxfpower;
            f = powr3 > threshold;
            powr3 = powr3 .* f;
        end
        if iii == 27 %special case
            threshold = 0.60*maxfpower;
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

%ntg-y
%1,4,6,7, are grids 
%needs manual threshold 4,6,7

count = 1;
for i = 1:60
    
    p = wty_data2{i,2};
    
    pax = subplot(6,10,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
    pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    count = count + 1;
end

count = 1;
for i = 1:60
    padsize = 110;
    p = wty_data2{i,3};
    
    subplot(6,10,count);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;
end

count = 1;
for i = 1:60
    padsize = 110;
    p = wty_data2{i,4};
    
    subplot(6,10,count);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;
end

%wta
%
%manual 5 7 16 19 21
count = 1;
for i = 1:60
    
    p = wta_data2{i,2};
    
    pax = subplot(6,10,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
    pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    count = count + 1;
    title(i)
end

count = 1;
for i = 1:60
    padsize = 110;
    p = wta_data2{i,3};
    
    subplot(6,10,count);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;
end

count = 1;
for i = 1:60
    padsize = 110;
    p = wta_data2{i,4};
    
    subplot(6,10,count);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    title(i)
    count = count + 1;
end


%j20y
%
%needs manual threshold: 5 6 8 10 2
count = 1;
for i = 1:60
    
    p = j20y_data2{i,2};
    
    pax = subplot(6,10,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
    pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    count = count + 1;
    title(i)
end

count = 1;
for i = 1:60
    padsize = 110;
    p = j20y_data2{i,3};
    
    subplot(6,10,count);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;
end

count = 1;
for i = 1:60
    padsize = 110;
    p = j20y_data2{i,4};
    
    subplot(6,10,count);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;
end


%j20a
%3,10,12 needs to be lower
%11,15,19,27

%2 5 24 25 look too messy

count = 1;
for i = 1:60
    
    p = j20a_data2{i,2};
    
    pax = subplot(6,10,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
    pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    count = count + 1;
    title(i)
end

count = 1;
for i = 1:60
    padsize = 110;
    p = j20a_data2{i,3};
    
    subplot(6,10,count);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;
end

count = 1;
for i = 1:60
    padsize = 110;
    p = j20a_data2{i,4};
    
    subplot(6,10,count);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;
end


%% now... add these corrected cells back to originally good cells data 


wty_data = [wtynormal; wty_data2(:,1:3)];
wta_data = [wtanormal; wta_data2(:,1:3)];
j20y_data = [j20ynormal; j20y_data2(:,1:3)];
j20a_data = [j20anormal; j20a_data2(:,1:3)];

% If you ran this code properly, you should save workspace as 'grid_polars_rotation_CORRECTED_BAD_CELLS'.
% again, msg me if you would like my version of this workspace for comparison purposes

clear 
load('C:\Users\Johnson\Desktop\moto\2d spatial fourier\rotation fourier verification\grid_polars_rotation_CORRECTED_BAD_CELLS.mat')
% load('C:\Users\Johnson\Desktop\moto\2d spatial fourier\rotation fourier verification\grid_polars_rotation_CORRECTED_BAD_CELLS2.mat')

%% polar autocorrelations

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

%Plot polar autocorrelations
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

%gridness scores 
s1 = 25;
s2 = 46;
s3 = 22;
s4 = 17;

% id = 1; %mean firing
% id = 2; %peak firing
% id = 3; %spt info
% id = 4; %MRL
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

%% Spatial alignment plots 

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
s1 = 25;
s2 = 46;
s3 = 22;
s4 = 19;

wtygridhalf = wty(1:s1,:);
wtyrechalf = wty(s1+1:end,:);

newwtyshuffledirgridhalf = newwtyshuffledir(1:s1,:);
newwtyshuffledirrechalf = newwtyshuffledir(s1+1:end,:);

%lets work with wty first 
sixtydegreecolumn = [wtygridhalf(:,78), wtygridhalf(:,183), wtygridhalf(:,288), wtygridhalf(:,393), wtygridhalf(:,497)];
%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'descend');

wtygridhalf = wtygridhalf(idx,:);
newwtyshuffledirgridhalf = newwtyshuffledirgridhalf(idx, :);

finalwty = [wtygridhalf;wtyrechalf];
newwtyshuffledir = [newwtyshuffledirgridhalf;newwtyshuffledirrechalf];

%rows 6 11 15 16 18 26 all go to beginning
r6 = finalwty(6,:);
r11 = finalwty(11,:);
r15 = finalwty(15,:);
r16 = finalwty(16,:);
r18 = finalwty(18,:);
r26 = finalwty(26,:);

finalwty([6,11,15,16,18,26],:) = []
newfinalwty = [r15;r16;r6;r11;r18;r26];
finalwty = [newfinalwty; finalwty];

r6 = newwtyshuffledir(6,:);
r11 = newwtyshuffledir(11,:);
r15 = newwtyshuffledir(15,:);
r16 = newwtyshuffledir(16,:);
r18 = newwtyshuffledir(18,:);
r26 = newwtyshuffledir(26,:);

newnewwtyshuffledir = newwtyshuffledir([15,16,6,11,18,26],:);
newwtyshuffledir([6,11,15,16,18,26],:) = [];
newwtyshuffledir = [newnewwtyshuffledir; newwtyshuffledir];

%rows 24-27 need to be reversed
%switch rows 24 with 27
r24 = finalwty(24,:);
r27 = finalwty(27,:);
finalwty(27,:) = r24;
finalwty(24,:) = r27;

r24 = newwtyshuffledir(24,:);
r27 = newwtyshuffledir(27,:);
newwtyshuffledir(24,:) = r27;
newwtyshuffledir(27,:) = r24;

%switch rows 20 with 24
r20 = finalwty(20,:);
r24 = finalwty(24,:);
finalwty(24,:) = r20;
finalwty(20,:) = r24;

r20 = newwtyshuffledir(20,:);
r24 = newwtyshuffledir(24,:);
newwtyshuffledir(20,:) = r24;
newwtyshuffledir(24,:) = r20;

%switch rows 25 with 26
r25 = finalwty(25,:);
r26 = finalwty(26,:);
finalwty(26,:) = r25;
finalwty(25,:) = r26;

r25 = newwtyshuffledir(25,:);
r26 = newwtyshuffledir(26,:);
newwtyshuffledir(25,:) = r26;
newwtyshuffledir(26,:) = r25;

subplot(1,4,1)
imagesc(finalwty)
colormap jet
xline(1.75 * 45,'r')
xline(1.75 * 135,'r')
xline(1.75 * 225,'r')
xline(1.75 * 315,'r')

subplot(1,4,1)
imagesc(finalwty)
colormap jet
xline(1.75 * 345,'r')
xline(1.75 * 45,'r')
xline(1.75 * 105,'r')
xline(1.75 * 165,'r')
xline(1.75 * 225,'r')
xline(1.75 * 285,'r')

subplot(1,4,1)
imagesc(finalwty)
colormap jet
xline(1.75 * 315,'r')
xline(1.75 * 15,'r')
xline(1.75 * 75,'r')
xline(1.75 * 135,'r')
xline(1.75 * 195,'r')
xline(1.75 * 255,'r')


%
%
%next, wta
wtagridhalf = wta(1:s2,:);
wtarechalf = wta(s2+1:end,:);

newwtashuffledirgridhalf = newwtashuffledir(1:s2,:);
newwtashuffledirrechalf = newwtashuffledir(s2+1:end,:);

%lets work with wta first 
sixtydegreecolumn = [wtagridhalf(:,74:82), wtagridhalf(:,181:185), wtagridhalf(:,284:292), wtagridhalf(:,390:396), wtagridhalf(:,494:500)];
% sixtydegreecolumn = [wtagridhalf(:,102:106), wtagridhalf(:,207:211), wtagridhalf(:,417:421), wtagridhalf(:,522:526)];

%     sixtydegreecolumn = nanmean(sixtydegreecolumn,2);
sixtydegreecolumn = sum(sixtydegreecolumn,2);

[~, idx] = sortrows(sixtydegreecolumn,'descend');

wtagridhalf = wtagridhalf(idx,:);
newwtashuffledirgridhalf = newwtashuffledirgridhalf(idx,:);

finalwta = [wtagridhalf;wtarechalf];
newwtashuffledir = [newwtashuffledirgridhalf;newwtashuffledirrechalf];


%doing something a little different
%going to group 60 and 30 together
wta30 = [47,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,24,25,26,27]';
wta60 = [21,22,23,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,48]';
wta90 = [49,50,51,52,53,54,55,56,57,58,59,60,61,62]';

wta30 = finalwta(wta30,:);
wta60 = finalwta(wta60,:);
wta90 = finalwta(wta90,:);

finalwta = [wta30;wta60;wta90];

wta30 = [47,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,24,25,26,27]';
wta60 = [21,22,23,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,48]';
wta90 = [49,50,51,52,53,54,55,56,57,58,59,60,61,62]';

wta30 = newwtashuffledir(wta30,:);
wta60 = newwtashuffledir(wta60,:);
wta90 = newwtashuffledir(wta90,:);

newwtashuffledir = [wta30;wta60;wta90];

%49 with 50 
r49 = finalwta(49,:);
r50 = finalwta(50,:);
finalwta(50,:) = r49;
finalwta(49,:) = r50;

r49 = newwtashuffledir(49,:);
r50 = newwtashuffledir(50,:);
newwtashuffledir(49,:) = r50;
newwtashuffledir(50,:) = r49;

%50 with 52 
r52 = finalwta(52,:);
r50 = finalwta(50,:);
finalwta(50,:) = r52;
finalwta(52,:) = r50;

r52 = newwtashuffledir(52,:);
r50 = newwtashuffledir(50,:);
newwtashuffledir(52,:) = r50;
newwtashuffledir(50,:) = r52;

%32 with 33 
r32 = finalwta(32,:);
r33 = finalwta(33,:);
finalwta(33,:) = r32;
finalwta(32,:) = r33;

r32 = newwtashuffledir(32,:);
r33 = newwtashuffledir(33,:);
newwtashuffledir(32,:) = r33;
newwtashuffledir(33,:) = r32;

%another round
wta30 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,49]';
wta60 = [26,27,28,29,30,31,32,38,45,33,34,35,36,37,39,40,41,42,43,44,46,47,48]';
wta90 = [50,51,52,53,54,55,56,57,58,59,60,61,62]';

wta30 = finalwta(wta30,:);
wta60 = finalwta(wta60,:);
wta90 = finalwta(wta90,:);

finalwta = [wta30;wta60;wta90];

wta30 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,49]';
wta60 = [26,27,28,29,30,31,32,38,45,33,34,35,36,37,39,40,41,42,43,44,46,47,48]';
wta90 = [50,51,52,53,54,55,56,57,58,59,60,61,62]';

wta30 = newwtashuffledir(wta30,:);
wta60 = newwtashuffledir(wta60,:);
wta90 = newwtashuffledir(wta90,:);

newwtashuffledir = [wta30;wta60;wta90];


%another round
wta30 = linspace(1,26,26)';
wta60 = linspace(27,49,23)';
wta90 = [53,54,55,50,51,52,56,57,58,59,60,61,62]';

wta30 = finalwta(wta30,:);
wta60 = finalwta(wta60,:);
wta90 = finalwta(wta90,:);

finalwta = [wta30;wta60;wta90];

wta30 = linspace(1,26,26)';
wta60 = linspace(27,49,23)';
wta90 = [53,54,55,50,51,52,56,57,58,59,60,61,62]';

wta30 = newwtashuffledir(wta30,:);
wta60 = newwtashuffledir(wta60,:);
wta90 = newwtashuffledir(wta90,:);

newwtashuffledir = [wta30;wta60;wta90];



%another round
wta30 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,50,51,52]';
wta60 = linspace(27,49,23)';
wta90 = [53,54,55,56,57,58,59,60,61,62]';

wta30 = finalwta(wta30,:);
wta60 = finalwta(wta60,:);
wta90 = finalwta(wta90,:);

finalwta = [wta30;wta60;wta90];

wta30 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,50,51,52]';
wta60 = linspace(27,49,23)';
wta90 = [53,54,55,56,57,58,59,60,61,62]';

wta30 = newwtashuffledir(wta30,:);
wta60 = newwtashuffledir(wta60,:);
wta90 = newwtashuffledir(wta90,:);

newwtashuffledir = [wta30;wta60;wta90];

 



%another round
wta30 = linspace(1,27,27)';
wta60 = linspace(28,53,26)';
wta90 = [56,58,54,55,57,59,60,61,62]';

wta30 = finalwta(wta30,:);
wta60 = finalwta(wta60,:);
wta90 = finalwta(wta90,:);

finalwta = [wta30;wta60;wta90];

wta30 = linspace(1,27,27)';
wta60 = linspace(28,53,26)';
wta90 = [56,58,54,55,57,59,60,61,62]';

wta30 = newwtashuffledir(wta30,:);
wta60 = newwtashuffledir(wta60,:);
wta90 = newwtashuffledir(wta90,:);

newwtashuffledir = [wta30;wta60;wta90];






%55 with 57 
r55 = finalwta(55,:);
r57 = finalwta(57,:);
finalwta(57,:) = r55;
finalwta(55,:) = r57;

r55 = newwtashuffledir(55,:);
r57 = newwtashuffledir(57,:);
newwtashuffledir(55,:) = r57;
newwtashuffledir(57,:) = r55;



subplot(1,4,2)
imagesc(finalwta)
colormap jet
xline(1.75 * 45,'r')
xline(1.75 * 135,'r')
xline(1.75 * 225,'r')
xline(1.75 * 315,'r')

subplot(1,4,2)
imagesc(finalwta)
colormap jet
xline(1.75 * 345,'r')
xline(1.75 * 45,'r')
xline(1.75 * 105,'r')
xline(1.75 * 165,'r')
xline(1.75 * 225,'r')
xline(1.75 * 285,'r')

subplot(1,4,2)
imagesc(finalwta)
colormap jet
xline(1.75 * 315,'r')
xline(1.75 * 15,'r')
xline(1.75 * 75,'r')
xline(1.75 * 135,'r')
xline(1.75 * 195,'r')
xline(1.75 * 255,'r')

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
sixtydegreecolumn = [j20ygridhalf(:,25:29), j20ygridhalf(:,129:134), j20ygridhalf(:,339:344), j20ygridhalf(:,444:449)];

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



%another round
j20y30 = [10,9,8,7,6,3,1,13,15]';
j20y60 = [2,4,5,11,12,14,16,17,18,19,20,21,22,23,24]'
j20y90 = [25,26,27,28,29,30]';

j20y30 = finalj20y(j20y30,:);
j20y60 = finalj20y(j20y60,:);
j20y90 = finalj20y(j20y90,:);

finalj20y = [j20y30;j20y60;j20y90];

j20y30 = [10,9,8,7,6,3,1,13,15]';
j20y60 = [2,4,5,11,12,14,16,17,18,19,20,21,22,23,24]'
j20y90 = [25,26,27,28,29,30]';

j20y30 = newj20yshuffledir(j20y30,:);
j20y60 = newj20yshuffledir(j20y60,:);
j20y90 = newj20yshuffledir(j20y90,:);

newj20yshuffledir = [j20y30;j20y60;j20y90];






%another round
j20y30 = [1,2,3,4,5,6,7,8,9]';
j20y60 = [16,15,14,13,12,11,10,17,18,19,20,21,22,23,24]'
j20y90 = [25,26,27,28,29,30]';

j20y30 = finalj20y(j20y30,:);
j20y60 = finalj20y(j20y60,:);
j20y90 = finalj20y(j20y90,:);

finalj20y = [j20y30;j20y60;j20y90];

j20y30 = [1,2,3,4,5,6,7,8,9]';
j20y60 = [16,15,14,13,12,11,10,17,18,19,20,21,22,23,24]'
j20y90 = [25,26,27,28,29,30]';

j20y30 = newj20yshuffledir(j20y30,:);
j20y60 = newj20yshuffledir(j20y60,:);
j20y90 = newj20yshuffledir(j20y90,:);

newj20yshuffledir = [j20y30;j20y60;j20y90];


%another round
j20y30 = [1,2,3,4,5,6,7,8,9]';
j20y60 = [10,11,12,13,14,15,16,24,17,18,19,20,21,22,23]'
j20y90 = [25,26,27,28,29,30]';

j20y30 = finalj20y(j20y30,:);
j20y60 = finalj20y(j20y60,:);
j20y90 = finalj20y(j20y90,:);

finalj20y = [j20y30;j20y60;j20y90];

j20y30 = [1,2,3,4,5,6,7,8,9]';
j20y60 = [10,11,12,13,14,15,16,24,17,18,19,20,21,22,23]'
j20y90 = [25,26,27,28,29,30]';

j20y30 = newj20yshuffledir(j20y30,:);
j20y60 = newj20yshuffledir(j20y60,:);
j20y90 = newj20yshuffledir(j20y90,:);

newj20yshuffledir = [j20y30;j20y60;j20y90];






subplot(1,4,3)
imagesc(finalj20y)
colormap jet
xline(1.75 * 45,'r')
xline(1.75 * 135,'r')
xline(1.75 * 225,'r')
xline(1.75 * 315,'r')

subplot(1,4,3)
imagesc(finalj20y)
colormap jet
xline(1.75 * 345,'r')
xline(1.75 * 45,'r')
xline(1.75 * 105,'r')
xline(1.75 * 165,'r')
xline(1.75 * 225,'r')
xline(1.75 * 285,'r')

subplot(1,4,3)
imagesc(finalj20y)
colormap jet
xline(1.75 * 315,'r')
xline(1.75 * 15,'r')
xline(1.75 * 75,'r')
xline(1.75 * 135,'r')
xline(1.75 * 195,'r')
xline(1.75 * 255,'r')

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
sixtydegreecolumn = [j20agridhalf(:,25:29), j20agridhalf(:,129:134), j20agridhalf(:,339:344), j20agridhalf(:,444:449)];

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




%another round
j20a30 = [11,10,9,8,7,6,5,4,3,2,1]';
j20a60 = [12,13,14,15,16,17,18,19,20,22,23]'
j20a90 = [21,24,25,26,27,28,29,30,31,32,33,34,35,36,37]';

j20a30 = finalj20a(j20a30,:);
j20a60 = finalj20a(j20a60,:);
j20a90 = finalj20a(j20a90,:);

finalj20a = [j20a30;j20a60;j20a90];

j20a30 = [11,10,9,8,7,6,5,4,3,2,1]';
j20a60 = [12,13,14,15,16,17,18,19,20,22,23]'
j20a90 = [21,24,25,26,27,28,29,30,31,32,33,34,35,36,37]';


j20a30 = newj20ashuffledir(j20a30,:);
j20a60 = newj20ashuffledir(j20a60,:);
j20a90 = newj20ashuffledir(j20a90,:);

newj20ashuffledir = [j20a30;j20a60;j20a90];





%another round
j20a30 = [1,2,3,4,5,16,6,7,8,9,12,10,11]';
j20a60 = [13,14,15,17,18,19,20,21,22]'
j20a90 = [23,24,25,26,27,28,29,30,31,32,33,34,35,36,37]';

j20a30 = finalj20a(j20a30,:);
j20a60 = finalj20a(j20a60,:);
j20a90 = finalj20a(j20a90,:);

finalj20a = [j20a30;j20a60;j20a90];

j20a30 = [1,2,3,4,5,16,6,7,8,9,12,10,11]';
j20a60 = [13,14,15,17,18,19,20,21,22]'
j20a90 = [23,24,25,26,27,28,29,30,31,32,33,34,35,36,37]';


j20a30 = newj20ashuffledir(j20a30,:);
j20a60 = newj20ashuffledir(j20a60,:);
j20a90 = newj20ashuffledir(j20a90,:);

newj20ashuffledir = [j20a30;j20a60;j20a90];



%another round
j20a30 = [1,2,3,4,5,6,7,8,9,10,11,12,22]';
j20a60 = [13,14,15,16,17,18,19,20,21,26]'
j20a90 = [24,25,27,28,29,30,31,32,33,34,35,36,37,23]';

j20a30 = finalj20a(j20a30,:);
j20a60 = finalj20a(j20a60,:);
j20a90 = finalj20a(j20a90,:);

finalj20a = [j20a30;j20a60;j20a90];

j20a30 = [1,2,3,4,5,6,7,8,9,10,11,12,22]';
j20a60 = [13,14,15,16,17,18,19,20,21,26]'
j20a90 = [24,25,27,28,29,30,31,32,33,34,35,36,37,23]';


j20a30 = newj20ashuffledir(j20a30,:);
j20a60 = newj20ashuffledir(j20a60,:);
j20a90 = newj20ashuffledir(j20a90,:);

newj20ashuffledir = [j20a30;j20a60;j20a90];


%another round
j20a30 = [1,2,3,4,5,6,7,8,9,10,11,12,13]';
j20a60 = [20,19,18,17,16,15,14,21,22,23]'
j20a90 = [24,25,26,27,28,29,30,31,32,33,34,35,36,37]';

j20a30 = finalj20a(j20a30,:);
j20a60 = finalj20a(j20a60,:);
j20a90 = finalj20a(j20a90,:);

finalj20a = [j20a30;j20a60;j20a90];

j20a30 = [1,2,3,4,5,6,7,8,9,10,11,12,13]';
j20a60 = [20,19,18,17,16,15,14,21,22,23]'
j20a90 = [24,25,26,27,28,29,30,31,32,33,34,35,36,37]';


j20a30 = newj20ashuffledir(j20a30,:);
j20a60 = newj20ashuffledir(j20a60,:);
j20a90 = newj20ashuffledir(j20a90,:);

newj20ashuffledir = [j20a30;j20a60;j20a90];



%another round
j20a30 = [21,1,2,3,4,5,6,7,8,9,10,11,12,13]';
j20a60 = [14,15,16,17,18,19,20,22,23]'
j20a90 = [24,25,26,27,28,29,30,31,32,33,34,35,36,37]';

j20a30 = finalj20a(j20a30,:);
j20a60 = finalj20a(j20a60,:);
j20a90 = finalj20a(j20a90,:);

finalj20a = [j20a30;j20a60;j20a90];

j20a30 = [21,1,2,3,4,5,6,7,8,9,10,11,12,13]';
j20a60 = [14,15,16,17,18,19,20,22,23]'
j20a90 = [24,25,26,27,28,29,30,31,32,33,34,35,36,37]';



j20a30 = newj20ashuffledir(j20a30,:);
j20a60 = newj20ashuffledir(j20a60,:);
j20a90 = newj20ashuffledir(j20a90,:);

newj20ashuffledir = [j20a30;j20a60;j20a90];



%another round
j20a30 = [2,3,4,5,6,7,8,9,10,11,12,13,14,15]';
j20a60 = [16,17,18,19,21,20,1,22,23]'
j20a90 = [24,25,26,27,28,29,30,31,32,33,34,35,36,37]';

j20a30 = finalj20a(j20a30,:);
j20a60 = finalj20a(j20a60,:);
j20a90 = finalj20a(j20a90,:);

finalj20a = [j20a30;j20a60;j20a90];

j20a30 = [2,3,4,5,6,7,8,9,10,11,12,13,14,15]';
j20a60 = [16,17,18,19,21,20,1,22,23]'
j20a90 = [24,25,26,27,28,29,30,31,32,33,34,35,36,37]';



j20a30 = newj20ashuffledir(j20a30,:);
j20a60 = newj20ashuffledir(j20a60,:);
j20a90 = newj20ashuffledir(j20a90,:);

newj20ashuffledir = [j20a30;j20a60;j20a90];




%22 with 23 
r23 = finalj20a(23,:);
r22 = finalj20a(22,:);
finalj20a(22,:) = r23;
finalj20a(23,:) = r22;

r23 = newj20ashuffledir(23,:);
r22 = newj20ashuffledir(22,:);
newj20ashuffledir(23,:) = r22;
newj20ashuffledir(22,:) = r23;



%another round
j20a30 = [22,23,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]';
j20a60 = [16,17,18,19,20,21]'
j20a90 = [24,25,26,27,28,29,30,31,32,33,34,35,36,37]';

j20a30 = finalj20a(j20a30,:);
j20a60 = finalj20a(j20a60,:);
j20a90 = finalj20a(j20a90,:);

finalj20a = [j20a30;j20a60;j20a90];

j20a30 = [22,23,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]';
j20a60 = [16,17,18,19,20,21]'
j20a90 = [24,25,26,27,28,29,30,31,32,33,34,35,36,37]';



j20a30 = newj20ashuffledir(j20a30,:);
j20a60 = newj20ashuffledir(j20a60,:);
j20a90 = newj20ashuffledir(j20a90,:);

newj20ashuffledir = [j20a30;j20a60;j20a90];



subplot(1,4,4)
imagesc(finalj20a)
colormap jet
xline(1.75 * 45,'r')
xline(1.75 * 135,'r')
xline(1.75 * 225,'r')
xline(1.75 * 315,'r')

subplot(1,4,4)
imagesc(finalj20a)
colormap jet
xline(1.75 * 345,'r')
xline(1.75 * 45,'r')
xline(1.75 * 105,'r')
xline(1.75 * 165,'r')
xline(1.75 * 225,'r')
xline(1.75 * 285,'r')

subplot(1,4,4)
imagesc(finalj20a)
colormap jet
xline(1.75 * 315,'r')
xline(1.75 * 15,'r')
xline(1.75 * 75,'r')
xline(1.75 * 135,'r')
xline(1.75 * 195,'r')
xline(1.75 * 255,'r')

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
xline(1.75 * 345,'r')
xline(1.75 * 45,'r')
xline(1.75 * 105,'r')
xline(1.75 * 165,'r')
xline(1.75 * 225,'r')
xline(1.75 * 285,'r')

xline(1.75 * 45,'g')
xline(1.75 * 135,'g')
xline(1.75 * 225,'g')
xline(1.75 * 315,'g')


subplot(1,4,2)
imagesc(finalwta)
colormap jet
xline(1.75 * 345,'r')
xline(1.75 * 45,'r')
xline(1.75 * 105,'r')
xline(1.75 * 165,'r')
xline(1.75 * 225,'r')
xline(1.75 * 285,'r')

xline(1.75 * 45,'g')
xline(1.75 * 135,'g')
xline(1.75 * 225,'g')
xline(1.75 * 315,'g')


subplot(1,4,3)
imagesc(finalj20y)
colormap jet
xline(1.75 * 345,'r')
xline(1.75 * 45,'r')
xline(1.75 * 105,'r')
xline(1.75 * 165,'r')
xline(1.75 * 225,'r')
xline(1.75 * 285,'r')

xline(1.75 * 45,'g')
xline(1.75 * 135,'g')
xline(1.75 * 225,'g')
xline(1.75 * 315,'g')

subplot(1,4,4)
imagesc(finalj20a)
colormap jet
xline(1.75 * 345,'r')
xline(1.75 * 45,'r')
xline(1.75 * 105,'r')
xline(1.75 * 165,'r')
xline(1.75 * 225,'r')
xline(1.75 * 285,'r')

xline(1.75 * 45,'g')
xline(1.75 * 135,'g')
xline(1.75 * 225,'g')
xline(1.75 * 315,'g')

%%
%pie charts

X = [9,27];
subplot(1,4,1)
pie(X)
colormap([0 0 0 ; 1 1 1])

X = [9,53];
subplot(1,4,2)
pie(X)
colormap([0 0 0 ; 1 1 1])

X = [6,24];
subplot(1,4,3)
pie(X)
colormap([0 0 0 ; 1 1 1])

X = [14,23];
subplot(1,4,4)
pie(X)
colormap([0 0 0 ; 1 1 1])


%binomial test
avg = (9/36 + 9/62 + 6/30 + 14/37)/4


% binopdf(9,36,avg)
% binopdf(9,62,avg)
% binopdf(6,30,avg)
% binopdf(15,37,avg) %p = 0.01 significant



binopdf(9,36,avg)
binopdf(9,62,avg)
binopdf(6,30,avg)
binopdf(14,37,avg) %p = 0.0256 significant

binopdf(9,36,avg)
binopdf(9,62,avg)
binopdf(6,30,avg)
binopdf(13,37,avg) %p = 0.0464 significant
%% 

id = 5;
id = 6;
id = 7;
id = 8;
id = 9;

wty = cell2mat(newwtyshuffledir(1:s1,id));
wty2 = cell2mat(newwtyshuffledir(s1+1:end,id));

wta = cell2mat(newwtashuffledir(1:s2,id));
wta2 = cell2mat(newwtashuffledir(s2+1:end,id));

j20y = cell2mat(newj20yshuffledir(1:s3,id));
j20y2 = cell2mat(newj20yshuffledir(s3+1:end,id));

j20a = cell2mat(newj20ashuffledir(1:s4,id));
j20a2 = cell2mat(newj20ashuffledir(s4+1:end,id));


ranksum(wty,wty2)
ranksum(wta,wta2)
ranksum(j20y,j20y2)
ranksum(j20a,j20a2)

subplot(1,4,1)
scatter(linspace(1,length(newwtyshuffledir(:,id)), length(newwtyshuffledir(:,id))), cell2mat(newwtyshuffledir(:,id)),8,'k','filled')
axis square
title(s1/length(newwtyshuffledir(:,id)))
xline(s1)
subplot(1,4,2)
scatter(linspace(1,length(newwtashuffledir(:,id)), length(newwtashuffledir(:,id))), cell2mat(newwtashuffledir(:,id)),8,'k','filled')
axis square
title(s2/length(newwtashuffledir(:,id)))
xline(s2)
subplot(1,4,3)
scatter(linspace(1,length(newj20yshuffledir(:,id)), length(newj20yshuffledir(:,id))), cell2mat(newj20yshuffledir(:,id)),8,'k','filled')
axis square
title(s3/length(newj20yshuffledir(:,id)))
xline(s3)
subplot(1,4,4)
scatter(linspace(1,length(newj20ashuffledir(:,id)), length(newj20ashuffledir(:,id))), cell2mat(newj20ashuffledir(:,id)),8,'k','filled')
axis square
title(s4/length(newj20ashuffledir(:,id)))
xline(s4)


