function o = ygrowth_(o) % --*-- Unitary tests --*--

% Computes yearly growth rates.
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
    o.data(2:end,:) = o.data(2:end,:)./o.data(1:end-1,:) - 1;
    o.data(1,:) = NaN;
    for i = 1:vobs(o)
        o.name(i) = {['ygrowth(' o.name{i} ')']};
        o.tex(i) = {['\delta ' o.tex{i}]};
    end
  case 4
    o.data(5:end,:) = o.data(5:end,:)./o.data(1:end-4,:) - 1;
    o.data(1:4,:) = NaN;
    for i = 1:vobs(o)
        o.name(i) = {['ygrowth(' o.name{i} ')']};
        o.tex(i) = {['\delta_4 ' o.tex{i}]};
    end
  case 12
    o.data(13:end,:) = o.data(13:end,:)./o.data(1:end-12,:) - 1;
    o.data(1:12,:) = NaN;
    for i = 1:vobs(o)
        o.name(i) = {['ygrowth(' o.name{i} ')']};
        o.tex(i) = {['\delta_{12} ' o.tex{i}]};
    end
  case 52
    o.data(53:end,:) = o.data(53:end,:)./o.data(1:end-52,:) - 1;
    o.data(1:52,:) = NaN;
    for i = 1:vobs(o)
        o.name(i) = {['ygrowth(' o.name{i} ')']};
        o.tex(i) = {['\delta_{52} ' o.tex{i}]};
    end
  otherwise
    error(['dseries::ygrowth: object ' inputname(1) ' has unknown frequency']);
end

%@test:1
%$ try
%$     data = repmat(transpose(1:4),100,1);
%$     ts = dseries(data,'1950Q1');
%$     ts.ygrowth_;
%$     t(1) = true;
%$ catch
%$     t(1) = false;
%$ end
%$
%$
%$ if t(1)
%$     DATA = NaN(4,ts.vobs);
%$     DATA = [DATA; zeros(ts.nobs-4,ts.vobs)];
%$     t(2) = dassert(ts.data,DATA);
%$ end
%$
%$ T = all(t);
%@eof:1

%@test:2
%$ try
%$     data = repmat(transpose(1:12),100,1);
%$     ts = dseries(data,'1950M1');
%$     ts.ygrowth_();
%$     t(1) = true;
%$ catch
%$     t(1) = false;
%$ end
%$
%$ if t(1)
%$     DATA = NaN(12,ts.vobs);
%$     DATA = [DATA; zeros(ts.nobs-12,ts.vobs)];
%$     t(2) = dassert(ts.data,DATA);
%$ end
%$
%$ T = all(t);
%@eof:2

%@test:3
%$ try
%$     data = repmat(transpose(1:52),100,1);
%$     ts = dseries(data,'1950W1');
%$     ts.ygrowth_();
%$     t(1) = true;
%$ catch
%$     t(1) = false;
%$ end
%$
%$
%$ if t(1)
%$     DATA = NaN(52,ts.vobs);
%$     DATA = [DATA; zeros(ts.nobs-52,ts.vobs)];
%$     t(2) = dassert(ts.data,DATA);
%$ end
%$
%$ T = all(t);
%@eof:3
