function s = setdefaultmember(name)

% Set members of X13 object to default values (empty).

% Copyright (C) 2017 Dynare Team
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

switch name
  case 'arima'
    s = struct('ar', [], 'ma', [], 'model', [], 'print', [], 'save', [], 'title', []);
  case 'regression'
    s = struct('aicdiff', [], 'aictest', [], 'chi2test', [], 'chi2testcv', [], ...
               'print', [], 'save', [], 'pvaictest', [], 'savelog', [], 'start', [], ...
               'tlimit', [], 'user', [], 'usertype', [], 'variables', [], 'b', [], ...
               'centeruser', [], 'eastermeans', [], 'noapply', [], 'tcrate', []);
  case 'estimate'
    s = struct('exact', [], 'maxiter', [], 'outofsample', [], 'print', [], 'save', [], 'savelog', ...
               [], 'tol', [], 'file', [], 'fix', []);
  case 'transform'
    s = struct('adjust', [], 'aicdiff', [], 'function', [], 'mode', [], 'name', [], ...
               'power', [], 'precision', [], 'print', [], 'save', [], 'savelog', [], ...
               'start', [], 'title', [], 'type', []);
  case 'outlier'
    s= struct('critical', [], 'lsrun', [], 'method', [], 'print', [], 'save', [], ...
              'savelog', [], 'span', [], 'types', [], 'almost', [], 'tcrate', []);
  case 'forecast'
    s = struct('exclude', [], 'lognormal', [], 'maxback', [], 'maxlead', [], 'print', [], ...
               'save', [], 'probability', []);
  case 'check'
    s = struct('maxlag', [], 'print', [], 'save', [], 'qtype', [], 'savelog', []);
  case 'x11'
    s = struct('appendbcst', [], 'appendfcst', [], 'final', [], 'mode', [], 'print', [], 'save', [], ...
               'savelog', [], 'seasonalma', [], 'sigmalim', [], 'title', [], 'trendma', [], 'type', [], ...
               'calendarsigma', [], 'centerseasonal', [], 'keepholiday', [], 'print1stpass', [], ...
               'sfshort', [], 'sigmavec', [], 'trendic', [], 'true7term', [], 'excludefcst', []);
  otherwise
    error('x13:setdefaultmember: Unknown member!')
end
