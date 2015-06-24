% Check that dates module is in matlab path.
try
    initialize_dates_toolbox;
catch
    message =               'The dates toolbox is not in the Matlab/Octave''s path!';
    message = char(message, 'The toolbox can be downloaded here:');
    message = char(message, '     https://github.com/DynareTeam/dates');
    message = char(message, 'Check that you added the dates/src folder in the path.');
    disp(' ')
    disp(message)
    disp(' ')
    error('Please install the dates module or check Matlab/Octave''s path!')
end

% Get the path to the dseries toolbox.
dseries_src_root = strrep(which('initialize_dseries_toolbox'),'initialize_dseries_toolbox.m','');

% Add some subfolders to the path.
addpath([dseries_src_root '/read'])
addpath([dseries_src_root '/utilities/is'])
addpath([dseries_src_root '/utilities/str'])
addpath([dseries_src_root '/utilities/insert'])
addpath([dseries_src_root '/utilities/file'])


% Add missing routines if dynare is not in the path
if ~exist('demean','file')
    addpath([dseries_src_root '/utilities/missing/demean'])
end

if ~exist('ndim','file')
    addpath([dseries_src_root '/utilities/missing/ndim'])
end

if ~exist('sample_hp_filter','file')
    addpath([dseries_src_root '/utilities/missing/sample_hp_filter'])
end

dseries('initialize');