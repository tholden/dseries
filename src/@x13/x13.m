classdef x13<handle % --*-- Unitary tests --*--

% Class for X13 toolbox.

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

    properties
        y          = [];         % dseries object with a single variable.
        x          = [];         % dseries object with an arbitrary number of variables (to be used in the REGRESSION block).
        arima      = [];         % ARIMA model.
        automdl    = [];         % ARIMA model selection.
        regression = [];         % Regression model.
        estimate   = [];         % Estimation options.
        transform  = [];         % Transform command  applied to y.
        outlier    = [];         % Outlier command.
        forecast   = [];         % Forecast command.
        check      = [];         % Check command.
        x11        = [];         % X11 cmmand
        results    = [];         % Estimation results
        commands   = {};         % List of commands.
    end

    methods
        function o = x13(y, x)
        % Constructor for the x13 class.
        %
        % INPUTS
        % - y      [dseries]    Data.
        %
        % OUPUTS
        % - o      [x13]        Empty object except for the data.
            if ~nargin
                o.y = dseries();
                o.x = dseries();
                o.arima = setdefaultmember('arima');
                o.automdl = setdefaultmember('automdl');
                o.regression = setdefaultmember('regression');
                o.estimate = setdefaultmember('estimate');
                o.transform = setdefaultmember('transform');
                o.outlier = setdefaultmember('outlier');
                o.forecast = setdefaultmember('forecast');
                o.check = setdefaultmember('check');
                o.x11 = setdefaultmember('x11');
                o.results = struct();
                o.commands = {};
                return
            end
            if isdseries(y)
                if isequal(y.vobs, 1)
                    o.y = y;
                else
                    error('x13:: Wrong input argument (a dseries object with a single variable is expected)!')
                end
            else
                error('x13:: Wrong input argument (a dseries object is expected)!')
            end
            if nargin>1
                if isdseries(x)
                    o.x = x;
                else
                    error('x13:: Wrong input argument (a dseries object is expected)!')
                end
            end
            % Initialize other members (they are empty initially and must be set by calling methods)
            o.arima = setdefaultmember('arima');
            o.automdl = setdefaultmember('automdl');
            o.regression = setdefaultmember('regression');
            o.estimate = setdefaultmember('estimate');
            o.transform = setdefaultmember('transform');
            o.outlier = setdefaultmember('outlier');
            o.forecast = setdefaultmember('forecast');
            o.check = setdefaultmember('check');
            o.x11 = setdefaultmember('x11');
            o.results = struct();
            o.commands = {};
        end
    end
end