function [spikes, position_x, position_y, sNeuronResponse, rate_maps_smooth, sNeurons] = ...
         gc_non_periodic(filename, n, tau, dt, beta, alphabar, abar, wtphase, alpha, useSpiking, n_track)
%-----------------------------------
% Grid Cell Dynamics - Non-Periodic
% Based on Burak and Fiete (2009)
%
% n_track controls how many neurons are tracked:
%   n_track = 3       track 3 random neurons (default)
%   n_track = n*n     track every neuron on the sheet
%
% Rate maps are accumulated directly during the simulation loop so
% memory scales as (n_bins x n_bins x n_track), not (steps x n_track).
% This makes tracking all n*n neurons feasible without storing the
% full spike history.
%-----------------------------------

%---------------------
% DEFAULTS
%---------------------
if nargin < 11 || isempty(n_track)
    n_track = 3;
end

track_all = (n_track == n*n);   % flag: are we tracking every neuron?

%---------------------
% LOAD OR GENERATE TRAJECTORY
%---------------------
FileLoad = 0;
if exist(filename,'file') == 2
    load(filename)
    FileLoad = 1;
else
    arena_half = 37.5;
    temp_velocity = rand()/2;
    position_x = zeros(20000,1);
    position_y = zeros(20000,1);
    headDirection = zeros(20000,1)';
    position_x(1) = (rand()-0.5)*75;
    position_y(1) = (rand()-0.5)*75;
    headDirection(1) = rand()*2*pi;

    for i = 2:20000
        temp_rand = max(min(normrnd(0,.05),.2),-.2);
        temp_velocity = min(max(temp_velocity + temp_rand,0),.25);
        leftOrRight = round(rand());
        if leftOrRight == 0, leftOrRight = -1; end

        next_x = position_x(i-1) + cos(headDirection(i-1))*temp_velocity;
        next_y = position_y(i-1) + sin(headDirection(i-1))*temp_velocity;

        while (abs(next_x) > arena_half || abs(next_y) > arena_half)
            headDirection(i-1) = headDirection(i-1) + leftOrRight*pi/100;
            next_x = position_x(i-1) + cos(headDirection(i-1))*temp_velocity;
            next_y = position_y(i-1) + sin(headDirection(i-1))*temp_velocity;
        end

        position_x(i) = next_x;
        position_y(i) = next_y;
        headDirection(i) = mod(headDirection(i-1) + (rand()-.5)/5*pi/2, 2*pi);
    end
end

sampling_length = length(position_x);
if FileLoad == 1
    if dt ~= .5
        if dt < .1
            position_x = downsample(position_x, floor(.5/dt));
            position_y = downsample(position_y, floor(.5/dt));
            dt = floor(.5/dt)*dt;
        end
        dt = round(dt*10)/10;
        position_x = interp(position_x, dt*10);
        position_y = interp(position_y, dt*10);
        position_x = downsample(position_x, 5);
        position_y = downsample(position_y, 5);
        dt = .5;
    end
    sampling_length = length(position_x);
    headDirection = zeros(sampling_length,1);
    for i = 1:(sampling_length-1)
        headDirection(i) = mod(atan2((position_y(i+1)-position_y(i)), ...
                                     (position_x(i+1)-position_x(i))), 2*pi);
    end
    headDirection(sampling_length) = headDirection(sampling_length-1);
end

%----------------------
% NEURON SELECTION
%----------------------
if track_all
    % All neurons on the sheet in row-major order
    [row_grid, col_grid] = ndgrid(1:n, 1:n);
    sNeurons = [row_grid(:), col_grid(:)];   % (n*n) x 2
    fprintf('[gc_non_periodic] Tracking all %d neurons.\n', n*n);
else
    % Random sample of n_track neurons
    rng('shuffle');
    sNeurons = [randi([1,n], n_track, 1), randi([1,n], n_track, 1)];
    fprintf('[gc_non_periodic] Tracking %d random neurons:\n', n_track);
    for k = 1:n_track
        fprintf('  Neuron %d: row=%d  col=%d\n', k, sNeurons(k,1), sNeurons(k,2));
    end
