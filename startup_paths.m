function startup_paths()
%STARTUP_PATHS  Put every code folder of this project on the MATLAB path.
root = fileparts(mfilename('fullpath'));

folders = { ...
    'model'                                                                  % CAN simulations
    'analysis'                                                               % population_fourier_analysis, VoronoiLimit
    'hpc'                                                                    % sweep drivers
    'aggregate'                                                              % sweep aggregation
    'validation'                                                             % validate_against_ying and friends
    'CMBHOME-master'                                                         % parent of +CMBHOME
    fullfile('Code-for-Ying-et-al.-2023-main', 'Figure_2', 'rotateAround')   % rotateAround.m
    };

added = {}; missing = {};
for i = 1:numel(folders)
    p = fullfile(root, folders{i});
    if isfolder(p)
        addpath(p);
        added{end+1}   = folders{i};   %#ok<AGROW>
    else
        missing{end+1} = folders{i};   %#ok<AGROW>
    end
end

fprintf('[startup_paths] added: %s\n', strjoin(added, ', '));
if ~isempty(missing)
    fprintf(2, '[startup_paths] MISSING, not added: %s\n', strjoin(missing, ', '));
end

% Fail loudly here rather than 400k simulation steps later.
% NB `which` is not a reliable existence test for a classdef METHOD: it returns
% empty for CMBHOME.Session.Gridness whenever the class has not yet been loaded
% into the session, so checking it that way cries wolf after every `clear`.
% Test the class instead, and use `which` only for plain functions.
deps = {'CMBHOME.Utils.extrema2', 'CMBHOME.Utils.moserac', ...
        'rotateAround', 'VoronoiLimit'};
bad  = deps(cellfun(@(d) isempty(which(d)), deps));
if exist('CMBHOME.Session', 'class') ~= 8
    bad{end+1} = 'CMBHOME.Session (class not on path)';
end
if ~isempty(bad)
    warning('startup_paths:unresolved', ...
            'Unresolved dependencies: %s. ac_metrics and/or voronoi_baseline will fail.', ...
            strjoin(bad, ', '));
end
end
