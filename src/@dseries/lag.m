function q = lag(o, p) % --*-- Unitary tests --*--

% Returns a lagged time series
%
% INPUTS 
% - o [dseries]
% - p [integer] Number of lags
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
%       | lag(Variable_1,1)
%    1Y | NaN              
%    2Y | 1                
%    3Y | 2                
%    4Y | 3                
%    5Y | 4         

% Copyright (C) 2013-2015 Dynare Team
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

% Set default number of lags
if nargin<2
    p = 1;
end

% Check second input argument
if p<=0
    error('dseries:WrongInputArguments','Second input argument must be strictly positive! Use lead method instead.')
end

if ~isint(p)
    error('dseries:WrongInputArguments','Second input argument must be an integer!')
end

% Copy of ts dseries object
q = copy(o);

% Update data member
q.data = [NaN(p, vobs(o));  q.data(1:end-p,:)];

for i=1:vobs(o)
    q.name(i) = {[ 'lag(' o.name{i} ',' int2str(p) ')']};
    q.tex(i) = {[ o.tex{i} '_{-' int2str(p) '}']};
end

%@test:1
%$ t = zeros(4,1);
%$
%$ try
%$     data = transpose(0:1:50);
%$     ts = dseries(data,'1950Q1');
%$     a = ts.lag;
%$     b = ts.lag.lag;
%$     c = lag(ts,2);
%$     t(1) = true;
%$ catch
%$     t(1) = false;
%$ end
%$
%$ if t(1)
%$     DATA = [NaN(1,ts.vobs); transpose(0:1:49)];
%$     t(2) = dassert(a.data,DATA,1e-15);
%$     DATA = [NaN(2,ts.vobs); transpose(0:1:48)];
%$     t(3) = dassert(b.data,DATA,1e-15);
%$     t(4) = dassert(b.data,c.data,1e-15);
%$ end
%$
%$ T = all(t);
%@eof:1