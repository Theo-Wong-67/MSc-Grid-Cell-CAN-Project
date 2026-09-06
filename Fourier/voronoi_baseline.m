function [baseline, nseed] = voronoi_baseline(rm_raw, n_bins, PAD, n_shuffle)
%Field-shuffle noise floor for the Fourier spectrum.

%   Method originates from Krupic et al., field-shuffle null for Fourier analysis of spatial
%   firing. Implementation transcribed from Ying et al. (2023) deviations from their code are
%   marked [CHANGED] / [ADDED] below.
%
%   IN   rm_raw    n_bins x n_bins, the UNSMOOTHED rate map (same map the
%                  observed spectrum is computed from)
%        n_bins    map side length
%        PAD       zero-pad target, 256 (must match fourier_power)
%        n_shuffle number of shuffles, 50 in Ying
%   OUT  baseline  scalar: the PRC-th percentile of pooled shuffle power.
%                  Inf if the map is too degenerate to shuffle.
%        nseed     number of fields found. Health check: Ying's maps give
%                  40-140. Far below that means the noise floor is unreliable
%                  even if nothing errors.
%                  NOTE this is the regionprops count, which is NOT always the
%                  number of patches the map is actually cut into -- see the
%                  [CHANGED] block at the VoronoiLimit call.

    PRC = 75; 
    % ---- Step 1: find the fields -------------------------------------------
    % Seeding map kernel was changed through approximating the mean number
    % of output seeds. As the kernel Ying et al. 2023 cannot be applied to
    % the rate CAN model outputs.
    % [CHANGED] Their seeding map is a SECOND CMBHOME rate map built as
    % smoothed-spikes / smoothed-occupancy at sigma ~ 0.96 bins (their L226).
    % Model output has neither spikes nor an occupancy denominator, so that
    % map cannot exist. SEED_SIGMA is tuned to reproduce their seed COUNT,
    % not their sigma -- state it that way, the two numbers are not comparable.
    SEED_SIGMA = 0.5;
    img  = double(rm_raw);                  % field VALUES -- what gets shuffled
    imgo = imgaussfilt(img, SEED_SIGMA);    % blurred copy -- only to LOCATE fields
    imgPros = imregionalmax(imgo, 4);       % 4-connectivity, as Ying
    objects = regionprops(imgPros, {'Centroid'});
    nseed = numel(objects);
    if nseed < 2        % Guarding from crash
        % [ADDED] Ying have no guard -- their recordings always have fields.
        % Inf is deliberate and conservative: nothing clears the baseline, so
        % a degenerate cell contributes no components rather than spurious ones.
        baseline = Inf;
        return
    end
    centroids = nan(numel(objects),2);
    for i=1:numel(objects), centroids(i,:)=objects(i).Centroid; end
    % NOTE regionprops Centroid is [x y] = [column row]. The rest of this
    % function inherits that ordering, including Ying's flip at the placement
    % step below.

    % ---- Step 2: carve the map into one patch per field --------------------
    % Voronoi tessellation: every bin is assigned to its nearest field centre,
    % so each field gets a patch containing it and its surrounding territory.
    % [CHANGED] Ying call this INSIDE the shuffle loop (their L248), rebuilding
    % an identical diagram 50 times -- centroids never change and VoronoiLimit
    % is deterministic, so it is hoisted here. No numerical effect, ~50x cheaper.
    % [ADDED] 'figure','off' -- VoronoiLimit defaults to fig='on' and would
    % otherwise draw a plot on every call.
    [V,C,XY] = VoronoiLimit(centroids(:,1), centroids(:,2), 'figure', 'off');
    % [CHANGED] third output KEPT (was [V,C,~], as Ying -- they assign XY at
    % their L249/514/777/1040 and never read it). VoronoiLimit does NOT return
    % one cell per input seed in input order. Three places inside it change the
    % list, and XY is carried through all three while `centroids` is not:
    %   its L140   XY = unique([x,y],'rows')      DEDUPLICATES and SORTS
    %   its L766   C(isemp)=[]; XY(isemp,:)=[]    drops cells polybool emptied
    %   its L922   boundary-split cells are INSERTED into both C and XY
    % So C{k} belongs to XY(k,:) and to nothing else. Indexing C by the
    % regionprops centroid list is only correct by coincidence -- see below.
    if isempty(C) || size(XY,1) ~= numel(C)
        % [ADDED] VoronoiLimit wraps its entire body in try/catch and merely
        % prints 'stop' on failure (its L997-999), so it can return a
        % partially built C with no error. Inf for the same reason as the
        % nseed guard: a cell we cannot tessellate contributes no components.
        fprintf(2, '[voronoi_baseline] VoronoiLimit returned %d cells for %d seeds -- baseline set to Inf\n', ...
                numel(C), nseed);
        baseline = Inf;
        return
    end
    vseed = XY;                             % [ADDED] one row per Voronoi cell,
    nvor  = size(vseed,1);                  % in C's order. USE THIS, not centroids.
    % WHY THIS WAS SILENT UNTIL NOW. When every regional maximum is a SINGLE
    % pixel, the centroid IS that pixel, bwconncomp labels components in
    % column-major scan order, and that is exactly the (x then y) order
    % unique(...,'rows') produces -- so XY == centroids, row for row, and the
    % old code was accidentally right. Degenerate maps have multi-pixel
    % PLATEAU maxima, whose centroids are neither guaranteed distinct nor in
    % label order, and the two lists come apart. That is why this only ever
    % fired at low alpha.

    allPoly = zeros(size(imgo,1), size(imgo,2), nvor);   % [CHANGED] preallocated
    for it=1:nvor                                        % [CHANGED] was size(C,1)
        cd = V(C{it},:);                    % vertices of this patch
        % [ADDED 2026-08-23] VoronoiLimit's try/catch (its L997-999) can also
        % return a C whose length MATCHES XY but whose vertices were never
        % clipped, leaving the Inf row voronoin emits for unbounded cells, so
        % the length guard above passes and poly2mask then errors out and kills
        % the whole ~22 min task over ONE neuron of 78. Same decision as that
        % guard: a cell we cannot tessellate contributes no components, and
        % fourier_power turns base = Inf into an all-zero spectrum, hence NaN.
        % Any map that completes today already has all-finite vertices, so this
        % cannot change a single run that currently works.
        if ~all(isfinite(cd(:)))
            fprintf(2, '[voronoi_baseline] cell %d of %d has a non-finite vertex -- baseline set to Inf\n', it, nvor);
            baseline = Inf;
            return
        end
        allPoly(:,:,it) = poly2mask(cd(:,1),cd(:,2),size(imgo,1),size(imgo,2));
    end                                     % allPoly(:,:,k) = binary mask of patch k

    allpowers = [];
    for iiii=1:n_shuffle

        % ---- Step 3: move to a 3x3 canvas ----------------------------------
        % Patches are about to be rotated and translated, and would be clipped
        % at the array edge. Working in a 3n x 3n canvas with the real map in
        % the centre tile lets them move freely; we crop back at Step 6.
        virtual = zeros(size(img,1)*3, size(img,2)*3);
        virtual(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2) = img;
        allPoly2 = zeros(size(img,1)*3, size(img,2)*3, size(allPoly,3));
        for it=1:size(allPoly,3)
            allPoly2(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2, it) = allPoly(:,:,it);
        end
        % [CHANGED] preallocated + direct 3-D write; Ying build via a temporary
        % 'm' inside the loop and grow allPoly2 (their L269-274).

        % Masks become PATCHES: multiply each binary mask by the real map, so
        % each slice now holds that field's actual firing values, zero elsewhere.
        allPoly3 = allPoly2 .* virtual;
        % [CHANGED] vectorised -- implicit expansion broadcasts the 2-D virtual
        % across dim 3. Ying loop this (their L279-283). Identical result.

        newc = [vseed(:,1)+size(img,1), vseed(:,2)+size(img,2)];  % [CHANGED] was centroids
        % This is the fix. newc now has exactly nvor rows, so it is in step
        % with allPoly/allPoly3/allPoly4 and both loops below are in range.
        % Previously it had nseed rows: the Step-4 loop (bounded by
        % size(allPoly3,3) = nvor) rotated patch k about seed k of the WRONG
        % list, and the Step-5 loop (bounded by size(newc,1) = nseed) ran off
        % the end of allPoly4 whenever nvor < nseed. The second is the crash;
        % the first is silent and was there on every call.

        % ---- Step 4: randomise each patch's orientation --------------------
        % Rotate about the field's OWN centre, so shape and size are preserved
        % and only orientation is destroyed. This is what removes any common
        % alignment between fields.
        allPoly4 = zeros(size(allPoly3));
        for it=1:nvor                       % [CHANGED] was size(allPoly3,3), same value
            dd = randi([-180 180]);                                    % RNG 1 of 3
            allPoly4(:,:,it) = rotateAround(allPoly3(:,:,it), newc(it,2), newc(it,1), dd);
        end

        % ---- Step 5: randomise each patch's position -----------------------
        % Drop each patch at a uniformly random location within the centre tile.
        % Implemented as a shift: pad by 300 (enough that nothing wraps), take a
        % window offset by the required displacement, so the patch lands with its
        % centre at (nr, nc).
        ps = 300; allPoly5 = zeros(size(allPoly4));
        for it=1:nvor                       % [CHANGED] was size(newc,1) -- THE CRASH
            nr=randi([size(img,1)+1,size(img,1)*2]); nc=randi([size(img,2)+1,size(img,2)*2]);  % RNG 2, 3
            xd=round(nr-newc(it,1)); yd=round(nc-newc(it,2));
            % NOTE Ying's own comment here reads "FLIPPED. careful of how you
            % index" -- nr is drawn against dim 1 but subtracted from newc(:,1),
            % which is a COLUMN coordinate. Preserved deliberately: the map is
            % square and placement is uniform, so it makes no statistical
            % difference, but it is their convention and changing it would
            % break comparability.
            pp=padarray(allPoly4(:,:,it),[ps ps],0,'both');
            allPoly5(:,:,it)=pp(ps+1-yd:end-300-yd, ps+1-xd:end-300-xd);
        end

        % ---- Step 6: reassemble, and bank whatever fell off the edge -------
        % Patches now overlap and leave gaps. Rule: later patch wins (czm zeroes
        % the overlap before adding). Anything now sitting OUTSIDE the centre
        % tile has left the arena -- collect those values in 'atr' so they can be
        % recycled into the gaps at Step 7, keeping the shuffled map's total
        % firing and value distribution the same as the original.
        fm=zeros(size(virtual)); atr=[];
        for it=1:size(allPoly5,3)
            czm=~logical(allPoly5(:,:,it)>0); fm=fm.*czm; fm=fm+allPoly5(:,:,it);
            te=ones(size(virtual)); te(size(img,1)+1:size(img,1)*2,size(img,2)+1:size(img,2)*2)=0;   % 1 outside arena
            oe=fm.*te; [rw,cl,~]=find(oe~=0);                                                        % what escaped
            if ~isempty(rw), ix=sub2ind(size(oe),rw',cl'); atr=[atr; oe(ix)']; end
            lf=zeros(size(virtual)); lf(size(img,1)+1:size(img,1)*2,size(img,2)+1:size(img,2)*2)=1;  % 1 inside arena
            fm=fm.*lf;                                                                               % discard the outside
        end
        % [CHANGED] Ying 'continue' when nothing escaped (their L349-351), which
        % also skips the lf mask. Equivalent -- if nothing escaped there is
        % nothing outside to mask.

        ffm=fm(size(img,1)+1:size(img,1)*2, size(img,2)+1:size(img,2)*2);   % crop back to arena

        % ---- Step 7: fill the gaps with the banked values ------------------
        % Both lists are shuffled first, so the recycled values land in random
        % positions rather than in scan order.
        [rw,cl,~]=find(ffm==0); atr=atr(randperm(length(atr)))';            % RNG 4
        ml=length(atr); rc=[rw,cl]; rc=rc(randperm(size(rc,1)),:);          % RNG 5
        if ml>0 && ml<=size(rc,1), ix=sub2ind(size(ffm),rc(1:ml,1),rc(1:ml,2)); ffm(ix)=atr; end
        % [ADDED] the ml bounds test. Ying index rc(1:ml,:) unguarded (their
        % L380) and error when escaped bins outnumber empty ones.

        % ---- Step 8: spectrum of this shuffled map -------------------------
        % Same pipeline as fourier_power. Must stay in step with it: the
        % normalisation coefficient cancels at the threshold only if both sides
        % use the same kind of mean.
        fr=nanmean(nanmean(ffm)); if isnan(fr)||fr==0, fr=1; end
        % [ADDED] the fr guard -- Ying have none (their L420). An all-zero
        % shuffle would give coef = Inf and Inf*0 = NaN.
        rp=padarray(ffm,[(PAD-n_bins)/2 (PAD-n_bins)/2],0,'both'); coef=1/(fr*sqrt(n_bins*n_bins));
        imgX=coef*fftshift(fft2(rp)); powr3=abs(imgX.^2);
        [xg,yg]=ndgrid(1:PAD,1:PAD);
        [rr,cc]=find(ismember(powr3,max(powr3(:))));
        g=1-exp(-((xg-cc(1)).^2+(yg-rr(1)).^2)./(2*1^2)); g=g.*(g==1); powr3=powr3.*g;
        % INCONSISTENCY WITH fourier_power: this notch keeps Ying's row/column
        % swap (xg is the ROW grid but is compared against cc, a COLUMN index);
        % fourier_power corrects it. Harmless -- DC is always the maximum of a
        % non-negative map and sits at the symmetric centre, so rr == cc -- but
        % the two functions should be made to agree.
        % The notch is a HARD hole of radius ~8.6 px, not a soft Gaussian:
        % g == 1 exactly only where exp(-d^2/2) < eps(1)/2.

        allpowers=[allpowers; reshape(powr3,[],1)];   % pool every pixel of every shuffle
        clear allPoly2 allPoly3 allPoly4 allPoly5 virtual fm   % [ADDED] each is 108x108xK
    end

    % ---- Step 9: the noise floor ------------------------------------------
    % Percentile over POOLED PIXELS of all shuffles (Ying's L468
    % 'allpowersforcurrent'), not over the per-shuffle maxima (their L459-462).
    baseline = prctile(allpowers, PRC);
end
