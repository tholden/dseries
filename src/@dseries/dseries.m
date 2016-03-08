classdef dseries<handle % --*-- Unitary tests --*--

% Class for time series.

% Copyright (C) 2013-2015 Dynare Team
%
% This code is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare dates submodule is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

    properties
        data  = [];         % Array of data (a column per variable, a row per observation)
        name  = {};         % Names of the variables.
        tex   = {};         % TeX names of the variables.
        dates = dates();    % Dates associated to the observations.
    end

    methods
        function o = dseries(varargin)
        % Constructor for the dseries class
        % 
        % INPUTS 
        %
        % - If no input arguments, the constructore returns an empty dseries object.
        %
        % - If only one input argument is provided, the behaviour of the constructor depends on the type of the argument:
        %  + varargin{1}  [dates]   Constructor will return a dseries object without data. The dseries object can be populated later using dseries' methods.
        %  + varargin{1}  [char]    The name of a csv, m, mat or xlsx file containing data. A dseries object is created from these data.
        %  + varargin{1}  [double]  A T*N array of data. A dseries object is created from the array (T observations, N variables).  
        %
        % - If only one two, three or four arguments are provided, we must have:
        %  + varargin{1}  [double]      A T*N array of data.
        %  + varargin{2}  [dates, char] A single element dates object or a string representing a date, the initial date of the database.
        %  + varargin{3}  [cell]        A N*1 cell of char or a N*q array of char, the names of  the variables.
        %  + varargin{4}  [cell]        A N*1 cell of char or a N*q array of char, the TeX names of  the variables.
        %
        % OUTPUTS 
        % - o [dseries]
            switch nargin
              case 0
                % Return empty object.
                o.data  = [];
                o.name  = {};
                o.tex   = {};
                o.dates = dates(); 
                return
              case 1
                if isdates(varargin{1})
                    switch length(varargin{1})
                      case 0
                        error('dseries:WrongInputArguments', 'Input (identified as a dates object) must be non empty!');
                      case 1
                        % Create an empty dseries object with an initial date.
                        o.data  = [];
                        o.name  = {};
                        o.tex   = {};
                        o.dates = varargin{1};
                      otherwise
                        error('dseries:WrongInputArguments', 'Input (identified as a dates object) must have a unique element!');
                    end
                    return
                elseif ischar(varargin{1})
                    if strcmp( varargin{1}, 'initialize' )
                        % Return empty object.
                        o.data  = [];
                        o.name  = {};
                        o.tex   = {};
                        o.dates = dates(); 
                        return
                    end
                    % Create a dseries object loading data in a file (*.csv, *.m, *.mat).
                    if isempty(varargin{1})
                        error('dseries:WrongInputArguments', 'Input argument cannot be an empty string!')
                    elseif check_file_extension(varargin{1},'m')
                        [freq,init,data,varlist,tex] = load_m_file_data(varargin{1});
                    elseif check_file_extension(varargin{1},'mat')
                        [freq,init,data,varlist,tex] = load_mat_file_data(varargin{1});
                    elseif check_file_extension(varargin{1},'csv')
                        [freq,init,data,varlist] = load_csv_file_data(varargin{1});
                        tex = [];
                    elseif check_file_extension(varargin{1},'xls') || check_file_extension(varargin{1},'xlsx')
                        if isglobalinbase('options_')
                            % Check that the object is instantiated within a dynare session so that options_ global structure exists.
                            % Should provide latter a mechanism to pass range and sheet to dseries constructor...
                            range = evalin('base','options_.xls_range');
                            sheet = evalin('base','options_.xls_sheet');
                        else
                            % By default only the (whole) first sheet is loaded.
                            range = [];
                            sheet = [];
                        end
                        [freq,init,data,varlist] = load_xls_file_data(varargin{1}, sheet, range);
                        tex = [];
                    else
                        error('dseries:WrongInputArguments', 'I''m not able to load data from %s!', varargin{1});
                    end
                    o.data = data;
                    o.name = varlist;
                    o.dates = init:init+(nobs(o)-1);
                    if isempty(tex)
                        o.tex = name2tex(varlist);
                    else
                        o.tex = tex;
                    end
                elseif isnumeric(varargin{1}) && isequal(ndims(varargin{1}),2)
                    o.data = varargin{1};
                    o.name = default_name(vobs(o));
                    o.tex = name2tex(o.name);
                    o.dates = dates(1,1):dates(1,1)+(nobs(o)-1); 
                end
              case  {2,3,4}
                if isequal(nargin,2) && ischar(varargin{1}) && isdates(varargin{2})
                    % Instantiate dseries object with a data file and force the initial date to be as given by the second input argument.
                    p = dseries(varargin{1});
                    o = dseries(p.data, varargin{2}, p.name, p.tex);
                    return
                end
                if isequal(nargin,2) && ischar(varargin{1}) && ischar(varargin{2}) && isdate(varargin{2})
                    % Instantiate dseries object with a data file and force the initial date to be as given by the second input argument.
                    p = dseries(varargin{1});
                    o = dseries(p.data, dates(varargin{2}), p.name, p.tex);
                    return
                end
                a = varargin{1};
                b = varargin{2};
                if nargin<4
                    d = {};
                else
                    d = varargin{4};
                    if ~iscell(d) && ~isempty(d)
                        d = cellstr(d);
                    end
                end
                if nargin<3
                    c = {};
                else
                    c = varargin{3};
                    if ~iscell(c) && ~isempty(c)
                        c = cellstr(c);
                    end
                end
                % Get data, number of observations and number of variables.
                o.data = a;
                % Get the first date and set the frequency.
                if isempty(b)
                    init = dates(1,1);
                elseif (isdates(b) && isequal(length(b),1))
                    init = b;
                elseif ischar(b) && isdate(b)% Weekly, Monthly, Quaterly or Annual data (string).
                    init = dates(b);
                elseif (isnumeric(b) && isscalar(b) && isint(b)) % Yearly data.
                    init = dates([num2str(b) 'Y']);
                elseif isdates(b) % Range of dates
                    init = b(1);
                    if nobs(o)>1 && ~isequal(b.ndat(),nobs(o))
                        error('dseries:WrongInputArguments', ['If second input is a range, its number ' ...
                                            'of elements must match\nthe number of rows in the ' ...
                                            'first input, unless the first input\nhas only one row.']);
                    elseif isequal(nobs(o), 1)
                        o.data = repmat(o.data,b.ndat(),1);
                    end
                    o.dates = b;
                elseif (isnumeric(b) && isint(b)) % Range of yearly dates.
                    error('dseries:WrongInputArguments', ['Not implemented! If you need to define ' ...
                                        'a range of years, you have to pass a dates object as the ' ...
                                        'second input argument']);
                else
                    error('dseries:WrongInputArguments', 'Wrong calling sequence! Please check the manual.');
                end
                % Get the names of the variables.
                if ~isempty(c)
                    if vobs(o)==length(c)
                        for i=1:vobs(o)
                            o.name = vertcat(o.name, c(i));
                        end
                    else
                        error('dseries:WrongInputArguments', 'The number of declared names does not match the number of variables!')
                    end
                else
                    o.name = default_name(vobs(o));
                end
                if ~isempty(d)
                    if vobs(o)==length(d)
                        for i=1:vobs(o)
                            o.tex = vertcat(o.tex, d(i));
                        end
                    else
                        error('dseries:WrongInputArguments', 'The number of declared tex names does not match the number of variables!')
                    end
                else
                    o.tex = name2tex(o.name);
                end 
              otherwise
                error('dseries:WrongInputArguments', 'Wrong calling sequence! Please check the manual.')
            end
            if isempty(o.dates)
                o.dates = init:init+(nobs(o)-1);
            end
        end % dseries
    end % methods