end

% Pre-compute linear indices into the n x n sheet for fast lookup
neuron_lin_idx = sub2ind([n, n], sNeurons(:,1), sNeurons(:,2));   % n_track x 1

%----------------------
% INITIALISE VARIABLES
%----------------------
big = 2*n;
dim = n/2;

r      = zeros(n,n);
rfield = r;
s      = r;

spikes = cell(sampling_length,1);
spikes(:) = {sparse(n,n)};

% sNeuronResponse: track neuron 1 only over time, for the real-time plot
% and backward compatibility. Not used for rate map accumulation.
sNeuronResponse = zeros(sampling_length, 1);

% Spike maps: accumulate firing directly into spatial bins during the loop.
% Dimensions: (n_bins x n_bins x n_track) — memory stays fixed regardless
% of simulation length, making this scale to all n*n neurons.
n_bins    = 25;
arena_half = 37.5;
bin_edges  = linspace(-arena_half, arena_half, n_bins + 1);
bin_centres = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;

spike_maps    = zeros(n_bins, n_bins, n_track);
occupancy_map = zeros(n_bins, n_bins);

%------------------------------------
% WEIGHT MATRICES
%------------------------------------
x    = -n/2:1:n/2-1;
lx   = length(x);
xbar = sqrt(beta)*x;

