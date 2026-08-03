

%% if you want to work with grid cells

clear
load('grid_data.mat')

%col 10 is theta and rho values 
wtythetarho = wty_data(:,10);
wtathetarho = wta_data(:,10);
j20ythetarho = j20y_data(:,10);
j20athetarho = j20a_data(:,10);

%col 4 is Fourier spectrum
wtyamp = wty_data(:,4);
wtaamp = wta_data(:,4);
j20yamp = j20y_data(:,4);
j20aamp = j20a_data(:,4);

clear wty_data
clear wta_data
clear j20y_data
clear j20a_data

%% Wavelength analysis

wtywavelengths = [];

for i = 1:size(wtythetarho,1)  
    cel = wtythetarho{i,1};
    f = find(cel(:,2) == 0); %0s are not real, were only there for better polar plots
    cel(f,:) = [];
    cel(end,:) = []; %also get rid of last value, which is the first value + 2pi
    
    cel(find(isnan(cel(:,1))),:) = [];

    powergraph = wtyamp{i,1}'; %retrieve Fourier spectrum for given cell
    
    %iterate through each Fourier component
    for j = 1:size(cel,1)
        angle = cel(j,1); %find the angle
        L = 500; %length of arbitrary line that we will draw on the Fourier spectrum
        startx = 128.5; %center of the Fourier spectrum, which also the start point of the line
        starty = 128.5;
        
        %end point of the line
        x2=startx+(L*cosd(angle));
        y2=starty+(L*sind(angle));
%         plot([startx x2],[starty y2])
%         xlim([0,600])
%         ylim([0 600])
        
        %create vector 
        x = [startx, x2];
        y = [starty, y2];
        [cx,cy,c] = improfile(powergraph, x, y); %draw line on Fourier spectrum image
        [m,idx] = max(c); %distance away from center with the max Fourier power is the spatial wavelength value
        
        wtywavelengths = [wtywavelengths;idx]; %store values
    end
end

%get rid of very small wavelength values 
f = find(wtywavelengths(:,1) < 5);
wtywavelengths(f,:) = [];


wtawavelengths = [];

for i = 1:size(wtathetarho,1)  
    cel = wtathetarho{i,1};
    f = find(cel(:,2) == 0);
    cel(f,:) = [];
    cel(end,:) = [];
    
    cel(find(isnan(cel(:,1))),:) = [];
    
    powergraph = wtaamp{i,1}';
    
    for j = 1:size(cel,1)
        angle = cel(j,1);
        L = 500;
        startx = 128.5;
        starty = 128.5;
        
        x2=startx+(L*cosd(angle));
        y2=starty+(L*sind(angle));
%         plot([startx x2],[starty y2])
%         xlim([0,600])
%         ylim([0 600])
        
        x = [startx, x2];
        y = [starty, y2];
        [cx,cy,c] = improfile(powergraph, x, y);
        [m,idx] = max(c);
        
        wtawavelengths = [wtawavelengths;idx];
    end
end

f = find(wtawavelengths(:,1) < 5);
wtawavelengths(f,:) = [];

j20ywavelengths = [];

for i = 1:size(j20ythetarho,1)  
    cel = j20ythetarho{i,1};
    f = find(cel(:,2) == 0);
    cel(f,:) = [];
    cel(end,:) = [];
    
    
    cel(find(isnan(cel(:,1))),:) = [];

    powergraph = j20yamp{i,1}';
    
    for j = 1:size(cel,1)
        angle = cel(j,1);
        L = 500;
        startx = 128.5;
        starty = 128.5;
        
        x2=startx+(L*cosd(angle));
        y2=starty+(L*sind(angle));
%         plot([startx x2],[starty y2])
%         xlim([0,600])
%         ylim([0 600])
        
        x = [startx, x2];
        y = [starty, y2];
        [cx,cy,c] = improfile(powergraph, x, y);
        [m,idx] = max(c);
        
        j20ywavelengths = [j20ywavelengths;idx];
    end
end

f = find(j20ywavelengths(:,1) < 5);
j20ywavelengths(f,:) = [];


j20awavelengths = [];

for i = 1:size(j20athetarho,1)  
    cel = j20athetarho{i,1};
    f = find(cel(:,2) == 0);
    cel(f,:) = [];
    cel(end,:) = [];
    
    cel(find(isnan(cel(:,1))),:) = [];

    powergraph = j20aamp{i,1}';
    
    for j = 1:size(cel,1)
        angle = cel(j,1);
        L = 500;
        startx = 128.5;
        starty = 128.5;
        
        x2=startx+(L*cosd(angle));
        y2=starty+(L*sind(angle));
%         plot([startx x2],[starty y2])
%         xlim([0,600])
%         ylim([0 600])
        
        x = [startx, x2];
        y = [starty, y2];
        [cx,cy,c] = improfile(powergraph, x, y);
        [m,idx] = max(c);
        
        j20awavelengths = [j20awavelengths;idx];
    end
end

f = find(j20awavelengths(:,1) < 5);
j20awavelengths(f,:) = [];



%plot
subplot(1,4,1)
hist(wtywavelengths,8)
axis square
xlim([0,35])
subplot(1,4,2)
hist(wtawavelengths,10)
axis square
xlim([0,35])
subplot(1,4,3)
hist(j20ywavelengths,15)
axis square
xlim([0,35])
subplot(1,4,4)
hist(j20awavelengths,12)
axis square
xlim([0,35])

f = find(wtywavelengths(:,1) < 15);
wtymod1 = wtywavelengths(f,1);
wtymod1 = nanmean(wtymod1);
f = find(wtywavelengths(:,1) >= 15);
wtymod2 = wtywavelengths(f,1);
wtymod2 = nanmean(wtymod2); 
wtyratio = wtymod2/wtymod1 %ratio

f = find(wtawavelengths(:,1) <= 15);
wtamod1 = wtawavelengths(f,1);
wtamod1 = nanmean(wtamod1);
f = find(wtawavelengths(:,1) > 15);
wtamod2 = wtawavelengths(f,1);
wtamod2 = nanmean(wtamod2);
wtaratio = wtamod2/wtamod1 %ratio

f = find(j20ywavelengths(:,1) <= 16);
j20ymod1 = j20ywavelengths(f,1);
j20ymod1 = nanmean(j20ymod1);
f = find(j20ywavelengths(:,1) > 16 & j20ywavelengths(:,1) < 25);
j20ymod2 = j20ywavelengths(f,1);
j20ymod2 = nanmean(j20ymod2);
j20yratio = j20ymod2/j20ymod1 %ratio

f = find(j20awavelengths(:,1) <= 16);
j20amod1 = j20awavelengths(f,1);
j20amod1 = nanmean(j20amod1);
f = find(j20awavelengths(:,1) > 16 & j20awavelengths(:,1) < 24);
j20amod2 = j20awavelengths(f,1);
j20amod2 = nanmean(j20amod2);
j20aratio = j20amod2/j20amod1 %ratio

%grid numbers
%wty: 12.6, 19.106, 1.516, 
%wta: 12.825, 19.5079, 1.5210, 
%j20y: 13.979, 18.75, 1.34, 
%j20a: 12.6, 20.0588, 1.5913, 


% Note: wavelength units are in pixels. To convert to cm, multiply by 2.08
% (length of environment - 75cm divided by size of rate map - 36 pixels). 



