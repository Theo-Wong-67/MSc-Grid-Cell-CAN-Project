function [rm_raw, rm_smooth] = ...
    gc_sdnoise(n, tau, dt, beta, alphabar, abar, wtphase, steps, eta_0, sigma_v, mu_v)
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
%   sigma_v  — afferent velocity-noise SD AT THE MEAN SPEED (m/s).  NOT a
%              constant SD -- see the noise block in the simulation loop.
%   mu_v     — reference mean speed (m/s), default 0.4998 (measured).  Only
%              sets what sigma_v means; it does not enter the dynamics.

% Outputs:
%   rm_smooth   — n^2 smoothed rate maps (n_bins × n_bins)
%   rm_raw      — n^2 unsmoothed rate maps (n_bins × n_bins)

    % Burak & Fiete (2009) random walk model from released code, speeds are 5x observed in
    % ying et al., 2023 to decrease simulation time required for the same
    % coverage of the enclosure (Nagaraj & Narayanan, 2024), while keeping difference within an order
    % of magnitude. This is possible because grid pattern flow is determined by eta_0/dt and
    % independent of velocity (Zhi & Cox, 2021)
    if nargin < 11 || isempty(mu_v), mu_v = 0.4998; end   % measured mean speed, m/s
    assert(mu_v > 0, 'gc_sdnoise:mu_v', 'mu_v must be positive');

    en_length = 75; en_half = en_length/2;  % Ying et al. (2023) enclosure specs
    pos_x = zeros(steps,1); pos_y = zeros(steps, 1);
    pos_x(1) = 0; pos_y(1) = 0;
    head_dir = zeros(steps,1); 
    head_dir(1) = rand()*2*pi;              % Random initial heading direction
    temp_vel = rand() * 0.025;
    for i = 2:steps
        temp_accel  = max(min(normrnd(0,0.01), 0.02), -0.02);   % Max accel at 0.02 and Min at -0.02
        temp_vel    = min(max(temp_vel + temp_accel,0), 0.05);  % Max vel at 0.05 and Min at 0
        L_Or_R = randi([0, 1]) * 2 - 1;                         % Output -1 (right turn) or 1 (left turn)
        next_x = pos_x(i-1) + temp_vel*cos(head_dir(i-1));
        next_y = pos_y(i-1) + temp_vel*sin(head_dir(i-1));
        % Keep the animal within the enclosure
        while abs(next_x) > en_half || abs(next_y) > en_half    % Absolute position below half of enclosure length
            head_dir(i-1) = head_dir(i-1) + L_Or_R*pi/100;      % Rotate by pi/100 until next step is within enclosure
            next_x = pos_x(i-1) + temp_vel*cos(head_dir(i-1));
            next_y = pos_y(i-1) + temp_vel*sin(head_dir(i-1));
        end
        pos_x(i)    = next_x;      
        pos_y(i)    = next_y;
        head_dir(i) = mod(head_dir(i-1) + (rand()-0.5)/5*pi/2, 2*pi); % Circular mapped heading direction
    end

    % Neuron indexing
    n_neurons = n^2;               % Square neuron sheet
    neuron_idx = (1:1:n_neurons)'; % Neuron indexing
    
    % Rate map discretisation
    n_bins      = 36;                                     % Number of spatial bins in Ying et al., 2023
    bin_edges   = linspace(-en_half, en_half, n_bins +1); % Find edges of the bins
    rm_raw      = zeros(n_bins, n_bins, n^2);             % Initiate rate map bundles
    rm_smooth   = zeros(n_bins, n_bins, n^2);
    
    % Convolution padding
    big = 2*n; % 256
    dim = n/2;
    % Initial population activity
    r = zeros(n,n); % No firing rate initially
    % Maps 
    spike_maps = zeros(n_bins, n_bins, n^2);
    occupancy_map = zeros(n_bins, n_bins);

    % Weight matrix building
    x    = (-n/2):1:(n/2-1); % 
    lx   = length(x);          
    xbar = sqrt(beta)*x;     % Sub xbar to simplify equation

    % Raw weights
    w_0 = abar * exp(-alphabar*(ones(lx,1)*xbar.^2 + xbar'.^2*ones(1,lx)))... 
        -exp(-1*(ones(lx,1)*xbar.^2 + xbar'.^2*ones(1,lx)));      % Equation 3 Burak & Fiete 2009
    % Aperiodic envelope A(xi)
    venvelope = exp(-4*(x'.^2*ones(1,n)+ones(n,1)*x.^2)/(n/2)^2); % Equation 5 Burak & Fiete 2009

    % Define sub-population of neurons through binary masks
    typeL = repmat([[1,0];[0,0]], dim, dim); % Repeat mapping in both directions in the neural sheet
    typeR = repmat([[0,0];[0,1]], dim, dim); % First indicates U D preferece, Second L R preference
    typeU = repmat([[0,1];[0,0]], dim, dim);
    typeD = repmat([[0,0];[1,0]], dim, dim);

    % Shifted weighted matrix to create preferred direction of neurons
    flshift = circshift(w_0, [0, -wtphase]); % Left  preference
    frshift = circshift(w_0, [0,  wtphase]); % Right preference
    fushift = circshift(w_0, [-wtphase, 0]); % Up    preference
    fdshift = circshift(w_0, [ wtphase, 0]); % Down  preference

    % Big FFT for initiation
    ftl = fft2(flshift, big, big); % Padded for aperiodic boundary, linear convolution
    ftr = fft2(frshift, big, big);
    ftu = fft2(fushift, big, big);
    ftd = fft2(fdshift, big, big);

    % Small FFT for simulation
    ftl_s = fft2(fftshift(flshift)); % Periodic boundary, circular convolution
    ftr_s = fft2(fftshift(frshift));
    ftu_s = fft2(fftshift(fushift));
    ftd_s = fft2(fftshift(fdshift));

    % Initiation Phase
    for iter = 1:1000
        if iter == 800
            venvelope = ones(n,n); % Update to periodic boundary condition
        end

        rfield = venvelope.*(typeL+typeR+typeU+typeD); % Equation 4 Burak & Fiete 2009, v=0 initiation
        convolution = real(ifft2( ...                  % Recurrent input, first term in the rectification
        fft2(r.*typeL, big, big).*ftl + ...            % Sum of recurrent weights via convolution, ifft2 to save computation
        fft2(r.*typeR, big, big).*ftr + ...            
        fft2(r.*typeU, big, big).*ftu + ...
        fft2(r.*typeD, big, big).*ftd));
        rfield = rfield + convolution(n/2+1:big-n/2, n/2+1:big-n/2); % Sum of weights and B
        f_r = (rfield > 0) .* rfield;      % Rectification
        r = min(10, (dt/tau)*(5*f_r-r)+r); % Equation 1 Burak & Fiete 2009, and their implementation in released code
    end

    % Simulation Phase
    % vbar = mean(hypot(diff(pos_x), diff(pos_y))) * (1/100) / (dt/1000); % Mean trajvelocity m/s, for testing only
    increment = 2; % Because pos(0) does not exist
    for iter = 1:steps -20
        theta_v = head_dir(increment);
        vel = sqrt((pos_x(increment) - pos_x(increment-1))^2 + ...
           (pos_y(increment) - pos_y(increment-1))^2) * (1/100) / (dt/1000); % Rescaled velocity
        % Directional velocity representations
        vx = vel*cos(theta_v); % Velocity in reference frame directions
        vy = vel*sin(theta_v);
        increment = increment + 1;
        %% SIGNAL-DEPENDENT afferent noise.  Structure follows N&N
        sd_t = sigma_v * sqrt(vel / mu_v);          % variance ∝ speed
        E = sd_t*randn(n,n);                        % one draw per neuron per step
        rfield = venvelope .* ((1 + eta_0*(vx+E)).*typeR + (1 - eta_0*(vx+E)).*typeL + ...
                               (1 + eta_0*(vy+E)).*typeU + (1 - eta_0*(vy+E)).*typeD); % Equation 4 Burak & Fiete 2009
        %%
        % Small convolution, same implementations as initiation phase
        convolution = real(ifft2( ...
        fft2(r.*typeL).*ftl_s + ...
        fft2(r.*typeR).*ftr_s + ...
        fft2(r.*typeU).*ftu_s + ...
        fft2(r.*typeD).*ftd_s));
        rfield = rfield + convolution;
        f_r = (rfield > 0) .* rfield;
        r  = min(10, (dt/tau) * (5*f_r - r) + r);
        
        % Spatial binning
        x_bin = discretize(pos_x(increment), bin_edges);
        y_bin = discretize(pos_y(increment), bin_edges);
        
        occupancy_map(y_bin, x_bin) = occupancy_map(y_bin, x_bin) +1; % Add 1 to the bin per time step in the bin
        fr_tracked = f_r(neuron_idx);                                 % Accumulate firing rate values
        spike_maps(y_bin, x_bin,:) = spike_maps(y_bin, x_bin,:) + ... % Add neuron activity to the bin its in 
            reshape(fr_tracked, 1,1,n_neurons);
    end
    
    % Rate map calculations and smoothing
    for k = 1:n^2
        rm               = spike_maps(:,:,k)./occupancy_map; % Occupancy normalisation
        rm(occupancy_map == 0) = 0;                          % Guarding unvisited bins
        rm_raw(:,:,k)    = rm;
        rm_smooth(:,:,k) = imgaussfilt(rm, 2.5);             % Reduced smoothing compared to Ying et al., 2023 due to lower level of noise
    end
end
