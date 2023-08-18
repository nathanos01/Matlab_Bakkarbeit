function [error_id,new_path] = ask_path(prev_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: ask_path()
%           Ask the user to give the path to a text file.
%
% IN    : - prev_path: path of the last operation
% IN/OUT: -
% OUT   : - error_id : '1' = the path does not exist, '0' = OK
%         - new_path : get the path given by the user
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Constants
  TEXT_PROMPT = 'Browse to the desired text file';
  FILE_TYPE   = '*.txt';

  % Initialization of the error status
  error_id = 0;

  % Dialog box asking for the text file location
  [file_name,path_name] = uigetfile(FILE_TYPE,prev_path,TEXT_PROMPT);

  % Check if the path is empty
  if (file_name == 0)
    new_path = '';
  else
    new_path = [path_name file_name];
    % Error handling
    if (~exist(new_path,'file'))
      % The path does not exist
      new_path = '';
      error_id = 1;
    end
  end
end
