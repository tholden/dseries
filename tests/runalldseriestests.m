opath = path();

% Check that the m-unit-tests module is available.
try
    initialize_unit_tests_toolbox;
catch
    urlwrite('https://github.com/DynareTeam/m-unit-tests/archive/master.zip','master.zip');
    warning('off','MATLAB:MKDIR:DirectoryExists')
    mkdir('../externals')
    warning('on','MATLAB:MKDIR:DirectoryExists')
    unzip('master.zip','../externals')
    delete('master.zip')
    addpath([pwd() '/../externals/m-unit-tests-master/src'])
    initialize_unit_tests_toolbox;
end

% Initialize the dseries module
try
    initialize_dseries_toolbox;
catch
    unit_tests_root = strrep(which('runalldseriestests'),'runalldseriestests.m','');
    addpath([unit_tests_root '../src']);
    initialize_dseries_toolbox;
end

tmp = dseries_src_root;
tmp = tmp(1:end-1); % Remove trailing slash.
run_unitary_tests_in_directory(tmp);

delete('*.log');
rmdir('../externals/m-unit-tests-master','s');
path(opath);