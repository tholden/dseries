function run(o, basename)

% Runs x13 program and saves results.

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

% Print spc file.
basename = o.print();

% Run spc file.
system(sprintf('%s %s', select_x13_binary(), basename));

o.results.name = basename; % Base name of the generated files.

% Save results related to the REGRESSION command
if ~all(cellfun(@isempty, struct2cell(o.regression)))
    if ~isempty(o.regression.save)
        savedoutput = strsplit(o.regression.save, {',' , '(' , ')' , ' '});
        savedoutput = savedoutput(~cellfun('isempty', savedoutput));
        for i=1:length(savedoutput)
            if exist(sprintf('%s.%s', basename, lower(savedoutput{i})))
                tmp  = importdata(sprintf('%s.%s', basename, lower(savedoutput{i})));
                data = tmp.data;
                o.results.(savedoutput{i}) = dseries(data(:,2), o.y.init, savedoutput{i});
            end
        end
    end
end

% Save results related to the X11 command
if ~all(cellfun(@isempty, struct2cell(o.x11)))
    if ~isempty(o.x11.save)
        savedoutput = strsplit(o.x11.save, {',' , '(' , ')' , ' '});
        savedoutput = savedoutput(~cellfun('isempty', savedoutput));
        for i=1:length(savedoutput)
            if exist(sprintf('%s.%s', basename, lower(savedoutput{i})))
                tmp  = importdata(sprintf('%s.%s', basename, lower(savedoutput{i})));
                data = tmp.data;
                o.results.(savedoutput{i}) = dseries(data(:,2), o.y.init, savedoutput{i});
            end
        end
    end
end

% Save results related to the FORECAST command
if ~all(cellfun(@isempty, struct2cell(o.forecast)))
    if ~isempty(o.forecast.save)
        savedoutput = strsplit(o.forecast.save, {',' , '(' , ')' , ' '});
        savedoutput = savedoutput(~cellfun('isempty', savedoutput));
        for i=1:length(savedoutput)
            if exist(sprintf('%s.%s', basename, lower(savedoutput{i})))
                tmp  = importdata(sprintf('%s.%s', basename, lower(savedoutput{i})));
                name = strsplit(tmp.textdata{1},'\t');
                name = name(2:end);
                data = tmp.data(:,2:end);
                o.results.(savedoutput{i}) = dseries(data, lastobservedperiod(o.y)+1, name);
            end
        end
    end
end

% Save main generated output file.
o.results.out = fileread(sprintf('%s.out', basename))

% Delete all generated files.
delete([basename '.*']);