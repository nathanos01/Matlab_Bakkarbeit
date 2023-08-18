function [list_of_avail_ports] = find_ports()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: find_ports()
% Goal    : Make a list of all available COM ports on the device.
%
% IN      : -
% IN/OUT  : -
% OUT     : - list_of_avail_ports: list of all available COM ports
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize the list of available ports
list_of_avail_ports = {};

try
    % Try to retrieve the list of all available COM ports
    freeports = serialportlist("all");
    
    % Only display available COM ports
    if ~isempty(freeports)
        list_of_avail_ports = freeports;
    end
catch
    % Handle the case when no COM ports are available
    warning('No COM port is available');
end

end