end % classdef

%@test:1
%$ % Test if we can instantiate an empty dseries object.
%$ try
%$     ts = dseries();
%$     t(1) = 1;
%$ catch
%$     t(1) = 0;
%$ end
%$
%$ T = all(t);
%@eof:1

%@test:2
%$ t = zeros(4,1);
%$
%$ try
%$     aa = dates('1938M11');
%$     ts = dseries(aa);
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dassert(ts.freq,12);
%$     t(3) = dassert(ts.init.freq,12);
%$     t(4) = dassert(ts.init.time,[1938, 11]);
%$ end
%$
%$ T = all(t);
%@eof:2

%@test:3
%$ t = zeros(6,1);
%$
%$ try
%$     [strfile, status] = urlwrite('http://www.dynare.org/Datasets/dseries/dynseries_test_data.m','dynseries_test_data.m');
%$     if ~status
%$         error()
%$     end
%$     ts = dseries('dynseries_test_data.m');
%$     delete('dynseries_test_data.m');
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dassert(ts.freq,4);
%$     t(3) = dassert(ts.init.freq,4);
%$     t(4) = dassert(ts.init.time,[1994, 3]);
%$     t(5) = dassert(ts.vobs,2);
%$     t(6) = dassert(ts.nobs,100);
%$ end
%$
%$ T = all(t);
%@eof:3

