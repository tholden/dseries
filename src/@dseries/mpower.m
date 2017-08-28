function q = mpower(o, p) % --*-- Unitary tests --*--

% Overloads the power (^) operator for dseries objects.
%
% INPUTS
% - o [dseries]           T observations and N variables.
% - p [dseries,double]    scalar, vector or dseries object.
%
% OUTPUTS
% - q [dseries]           T observations and N variables.

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

if isnumeric(o) && isvector(o) && length(o)>1
    if ~isdseries(p)
        error('dseries:WrongInputArguments', 'Second input argument must be a dseries object!')
    end
    q = copy(p);
    q.data = bsxfun(@power, p.data, o);
    return;
end

if isnumeric(p) && isvector(p) && length(p)>1
    if ~isdseries(o)
        error('dseries:WrongInputArguments', 'First input argument must be a dseries object!')
    end
    q = copy(o);
    q.data = bsxfun(@power, o.data, p);
    return
end

if isdseries(o) && isnumeric(p) && isreal(p) &&  isscalar(p)
    q = dseries();
    q.dates = o.dates;
    q.data = o.data.^p;
    q.name = cell(vobs(q),1);
    q.tex = cell(vobs(q),1);
    for i=1:vobs(q)
        q.name(i) = {['power(' o.name{i} ';' num2str(p) ')']};
        q.tex(i) = {[o.tex{i} '^' num2str(p) ]};
    end
    return
end

if isdseries(o) && isdseries(p)
    if isequal(nobs(o),nobs(p)) && isequal(vobs(o), vobs(p)) && isequal(frequency(o),frequency(p))
        q = dseries();
        q.data = (o.data).^p.data;
        q.dates = o.dates;
        q.name = cell(vobs(q),1);
        q.tex = cell(vobs(q),1);
        for i=1:vobs(q)
            q.name(i) = {['power(' o.name{i} ';' p.name{i} ')']};
            q.tex(i) = {[o.tex{i} '^{' p.tex{i} '}']};
        end
    else
        error('dseries:WrongInputArguments', 'If both input arguments are dseries objects, they must have the same numbers of variables and observations and common frequency!')
    end
    return
end

error('dseries:WrongInputArguments', 'Wrong calling sequence! Please check the manual.')

%@test:1
%$ % Define a datasets.
%$ A = rand(10,2); B = randn(10,2);
%$
%$ % Define names
%$ A_name = {'A1';'A2'}; B_name = {'B1';'B2'};
%$
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts2 = dseries(B,[],B_name,[]);
%$    ts3 = ts1^ts2;
%$    t(1) = true;
%$ catch
%$    t(1) = false;
%$ end
%$
%$ if t(1)
%$    t(2) = dassert(ts3.vobs,2);
%$    t(3) = dassert(ts3.nobs,10);
%$    t(4) = dassert(ts3.data,A.^B,1e-15);
%$    t(5) = dassert(ts3.name,{'power(A1;B1)';'power(A2;B2)'});
%$    t(6) = dassert(ts3.tex,{'A1^{B1}';'A2^{B2}'});
%$    t(7) = dassert(ts1.data, A, 1e-15);
%$ end
%$ T = all(t);
%@eof:1

%@test:2
%$ % Define a datasets.
%$ A = rand(10,2);
%$
%$ % Define names
%$ A_name = {'A1';'A2'};
%$
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts3 = ts1^2;
%$    t(1) = true;
%$ catch
%$    t(1) = false;
%$ end
%$
%$ if t(1)
%$    t(2) = dassert(ts3.vobs,2);
%$    t(3) = dassert(ts3.nobs,10);
%$    t(4) = dassert(ts3.data,A.^2,1e-15);
%$    t(5) = dassert(ts3.name,{'power(A1;2)';'power(A2;2)'});
%$    t(6) = dassert(ts3.tex,{'A1^2';'A2^2'});
%$ end
%$ T = all(t);
%@eof:2

%@test:3
%$ % Define a dseries object
%$ ts1=dseries([1 1;2 2;3 3], '1999y', {'MyVar1','MyVar2'});
%$
%$ % Use the power
%$ try
%$    ts2 = ts1^transpose(1:3);
%$    t(1) = true;
%$ catch
%$    t(1) = false;
%$ end
%$
%$ if t(1)
%$    t(2) = dassert(ts2.vobs,2);
%$    t(3) = dassert(ts2.nobs,3);
%$    t(4) = dassert(ts2.data,bsxfun(@power,ts1.data,transpose(1:3)),1e-15);
%$    t(5) = dassert(ts2.name,{'MyVar1';'MyVar2'});
%$    t(6) = dassert(ts2.tex,{'MyVar1';'MyVar2'});
%$ end
%$ T = all(t);
%@eof:3