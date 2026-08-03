
%% Extracting Fourier components for ALL cells
% Code is very similar to grid cells
% Only small difference here is that we won't do voronoi segmentation to
% extract Fourier powers (and then shuffle) them as we did for the grid
% cells
%
% Here, the shuffling procedure is done directly on shuffled versions of
% the rate map, thus simplifying the process and requires less computation
% time. 

% Since these are the same code,  only nTG-y code is commended in detail

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

%picking out cells 
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



%% nTG-y 

wty_data = {};

for iii = 1:size(wty_filt999)
    %%
    disp(iii)
    
    %load cell
    load(wty_filt999{iii,4}(end-18:end));
    cel = [wty_filt999{iii,5},wty_filt999{iii,6}];
    
    if (wty_filt999{iii, 8} < 0.1 )
        continue
    end
    
    try
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making rate maps 36x36
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
        powr3 = abs(imgX.^2); %power spectrum
    
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
    
        wty_data{iii,3} = powr3; %store unfiltered power spectrum
    
    
        %shuffle cell 50 times and find 50th percentile power
        %
        %note, you could also use the shuffled powers from voronoi
        %segmentation in Figure 1, and it would yield same results
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
    
        
        wty_data{iii,4} = powr3;    %store filtered power spectrum 
    
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
        
        wty_data{iii,9} = waveformyx; %store
        
        %just adding 0s between rows to make it suitable for polar plots
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]]; %[rho, theta]
        
        wty_data{iii,10} = thetarho; %store
        
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
        
        %%finally, extract info about individual components
        
%         wty_data{iii,12} = imgX;
%         
%         centroids = [];
%         for ii = 1:size(measurements,1)
%             centroids = [centroids; measurements(ii).Centroid];
%         end
%         
%         gaussians = [];
%         for ii = 1:size(centroids,1)
%             gaussians(:,:,ii) = exp(-((x-centroids(ii,2)).^2 + (y-centroids(ii,1)).^2) ./ (2*width^2)); %careful with x and y. centroid(ii,2} is actually the column coordinate
%         end
%         
%         wty_data{iii,13} = centroids;
%         wty_data{iii,14} = gaussians;
%     
%         wty_data{iii,15} = nanmean(gaussians,3);
%         wty_data{iii,16} = abs((imgX.*nanmean(gaussians,3)).^2);
%         
%         %all individual components re-visualized as images of spatially periodic bands
%         %using the inverse Fourier transform function
%         allcomponents = {};
%         for ii = 1:size(centroids,1)
%             imgrecon = real(ifft2( imgX.*gaussians(:,:,ii) ));
%             imgrecon2 = real(ifft2(fftshift( imgX.*gaussians(:,:,ii) )));
%             
%             allcomponents{1,ii} = imgrecon;
%             allcomponents{2,ii} = imgrecon2; % <- visualize this one 
%             
%         end
%         
%         wty_data{iii,17} = allcomponents; %stores all individual components re-visualized as images of spatially periodic bands 
    catch
    end
end




%% nTG-a

wta_data = {};

for iii = 1:size(wta_filt999)
    %%
    disp(iii)
    
    %load cell
    load(wta_filt999{iii,4}(end-18:end));
    cel = [wta_filt999{iii,5},wta_filt999{iii,6}];
    
    if (wta_filt999{iii, 8} < 0.1 )
        continue
    end
    
    try
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making rate maps 36x36
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        %create smoothed and unsmoothed rate maps
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
        powr3 = abs(imgX.^2); %power spectrum
    
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
    
        wta_data{iii,3} = powr3; %store unfiltered power spectrum
    
    
        %shuffle cell 50 times and find 50th percentile power
        %
        %note, you could also use the shuffled powers from voronoi
        %segmentation in Figure 1, and it would yield same results
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
    
        
        wta_data{iii,4} = powr3;    %store filtered power spectrum 
    
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
        
        wta_data{iii,5} = numcomp; %store number of components 
        
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
        
        wta_data{iii,6} = disttocenter; %store distances
        
        %calculate wavelengths (method used in Krupic et al.2012 see Star Methods)
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
        
        wta_data{iii,8} = waveformyx; %store wavelength info [x distance, y distance, theta(magnitude), rho(angle)]
        
        %sorted wavelengths in ascending order by rho
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        wta_data{iii,9} = waveformyx; %store
        
        %just adding 0s between rows to make it suitable for polar plots
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]]; %[rho, theta]
        
        wta_data{iii,10} = thetarho; %store
        
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
        
        wta_data{iii,11} = thetarho2;
        
