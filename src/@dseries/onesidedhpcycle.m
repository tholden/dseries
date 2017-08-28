function o = onesidedhpcycle(o, lambda) % --*-- Unitary tests --*--

% Extracts the cycle component from a dseries object using the one sided HP filter.
%
% INPUTS
% - o         [dseries]   Original time series.
% - lambda    [double]    scalar, trend smoothness parameter.
%
% OUTPUTS
% - o         [dseries]   Cycle component of the original time series.

% Copyright (C) 2017 Dynare Team
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

if nargin>1
    if lambda<=0
        error(['dseries::onesidedhptrend: Lambda must be a positive integer!'])
    end
else
    lambda = [];
end

o = copy(o);
o.onesidedhpcycle_(lambda);

return

%@test:1
d = randn(100,1);
o = dseries(d);

try
    p = o.onesidedhpcycle();
    t(1) = 1;
catch
    t(1) = 0;
end

if t(1)
    t(2) = dassert(o.data,d);
end

T = all(t);
%@eof:1