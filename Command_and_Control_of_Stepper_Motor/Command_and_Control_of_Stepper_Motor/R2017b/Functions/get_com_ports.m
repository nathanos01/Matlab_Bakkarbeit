function [list_of_ports] = get_com_ports()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: get_com_ports()
% Goal    : Retrieve the list of all available COM ports on the computer.
%
% IN      : - 
% IN/OUT  : -
% OUT     : - list_of_ports: list of all available COM ports
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#ok<*NASGU>

  % Constants
  COLON_DELIMITER  = ': ';
  COMMA_DELIMITER  = ', ';
  DOT_DELIMITER    = '. ';
  DOT_BN_DELIMITER = ['.' newline];
  % Exception definition
  ME_COM_PORT = MException('MATLAB:COM_port','COM port not available'); 

  % Retrieve the list of all available COM ports
  try
    % Force the opening of an unknown port to get a list of available ports
    serial_obj = serial('LIST_ALL_PORTS');
    fopen(serial_obj); 
  catch ME_COM_PORT
    % Extract available COM ports from the error message
    error_message   = split(ME_COM_PORT.message,...
                           {DOT_DELIMITER,DOT_BN_DELIMITER});
    available_ports = extractAfter(error_message(2),COLON_DELIMITER);
    % Only display available COM ports 
    if ~ismissing(available_ports)
      list_of_ports = flipud(cellstr(split(available_ports,COMMA_DELIMITER)));
    else
      list_of_ports = {''};
    end
  end 
end 