%         %%finally, extract info about individual components
%         
%         wta_data{iii,12} = imgX;
%         
%         centroids = [];
%         for ii = 1:size(measurements,1)
%             centroids = [centroids; measurements(ii).Centroid];
%         end
%         
%         gaussians = [];
%         for ii = 1:size(centroids,1)
%             gaussians(:,:,ii) = exp(-((x-centroids(ii,2)).^2 + (y-centroids(ii,1)).^2) ./ (2*width^2)); %careful with x and y. centroid(ii,2} is actually the column coordinate
%         end
%         
%         wta_data{iii,13} = centroids;
%         wta_data{iii,14} = gaussians;
%     
%         wta_data{iii,15} = nanmean(gaussians,3);
%         wta_data{iii,16} = abs((imgX.*nanmean(gaussians,3)).^2);
%         
%         %all individual components re-visualized as images of spatially periodic bands
%         %using the inverse Fourier transform function
%         allcomponents = {};
%         for ii = 1:size(centroids,1)
%             imgrecon = real(ifft2( imgX.*gaussians(:,:,ii) ));
%             imgrecon2 = real(ifft2(fftshift( imgX.*gaussians(:,:,ii) )));
%             
%             allcomponents{1,ii} = imgrecon;
%             allcomponents{2,ii} = imgrecon2; % <- visualize this one 
%             
%         end
%         
%         wta_data{iii,17} = allcomponents; %stores all individual components re-visualized as images of spatially periodic bands 
    catch
    end
end

%% APP-y

j20y_data = {};

for iii = 1:size(j20y_filt999)
    %%
    disp(iii)
    
    %load cell
    load(j20y_filt999{iii,4}(end-18:end));
    cel = [j20y_filt999{iii,5},j20y_filt999{iii,6}];
    
    if (j20y_filt999{iii, 8} < 0.1 )
        continue
    end
    
    try
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making rate maps 36x36
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        %create smoothed and unsmoothed rate maps
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
        powr3 = abs(imgX.^2); %power spectrum
    
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
    
        j20y_data{iii,3} = powr3; %store unfiltered power spectrum
    
    
        %shuffle cell 50 times and find 50th percentile power
        %
        %note, you could also use the shuffled powers from voronoi
        %segmentation in Figure 1, and it would yield same results
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
    
        
        j20y_data{iii,4} = powr3;    %store filtered power spectrum 
    
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
        
        j20y_data{iii,5} = numcomp; %store number of components 
        
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
        
        j20y_data{iii,6} = disttocenter; %store distances
        
        %calculate wavelengths (method used in Krupic et al.2012 see Star Methods)
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
        
        j20y_data{iii,8} = waveformyx; %store wavelength info [x distance, y distance, theta(magnitude), rho(angle)]
        
        %sorted wavelengths in ascending order by rho
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        j20y_data{iii,9} = waveformyx; %store
        
        %just adding 0s between rows to make it suitable for polar plots
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]]; %[rho, theta]
        
        j20y_data{iii,10} = thetarho; %store
        
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
        
        j20y_data{iii,11} = thetarho2;
        
        %%finally, extract info about individual components
        
%         j20y_data{iii,12} = imgX;
%         
%         centroids = [];
%         for ii = 1:size(measurements,1)
%             centroids = [centroids; measurements(ii).Centroid];
%         end
%         
%         gaussians = [];
%         for ii = 1:size(centroids,1)
%             gaussians(:,:,ii) = exp(-((x-centroids(ii,2)).^2 + (y-centroids(ii,1)).^2) ./ (2*width^2)); %careful with x and y. centroid(ii,2} is actually the column coordinate
%         end
%         
%         j20y_data{iii,13} = centroids;
%         j20y_data{iii,14} = gaussians;
%     
%         j20y_data{iii,15} = nanmean(gaussians,3);
%         j20y_data{iii,16} = abs((imgX.*nanmean(gaussians,3)).^2);
        
%         %all individual components re-visualized as images of spatially periodic bands
%         %using the inverse Fourier transform function
%         allcomponents = {};
%         for ii = 1:size(centroids,1)
%             imgrecon = real(ifft2( imgX.*gaussians(:,:,ii) ));
%             imgrecon2 = real(ifft2(fftshift( imgX.*gaussians(:,:,ii) )));
%             
%             allcomponents{1,ii} = imgrecon;
%             allcomponents{2,ii} = imgrecon2; % <- visualize this one 
%             
%         end
%         
%         j20y_data{iii,17} = allcomponents; %stores all individual components re-visualized as images of spatially periodic bands 
    catch
    end
end

%% APP-a

j20a_data = {};

