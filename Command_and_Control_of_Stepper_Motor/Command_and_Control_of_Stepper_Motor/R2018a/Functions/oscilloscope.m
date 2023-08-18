function [new_data] = oscilloscope(index,width_time,refresh_time,...
                                   measured_data,new_data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: oscilloscope()
% Goal    : Organize the data so that they can be plotted like in a
%           standard oscilloscope.
%
% IN      : - index        : index indicating if a plot refresh is needed
%           - width_time   : time window representing the amount of sample
%                            to update
%           - refresh_time : time before refreshing the plot
%           - measured_data: last data coming in the plot
% IN/OUT  : - new_data     : new set of data to plot
% OUT     : -
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Update the time and data values to plot
  if (index*refresh_time <= width_time)
    % The data are still in the displayed time window
    new_data(1+(index-1)*refresh_time:index*refresh_time,:) = measured_data;
  else
    % The data are out of the displayed time window
    if any(isnan(new_data))
      temp = new_data(1:(index-1)*refresh_time,:);
      new_data = [temp((index*refresh_time-width_time)+1:end,:);measured_data];
    else
      % Shift data
      new_data = [new_data(refresh_time+1:width_time,:);measured_data];
    end
  end
end
