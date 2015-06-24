% Check that the dates module is available.
try
    initialize_dates_toolbox;
catch
    urlwrite('https://github.com/DynareTeam/dates/archive/master.zip','master.zip');
    warning('off','MATLAB:MKDIR:DirectoryExists')
    mkdir('../externals')
    warning('on','MATLAB:MKDIR:DirectoryExists')
    unzip('master.zip','../externals')
    delete('master.zip')
    addpath([pwd() '/../externals/dates-master/src'])
    initialize_dates_toolbox;
end

% Get the path to the dseries toolbox.
dseries_src_root = strrep(which('initialize_dseries_toolbox'),'initialize_dseries_toolbox.m','');

% Add some subfolders to the path.
addpath([dseries_src_root '/read'])
addpath([dseries_src_root '/utilities/is'])
addpath([dseries_src_root '/utilities/str'])
addpath([dseries_src_root '/utilities/insert'])
addpath([dseries_src_root '/utilities/file'])
addpath([dseries_src_root '/utilities/from'])

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