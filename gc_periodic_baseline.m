function [spikes, position_x, position_y, rate_maps_smooth, sNeurons] = ...
         gc_periodic_baseline(n, tau, dt, beta, alphabar, abar, wtphase, n_track)
%-----------------------------------
% Grid Cell Dynamics - Periodic Baseline
% Based on Burak and Fiete (2009)
% N = 128, rate-coded, no damage
% Square 75x75 cm arena
%
% n_track controls how many neurons are tracked:
%   n_track = 3       track 3 random neurons (default)
%   n_track = n*n     track every neuron on the sheet
%
% Periodic boundary conditions are preserved via the small FFT
% convolution (no zero-padding) in the simulation phase.
%-----------------------------------

steps = 50000;
if nargin < 1,  n         = 128;  end
if nargin < 2,  tau       = 10;   end
if nargin < 3,  dt        = 0.5;  end
if nargin < 4,  beta      = 3/13^2; end
if nargin < 5,  alphabar  = 1.05*beta; end
if nargin < 6,  abar      = 1;    end
if nargin < 7,  wtphase   = 2;    end
if nargin < 8  || isempty(n_track), n_track = 3; end

track_all = (n_track == n*n);

%---------------------
% GENERATE TRAJECTORY
%---------------------
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
    if leftOrRight == 0, leftOrRight = -1; end
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

sampling_length = length(position_x);

%----------------------
% NEURON SELECTION
%----------------------
if track_all
    [row_grid, col_grid] = ndgrid(1:n, 1:n);
    sNeurons = [row_grid(:), col_grid(:)];
    fprintf('[gc_periodic_baseline] Tracking all %d neurons.\n', n*n);
else
    rng('shuffle');
    sNeurons = [randi([1,n], n_track, 1), randi([1,n], n_track, 1)];
    fprintf('[gc_periodic_baseline] Tracking %d random neurons:\n', n_track);
    for k = 1:n_track
        fprintf('  Neuron %d: row=%d  col=%d\n', k, sNeurons(k,1), sNeurons(k,2));
    end
end

% Pre-compute linear indices for fast lookup during the simulation loop
neuron_lin_idx = sub2ind([n, n], sNeurons(:,1), sNeurons(:,2));

%----------------------
% INITIALISE VARIABLES
%----------------------
big = 2 * n;
dim = n / 2;

r      = zeros(n, n);
rfield = zeros(n, n);

spikes = {};   % rate-coded mode — spike cell array not populated

% Direct accumulation — memory is (n_bins x n_bins x n_track) regardless
% of simulation length
n_bins      = 36;
arena_half  = 37.5;
bin_edges   = linspace(-arena_half, arena_half, n_bins + 1);

spike_maps    = zeros(n_bins, n_bins, n_track);
occupancy_map = zeros(n_bins, n_bins);

%------------------------------------
% SYNAPTIC WEIGHT MATRICES
%------------------------------------
x    = -n/2:1:n/2-1;
lx   = length(x);
xbar = sqrt(beta) * x;

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

% Big FFT — used only during initialisation phase
ftu = fft2(fushift, big, big);
ftd = fft2(fdshift, big, big);
ftl = fft2(flshift, big, big);
ftr = fft2(frshift, big, big);

% Small FFT — used during simulation phase (no zero-padding = periodic BC)
ftu_small = fft2(fftshift(fushift));
ftd_small = fft2(fftshift(fdshift));
ftl_small = fft2(fftshift(flshift));
ftr_small = fft2(fftshift(frshift));

%------------------
% INITIALISATION PHASE  (1000 iterations, big FFT)
%------------------

for iter = 1:1000
    if iter == 800
        venvelope = ones(n, n);   % remove taper once bump is stable
    end

    rfield = venvelope;   % vel=0 during init: all subpopulations get equal drive

    % Big (zero-padded) FFT convolution during initialisation
    convolution = real(ifft2( ...
        fft2(r.*typeR, big, big).*ftr + ...
        fft2(r.*typeL, big, big).*ftl + ...
        fft2(r.*typeD, big, big).*ftd + ...
        fft2(r.*typeU, big, big).*ftu));

    rfield = rfield + convolution(n/2+1:big-n/2, n/2+1:big-n/2);

    fr = (rfield > 0) .* rfield;
    r  = min(10, (dt/tau) * (5*fr - r) + r);

end

%----------------------------------------------------------
% SIMULATION PHASE — small FFT (periodic boundary conditions)
%----------------------------------------------------------
increment = 2;

for iter = 1:sampling_length - 20

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

    % Small FFT convolution — no zero-padding = periodic boundary conditions
    convolution = real(ifft2( ...
        fft2(r.*typeR).*ftr_small + ...
        fft2(r.*typeL).*ftl_small + ...
        fft2(r.*typeD).*ftd_small + ...
        fft2(r.*typeU).*ftu_small));

    rfield = rfield + convolution;

    fr = (rfield > 0) .* rfield;
    r  = min(10, (dt/tau) * (5*fr - r) + r);

    % ----------------------------------------------------------
    % DIRECT ACCUMULATION into spatial bins
    % ----------------------------------------------------------
    xi = discretize(position_x(increment), bin_edges);
    yi = discretize(position_y(increment), bin_edges);

    if ~isnan(xi) && ~isnan(yi)
        occupancy_map(yi, xi) = occupancy_map(yi, xi) + 1;
        fr_flat    = fr(:);
        % Binary accumulation — matches original: records 1 if neuron fired
        fr_tracked = fr_flat(neuron_lin_idx) > 0;
        spike_maps(yi, xi, :) = spike_maps(yi, xi, :) + ...
                                 reshape(fr_tracked, 1, 1, n_track);
    end

end

%----------------------------------------------------------
% COMPUTE RATE MAPS FROM ACCUMULATED SPIKE MAPS
%----------------------------------------------------------
rate_maps_smooth = zeros(n_bins, n_bins, n_track);

for k = 1:n_track
    rm = spike_maps(:,:,k) ./ occupancy_map;
    rm(occupancy_map == 0) = 0;
    rate_maps_smooth(:,:,k) = imgaussfilt(rm, 1);
end

end