function [spikes, position_x, position_y, sNeuronResponse, rate_map_smooth] = gc_periodic_baseline(filename,n,tau,dt,beta,alphabar,abar,wtphase);
%-----------------------------------
% Grid Cell Dynamics - Periodic Baseline
% Based on Burak and Fiete (2009)
% N = 128, rate-coded, no damage
% Square 75x75 cm arena
%-----------------------------------
steps = 50000;
if nargin < 1, filename = ''; end
if nargin < 2, n = 128; end
if nargin < 3, tau = 10; end
if nargin < 4, dt = 0.5; end
if nargin < 5, beta = 3/13^2; end
if nargin < 6, alphabar = 1.05*beta; end
if nargin < 7, abar = 1; end
if nargin < 8, wtphase = 2; end

%---------------------
% LOAD OR GENERATE TRAJECTORY
%---------------------
FileLoad = 0;
if exist(filename, 'file') == 2
    load(filename)
    FileLoad = 1;
else
    arena_half = 75 / 2;
    temp_velocity = rand() / 2;
    position_x = zeros(steps, 1);
    position_y = zeros(steps, 1);
    headDirection = zeros(steps, 1)';
    position_x(1) = (rand() - 0.5) * 75;
    position_y(1) = (rand() - 0.5) * 75;
    headDirection(1) = rand() * 2 * pi;

    for i = 2:steps
        temp_rand = max(min(normrnd(0, .05), .2), -.2);
        temp_velocity = min(max(temp_velocity + temp_rand, 0), .25);

        leftOrRight = round(rand());
        if leftOrRight == 0
            leftOrRight = -1;
        end

        next_x = position_x(i-1) + cos(headDirection(i-1)) * temp_velocity;
        next_y = position_y(i-1) + sin(headDirection(i-1)) * temp_velocity;

        while (abs(next_x) > arena_half || abs(next_y) > arena_half)
            headDirection(i-1) = headDirection(i-1) + leftOrRight * pi / 100;
            next_x = position_x(i-1) + cos(headDirection(i-1)) * temp_velocity;
            next_y = position_y(i-1) + sin(headDirection(i-1)) * temp_velocity;
        end

        position_x(i) = next_x;
        position_y(i) = next_y;
        headDirection(i) = mod(headDirection(i-1) + (rand() - .5) / 5 * pi / 2, 2 * pi);
    end
end

sampling_length = length(position_x);

if FileLoad == 1
    if dt ~= .5
        if dt < .1
            position_x = downsample(position_x, floor(.5/dt));
            position_y = downsample(position_y, floor(.5/dt));
            dt = floor(.5/dt) * dt;
        end
        dt = round(dt * 10) / 10;
        position_x = interp(position_x, dt * 10);
        position_y = interp(position_y, dt * 10);
        position_x = downsample(position_x, 5);
        position_y = downsample(position_y, 5);
        dt = .5;
    end

    sampling_length = length(position_x);
    headDirection = zeros(sampling_length, 1);
    for i = 1:(sampling_length - 1)
        headDirection(i) = mod(atan2((position_y(i+1) - position_y(i)), ...
                                     (position_x(i+1) - position_x(i))), 2 * pi);
    end
    headDirection(sampling_length) = headDirection(sampling_length - 1);
end

%----------------------
% INITIALISE VARIABLES
%----------------------
big = 2 * n;
dim = n / 2;

r = zeros(n, n);
rfield = r;
s = r;

spikes = cell(sampling_length, 1);
spikes(:) = {sparse(n, n)};

sNeuronResponse = zeros(sampling_length,1);
sNeuron = [n/2, n/2];

x = -n/2:1:n/2-1;
lx = length(x);
xbar = sqrt(beta) * x;

