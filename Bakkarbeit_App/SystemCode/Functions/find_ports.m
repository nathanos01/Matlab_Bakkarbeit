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
    list_of_avail_ports = serialportlist("all");
    
    % Only display available COM ports
    if isempty(list_of_avail_ports)
       warning('No COM port is available');
    end
catch
    warning('An error has occurred');
end

end