function [spikes] = gc_dynamics(dt, useSpiking, simulate_non_periodic, n_track)
%---------------------------------------------------------------
% GC Dynamics — entry point
% Burak & Fiete (2009)
%
% Usage:
%   gc_dynamics(0, 0, 0)          periodic BC, 3 neurons
%   gc_dynamics(0, 0, 0, 3)       periodic BC, 3 neurons
%   gc_dynamics(0, 0, 0, 128^2)   periodic BC, all neurons
%   gc_dynamics(0, 0, 1, 3)       non-periodic BC, 3 neurons
%---------------------------------------------------------------
close all;

if dt == 0,  dt = 0.5;  end

% Network parameters
n        = 2^7;
tau      = 5;
lambda   = 13;
beta     = 3/lambda^2;
alphabar = 1.05;
abar     = 1;
wtphase  = 2;  
alpha    = 1;

if nargin < 4 || isempty(n_track)
    n_track = 3;
end

%---------------
% RUN SIMULATION
%---------------
if simulate_non_periodic == 0
    [spikes, ~, ~, rate_maps_smooth, sNeurons] = ...
        gc_periodic_baseline(n, tau, dt, beta, alphabar, abar, wtphase, n_track);

elseif simulate_non_periodic == 1
    [spikes, ~, ~, ~, rate_maps_smooth, sNeurons] = ...
        gc_non_periodic('', n, tau, dt, beta, alphabar, abar, ...
                        wtphase, alpha, useSpiking, n_track);
end

%---------------
% ANALYSIS
%---------------
if n_track <= 10
    for k = 1:n_track
        fprintf('\n==============================\n');
        fprintf(' Fourier analysis — Neuron %d  [row=%d, col=%d]\n', ...
                k, sNeurons(k,1), sNeurons(k,2));
        fprintf('==============================\n');
        fourier_analysis(rate_maps_smooth(:,:,k), [], [], [], ...
            sprintf('Neuron %d  [row=%d, col=%d]', k, sNeurons(k,1), sNeurons(k,2)));
    end
else
    fprintf('\n[gc_dynamics] Running population Fourier analysis (%d neurons)...\n', n_track);
    population_fourier_analysis(rate_maps_smooth);
end

end