filt = abar*exp(-alphabar*(ones(lx,1)*xbar.^2 + xbar'.^2*ones(1,lx))) ...
           - exp(-1*(ones(lx,1)*xbar.^2 + xbar'.^2*ones(1,lx)));

venvelope = exp(-4*(x'.^2*ones(1,n) + ones(n,1)*x.^2)/(n/2)^2);

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

%----------------------------
% INITIAL MOVEMENT CONDITIONS
%----------------------------
theta_v = pi/5;
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

for iter = 1:500
    rfield = venvelope.*((1+vel*right)*typeR + (1+vel*left)*typeL + ...
                         (1+vel*up)*typeU   + (1+vel*down)*typeD);

    convolution = real(ifft2( ...
        fft2(r.*typeR, big, big).*ftr + ...
        fft2(r.*typeL, big, big).*ftl + ...
        fft2(r.*typeD, big, big).*ftd + ...
        fft2(r.*typeU, big, big).*ftu));

    rfield = rfield + convolution(n/2+1:big-n/2, n/2+1:big-n/2);
    fr = (rfield > 0) .* rfield;
    r_old = r;
    r = min(10, (dt/tau)*(5*fr - r_old) + r_old);

    if mod(iter,20) == 1
        imagesc(r, [0,2]); colormap(hot); colorbar; drawnow;
        title('Initialisation — Neural Population Activity');
        xlabel('Neuron index (x)'); ylabel('Neuron index (y)');
    end
end

%----------------------------------------------------------
% SIMULATION PHASE
%----------------------------------------------------------
increment = 2;
s = r;
set(fig, 'Position', [50, 1000, 450, 900]);
wb = waitbar(0, 'Running simulation...');

for iter = 1:sampling_length - 20

    waitbar(iter/(sampling_length-20), wb, ...
        sprintf('Step %d / %d (%.1f%%)', iter, sampling_length-20, ...
        100*iter/(sampling_length-20)));

    theta_v = headDirection(increment);
    vel = sqrt((position_x(increment) - position_x(increment-1))^2 + ...
               (position_y(increment) - position_y(increment-1))^2);
    left  = -cos(theta_v);
    right =  cos(theta_v);
    up    =  sin(theta_v);
    down  = -sin(theta_v);

    increment = increment + 1;

    rfield = venvelope.*((1+alpha*vel*right)*typeR + (1+alpha*vel*left)*typeL + ...
                         (1+alpha*vel*up)*typeU   + (1+alpha*vel*down)*typeD);

    convolution = real(ifft2( ...
        fft2(r.*typeR, big, big).*ftr + ...
        fft2(r.*typeL, big, big).*ftl + ...
        fft2(r.*typeD, big, big).*ftd + ...
        fft2(r.*typeU, big, big).*ftu));

    rfield = rfield + convolution(n/2+1:big-n/2, n/2+1:big-n/2);
    fr = (rfield > 0) .* rfield;
    r_old = r;
    r_new = min(10, (dt/tau)*(5*fr - r_old) + r_old);
    r = r_new;

    if useSpiking == 1
        spike = rfield*dt > rand(n,n);
        s = min(10, s + (dt/tau)*(-s + (tau/dt)*spike));
        r = s;
        spikes{increment,1} = sparse(spike);
    end

    % ----------------------------------------------------------
    % DIRECT ACCUMULATION — add current firing into spatial bins.
    % This runs for every neuron simultaneously using linear indexing,
    % so it is the same cost whether n_track = 3 or n_track = n*n.
    % ----------------------------------------------------------
    xi = find(position_x(increment) >= bin_edges(1:end-1) & ...
              position_x(increment) <  bin_edges(2:end), 1);
    yi = find(position_y(increment) >= bin_edges(1:end-1) & ...
              position_y(increment) <  bin_edges(2:end), 1);

    if ~isempty(xi) && ~isempty(yi)
        occupancy_map(yi, xi) = occupancy_map(yi, xi) + 1;

        % fr(:) flattens the sheet; neuron_lin_idx picks the tracked ones
        fr_flat    = fr(:);
        fr_tracked = fr_flat(neuron_lin_idx);           % n_track x 1
        spike_maps(yi, xi, :) = spike_maps(yi, xi, :) + ...
                                 reshape(fr_tracked, 1, 1, n_track);
    end

    % Track neuron 1 for real-time plot and backward compatibility
    if fr(sNeurons(1,1), sNeurons(1,2)) > 0
        sNeuronResponse(increment) = 1;
    end

    if mod(iter,20) == 1
        subplot(2,1,1)
        imagesc(r_new, [0,2]); colormap(hot); colorbar; drawnow;
        title('Neural Population Activity');
        xlabel('Neuron index (x)'); ylabel('Neuron index (y)');

        tempx = sNeuronResponse(1:increment) .* position_x(1:increment);
        tempy = sNeuronResponse(1:increment) .* position_y(1:increment);
        tempx(tempx == 0) = [];
        tempy(tempy == 0) = [];
        subplot(2,1,2)
        plot(position_x(1:increment), position_y(1:increment), '-', ...
             position_x(increment),   position_y(increment),   'o', ...
             tempx, tempy, 'x');
        title('Single Neuron Response (Neuron 1)');
        xlabel('x position (cm)'); ylabel('y position (cm)');
        axis([-arena_half, arena_half, -arena_half, arena_half]);
        drawnow;
    end
end

close(wb);

%----------------------------------------------------------
% COMPUTE RATE MAPS FROM ACCUMULATED SPIKE MAPS
%----------------------------------------------------------
rate_maps_smooth = zeros(n_bins, n_bins, n_track);

for k = 1:n_track
    rm = spike_maps(:,:,k) ./ occupancy_map;
    rm(occupancy_map == 0) = 0;
    rate_maps_smooth(:,:,k) = imgaussfilt(rm, 1);
end

% Show rate maps — up to 3 for readability; show all if n_track is small
n_show = min(n_track, 3);
figure('Name', sprintf('Rate Maps (%d tracked neurons)', n_track), ...
       'Position', [50 50 1300 400]);
for k = 1:n_show
    subplot(1, n_show, k)
    imagesc(bin_centres, bin_centres, rate_maps_smooth(:,:,k));
    colormap(jet); colorbar;
    if track_all
        title(sprintf('Neuron %d of %d', k, n_track));
    else
        title(sprintf('Neuron %d  [row=%d, col=%d]', k, sNeurons(k,1), sNeurons(k,2)));
    end
    xlabel('x (cm)'); ylabel('y (cm)');
    axis equal tight; set(gca, 'YDir', 'normal');
end
if n_track > 3
    sgtitle(sprintf('Rate Maps — showing 3 of %d tracked neurons', n_track));
else
    sgtitle('Rate Maps — Tracked Neurons');
end

end