function o = subsref(o, S) % --*-- Unitary tests --*--

% Overloads the subsref method.

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

switch S(1).type
  case '.'
    switch S(1).subs
      case {'arima','automdl','regression','transform','outlier', 'forecast', 'check', 'x11', 'estimate'}
        if isequal(length(S), 1)
            % Just print the member.
            disp(o.(S(1).subs))
        else
            if isequal(S(2).type,'()')
                if ~ismember(S(1).subs, o.commands)
                    switch S(1).subs
                      case 'arima'
                        if ismember('automdl', o.commands)
                            error('x13:arima: ARIMA command is not compatible with AUTOMDL command!')
                        end
                      case 'automdl'
                        if ismember('arima', o.commands)
                            error('x13:automdl: AUTOMDL command is not compatible with ARIMA command!')
                        end
                      otherwise
                    end
                    o.commands(end+1) = {S(1).subs};
                end
                if isempty(S(2).subs)
                    % Reset the member to its default (empty).
                    o.(S(1).subs) = setdefaultmember(S(1).subs);
                else
                    % Set options.
                    if mod(length(S(2).subs), 2)
                        error('x13:%s: Wrong calling sequence, number of input arguments has to be even!', S(1).subs)
                    end
                    for i=1:2:length(S(2).subs)
                        if isoption(S(1).subs, S(2).subs{i})
                            o.(S(1).subs) = setoption(o.(S(1).subs), S(2).subs{i}, S(2).subs{i+1});
                        else
                            disp(sprintf('Option %s is not available in block %s!', S(2).subs{i}, S(1).subs))
                        end
                    end
                end
            else
                error('x13:%s: Wrong calling sequence!', S(1).subs)
            end
        end
      case {'print', 'run', 'clean'}
        if isequal(length(S), 1)
            feval(S(1).subs, o);
        elseif isequal(length(S), 2)
            if isequal(S(2).type,'()')
                if isempty(S(2).subs)
                    feval(S(1).subs, o);
                else
                    feval(S(1).subs, o, S(2).subs{:});
                end
            else
                error('x13:: Wrong calling sequence!')
            end
        else
            error('x13:: I expect no more than two input arguments!')
        end
      case 'results'
        % Returns a structure with all the results.
        o = o.results;
      otherwise
        error('x13:: I do not understand what you are asking for!')
    end
  otherwise
    error('x13:: I do not understand what you are asking for!')
end