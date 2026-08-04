function [com_count, phi_cell, spectra, gridness, lobe_cell] = population_fourier_analysis(rm_raw, rm_smooth, thresh, neuron_subset)  
    % Calculates Fourier component analysis for every tracked neuron.
    % Computes component counts, grid spacing (moserac autocorrelogram), gridness,
    % and the Fourier symmetry ratio.
    % Convention follows Ying et al. (2023)

    warning('off');
    ANG_CENTRE = [128.5, 128.5];   % Followed Ying's spectrum centre 
    bin_cm      = 75/36;
    n_shuffle   = 50; % Voronoi shuffle count
    [n_bins, ~, n_neurons] = size(rm_raw);
    PAD    = 256;
    CENTRE = [129, 129]; % In case for non-square
    offset = floor((PAD - n_bins) / 2);
    neuron_subset = neuron_subset(:)';

    % Counts
    all_wl      = [];
    all_seeds   = [];   
    count_60    = 0;
    count_90    = 0;

    % Display k neurons
    n_disp = 25;
    n_display_maps  = min([n_disp, n_neurons, numel(neuron_subset)]);
    rand_idx        = neuron_subset(randperm(numel(neuron_subset), n_display_maps));
    disp_rm_rand    = zeros(n_bins, n_bins, n_display_maps);
    disp_pc_rand    = zeros(PAD, PAD, n_display_maps);
    rand_pos        = zeros(n_neurons,1);
    rand_pos(rand_idx)  = 1:n_display_maps; 
    com_count = zeros(n_neurons, 1);
    gridness  = nan(n_neurons, 1);
    phi_cell  = cell(n_neurons, 1);
    lobe_cell = cell(n_neurons, 1);  
    CROP    = 40;                       % half-width of stored spectrum crop (px)
    CROP_R  = CENTRE(1)-CROP : CENTRE(1)+CROP;
    CROP_C  = CENTRE(2)-CROP : CENTRE(2)+CROP;
    spectra = zeros(2*CROP+1, 2*CROP+1, numel(neuron_subset), 'single');
    si      = 0;

    fprintf('[population_fourier_analysis] Analysing %d of %d neurons\n', numel(neuron_subset), n_neurons);
    
    % Mean firing calculations
    for k = neuron_subset
        si = si + 1;
        rm          = rm_raw(:,:,k);
        rm_fields   = rm_smooth(:,:,k);
        mean_fr     = mean(rm(:));
        if isnan(mean_fr) || mean_fr == 0,  mean_fr = 1; end

        % Display rate map extraction
        if ismember(k, rand_idx)
            disp_rm_rand(:,:,rand_pos(k)) = rm_fields;
        end

        % Step 1-6: Zero-padded FFT, normalisation, square, fftshift, DC notch
        power       = compute_power(rm, mean_fr, n_bins, PAD, offset);
        % Step 7-8: Subtract baseline, clip negatives
        [base_k, nseed_k] = voronoi_baseline(rm, rm_fields, n_bins, PAD,n_shuffle);
        all_seeds(end+1) = nseed_k;                                             
        power_clean =  max(power - base_k, 0);
        spectra(:,:,si) = single(power_clean(CROP_R, CROP_C));  % pre-threshold, for re-analysis
        % Step 9: Zero below threhold
        power_clean(power_clean < thresh*max(power_clean(:))) = 0;
        % Step 10: Discard small blobs
        props = regionprops(power_clean>0, 'Area', 'Centroid', 'PixelIdxList'); % find blobs post cleaning
        for p = 1:numel(props)
            if props(p).Area < 10
                power_clean(props(p).PixelIdxList) = 0;
            end
        end 
        props = props([props.Area]>=10); % Clear out small blobs from the list
        if isempty(props), continue; end % Damage guard

        % Centroid from centre
        all_cen = reshape([props.Centroid],2,[])';
        cen_col = all_cen(:,1);
        cen_row = all_cen(:,2);

        dx      = cen_col - ANG_CENTRE(1);  
        dy      = cen_row - ANG_CENTRE(2);   
        if isempty(dx), continue; end % Damage guard

        % Component analysis. Ying take the angle of the RECIPROCAL vector
        % (2*pi/kx, 2*pi/ky); their dy is up-positive, ours row-positive-down,
        % hence the sign. NaN reproduces their divide-by-exactly-zero.
        phi = mod(atan2d(-1 ./ dy, 1 ./ dx), 360);
        phi(dx == 0 | dy == 0) = NaN;
        [sp_cm, gr_cell] = ac_metrics(rm_fields, bin_cm);
        if ~isnan(gr_cell), gridness(k) = gr_cell; end
        if ~isnan(sp_cm), all_wl = [all_wl; sp_cm]; end

        if ismember(k, rand_idx)
            disp_pc_rand(:,:,rand_pos(k)) = power_clean;
        end

        % Blob count
        com_count(k) = round(numel(phi)/2);
        phi_sorted   = sort(mod(phi(:), 180));                    % Sort For degree testing
        phi_unique   = phi_sorted([true; diff(phi_sorted) > 10]); % <10 deg difference is the same component
        phi_cell{k}  = phi_unique;   % per-cell axis orientations (deg, mod 180)
        lobes        = sort(phi(~isnan(phi)));                          
        lobe_cell{k} = lobes(:);                                              

        % Symmetry
        if numel(lobes) >= 2
            lobes_w   = [lobes(:); lobes(1) + 360];                            
            all_diffs = abs(diff(lobes_w));                                     
            count_60 = count_60 + sum(all_diffs > 50 & all_diffs < 70);        
            count_90 = count_90 + sum(all_diffs > 80 & all_diffs < 100);        
        end
    end 

    % Component count histogram
    count_subset = com_count(neuron_subset);
    figure('Position', [100 100 650 450], 'Name','Population Fourier Analysis');
    histogram(count_subset);
    xlabel('Number of components (unique axes)');
    ylabel('Number of neurons');
    xlim([0 8]);
    title(sprintf('Component count distribution  |  %d neurons', numel(neuron_subset)));

    % Voronoi seeding check. Ying's maps gave ~40-140 segments (their own
    % histogram, extraction line 1301). Too few seeds => patches too large =>
    % the shuffle keeps too much structure => the noise floor comes out too LOW.
    if ~isempty(all_seeds)
        fprintf('\n[population_fourier_analysis] Voronoi seeds/cell: median %.0f (min %d, max %d)\n', ...
            median(all_seeds), min(all_seeds), max(all_seeds));
        if median(all_seeds) < 40 || median(all_seeds) > 140
            fprintf(['  WARNING: outside Ying''s ~40-140 band. The baseline is likely biased;\n' ...
                     '           adjust SEED_SIGMA in voronoi_baseline before trusting the ratio.\n']);
        end
    end

    % Terminal summary
    fprintf('\n[population_fourier_analysis] Component count summary:\n');
    if ~isempty(all_wl)
        fprintf('\n[population_fourier_analysis] Grid spacing summary (moserac AC; %d cells):\n', ...
            numel(all_wl));
        fprintf('  Mean:    %.2f cm\n', mean(all_wl));
        fprintf('  Median:  %.2f cm\n', median(all_wl));
        fprintf('  Range:   %.2f -- %.2f cm\n', min(all_wl), max(all_wl));
    end

    if count_60 + count_90 > 0
    gs = gridness(neuron_subset); gs = gs(~isnan(gs));
    if ~isempty(gs)
        fprintf('\n[population_fourier_analysis] Gridness (rotational, Ying threshold 0.54):\n');
        fprintf('  Mean:    %.3f\n', mean(gs));
        fprintf('  Median:  %.3f\n', median(gs));
        fprintf('  Passing 0.54: %d of %d (%.0f%%)\n', sum(gs>0.54), numel(gs), 100*mean(gs>0.54));
    end

        fprintf('\n[population_fourier_analysis] Fourier symmetry ratio (60 / 90 deg):\n');
        fprintf('  60 deg pairs: %d\n', count_60);
        fprintf('  90 deg pairs: %d\n', count_90);
        fprintf('  Ratio = %.3f    \n', ...
            count_60 / count_90);
    else
        fprintf('\n[population_fourier_analysis] Fourier symmetry ratio: no qualifying pairs found.\n');
    end

    % Random neuron rate maps
    n_pairs_per_row = 5;
    n_rows_rand     = ceil(n_display_maps / n_pairs_per_row);

    figure('Position', [50 50 2000 400 * n_rows_rand], ...
        'Name', '25 Random Neurons: Rate Map and Fourier Spectrum');
    for i = 1:n_display_maps
        row      = ceil(i / n_pairs_per_row);
        col_pair = mod(i - 1, n_pairs_per_row);

        subplot(n_rows_rand, n_pairs_per_row * 2, ...
                (row-1) * n_pairs_per_row*2 + col_pair*2 + 1);
        imagesc(disp_rm_rand(:,:,i));
        colormap(gca, jet); axis equal tight off;
        title(sprintf('N%d', rand_idx(i)), 'FontSize', 6);

        pc_i   = disp_pc_rand(:,:,i);
        pmax_i = max(pc_i(:));
        subplot(n_rows_rand, n_pairs_per_row * 2, ...
                (row-1) * n_pairs_per_row*2 + col_pair*2 + 2);
        imagesc(pc_i, [0, max(pmax_i, eps)]);
        colormap(gca, jet); axis equal tight off;
        title(sprintf('c=%d', com_count(rand_idx(i))), 'FontSize', 6);
    end
    sgtitle('25 Random Neurons  |  Rate Map (left)  Fourier Spectrum (right)');

    % Wavelength distribution
    if ~isempty(all_wl)
        figure('Name', 'Wavelength distribution');
        histogram(all_wl, 'BinWidth', 2, 'BinLimits', [10 60]);
        xlabel('Wavelength (cm)'); ylabel('Count');
        title('Wavelength distribution');
    end