for iii = 1:size(j20a_filt999)
    %%
    disp(iii)
    
    %load cell
    load(j20a_filt999{iii,4}(end-18:end));
    cel = [j20a_filt999{iii,5},j20a_filt999{iii,6}];
    
    if (j20a_filt999{iii, 8} < 0.1 )
        continue
    end
    
    try
        [oc, xdim, ydim] = root.Occupancy();
        xdim2 = linspace(xdim(1), xdim(end), 36); %making rate maps 36x36
        ydim2 = linspace(ydim(1), ydim(end), 36);
        
        %create smoothed and unsmoothed rate maps
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
        powr3 = abs(imgX.^2); %power spectrum
    
        width  = 1;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgL,1),1:size(imgL,2));
        [row, col] = find(ismember(powr3, max(powr3(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr3 = powr3 .* gaus2d;
    
        j20a_data{iii,3} = powr3; %store unfiltered power spectrum
    
    
        %shuffle cell 50 times and find 50th percentile power
        %
        %note, you could also use the shuffled powers from voronoi
        %segmentation in Figure 1, and it would yield same results
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
    
        
        j20a_data{iii,4} = powr3;    %store filtered power spectrum 
    
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
        
        j20a_data{iii,5} = numcomp; %store number of components 
        
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
        
        j20a_data{iii,6} = disttocenter; %store distances
        
        %calculate wavelengths (method used in Krupic et al.2012 see Star Methods)
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
        
        j20a_data{iii,8} = waveformyx; %store wavelength info [x distance, y distance, theta(magnitude), rho(angle)]
        
        %sorted wavelengths in ascending order by rho
        waveformyx = sortrows(waveformyx,4,'ascend');
        waveformyx(end+1,:) = waveformyx(1,:);
        waveformyx(end,4) =  waveformyx(end,4) + 2*pi;
        
        j20a_data{iii,9} = waveformyx; %store
        
        %just adding 0s between rows to make it suitable for polar plots
        thetarho = [];
        for ii = 1:size(waveformyx,1)-1
            thetarho = [thetarho;[waveformyx(ii,4), waveformyx(ii,3)]];
            btwn = (waveformyx(ii,4) + waveformyx(ii+1,4))/2;
            thetarho = [thetarho;[btwn, 0]];
        end
        thetarho = [thetarho;[waveformyx(ii+1,4), waveformyx(ii+1,3)]]; %[rho, theta]
        
        j20a_data{iii,10} = thetarho; %store
        
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
        
        j20a_data{iii,11} = thetarho2;
        
        %%finally, extract info about individual components
        
%         j20a_data{iii,12} = imgX;
%         
%         centroids = [];
%         for ii = 1:size(measurements,1)
%             centroids = [centroids; measurements(ii).Centroid];
%         end
%         
%         gaussians = [];
%         for ii = 1:size(centroids,1)
%             gaussians(:,:,ii) = exp(-((x-centroids(ii,2)).^2 + (y-centroids(ii,1)).^2) ./ (2*width^2)); %careful with x and y. centroid(ii,2} is actually the column coordinate
%         end
%         
%         j20a_data{iii,13} = centroids;
%         j20a_data{iii,14} = gaussians;
%     
%         j20a_data{iii,15} = nanmean(gaussians,3);
%         j20a_data{iii,16} = abs((imgX.*nanmean(gaussians,3)).^2);
        
%         %all individual components re-visualized as images of spatially periodic bands
%         %using the inverse Fourier transform function
%         allcomponents = {};
%         for ii = 1:size(centroids,1)
%             imgrecon = real(ifft2( imgX.*gaussians(:,:,ii) ));
%             imgrecon2 = real(ifft2(fftshift( imgX.*gaussians(:,:,ii) )));
%             
%             allcomponents{1,ii} = imgrecon;
%             allcomponents{2,ii} = imgrecon2; % <- visualize this one 
%             
%         end
%         
%         j20a_data{iii,17} = allcomponents; %stores all individual components re-visualized as images of spatially periodic bands 
    catch
    end
end


% Again, the output that you would get is in 'allcells_workspace.mat'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Now, remove all cells not recorded in the square environment, empty cells, and cells that have either 0 or >4 fourier components
% Again, you don't need to run this, the cells that should be removed are all saved into .mat workspaces ... code just here for transparency

clear
load('allcells_workspace.mat')


% remove cells that were recorded in circle environments


wtycircle = [];
wtacircle = [];
j20ycircle = [];
j20acircle = [];

for i = 1:100
    try
        subplot(10,10,i)
        imagesc(wty_data{i,2})
        colormap jet
        axis square
        title(i)
    catch
    end
end

for i = 1:100
    try
        subplot(10,10,i)
        imagesc(wta_data{i,2})
        colormap jet
        axis square
        title(i)
    catch
    end
end
wtacircle = linspace(1,21,21)'

for i = 1:100
    try
        subplot(10,10,i)
        imagesc(j20y_data{i,2})
        colormap jet
        axis square
        title(i)
    catch
    end
end


for i = 1:100
    try
        subplot(10,10,i)
        imagesc(j20a_data{i,2})
        colormap jet
        axis square
        title(i)
    catch
    end
end
j20acircle = [1;2;3;4;5;6;7];



for i = 1:21
    try
        subplot(5,5,i)
        imagesc(wta_data{i,2})
        colormap jet
        axis square
        title(i)
    catch
    end
end



% wta_data(wtacircle,:) = [];
% j20a_data(j20acircle,:) = [];

%also remove empty rows
wtyempty = [1;5;8;16;17;23;27;36;48;353;665;]
wtaempty = [5;221;243;280;320;470;483;563;574;579;705;787;1002;1106]
j20yempty = [489;546;611]
j20aempty = [32;96;217;252;254;256;378;510;520;604;605;624;743;748;760;766;843;918;922;1158;1319;1322;1330;1463;1473]


% wty_data(wtyempty,:) = [];
% wta_data(wtaempty,:) = [];
% j20y_data(j20yempty,:) = [];
% j20a_data(j20aempty,:) = [];

%lastly, remove all components less than 1 and more than 4
wtycompo = find(cell2mat(wty_data(:,5)) >= 1 & cell2mat(wty_data(:,5)) <= 4  )
wtacompo = find(cell2mat(wta_data(:,5)) >= 1 & cell2mat(wta_data(:,5)) <= 4  )
j20ycompo = find(cell2mat(j20y_data(:,5)) >= 1 & cell2mat(j20y_data(:,5)) <= 4  )
j20acompo = find(cell2mat(j20a_data(:,5)) >= 1 & cell2mat(j20a_data(:,5)) <= 4  )

% wty_data = wty_data(wtycompo,:);
% wta_data = wta_data(wtacompo,:);
% j20y_data = j20y_data(j20ycompo,:);
% j20a_data = j20a_data(j20acompo,:);


% The lists of cells that need to be removed/kept are found in 'removecirclecells.mat', 'emptycells.mat', '1and4components'
%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures E and F


clear
load('C:\Users\Johnson\Desktop\Code instructions\Additional fourier controls\population level stuff figure 1\allcells_workspace.mat')


load('C:\Users\Johnson\Desktop\Code instructions\Additional fourier controls\population level stuff figure 1\1and4components.mat')
load('C:\Users\Johnson\Desktop\Code instructions\Additional fourier controls\population level stuff figure 1\emptycells.mat')
load('C:\Users\Johnson\Desktop\Code instructions\Additional fourier controls\population level stuff figure 1\removecirclecells.mat')

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



%plot this for nongrid cells 
subplot(1,4,1)
hist(wtyorientationdiff,50)
axis square
xlim([0,200])
% xlim([0,30])
subplot(1,4,2)
hist(wtaorientationdiff,50)
axis square
xlim([0,200])
subplot(1,4,3)
hist(j20yorientationdiff,50)
axis square
xlim([0,200])
subplot(1,4,4)
hist(j20aorientationdiff,50)
axis square
xlim([0,200])


%plot this for grid cells 
subplot(1,4,1)
hist(wtyorientationdiff,50)
axis square
xlim([0,200])
% xlim([0,30])
subplot(1,4,2)
hist(wtaorientationdiff,50)
axis square
xlim([0,200])
subplot(1,4,3)
hist(j20yorientationdiff,50)
axis square
xlim([0,200])
subplot(1,4,4)
hist(j20aorientationdiff,50)
axis square
xlim([0,200])


subplot(1,4,1)
[h,j] = hist(wtyorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,28])
xline(9,'r')
xline(13,'r')
xline(26,'r')
axis square
ylim([0, 0.35])
subplot(1,4,2)
[h,j] = hist(wtaorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,28])
axis square
xline(9,'r')
xline(13,'r')
xline(26,'r')
ylim([0, 0.35])
subplot(1,4,3)
[h,j] = hist(j20yorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,28])
axis square
xline(9,'r')
xline(13,'r')
xline(26,'r')
ylim([0, 0.35])
subplot(1,4,4)
ylim([0, 0.35])
[h,j] = hist(j20aorientationdiff,50)
h = h/sum(h)
bar(h)
xlim([0,28])
axis square
xline(9,'r')
xline(13,'r')
xline(26,'r')
ylim([0, 0.35])

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

wtyorientation180 = length(find(wtyorientationdiff(:,1) >170 & wtyorientationdiff(:,1) <190)) / length(wtyorientationdiff)
wtaorientation180 = length(find(wtaorientationdiff(:,1) >170 & wtaorientationdiff(:,1) <190)) / length(wtaorientationdiff)
j20yorientation180 = length(find(j20yorientationdiff(:,1) >170 & j20yorientationdiff(:,1) <190)) / length(j20yorientationdiff)
j20aorientation180 = length(find(j20aorientationdiff(:,1) >170 & j20aorientationdiff(:,1) <190)) / length(j20aorientationdiff)
% 
% %or for non grids, modulus 90
% wtyorientation90 = (length(find(wtyorientationdiff(:,1) >80 & wtyorientationdiff(:,1) <100)) + length(find(wtyorientationdiff(:,1) >170 & wtyorientationdiff(:,1) <190)) + length(find(wtyorientationdiff(:,1) >260 & wtyorientationdiff(:,1) <280)) + length(find(wtyorientationdiff(:,1) >350 & wtyorientationdiff(:,1) <=360)) + length(find(wtyorientationdiff(:,1) >=0 & wtyorientationdiff(:,1) <10)))/ length(wtyorientationdiff)
% wtaorientation90 = (length(find(wtaorientationdiff(:,1) >80 & wtaorientationdiff(:,1) <100)) + length(find(wtaorientationdiff(:,1) >170 & wtaorientationdiff(:,1) <190)) + length(find(wtaorientationdiff(:,1) >260 & wtaorientationdiff(:,1) <280)) + length(find(wtaorientationdiff(:,1) >350 & wtaorientationdiff(:,1) <=360)) + length(find(wtaorientationdiff(:,1) >=0 & wtaorientationdiff(:,1) <10)))/ length(wtaorientationdiff)
% j20yorientation90 = (length(find(j20yorientationdiff(:,1) >80 & j20yorientationdiff(:,1) <100)) + length(find(j20yorientationdiff(:,1) >170 & j20yorientationdiff(:,1) <190)) + length(find(j20yorientationdiff(:,1) >260 & j20yorientationdiff(:,1) <280)) + length(find(j20yorientationdiff(:,1) >350 & j20yorientationdiff(:,1) <=360)) + length(find(j20yorientationdiff(:,1) >=0 & j20yorientationdiff(:,1) <10)))/ length(j20yorientationdiff)
% j20aorientation90 = (length(find(j20aorientationdiff(:,1) >80 & j20aorientationdiff(:,1) <100)) + length(find(j20aorientationdiff(:,1) >170 & j20aorientationdiff(:,1) <190)) + length(find(j20aorientationdiff(:,1) >260 & j20aorientationdiff(:,1) <280)) + length(find(j20aorientationdiff(:,1) >350 & j20aorientationdiff(:,1) <=360)) + length(find(j20aorientationdiff(:,1) >=0 & j20aorientationdiff(:,1) <10)))/ length(j20aorientationdiff)



avg = (wtyorientation60 + wtaorientation60 + j20yorientation60 + j20aorientation60) / 4

binopdf(length(find(wtyorientationdiff(:,1) >50 & wtyorientationdiff(:,1) <70)), length(wtyorientationdiff), avg)
binopdf(length(find(wtaorientationdiff(:,1) >50 & wtaorientationdiff(:,1) <70)), length(wtaorientationdiff), avg)
binopdf(length(find(j20yorientationdiff(:,1) >50 & j20yorientationdiff(:,1) <70)), length(j20yorientationdiff), avg)
binopdf(length(find(j20aorientationdiff(:,1) >50 & j20aorientationdiff(:,1) <70)), length(j20aorientationdiff), avg)





avg = (wtyorientation90 + wtaorientation90 + j20yorientation90 + j20aorientation90) / 4

binopdf(length(find(wtyorientationdiff(:,1) >80 & wtyorientationdiff(:,1) <100)), length(wtyorientationdiff), avg)
binopdf(length(find(wtaorientationdiff(:,1) >80 & wtaorientationdiff(:,1) <100)), length(wtaorientationdiff), avg)
binopdf(length(find(j20yorientationdiff(:,1) >80 & j20yorientationdiff(:,1) <100)), length(j20yorientationdiff), avg)
binopdf(length(find(j20aorientationdiff(:,1) >80 & j20aorientationdiff(:,1) <100)), length(j20aorientationdiff), avg)




avg = (wtyorientation180 + wtaorientation180 + j20yorientation180 + j20aorientation180) / 4

binopdf(length(find(wtyorientationdiff(:,1) >170 & wtyorientationdiff(:,1) <190)), length(wtyorientationdiff), avg)
binopdf(length(find(wtaorientationdiff(:,1) >170 & wtaorientationdiff(:,1) <190)), length(wtaorientationdiff), avg)
binopdf(length(find(j20yorientationdiff(:,1) >170 & j20yorientationdiff(:,1) <190)), length(j20yorientationdiff), avg)
binopdf(length(find(j20aorientationdiff(:,1) >170 & j20aorientationdiff(:,1) <190)), length(j20aorientationdiff), avg)
% 
% binopdf((length(find(wtyorientationdiff(:,1) >80 & wtyorientationdiff(:,1) <100)) + length(find(wtyorientationdiff(:,1) >170 & wtyorientationdiff(:,1) <190)) + length(find(wtyorientationdiff(:,1) >260 & wtyorientationdiff(:,1) <280)) + length(find(wtyorientationdiff(:,1) >350 & wtyorientationdiff(:,1) <=360)) + length(find(wtyorientationdiff(:,1) >=0 & wtyorientationdiff(:,1) <10))), length(wtyorientationdiff), avg)
% binopdf((length(find(wtaorientationdiff(:,1) >80 & wtaorientationdiff(:,1) <100)) + length(find(wtaorientationdiff(:,1) >170 & wtaorientationdiff(:,1) <190)) + length(find(wtaorientationdiff(:,1) >260 & wtaorientationdiff(:,1) <280)) + length(find(wtaorientationdiff(:,1) >350 & wtaorientationdiff(:,1) <=360)) + length(find(wtaorientationdiff(:,1) >=0 & wtaorientationdiff(:,1) <10))), length(wtaorientationdiff), avg)
% binopdf((length(find(j20yorientationdiff(:,1) >80 & j20yorientationdiff(:,1) <100)) + length(find(j20yorientationdiff(:,1) >170 & j20yorientationdiff(:,1) <190)) + length(find(j20yorientationdiff(:,1) >260 & j20yorientationdiff(:,1) <280)) + length(find(j20yorientationdiff(:,1) >350 & j20yorientationdiff(:,1) <=360)) + length(find(j20yorientationdiff(:,1) >=0 & j20yorientationdiff(:,1) <10))), length(j20yorientationdiff), avg)
% binopdf((length(find(j20aorientationdiff(:,1) >80 & j20aorientationdiff(:,1) <100)) + length(find(j20aorientationdiff(:,1) >170 & j20aorientationdiff(:,1) <190)) + length(find(j20aorientationdiff(:,1) >260 & j20aorientationdiff(:,1) <280)) + length(find(j20aorientationdiff(:,1) >350 & j20aorientationdiff(:,1) <=360)) + length(find(j20aorientationdiff(:,1) >=0 & j20aorientationdiff(:,1) <10))), length(j20aorientationdiff), avg)



%bar graph
bar( [wtyorientation60;wtaorientation60;j20yorientation60;j20aorientation60;wtyorientation90;wtaorientation90;j20yorientation90;j20aorientation90])
ylim([0, 0.35])
avg = (wtyorientation60 + wtaorientation60 + j20yorientation60 + j20aorientation60) / 4
yline(avg)
avg = (wtyorientation90 + wtaorientation90 + j20yorientation90 + j20aorientation90) / 4
yline(avg)
axis square

subplot(1,2,1)
bar( [wtyorientation60;wtaorientation60;j20yorientation60;j20aorientation60])
ylim([0, 0.1])
avg = (wtyorientation60 + wtaorientation60 + j20yorientation60 + j20aorientation60) / 4
yline(avg)
xlim([0,5])
axis square
subplot(1,2,2)
bar( [wtyorientation90;wtaorientation90;j20yorientation90;j20aorientation90])
ylim([0, 0.3])
avg = (wtyorientation90 + wtaorientation90 + j20yorientation90 + j20aorientation90) / 4
yline(avg)
xlim([0,5])
axis square

% 
% %% Figure 1f - zero degree normalized graphs
% 
% wtyorientationdiff = [];
% 
% for i = 1:size(wtythetarho,1)  
%     cel = wtythetarho{i,1};
%     f = find(cel(:,2) == 0);
%     cel(f,:) = [];
%         
%     zeronorm = cel(1,1);
%     
%     cel(:,1) = cel(:,1) - zeronorm;
%     
%     for j = 2:size(cel,1)-1
%         ag = rad2deg(cel(j,1));
%         wtyorientationdiff = [wtyorientationdiff; ag];
%     end
% end
% 
% 
% wtaorientationdiff = [];
% 
% for i = 1:size(wtathetarho,1)  
%     cel = wtathetarho{i,1};
%     f = find(cel(:,2) == 0);
%     cel(f,:) = [];
%         
%     zeronorm = cel(1,1);
%     
%     cel(:,1) = cel(:,1) - zeronorm;
%     
%     for j = 2:size(cel,1)-1
%         ag = rad2deg(cel(j,1));
%         wtaorientationdiff = [wtaorientationdiff; ag];
%     end
% end
% 
% j20yorientationdiff = [];
% 
% for i = 1:size(j20ythetarho,1)  
%     cel = j20ythetarho{i,1};
%     f = find(cel(:,2) == 0);
%     cel(f,:) = [];
%         
%     zeronorm = cel(1,1);
%     
%     cel(:,1) = cel(:,1) - zeronorm;
%     
%     for j = 2:size(cel,1)-1
%         ag = rad2deg(cel(j,1));
%         j20yorientationdiff = [j20yorientationdiff; ag];
%     end
% end
% 
% j20aorientationdiff = [];
% 
% for i = 1:size(j20athetarho,1)  
%     cel = j20athetarho{i,1};
%     f = find(cel(:,2) == 0);
%     cel(f,:) = [];
%     
%     zeronorm = cel(1,1);
%     
%     cel(:,1) = cel(:,1) - zeronorm;
%     
%     for j = 2:size(cel,1)-1
%         ag = rad2deg(cel(j,1));
%         j20aorientationdiff = [j20aorientationdiff; ag];
%     end
% end
% 
% 
% %plot these subplots for nongrid cells 
% subplot(1,4,1)
% hist(wtyorientationdiff,100)
% axis square
% xline(90);
% hold on
% xline(180);
% hold on
% xline(270);
% hold on
% xline(360);
% subplot(1,4,2)
% hist(wtaorientationdiff,100)
% axis square
% xline(90);
% hold on
% xline(180);
% hold on
% xline(270);
% hold on
% xline(360);
% subplot(1,4,3)
% hist(j20yorientationdiff,100)
% axis square
% xline(90);
% hold on
% xline(180);
% hold on
% xline(270);
% hold on
% xline(360);
% subplot(1,4,4)
% hist(j20aorientationdiff,125)
% axis square
% xline(90);
% hold on
% xline(180);
% hold on
% xline(270);
% hold on
% xline(360);
% ylim([0 140])
% 
% 
% %plot these subplots for grid cells 
% subplot(1,4,1)
% hist(wtyorientationdiff,60)
% axis square
% xline(60);
% hold on
% xline(120);
% hold on
% xline(180);
% hold on
% xline(240);
% hold on
% xline(300);
% hold on
% xline(360);
% hold on
% subplot(1,4,2)
% hist(wtaorientationdiff,90)
% axis square
% xline(60);
% hold on
% xline(120);
% hold on
% xline(180);
% hold on
% xline(240);
% hold on
% xline(300);
% hold on
% xline(360);
% hold on
% % xlim([0,180])
% subplot(1,4,3)
% hist(j20yorientationdiff,60)
% axis square
% xline(60);
% hold on
% xline(120);
% hold on
% xline(180);
% hold on
% xline(240);
% hold on
% xline(300);
% hold on
% xline(360);
% hold on
% ylim([0, 30])
% % xlim([0,180])
% subplot(1,4,4)
% hist(j20aorientationdiff,60)
% axis square
% xline(60);
% hold on
% xline(120);
% hold on
% xline(180);
% hold on
% xline(240);
% hold on
% xline(300);
% hold on
% xline(360);
% hold on
% % xlim([0,180])
% 
% 
% 
% 
% 
% 
% %
% 
% wtymodded60 = mod(wtyorientationdiff,60);
% wtamodded60 = mod(wtaorientationdiff,60);
% j20ymodded60 = mod(j20yorientationdiff,60);
% j20amodded60 = mod(j20aorientationdiff,60);
% 
% wtyorientation60 = (length(find( wtymodded60(:,1) >= 0 & wtymodded60(:,1) < 10)) + length(find( wtymodded60(:,1) > 50 & wtymodded60(:,1) <= 60))) / length(wtymodded60)
% wtaorientation60 = (length(find( wtamodded60(:,1) >= 0 & wtamodded60(:,1) < 10)) + length(find( wtamodded60(:,1) > 50 & wtamodded60(:,1) <= 60))) / length(wtamodded60)
% j20yorientation60 = (length(find( j20ymodded60(:,1) >= 0 & j20ymodded60(:,1) < 10)) + length(find( j20ymodded60(:,1) > 50 & j20ymodded60(:,1) <= 60))) / length(j20ymodded60)
% j20aorientation60 = (length(find( j20amodded60(:,1) >= 0 & j20amodded60(:,1) < 10)) + length(find( j20amodded60(:,1) > 50 & j20amodded60(:,1) <= 60))) / length(j20amodded60)
% 
% avg = (wtyorientation60+wtaorientation60+j20yorientation60+j20aorientation60) / 4
% 
% binopdf((length(find( wtymodded60(:,1) >= 0 & wtymodded60(:,1) < 10)) + length(find( wtymodded60(:,1) > 50 & wtymodded60(:,1) <= 60))), length(wtyorientationdiff), avg)
% binopdf((length(find( wtamodded60(:,1) >= 0 & wtamodded60(:,1) < 10)) + length(find( wtamodded60(:,1) > 50 & wtamodded60(:,1) <= 60))), length(wtaorientationdiff), avg)
% binopdf((length(find( j20ymodded60(:,1) >= 0 & j20ymodded60(:,1) < 10)) + length(find( j20ymodded60(:,1) > 50 & j20ymodded60(:,1) <= 60))), length(j20yorientationdiff), avg)
% binopdf((length(find( j20amodded60(:,1) >= 0 & j20amodded60(:,1) < 10)) + length(find( j20amodded60(:,1) > 50 & j20amodded60(:,1) <= 60))), length(j20aorientationdiff), avg)
% 
% 
% wtymodded90 = mod(wtyorientationdiff,90);
% wtamodded90 = mod(wtaorientationdiff,90);
% j20ymodded90 = mod(j20yorientationdiff,90);
% j20amodded90 = mod(j20aorientationdiff,90);
% 
% wtyorientation90 = (length(find( wtymodded90(:,1) >= 0 & wtymodded90(:,1) < 10)) + length(find( wtymodded90(:,1) > 80 & wtymodded90(:,1) <= 90))) / length(wtymodded90)
% wtaorientation90 = (length(find( wtamodded90(:,1) >= 0 & wtamodded90(:,1) < 10)) + length(find( wtamodded90(:,1) > 80 & wtamodded90(:,1) <= 90))) / length(wtamodded90)
% j20yorientation90 = (length(find( j20ymodded90(:,1) >= 0 & j20ymodded90(:,1) < 10)) + length(find( j20ymodded90(:,1) > 80 & j20ymodded90(:,1) <= 90))) / length(j20ymodded90)
% j20aorientation90 = (length(find( j20amodded90(:,1) >= 0 & j20amodded90(:,1) < 10)) + length(find( j20amodded90(:,1) > 80 & j20amodded90(:,1) <= 90))) / length(j20amodded90)
% 
% avg = (wtyorientation90 + wtaorientation90 + j20yorientation90 + j20aorientation90) / 4
% 
% binopdf((length(find( wtymodded90(:,1) >= 0 & wtymodded90(:,1) < 10)) + length(find( wtymodded90(:,1) > 80 & wtymodded90(:,1) <= 90))), length(wtyorientationdiff), avg)
% binopdf((length(find( wtamodded90(:,1) >= 0 & wtamodded90(:,1) < 10)) + length(find( wtamodded90(:,1) > 80 & wtamodded90(:,1) <= 90))), length(wtaorientationdiff), avg)
% binopdf((length(find( j20ymodded90(:,1) >= 0 & j20ymodded90(:,1) < 10)) + length(find( j20ymodded90(:,1) > 80 & j20ymodded90(:,1) <= 90))), length(j20yorientationdiff), avg)
% binopdf((length(find( j20amodded90(:,1) >= 0 & j20amodded90(:,1) < 10)) + length(find( j20amodded90(:,1) > 80 & j20amodded90(:,1) <= 90))), length(j20aorientationdiff), avg)
% 
% 
% 
% 
% 
% %bar graph
% bar( [wtyorientation60;wtaorientation60;j20yorientation60;j20aorientation60;wtyorientation90;wtaorientation90;j20yorientation90;j20aorientation90])
% ylim([0, 0.8])
% avg = (wtyorientation60 + wtaorientation60 + j20yorientation60 + j20aorientation60) / 4
% yline(avg)
% avg = (wtyorientation90 + wtaorientation90 + j20yorientation90 + j20aorientation90) / 4
% yline(avg)
% axis square
% 
% 
% 
% 
% 
% 
% 
% %%
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