%@test:4
%$ t = zeros(6,1);
%$
%$ try
%$     [strfile, status] = urlwrite('http://www.dynare.org/Datasets/dseries/dynseries_test_data.mat','dynseries_test_data.mat');
%$     if ~status
%$         error()
%$     end
%$     ts = dseries('dynseries_test_data.mat');
%$     delete('dynseries_test_data.mat');
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dassert(ts.freq,4);
%$     t(3) = dassert(ts.init.freq,4);
%$     t(4) = dassert(ts.init.time,[1994, 3]);
%$     t(5) = dassert(ts.vobs,2);
%$     t(6) = dassert(ts.nobs,100);
%$ end
%$
%$ T = all(t);
%@eof:4

%@test:5
%$ t = zeros(8,1);
%$
%$ try
%$     [strfile, status] = urlwrite('http://www.dynare.org/Datasets/dseries/dynseries_test_data.csv','dynseries_test_data.csv');
%$     if ~status
%$         error()
%$     end
%$     ts = dseries('dynseries_test_data.csv');
%$     delete('dynseries_test_data.csv');
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dassert(ts.freq,4);
%$     t(3) = dassert(ts.init.freq,4);
%$     t(4) = dassert(ts.init.time,[1990, 1]);
%$     t(5) = dassert(ts.vobs,4);
%$     t(6) = dassert(ts.nobs,4);
%$     t(7) = dassert(ts.name,{'azert';'yuiop';'qsdfg';'jklm'});
%$     t(8) = dassert(ts.tex,{'azert';'yuiop';'qsdfg';'jklm'});
%$ end
%$
%$ T = all(t);
%@eof:5

%@test:6
%$ t = zeros(8,1);
%$
%$ try
%$     ts = dseries(transpose(1:5),[]);
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dassert(ts.freq,1);
%$     t(3) = dassert(ts.init.freq,1);
%$     t(4) = dassert(ts.init.time,[1, 1]);
%$     t(5) = dassert(ts.vobs,1);
%$     t(6) = dassert(ts.nobs,5);
%$     t(7) = dassert(ts.name,{'Variable_1'});
%$     t(8) = dassert(ts.tex,{'Variable\\_1'});
%$ end
%$
%$ T = all(t);
%@eof:6

%@test:7
%$ t = zeros(8,1);
%$
%$ try
%$     ts = dseries(transpose(1:5),'1950Q1');
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dassert(ts.freq,4);
%$     t(3) = dassert(ts.init.freq,4);
%$     t(4) = dassert(ts.init.time,[1950, 1]);
%$     t(5) = dassert(ts.vobs,1);
%$     t(6) = dassert(ts.nobs,5);
%$     t(7) = dassert(ts.name,{'Variable_1'});
%$     t(8) = dassert(ts.tex,{'Variable\\_1'});
%$ end
%$
%$ T = all(t);
%@eof:7

%@test:8
%$ t = zeros(8,1);
%$
%$ try
%$     ts = dseries([transpose(1:5), transpose(6:10)],'1950q1',{'Output'; 'Consumption'}, {'Y_t'; 'C_t'});
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dassert(ts.freq,4);
%$     t(3) = dassert(ts.init.freq,4);
%$     t(4) = dassert(ts.init.time,[1950, 1]);
%$     t(5) = dassert(ts.vobs,2);
%$     t(6) = dassert(ts.nobs,5);
%$     t(7) = dassert(ts.name,{'Output'; 'Consumption'});
%$     t(8) = dassert(ts.tex,{'Y_t'; 'C_t'});
%$ end
%$
%$ T = all(t);
%@eof:8

%@test:9
%$ try
%$     [strfile, status] = urlwrite('http://www.dynare.org/Datasets/dseries/dynseries_test_data-1.xlsx','dynseries_test_data-1.xlsx');
%$     if ~status
%$         error()
%$     end
%$     ts = dseries('dynseries_test_data-1.xlsx');
%$     delete('dynseries_test_data-1.xlsx');
%$     t(1) = 1;
%$ catch
%$     t(1) = 0;
%$ end
%$
%$ if t(1)
%$     t(2) = dassert(ts.freq,4);
%$     t(3) = dassert(ts.init.freq,4);
%$     t(4) = dassert(ts.init.time,[1990, 1]);
%$     t(5) = dassert(ts.vobs,3);
%$     t(6) = dassert(ts.nobs,5);
%$     t(7) = dassert(ts.name,{'GDP';'Consumption';'CPI'});
%$     t(8) = dassert(ts.tex,{'GDP';'Consumption';'CPI'});
%$ end
%$
%$ T = all(t);
%@eof:9

