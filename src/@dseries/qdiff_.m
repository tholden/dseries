function o = qdiff_(o) % --*-- Unitary tests --*--

% Computes quaterly differences.
%
% INPUTS
% - o   [dseries]
%
% OUTPUTS
% - o   [dseries]

% Copyright (C) 2012-2017 Dynare Team
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

switch frequency(o)
  case 1
    error('dseries::qdiff: I cannot compute quaterly differences from yearly data!')
  case 4
    o.data(2:end,:) = o.data(2:end,:)-o.data(1:end-1,:);
    o.data(1,:) = NaN;
    for i = 1:vobs(o)
        o.name(i) = {['qdiff(' o.name{i} ')']};
        o.tex(i) = {['\Delta ' o.tex{i}]};
    end
  case 12
    o.data(4:end,:) = o.data(4:end,:)-o.data(1:end-3,:);
    o.data(1:3,:) = NaN;
    for i = 1:vobs(o)
        o.name(i) = {['qdiff(' o.name{i} ')']};
        o.tex(i) = {['\Delta_3 ' o.tex{i}]};
    end
  case 52
    error('dseries::qdiff: I do not know yet how to compute quaterly differences from weekly data!')
  otherwise
    error(['dseries::qdiff: object ' inputname(1) ' has unknown frequency']);
end

%@test:1
%$ try
%$     data = transpose(0:1:50);
%$     ts = dseries(data,'1950Q1');
%$     ts.qdiff_;
%$     t(1) = 1;
%$ catch
%$     t(1) = 0;
%$ end
%$
%$ if t(1)
%$     DATA = NaN(1,ts.vobs);
%$     DATA = [DATA; ones(ts.nobs-1,ts.vobs)];
%$     t(2) = dassert(ts.data,DATA,1e-15);
%$ end
%$
%$ T = all(t);
%@eof:1

%@test:2
%$ try
%$     data = transpose(0:1:80);
%$     ts = dseries(data,'1950M1');
%$     ts.qdiff_;
%$     t(1) = 1;
%$ catch
%$     t(1) = 0;
%$ end
%$
%$ if t(1)
%$     DATA = NaN(3,ts.vobs);
%$     DATA = [DATA; 3*ones(ts.nobs-3,ts.vobs)];
%$     t(2) = dassert(ts.data,DATA,1e-15);
%$ end
%$
%$ T = all(t);
%@eof:2