end

%% Local functions
function pwr = compute_power(rm, mfr, n_bins, PAD, offset)
    SIGMA_DC = 1;                                                           % Gaussian dc notch width
    padded = zeros(PAD, PAD);                                               % Zero-padding
    padded(offset+1:offset+n_bins, offset+1:offset+n_bins) = rm;            % Place rate map
    coef = 1 / (mfr*sqrt(n_bins^2));                                        % Normalisation coeff Ying et al., 2023
    imgX = coef * fftshift(fft2(padded));                                   % 2D fft and normalised  
    pwr = abs(imgX.^2);                                                     % Power calculation                 
    [rr,cc] = ndgrid(1:PAD, 1:PAD);                                         % Coordinate grid 
    [mrow, mcol] = find(ismember(pwr, max(pwr(:))));                        % Gaussian dc notch
    gaus2d = 1 - exp(-((rr-mrow(1)).^2 + (cc-mcol(1)).^2)./(2*SIGMA_DC^2));
    gaus2d = gaus2d .* (gaus2d == 1);
    pwr = pwr .* gaus2d;
end


function [baseline, nseed] = voronoi_baseline(rm_raw, rm_smooth_for_fields, n_bins, PAD, n_shuffle)   %#ok<INUSL>
    PRC = 75;   % Was 95
    SEED_SIGMA = 0.5; 
    img  = double(rm_raw);
    imgo = imgaussfilt(img, SEED_SIGMA);
    imgPros = imregionalmax(imgo, 4);
    objects = regionprops(imgPros, {'Centroid'});
    nseed = numel(objects);        
    if nseed < 2
        baseline = Inf;   % cannot shuffle -> nothing passes (conservative)
        return
    end
    centroids = nan(numel(objects),2);
    for i=1:numel(objects), centroids(i,:)=objects(i).Centroid; end
    [V,C,~] = VoronoiLimit(centroids(:,1), centroids(:,2), 'figure', 'off');
    allPoly = [];
    for it=1:size(C,1)
        cd = V(C{it},:);
        allPoly(:,:,it) = poly2mask(cd(:,1),cd(:,2),size(imgo,1),size(imgo,2));
    end
    allpowers = [];
    for iiii=1:n_shuffle
        virtual = zeros(size(img,1)*3, size(img,2)*3);
        virtual(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2) = img;
        allPoly2 = zeros(size(img,1)*3, size(img,2)*3, size(allPoly,3));
        for it=1:size(allPoly,3)
            allPoly2(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2, it) = allPoly(:,:,it);
        end
        allPoly3 = allPoly2 .* virtual;
        newc = [centroids(:,1)+size(img,1), centroids(:,2)+size(img,2)];
        allPoly4 = zeros(size(allPoly3));
        for it=1:size(allPoly3,3)
            dd = randi([-180 180]);
            allPoly4(:,:,it) = rotateAround(allPoly3(:,:,it), newc(it,2), newc(it,1), dd);
        end
        ps = 300; allPoly5 = zeros(size(allPoly4));
        for it=1:size(newc,1)
            nr=randi([size(img,1)+1,size(img,1)*2]); nc=randi([size(img,2)+1,size(img,2)*2]);
            xd=round(nr-newc(it,1)); yd=round(nc-newc(it,2));
            pp=padarray(allPoly4(:,:,it),[ps ps],0,'both');
            allPoly5(:,:,it)=pp(ps+1-yd:end-300-yd, ps+1-xd:end-300-xd);
        end
        fm=zeros(size(virtual)); atr=[];
        for it=1:size(allPoly5,3)
            czm=~logical(allPoly5(:,:,it)>0); fm=fm.*czm; fm=fm+allPoly5(:,:,it);
            te=ones(size(virtual)); te(size(img,1)+1:size(img,1)*2,size(img,2)+1:size(img,2)*2)=0;
            oe=fm.*te; [rw,cl,~]=find(oe~=0);
            if ~isempty(rw), ix=sub2ind(size(oe),rw',cl'); atr=[atr; oe(ix)']; end
            lf=zeros(size(virtual)); lf(size(img,1)+1:size(img,1)*2,size(img,2)+1:size(img,2)*2)=1; fm=fm.*lf;
        end
        ffm=fm(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2);
        [rw,cl,~]=find(ffm==0); atr=atr(randperm(length(atr)))';
        ml=length(atr); rc=[rw,cl]; rc=rc(randperm(size(rc,1)),:);
        if ml>0 && ml<=size(rc,1), ix=sub2ind(size(ffm),rc(1:ml,1),rc(1:ml,2)); ffm(ix)=atr; end
        % power of this shuffle map
        fr=nanmean(nanmean(ffm)); if isnan(fr)||fr==0, fr=1; end
        rp=padarray(ffm,[(PAD-n_bins)/2 (PAD-n_bins)/2],0,'both'); coef=1/(fr*sqrt(n_bins*n_bins));
        imgX=coef*fftshift(fft2(rp)); powr3=abs(imgX.^2);
        [xg,yg]=ndgrid(1:PAD,1:PAD);
        [rr,cc]=find(ismember(powr3,max(powr3(:))));
        g=1-exp(-((xg-cc(1)).^2+(yg-rr(1)).^2)./(2*1^2)); g=g.*(g==1); powr3=powr3.*g;
        allpowers=[allpowers; reshape(powr3,[],1)];
        clear allPoly2 allPoly3 allPoly4 allPoly5 virtual fm
    end
    baseline = prctile(allpowers, PRC);
end


function [spacing_cm, gridness] = ac_metrics(rm, bin_cm)
%   AC_METRICS  Grid spacing and gridness from the rate-map autocorrelogram.
%   Requires CMBHOME on the path (moserac, CMBHOME.Utils.extrema2,
%   CMBHOME.Session.Gridness).
    spacing_cm = NaN; gridness = NaN;
    rm(~isfinite(rm)) = 0;
    if max(rm(:)) <= 0, return; end

    ac = CMBHOME.Utils.moserac(rm, rm, 25);   % qualified: not vendored in this repo

    % --- spacing: CMBHOME gridDistance.m, transcribed (Pd = 7, thresh = -Inf) ---
    [~, inds] = CMBHOME.Utils.extrema2(ac);
    if ~isempty(inds)
        [rowInd, colInd] = ind2sub(size(ac), inds);
        [~, ord] = sort(ac(inds), 'descend');
        idelete = false(numel(ord),1);
        for i = 1:numel(ord)                       % drop peaks closer than Pd
            i1 = ord(i);                           % to any taller peak
            for k = 1:i-1
                i2 = ord(k);
                if hypot(rowInd(i1)-rowInd(i2), colInd(i1)-colInd(i2)) < 7
                    idelete(i) = true;
                end
            end
        end
        ord(idelete) = [];
        rowInd = rowInd(ord); colInd = colInd(ord);   % ordered tallest first
        if numel(rowInd) >= 7
            d = sort(hypot(rowInd - rowInd(1), colInd - colInd(1)));
            spacing_cm = median(d(2:7)) * bin_cm;  % their d(2:7), median taken here
        end
    end

    % --- gridness: CMBHOME's own implementation, called directly ---
    persistent S warned
    if isempty(S), [~] = evalc('S = CMBHOME.Session();'); end
    try
        % evalc, not a bare call: Gridness disp()s "No cells in session object"
        % on every invocation via self.epoch. 78 lines a run here, ~1.4M across
        % a full sweep. Errors still raise -- evalc only swallows stdout.
        [~] = evalc(['gridness = S.Gridness([], ''autocorr'', ac, ''grid3'', 1, ' ...
                     '''rotate_inc'', 30, ''supress_plot'', 1);']);
    catch ME
        gridness = NaN;                            % degenerate autocorrelogram
        if isempty(warned)                         % report once, to stderr:
            warned = true;                         % line 9's warning('off')
            fprintf(2, '[ac_metrics] CMBHOME Gridness failed: %s\n', ME.message);
        end                                        % would swallow a warning()
    end
    if isempty(gridness), gridness = NaN; end
end
