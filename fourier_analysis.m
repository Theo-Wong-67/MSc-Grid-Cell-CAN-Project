function fourier_analysis(rate_map_smooth)
% Fourier analysis of a single neuron firing rate map
% Following Ying et al. (2023) STAR Methods

% Zero-pad to 256x256
rate_map_padded = zeros(256, 256);
[rows, cols] = size(rate_map_smooth);  % should be 25x25
row_offset = floor((256 - rows) / 2);
col_offset = floor((256 - cols) / 2);
rate_map_padded(row_offset+1:row_offset+rows, col_offset+1:col_offset+cols) = rate_map_smooth;

% 2D Fourier transform
win = hann(256) * hann(256)';
rate_map_padded_windowed = rate_map_padded .* win;
F = fft2(rate_map_padded_windowed);
F_shifted = fftshift(F);
power = abs(F_shifted).^2;

% Find dominant components — exclude DC (centre)
centre = [129, 129];
[rows_grid, cols_grid] = ndgrid(1:256, 1:256);
dist_from_centre = sqrt((rows_grid - centre(1)).^2 + (cols_grid - centre(2)).^2);

% Mask DC and near-DC
min_radius = 10;
max_radius = 100;
mask = (dist_from_centre >= min_radius) & (dist_from_centre <= max_radius);
masked_power = power .* mask;

% Find peaks — take top 6 candidates
num_peaks = 6;
[~, idx] = sort(masked_power(:), 'descend');
peak_indices = idx(1:num_peaks);
[peak_rows, peak_cols] = ind2sub([256, 256], peak_indices);

% Compute angles of each peak relative to centre
angles = atan2d(peak_rows - centre(1), peak_cols - centre(2));
angles = mod(angles, 360);

% Compute pairwise angular offsets between peaks
n_peaks = length(angles);
offsets = [];
for i = 1:n_peaks
    for j = i+1:n_peaks
        diff = abs(angles(i) - angles(j));
        diff = min(diff, 360 - diff);  % wrap to [0, 180]
        offsets(end+1) = diff;
    end
end

% Classify offsets: 60deg (+-10) = hexagonal, 90deg (+-10) = quadrant
hex_count  = sum(abs(offsets - 60) <= 10);
quad_count = sum(abs(offsets - 90) <= 10);

fprintf('Hexagonal (60 deg) offsets: %d\n', hex_count);
fprintf('Quadrant  (90 deg) offsets: %d\n', quad_count);

if quad_count > 0
    ratio = hex_count / quad_count;
    fprintf('Fourier ratio (60/90): %.4f\n', ratio);
else
    fprintf('Fourier ratio: undefined (no 90 deg components)\n');
    ratio = Inf;
end

% Visualise
figure;
subplot(1,2,1)
imagesc(rate_map_smooth); colormap(jet); colorbar;
title('Firing Rate Map (25x25)');
axis equal tight;

subplot(1,2,2)
imagesc(log(power + 1)); colormap(hot); colorbar;
hold on;
plot(peak_cols, peak_rows, 'c+', 'MarkerSize', 10, 'LineWidth', 2);
title('Power Spectrum (log scale)');
axis equal tight;
end