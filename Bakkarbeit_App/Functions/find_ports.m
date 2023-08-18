function [list_of_ports] = find_ports()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: find_ports()
% Goal    : Make a list of all available COM ports on the device.
%
% IN      : -
% IN/OUT  : -
% OUT     : - list_of_ports: list of all available COM ports
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Exception definition
ME_COM_PORT = MException('MATLAB:COM_port','COM port not available');

% Retrieve the list of all available COM ports
try
    % Force the opening of an unknown port to get a list of available ports
    freeports = serialport('all');
catch ME_COM_PORT
    
    % Extract available COM ports from the error message
    error_message   = split(ME_COM_PORT.message,...
        {'. ',['.' newline]});
    available_ports = extractAfter(error_message(2),': ');
    % Only display available COM ports
    if ~ismissing(available_ports)
        list_of_ports = flipud(cellstr(split(available_ports,', ')));
    else
        list_of_ports = {''};
    end
end
end