function installx13()

% Installs CENSUS X13 binaries (Windows and Linux).

% Copyright (C) 2017 Dynare Team
%
% This code is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare dseries submodule is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.


if ~exist('x13.zip','file')
    if ( ~isoctave() && verLessThan('matlab', 'R2014b') )
        websave('x13.zip', 'http://www.dynare.org/x13/x13.zip');
    else
        urlwrite('http://www.dynare.org/x13/x13.zip', 'x13.zip');
    end
    unzip('x13.zip');
    movefile('binaries/linux','./linux');
    movefile('binaries/windows','./windows');
    rmdir('binaries');
end
