

clear
load('C:\Users\Johnson\Desktop\moto\2d spatial fourier\new analyses\grid_dir_separated_into_hexagonal_and_rectangular.mat')

wta_filt = j20adir2

count = 1;

for iii = 1:8    %%
    disp(iii)
    load(wta_filt{iii,3});
    cel = wta_filt{iii,4};
    
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
    
    % plot original image
    subplot(8,10,count)
    imagesc(rate_map2)
    axis off, axis square
    colormap jet
    
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
        %     imgXX(121:136,121:136) = 0;
        powr22 = (abs(imgXX));
        %     powr33 = imgXX;
        %     for nn = 1:nx
        %         for mm = 1:mx
        %             powr33(mm,nn) = sqrt((real(imgXX(mm,nn))^2) + (imag(imgXX(mm,nn))^2));
        %         end
        %     end
        %     powr33 = abs(imgXX);
        powr33 = abs(imgXX.^2);
        
        width  = 40;   % width of gaussian
        [x,y]  = ndgrid(1:size(imgLL,1),1:size(imgLL,2));
        [row, col] = find(ismember(powr33, max(powr33(:))));
        gaus2d = 1-exp(-((x-col).^2 + (y-row).^2) ./ (2*width^2));
        f = gaus2d == 1;
        gaus2d = gaus2d .* f;
        powr33 = powr33 .* gaus2d;
        
        allpowers = [allpowers; reshape(powr33,[],1)];
    end
    prc50 = prctile(allpowers,95);     %%%%%%%%
    
    powr3 = powr3 - prc50;
    f = powr3 > 0;
    powr3 = powr3 .* f;
    maxfpower = nanmax(nanmax(powr3)); %max fourier power...
    threshold = 0.25*maxfpower;         %%%%%%%%%%
    
    f = powr3 > threshold;
    powr3 = powr3 .* f;
    
%     %extra round of filtering       %%%%%%%%%
%     maxfpower = nanmax(nanmax(powr3)); %max fourier power...
%     threshold = 0.5*maxfpower;
%     f = powr3 > threshold;
%     powr3 = powr3 .* f;
    
    subplot(8,10,count+1)
    imagesc(moserac(rate_map2))
    % set(gca,'clim',[50 150])
    axis off, axis square
    colormap jet

    subplot(8,10,count+2)
    imagesc(powr3(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    % set(gca,'clim',[50 150])
    axis off, axis square
    colormap jet
    
    
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
    
    disttocenter = [];
    for i = 1:size(measurements,1)
        c = measurements(i).Centroid;
        center = [128.5,128.5];
        dx = (center(1,1) - c(1,1));
        dy = (center(1,2) - c(1,2));
        
        disttocenter = [disttocenter; [-dx,dy]]; %arbitrary signs just to visualize easier
    end
    clear i
    b = 2.08; %in cm. binsize
    
    clear i
    kyx = [];
    for ii = 1:size(disttocenter,1)
        dy = disttocenter(ii,2);
        dx = disttocenter(ii,1);
        
        ky = 2*pi*dy / (mx*b);
        kx = 2*pi*dx / (nx*b);
        
        kyx = [kyx; [kx,ky]];
    end
    
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
    
    
    thetarho2 = [];
    for ii = 1:size(thetarho,1)-1
        thetarho2 = [thetarho2;[thetarho(ii,1), thetarho(ii,2)]];
        
        interptheta = linspace(thetarho(ii,1), thetarho(ii+1,1), 30)';
        interprho = linspace(thetarho(ii,2), thetarho(ii+1,2), 30)';
        
        btwn = [interptheta,interprho];
        
        thetarho2 = [thetarho2;btwn];
    end
    
    pax = subplot(8,10,count+3, polaraxes);
    polarplot(thetarho(:,1), sqrt(thetarho(:,2)),'k','LineWidth',2)
    pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    
%     pax = subplot(8,16,count+3, polaraxes);
%     polarplot(thetarho2(:,1), sqrt(thetarho2(:,2)),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
%     pax.RGrid  = 'off';
%     pax.RTickLabels = [];
%     set(gcf,'color','w');
%     
    count = count + 10;
end

