function [tracked, radius] = tracked_subset(n)
%TRACKED_SUBSET  Neurons sampled from the sheet: 6 angles at each of 13 radii.
%
%   [tracked, radius] = tracked_subset(n)
%
%   tracked  1 x 78 at n = 128, linear indices into the n x n sheet
%   radius   1 x 78, distance from the sheet centre, in sheet units
%
%   Centre is n/2, matching gc_alpha's ns_centre, so radius is directly
%   comparable with the damage radius R.

    cen     = n/2;
    radii   = [2 4 7 10 14 18 22 28 34 40 46 52 58];
    tracked = [];
    for r = radii
        for a = (0:5)/6 * 2*pi
            tracked(end+1) = sub2ind([n n], round(cen + r*sin(a)), ...
                                            round(cen + r*cos(a))); 
        end
    end
    tracked  = unique(tracked, 'stable');
    [tr, tc] = ind2sub([n n], tracked);
    radius   = hypot(tr - cen, tc - cen);
end
