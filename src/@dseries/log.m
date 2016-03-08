function o = log(o) % --*-- Unitary tests --*--

% Apply the logarithm to all the variables in a dseries object (without in place modification).
%
% INPUTS 
% - o [dseries]
%
% OUTPUTS 
% - o [dseries]

% Copyright (C) 2011-2015 Dynare Team
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

if any(o.data<eps)
    error('dseries:WrongInputArguments', 'Variables in %s have be strictly positive!', inputname(1))
end

o = copy(o);
o.log_;

%@test:1
%$ % Define a dates object
%$ data = ones(10,2);
%$ o = dseries(data);
%$ q = dseries(data);
%$
%$ % Call the tested routine.
%$ try
%$     p = o.log();
%$     t(1) = true;
%$ catch
%$     t(1) = false;
%$ end
%$ 
%$ if t(1)
%$      t(2) = dassert(o, q);
%$      t(3) = dassert(p.data, zeros(10, 2));
%$ end
%$
%$ T = all(t);
%@eof:1

%@test:2
%$ % Define a dates object
%$ data = ones(10,2);
%$ o = dseries(data);
%$ q = dseries(data);
%$
%$ % Call the tested routine.
%$ try
%$     p = o.log();
%$     t(1) = true;
%$ catch
%$     t(1) = false;
%$ end
%$ 
%$ if t(1)
%$      t(2) = dassert(length(p.name), 2);
%$      t(3) = dassert(p.name{1},'log(Variable_1)');
%$      t(4) = dassert(p.name{2},'log(Variable_2)');
%$      t(5) = dassert(o.name{1},'Variable_1');
%$      t(6) = dassert(o.name{2},'Variable_2');
%$ end
%$
%$ T = all(t);
%@eof:2