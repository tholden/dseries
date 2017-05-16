function printspan(fid, period1, period2)

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

if ~isequal(period1.freq, period2.freq)
    error('x13:printspan: Second and third input argument must have common frequency!')
end

if ~ismember(period1.freq, [1 4 12]) || ~ismember(period2.freq, [1 4 12]) 
    error('x13:printspan: Only monthly, quaterly or annual data are allowed!')
end

if period1>=period2
    error('x13:printspan: Third argument has to be greater than the second argument!')
end

switch period1.freq
  case 12
    ListOfMonths = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
    fprintf(fid, ' span = (%i.%s, %i.%s)\n', period1.year, ListOfMonths{period1.subperiod}, period2.year, ListOfMonths{period2.subperiod});
  case 4
    fprintf(fid, ' span = (%i.%s, %i.%s)\n', period1.year, period1.subperiod, period2.year, period2.subperiod);
  case 1
    fprintf(fid, ' span = (%i,%i)\n', period1.year, period2.year);
  otherwise
    error('x13:regression: This is a bug! Please contact the authors.')
end