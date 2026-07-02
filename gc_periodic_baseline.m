function [pos_x, pos_y, rm_smooth, sNeurons] = ...
    gc_periodic_baseline(n, tau, dt, beta, alphabar, abar, wtphase, steps, eta_0)

% Parameter in correspondence with Burak & Fiete (2009):
%   n        — network side length (N = n×n neurons)
%   tau      — neural time constant τ (ms)
%   dt       — simulation time step (ms)
%   beta     — inhibitory Gaussian decay rate β = 3/λ², where λ = 13 (lattice periodicity)
%   alphabar — excitatory Gaussian decay rate γ/β = 1.05
%   abar     — excitatory amplitude a
%   wtphase  — weight shift l (neurons)
%   steps    — number of steps taken
%   eta_0    — translation velocity scaling

% Outputs:
%   pos_x       — x trajectory (steps × 1, cm)
%   pos_y       — y trajectory (steps × 1, cm)
%   rm_smooth   — n^2 smoothed rate maps (n_bins × n_bins)
%   sNeurons    — tracked neuron positions on sheet (n^2 × 2, [row col])

    % Random walk model Burak & Fiete (2009)
    en_length = 75; en_half = en_length/2 ; 
    pos_x = zeros(steps, 1); pos_x(1) = 0;
    pos_y = zeros(steps, 1); pos_y(1) = 0;
    headDir = zeros(steps, 1); headDir(1) = rand()*2*pi;
    temp_vel = rand() * 0.025;
    for i = 2:steps
        temp_acc = max(min(normrnd(0, 0.010), 0.020), -0.020); % Stability criteria η₀ × v < 1.4
        temp_vel = min(max(temp_vel + temp_acc, 0), 0.05);
        L_Or_R = randi([0, 1]) * 2 - 1; % Output -1 or 1
        next_x = pos_x(i-1) + temp_vel*cos(headDir(i-1));
        next_y = pos_y(i-1) + temp_vel*sin(headDir(i-1));
        % Rotate until next position is within enclosure
        while abs(next_x) > en_half || abs(next_y) > en_half  
            headDir(i-1) = headDir(i-1) + L_Or_R*pi/100;
            next_x = pos_x(i-1) + temp_vel * cos(headDir(i-1));
            next_y = pos_y(i-1) + temp_vel * sin(headDir(i-1));
        end
        pos_x(i) = next_x;
        pos_y(i) = next_y;
        headDir(i) = mod(headDir(i-1) + (rand()-.5)/5*pi/2,2*pi);
    end
    
    % Neuron indexing
    n_neurons = n^2;
    [row_coord, col_coord] = ndgrid(1:n, 1:n);
    sNeurons = [row_coord(:), col_coord(:)];
    neuron_idx = sub2ind([n,n], sNeurons(:,1), sNeurons(:,2));
    
    % Discretise to Ying et al. 2023
    n_bins      = 36;
    bin_edges   = linspace(-en_half, en_half, n_bins + 1);
    rm_smooth = zeros(n_bins, n_bins, n^2);

    % padding for convolutions
    big = 2*n; 
    dim = n/2; 
    % initial population activity
    r=zeros(n,n);  
    % Maps
    spike_maps    = zeros(n_bins, n_bins, n^2);
    occupancy_map = zeros(n_bins, n_bins);

    % Weights
    x = -n/2:1:n/2-1;
    lx = length(x);
    xbar = sqrt(beta) * x;
    % Raw weight
    w_0 = abar * exp(-alphabar*(ones(lx,1)*xbar.^2 + xbar'.^2*ones(1,lx)))... 
        -exp(-1*(ones(lx,1)*xbar.^2 + xbar'.^2*ones(1,lx)));
    % Feedforward envelope A(xi)
    venvelope = exp(-4 * (x'.^2 * ones(1,n) + ones(n,1) * x.^2) / (n/2)^2);

    % Define sub-population of neurons using binary masks
    typeL = repmat([[1,0];[0,0]], dim, dim);
    typeR = repmat([[0,0];[0,1]], dim, dim);
    typeU = repmat([[0,1];[0,0]], dim, dim);
    typeD = repmat([[0,0];[1,0]], dim, dim);

    % Shift weight matrix by wtphase (neurons) to create preferred direction
    frshift = circshift(w_0, [0,  wtphase]);
    flshift = circshift(w_0, [0, -wtphase]);
    fdshift = circshift(w_0, [ wtphase, 0]);
    fushift = circshift(w_0, [-wtphase, 0]);

    % Big FFT to create stable initiation
    ftu = fft2(fushift, big, big);
    ftd = fft2(fdshift, big, big);
    ftl = fft2(flshift, big, big);
    ftr = fft2(frshift, big, big);

    % Small FFT used during simulation phase 
    ftu_small = fft2(fftshift(fushift));
    ftd_small = fft2(fftshift(fdshift));
    ftl_small = fft2(fftshift(flshift));
    ftr_small = fft2(fftshift(frshift));

    % Initiation phase
    for iter = 1:1000 
        if iter == 800
            venvelope = ones(n,n); % Update to periodic boundary condition
        end

        rfield = venvelope.* (typeR + typeL + typeU + typeD); % No velocity in initiation phase
        convolution = real(ifft2( ...
        fft2(r.*typeR, big, big).*ftr + ...
        fft2(r.*typeL, big, big).*ftl + ...
        fft2(r.*typeD, big, big).*ftd + ...
        fft2(r.*typeU, big, big).*ftu));
        % Central region convolution extraction
        rfield = rfield + convolution(n/2+1:big-n/2, n/2+1:big-n/2); 
        f_r = (rfield > 0) .* rfield; % rectification
        r  = min(10, (dt/tau) * (5*f_r - r) + r); % firing rate equation
    end 

    % Plot rate map
    figure; imagesc(r); colormap(hot); colorbar;
    title('Sheet activity after init');
    
    % Simulation phase
    increment  = 2; % Initial increment = 2, because no pos(0)
    for iter = 1:steps -20 % -20 from Burak and Fiete
        theta_v = headDir(increment);
        vel = sqrt((pos_x(increment) - pos_x(increment-1))^2 + ...
           (pos_y(increment) - pos_y(increment-1))^2) * (1/100) / (dt/1000);
        % directional velocity
        left  = -cos(theta_v);
        right =  cos(theta_v);
        up    =  sin(theta_v);
        down  = -sin(theta_v);
        increment = increment + 1;
        rfield = venvelope .* ((1 + eta_0*vel*right)*typeR + (1 + eta_0*vel*left)*typeL + ...
                           (1 + eta_0*vel*up)*typeU   + (1 + eta_0*vel*down)*typeD);

        % Small convolution
        convolution = real(ifft2( ...
        fft2(r.*typeR).*ftr_small + ...
        fft2(r.*typeL).*ftl_small + ...
        fft2(r.*typeD).*ftd_small + ...
        fft2(r.*typeU).*ftu_small));
        rfield = rfield + convolution;
        f_r = (rfield > 0) .* rfield;
        r  = min(10, (dt/tau) * (5*f_r - r) + r);
        
        % Spatial binning
        x_bin = discretize(pos_x(increment), bin_edges);
        y_bin = discretize(pos_y(increment), bin_edges);
        % Guarding overstepping
        if ~isnan(x_bin) && ~isnan(y_bin)
            occupancy_map(y_bin, x_bin) = occupancy_map(y_bin, x_bin) + 1;
            fr_tracked = f_r(neuron_idx) > 0;
            spike_maps(y_bin, x_bin, :) = spike_maps(y_bin, x_bin, :) +...
                reshape(fr_tracked, 1, 1, n_neurons);
        end
    end

    % Rate map calculations
    for k = 1:n^2
        rm = spike_maps(:,:,k)./occupancy_map;
        rm(occupancy_map == 0) = 0; % Prevent unvisited bins
        rm_smooth(:,:,k) = imgaussfilt(rm,1);
    end
end