%------------------------------------
% INITIALISE SYNAPTIC WEIGHT MATRICES
% Equation (3) — Burak and Fiete (2009)
%------------------------------------
filt = abar * exp(-alphabar * (ones(lx,1)*xbar.^2 + xbar'.^2*ones(1,lx))) ...
           - exp(-1  * (ones(lx,1)*xbar.^2 + xbar'.^2*ones(1,lx)));

venvelope = exp(-4 * (x'.^2 * ones(1,n) + ones(n,1) * x.^2) / (n/2)^2);

typeL = repmat([[1,0];[0,0]], dim, dim);
typeR = repmat([[0,0];[0,1]], dim, dim);
typeU = repmat([[0,1];[0,0]], dim, dim);
typeD = repmat([[0,0];[1,0]], dim, dim);

frshift = circshift(filt, [0,  wtphase]);
flshift = circshift(filt, [0, -wtphase]);
fdshift = circshift(filt, [ wtphase, 0]);
fushift = circshift(filt, [-wtphase, 0]);

ftu = fft2(fushift, big, big);
ftd = fft2(fdshift, big, big);
ftl = fft2(flshift, big, big);
ftr = fft2(frshift, big, big);

ftu_small = fft2(fftshift(fushift));
ftd_small = fft2(fftshift(fdshift));
ftl_small = fft2(fftshift(flshift));
ftr_small = fft2(fftshift(frshift));

%----------------------------
% INITIAL MOVEMENT CONDITIONS
%----------------------------
theta_v = pi / 5;
left  = -sin(theta_v);
right =  sin(theta_v);
up    = -cos(theta_v);
down  =  cos(theta_v);
vel   = 0;

%------------------
% INITIALISATION PHASE
%------------------
fig = figure(1);
set(fig, 'Position', [50, 1000, 550, 450]);

for iter = 1:1000
    if iter == 800
        venvelope = ones(n, n);
    end

    rfield = venvelope .* ((1 + vel*right)*typeR + (1 + vel*left)*typeL + ...
                           (1 + vel*up)*typeU   + (1 + vel*down)*typeD);

    convolution = real(ifft2( ...
        fft2(r.*typeR, big, big).*ftr + ...
        fft2(r.*typeL, big, big).*ftl + ...
        fft2(r.*typeD, big, big).*ftd + ...
        fft2(r.*typeU, big, big).*ftu));

    rfield = rfield + convolution(n/2+1:big-n/2, n/2+1:big-n/2);

    fr = (rfield > 0) .* rfield;

    r_old = r;
    r_new = min(10, (dt/tau) * (5*fr - r_old) + r_old);
    r = r_new;

    if mod(iter, 20) == 1
        imagesc(r_new, [0, 2]); colormap(hot); colorbar; drawnow;
        title('Initialisation — Neural Population Activity');
        xlabel('Neuron index (x)');
        ylabel('Neuron index (y)');
    end
end

%----------------------------------------------------------
% SIMULATION PHASE — PERIODIC BOUNDARY, VELOCITY-DRIVEN
%----------------------------------------------------------
increment = 2;
s = r;
set(fig, 'Position', [50, 1000, 450, 900]);

wb = waitbar(0, 'Running simulation...');

for iter = 1:sampling_length - 20

    waitbar(iter / (sampling_length - 20), wb, ...
        sprintf('Step %d / %d (%.1f%%)', iter, sampling_length - 20, ...
        100 * iter / (sampling_length - 20)));

    theta_v = headDirection(increment);
    vel = sqrt((position_x(increment) - position_x(increment-1))^2 + ...
               (position_y(increment) - position_y(increment-1))^2);

    left  = -cos(theta_v);
    right =  cos(theta_v);
    up    =  sin(theta_v);
    down  = -sin(theta_v);

    increment = increment + 1;

    rfield = venvelope .* ((1 + vel*right)*typeR + (1 + vel*left)*typeL + ...
                           (1 + vel*up)*typeU   + (1 + vel*down)*typeD);

    convolution = real(ifft2( ...
        fft2(r.*typeR).*ftr_small + ...
        fft2(r.*typeL).*ftl_small + ...
        fft2(r.*typeD).*ftd_small + ...
        fft2(r.*typeU).*ftu_small));

    rfield = rfield + convolution;

    fr = (rfield > 0) .* rfield;

    r_old = r;
    r_new = min(10, (dt/tau) * (5*fr - r_old) + r_old);
    r = r_new;

    if fr(sNeuron(1), sNeuron(2)) > 0
        sNeuronResponse(increment) = 1;
    end

    if mod(iter, 20) == 1
        subplot(2, 1, 1)
        imagesc(r_new, [0, 2]); colormap(hot); colorbar; drawnow;
        title('Neural Population Activity');
        xlabel('Neuron index (x)');
        ylabel('Neuron index (y)');

        tempx = sNeuronResponse .* position_x;
        tempy = sNeuronResponse .* position_y;
        tempx(tempx == 0) = [];
        tempy(tempy == 0) = [];

        subplot(2, 1, 2)
        plot(position_x(1:increment), position_y(1:increment), '-', ...
             position_x(increment),   position_y(increment),   'o', ...
             tempx, tempy, 'x')
        title('Single Neuron Response');
        xlabel('x position (cm)');
        ylabel('y position (cm)');
        axis([-arena_half, arena_half, -arena_half, arena_half]);
        drawnow;
    end
end

close(wb);

%----------------------------------------------------------
% FIRING RATE MAP
%----------------------------------------------------------
n_bins = 25;
arena_half = 37.5;
bin_edges = linspace(-arena_half, arena_half, n_bins + 1);
bin_centres = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;

spike_map = zeros(n_bins, n_bins);
occupancy_map = zeros(n_bins, n_bins);

for t = 1:length(position_x)
    xi = find(position_x(t) >= bin_edges(1:end-1) & position_x(t) < bin_edges(2:end), 1);
    yi = find(position_y(t) >= bin_edges(1:end-1) & position_y(t) < bin_edges(2:end), 1);
    if ~isempty(xi) && ~isempty(yi)
        spike_map(yi, xi) = spike_map(yi, xi) + sNeuronResponse(t);
        occupancy_map(yi, xi) = occupancy_map(yi, xi) + 1;
    end
end

rate_map = spike_map ./ occupancy_map;
rate_map(occupancy_map == 0) = 0;

rate_map_smooth = imgaussfilt(rate_map, 1);

figure;
imagesc(bin_centres, bin_centres, rate_map_smooth);
colormap(jet); colorbar;
title('Firing Rate Map (25\times25 bins)');
xlabel('x position (cm)');
ylabel('y position (cm)');
axis equal tight;
set(gca, 'YDir', 'normal');

end