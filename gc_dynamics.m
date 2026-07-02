function gc_dynamics()
    close all;

    % Network parameters — Burak & Fiete (2009)
    dt       = 0.5;
    n        = 128;
    tau      = 10;
    lambda   = 13;
    beta     = 3/lambda^2;
    alphabar = 1.05;
    abar     = 1;
    wtphase  = 2;
    steps    = 400000;
    eta_0    = 0.15;

    % RUN SIMULATION
    fprintf('\n[gc_dynamics] Running\n');
    [~, ~, rm_smooth, ~] = ...
        gc_periodic_baseline(n, tau, dt, beta, alphabar, abar, wtphase, steps, eta_0);

    % ANALYSIS
    fprintf('\n[gc_dynamics] Running population Fourier analysis (%d neurons)...\n', n^2);
    population_fourier_analysis(rm_smooth, .4);

end