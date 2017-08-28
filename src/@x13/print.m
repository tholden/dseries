function basename = print(o, basename)

% Prints spc file.

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

if nargin<2 || isempty(basename)
    basename = randomstring(10);
end

fid = fopen(sprintf('%s.spc', basename), 'w');

% Print creation date
if ~isoctave() && ~verLessThan('matlab','9.0')
    fprintf(fid, '# File created on %s by Dynare.\n\n', datetime());
else
    fprintf(fid, '# File created on %s by Dynare.\n\n', datestr(now));
end

% Write SERIES block
fprintf(fid, 'series {\n');
fprintf(fid, ' title = "%s"\n', o.y.name{1});
p1 = firstobservedperiod(o.y);
p2 = lastobservedperiod(o.y);
printstart(fid, p1);
fprintf(fid, ' period = %i\n', o.y.init.freq);
fprintf(fid, ' data = %s', sprintf(data2txt(o.y(p1:p2).data)));
fprintf(fid, '}\n\n');

% Write TRANSFORM block
if ismember('transform', o.commands)
    fprintf(fid, 'transform {');
    if ~all(cellfun(@isempty, struct2cell(o.transform)))
        fprintf(fid, '\n');
        optionnames = fieldnames(o.transform);
        for i=1:length(optionnames)
            if ~isempty(o.transform.(optionnames{i}))
                printoption(fid, optionnames{i}, o.transform.(optionnames{i}));
            end
        end
    end
    fprintf(fid, '}\n\n');
end

% Write REGRESSION block
if ismember('regression', o.commands)
    fprintf(fid, 'regression {');
    if ~all(cellfun(@isempty, struct2cell(o.regression)))
        optionnames = fieldnames(o.regression);
        fprintf(fid, '\n');
        for i=1:length(optionnames)
            if ~isempty(o.regression.(optionnames{i}))
                if isequal(optionnames{i}, 'user') % Write needed data to a file.
                                                   % Determine the set of needed data
                    conditionningvariables = strsplit(o.regression.user, {',' , '(' , ')' , ' '});
                    conditionningvariables = conditionningvariables(~cellfun(@isempty,conditionningvariables));
                    % Check that these data are available.
                    for i=1:length(conditionningvariables)
                        if ~ismember(conditionningvariables{i}, o.x.name)
                            fclose(fid);
                            error('x13:regression: Variable %s is unkonwn', conditionningvariables{i})
                        end
                    end
                    % Select the data.
                    if length(conditionningvariables)<vobs(o.x)
                        x = o.x{conditionningvariables{:}};
                    else
                        x= o.x;
                    end
                    % Print user statement.
                    fprintf(fid, ' user = %s\n', o.regression.user);
                    % Print data statement.
                    fprintf(fid, ' data = %s\n', sprintf(data2txt(x.data)));
                elseif isequal(optionnames{i}, 'start')
                    if ischar(o.regression.start)
                        if isdate(o.regression.start)
                            PERIOD = dates(o.regression.start);
                        else
                            error('x13:regression: Option start cannot be interpreted as a date!')
                        end
                    elseif isdates(o.regression.start)
                        PERIOD = o.regression.start;
                    else
                        error('x13:regression: Option start cannot be interpreted as a date!')
                    end
                    printstart(fid, PERIOD);
                else
                    printoption(fid, optionnames{i}, o.regression.(optionnames{i}));
                end
            end
        end
        if ~isempty(o.x) && isempty(o.regression.start)
            fprintf(fid, ' start = %i.%i\n', year(o.x.init), subperiod(o.x.init));
        end
    end
    fprintf(fid, '}\n\n');
end

% Write ARIMA block
if ismember('arima', o.commands)
    fprintf(fid, 'arima {');
    if ~all(cellfun(@isempty, struct2cell(o.arima)))
        optionnames = fieldnames(o.arima);
        fprintf(fid, '\n');
        for i=1:length(optionnames)
            if ~isempty(o.arima.(optionnames{i}))
                printoption(fid, optionnames{i}, o.arima.(optionnames{i}));
            end
        end
    end
    fprintf(fid, '}\n\n');
end

% Write AUTOMDL block
if ismember('automdl', o.commands)
    fprintf(fid, 'automdl {');
    if ~all(cellfun(@isempty, struct2cell(o.automdl)))
        optionnames = fieldnames(o.automdl);
        fprintf(fid, '\n');
        for i=1:length(optionnames)
            if ~isempty(o.automdl.(optionnames{i}))
                printoption(fid, optionnames{i}, o.automdl.(optionnames{i}));
            end
        end
    end
    fprintf(fid, '}\n\n');
end

% Write OUTLIER block
if ismember('outlier', o.commands)
    fprintf(fid, 'outlier {');
    if ~all(cellfun(@isempty, struct2cell(o.outlier)))
        optionnames = fieldnames(o.outlier);
        fprintf(fid, '\n');
        for i=1:length(optionnames)
            if ~isempty(o.outlier.(optionnames{i}))
                printoption(fid, optionnames{i}, o.outlier.(optionnames{i}));
            end
        end
    end
    fprintf(fid, '}\n\n');
end

% Write FORECAST block
if ismember('forecast', o.commands)
    fprintf(fid, 'forecast {');
    if ~all(cellfun(@isempty, struct2cell(o.forecast)))
        optionnames = fieldnames(o.forecast);
        fprintf(fid, '\n');
        for i=1:length(optionnames)
            if ~isempty(o.forecast.(optionnames{i}))
                printoption(fid, optionnames{i}, o.forecast.(optionnames{i}));
            end
        end
    end
    fprintf(fid, '}\n\n');
end

% Write ESTIMATE block
if ismember('estimate', o.commands)
    fprintf(fid, 'estimate {');
    if ~all(cellfun(@isempty, struct2cell(o.estimate)))
        optionnames = fieldnames(o.estimate);
        fprintf(fid, '\n');
        for i=1:length(optionnames)
            if ~isempty(o.estimate.(optionnames{i}))
                printoption(fid, optionnames{i}, o.estimate.(optionnames{i}));
            end
        end
    end
    fprintf(fid, '}\n\n');
end

% Write CHECK block
if ismember('check', o.commands)
    fprintf(fid, 'check {');
    if ~all(cellfun(@isempty, struct2cell(o.check)))
        optionnames = fieldnames(o.check);
        fprintf(fid, '\n');
        for i=1:length(optionnames)
            if ~isempty(o.check.(optionnames{i}))
                printoption(fid, optionnames{i}, o.check.(optionnames{i}));
            end
        end
    end
    fprintf(fid, '}\n\n');
end

% Write X11 block
if ismember('x11', o.commands)
    fprintf(fid, 'x11 {');
    if ~all(cellfun(@isempty, struct2cell(o.x11)))
        optionnames = fieldnames(o.x11);
        fprintf(fid, '\n');
        for i=1:length(optionnames)
            if ~isempty(o.x11.(optionnames{i}))
                printoption(fid, optionnames{i}, o.x11.(optionnames{i}));
            end
        end
    end
    fprintf(fid, '}\n\n');
end

fclose(fid);