%@test:10
%$ try
%$     [strfile, status] = urlwrite('http://www.dynare.org/Datasets/dseries/dynseries_test_data-2.xlsx','dynseries_test_data-2.xlsx');
%$     if ~status
%$         error()
%$     end
%$     ts = dseries('dynseries_test_data-2.xlsx');
%$     delete('dynseries_test_data-2.xlsx');
%$     t(1) = 1;
%$ catch
%$     t(1) = 0;
%$ end
%$
%$ if t(1)
%$     t(2) = dassert(ts.freq,4);
%$     t(3) = dassert(ts.init.freq,4);
%$     t(4) = dassert(ts.init.time,[1990, 1]);
%$     t(5) = dassert(ts.vobs,3);
%$     t(6) = dassert(ts.nobs,5);
%$     t(7) = dassert(ts.name,{'Variable_1';'Variable_2';'Variable_3'});
%$     t(8) = dassert(ts.tex,{'Variable\\_1';'Variable\\_2';'Variable\\_3'});
%$ end
%$
%$ T = all(t);
%@eof:10

%@test:11
%$ try
%$     [strfile, status] = urlwrite('http://www.dynare.org/Datasets/dseries/dynseries_test_data-3.xlsx','dynseries_test_data-3.xlsx');
%$     if ~status
%$         error()
%$     end
%$     ts = dseries('dynseries_test_data-3.xlsx');
%$     delete('dynseries_test_data-3.xlsx');
%$     t(1) = 1;
%$ catch
%$     t(1) = 0;
%$ end
%$
%$ if t(1)
%$     t(2) = dassert(ts.freq,1);
%$     t(3) = dassert(ts.init.freq,1);
%$     t(4) = dassert(ts.init.time,[1, 1]);
%$     t(5) = dassert(ts.vobs,3);
%$     t(6) = dassert(ts.nobs,5);
%$     t(7) = dassert(ts.name,{'Variable_1';'Variable_2';'Variable_3'});
%$     t(8) = dassert(ts.tex,{'Variable\\_1';'Variable\\_2';'Variable\\_3'});
%$ end
%$
%$ T = all(t);
%@eof:11

%@test:12
%$ try
%$     [strfile, status] = urlwrite('http://www.dynare.org/Datasets/dseries/dynseries_test_data-4.xlsx','dynseries_test_data-4.xlsx');
%$     if ~status
%$         error()
%$     end
%$     ts = dseries('dynseries_test_data-4.xlsx');
%$     delete('dynseries_test_data-4.xlsx');
%$     t(1) = 1;
%$ catch
%$     t(1) = 0;
%$ end
%$
%$ if t(1)
%$     t(2) = dassert(ts.freq,1);
%$     t(3) = dassert(ts.init.freq,1);
%$     t(4) = dassert(ts.init.time,[1, 1]);
%$     t(5) = dassert(ts.vobs,3);
%$     t(6) = dassert(ts.nobs,5);
%$     t(7) = dassert(ts.name,{'GDP';'Consumption';'CPI'});
%$     t(8) = dassert(ts.tex,{'GDP';'Consumption';'CPI'});
%$ end
%$
%$ T = all(t);
%@eof:12

%@test:13
%$ t = zeros(6,1);
%$
%$ try
%$     ts = dseries(transpose(1:4),dates('1990Q1'):dates('1990Q4'));
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dassert(ts.freq,4);
%$     t(3) = dassert(ts.init.freq,4);
%$     t(4) = dassert(ts.init.time,[1990, 1]);
%$     t(5) = dassert(ts.vobs,1);
%$     t(6) = dassert(ts.nobs,4);
%$ end
%$
%$ T = all(t);
%@eof:13

%@test:14
%$ t = zeros(7,1);
%$
%$ try
%$     ts = dseries([1, 2],dates('1990Q1'):dates('1990Q4'));
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dassert(ts.freq,4);
%$     t(3) = dassert(ts.init.freq,4);
%$     t(4) = dassert(ts.init.time,[1990, 1]);
%$     t(5) = dassert(ts.vobs,2);
%$     t(6) = dassert(ts.nobs,4);
%$     t(7) = dassert(ts.data, [ones(4,1), 2*ones(4,1)]);
%$ end
%$
%$ T = all(t);
%@eof:14

%@test:15
%$ try
%$     evalc('dseries([1; 2],dates(''1990Q1''):dates(''1990Q4''));');
%$     t = 0;
%$ catch
%$     t = 1;
%$ end
%$
%$ T = all(t);
%@eof:15
