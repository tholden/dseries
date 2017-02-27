function o = lead_(o, p) % --*-- Unitary tests --*--

% Returns a leaded time series
%
% INPUTS 
% - o [dseries]
% - p [integer]   Number of leads
%
% OUTPUTS 
% - o [dseries]
%
% EXAMPLE 
% Define a dseries object as follows:
%
% >> o = dseries(transpose(1:5))
%
% then o.lag(1) returns
%
%       | lead(Variable_1,1)
%    1Y | 2                 
%    2Y | 3                 
%    3Y | 4                 
%    4Y | 5                 
%    5Y | NaN       

% Copyright (C) 2013-2017 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

% Set default number of leads
if nargin<2
    p = 1;
end

% Check second input argument
if p<=0
    error('dseries:WrongInputArguments','Second input argument must be strictly positive! Use lag method instead.')
end

if ~isint(p)
    error('dseries:WrongInputArguments','Second input argument must be an integer!')
end

% Update data member
o.data = [  o.data(p+1:end,:); NaN(p, vobs(o));];

for i=1:vobs(o)
    o.name(i) = {[ 'lead(' o.name{i} ',' int2str(p) ')']};
    o.tex(i) = {[ o.tex{i} '_{+' int2str(p) '}']};
end

%@test:1
%$ try
%$     data = transpose(1:50);
%$     ts = dseries(data,'1950Q1');
%$     ts.lead_;
%$     t(1) = true;
%$ catch
%$     t(1) = false;
%$ end
%$
%$ if t(1)
%$     DATA = [data(2:end); NaN(1)];
%$     t(2) = dassert(ts.data, DATA, 1e-15);
%$ end
%$
%$ T = all(t);
%@eof:1

%@test:2
%$ try
%$     data = transpose(1:50);
%$     ts = dseries(data,'1950Q1');
%$     ts.lead_.lead_;
%$     t(1) = true;
%$ catch
%$     t(1) = false;
%$ end
%$
%$ if t(1)
%$     t(2) = all(isnan(ts.data(end-1:end))) && isequal(ts.data(1:end-2), data(3:end));
%$ end
%$
%$ T = all(t);
%@eof:2