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

% Set the subfolders to be added in the path.
p = {'/read'; ...
     '/utilities/is'; ...
     '/utilities/str'; ...
     '/utilities/x13'; ...
     '/utilities/insert'; ...
     '/utilities/file'; ...
     '/utilities/from'; ...
     '/utilities/print'; ...
     '/utilities/variables'; ...
     '/utilities/cumulate'};

% Add missing routines if dynare is not in the path
if ~exist('demean','file')
    p{end+1} = '/utilities/missing/demean';
end

if ~exist('ndim','file')
    p{end+1} = '/utilities/missing/ndim';
end

if ~exist('sample_hp_filter','file')
    p{end+1} = '/utilities/missing/sample_hp_filter';
end

if ~exist('get_file_extension','file')
    p{end+1} = '/utilities/missing/get_file_extension';
end

if isoctave && ~exist('user_has_octave_forge_package','file')
    p{end+1} = '/utilities/missing/user_has_octave_forge_package';
end

if ~exist('get_cells_id','file')
    p{end+1} = '/utilities/missing/get_cells_id';
end

if ~exist('randomstring','file')
    p{end+1} = '/utilities/missing/randomstring';
end

% Install X13 binaries
opath = pwd();
cd([dseries_src_root '/../externals/x13'])
installx13();
cd(opath);

% Set path
P = cellfun(@(c)[dseries_src_root(1:end-1) c], p, 'uni', false);
addpath(P{:});