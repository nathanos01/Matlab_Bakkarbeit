function [error_id,error_txt,decoded_data] = send_serial_command(...
          serial_obj,address,command,type,motor,value_data,wait_time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: send_serial_command()
% Goal    : Send an instruction to the TMCM-1160 via serial communication
%           and read the feedback message.
%
% Message structure:
% +-------+-------+-------+-------++------+-------+-------+------++-------+
% |Module |Command| Type  | Motor ||Value | Value | Value | Value|| Check |
% |address| number| number| number|| MSB  |       |       | LSB  ||  sum  |
% +-------+-------+-------+-------++------+-------+-------+------++-------+
%
% Module address: 0x01 for the module and 0x02 for the host
% Command number: 0xYZ value depends on the mnemonic encoding
% Type number   : 0x00 for motion commands and 0xYZ for axis parameters
% Motor number  : 0x00 for one single motor that is connected
% Value data    : 32bit encoded value with the MSB first
% Checksum      : sum of all message bytes 
%
% IN      : - serial_obj: serial object used for the communication
%           - address   : module identifier code (1 for a motor)
%           - command   : mnemonic encoding in decimal
%           - type      : always 0 excepted for axis parameters
%           - motor     : motor identifier (0 for one motor only)
%           - value_data: position, speed or acceleration data to the motor
%           - wait_time : time to wait before stopping the command in [s]
%                         this parameter is optional
% IN/OUT  : -
% OUT     : - error_id    : contains the error code of the last command
%           - error_txt   : contains the error message of the last command
%           - decoded_data: contains the output value of the last command
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#ok<*NASGU>

  % Constants
  BYTE              = 8;
  NB_BYTES          = 9;
  NB_VALUE_BYTES    = 4;
  NO_CONNECTION_ID  = int8(8);
  NO_CONNECTION_TXT = ['There is an issue with the serial connection.',...
                       newline,...
                       'Perhaps the wrong COM port has been selected.'];
  ME_CONNECTION     = MException('MATLAB:COM','No serial connection');

  % Optional waiting time parameter
  if ~exist('wait_time','var')
    wait_time = 0; % No waiting time, so the default value is 0
  end
  
  % Initialization
  value     = zeros(1,NB_VALUE_BYTES);
  value_sum = 0;

  % Serial Byte chunks preparation
  value_4B  = dec2bin(typecast(int32(value_data),'uint32'),NB_VALUE_BYTES*BYTE);
  for i=NB_VALUE_BYTES:-1:1 % MSB first for the chunk value
    value(i)  = bin2dec(value_4B((i-1)*BYTE+1:i*BYTE));
    value_sum = value_sum + value(i);
  end
  value_sum_B = dec2bin(value_sum,BYTE);
  % Checksum calculation
  checksum = address+command+type+motor+bin2dec(value_sum_B(end-BYTE+1:end));
  % Message construction
  message = [address,command,type,motor,value,checksum];
  
  try
    % Send the well-formatted message
    fwrite(serial_obj,message,'uint8');
    % Read the reply from the module
    [error_id,error_txt,read_value] = read_serial_reply(serial_obj,NB_BYTES);
  catch ME_CONNECTION
    error_id     = NO_CONNECTION_ID;
    error_txt    = NO_CONNECTION_TXT;
    decoded_data = int32(0);
  end
  % Stop the execution because an error occured
  if (error_id ~= 0)
    return;
  end

  % Decoding of the read value based on the measured parameter
  value_B      = dec2bin(read_value,BYTE);
  value_4B     = [value_B(1,:) value_B(2,:) value_B(3,:) value_B(4,:)];
  decoded_data = typecast(uint32(bin2dec(value_4B)),'int32');

  % Optional waiting time parameter if needed
  if (wait_time ~= 0)
    pause(wait_time);
  end
end

function [error_code,error_msg,data] = read_serial_reply(com_obj,nb_bytes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: read_serial_reply()
% Goal    : Read the feedback message from the TMCM-1160 via serial
%           communication and gather any possible error.
%
% Message structure:
% +-------+-------+-------+-------++------+-------+-------+------++-------+
% | Reply |Module |Status |Command||Value | Value | Value | Value|| Check |
% |address|address|       | number|| MSB  |       |       | LSB  ||  sum  |
% +-------+-------+-------+-------++------+-------+-------+------++-------+
%
% Reply address : 0x02 for the host
% Module address: 0x01 for the module
% Status        : 100 = no error, 1 to 7 are errors
% Command number: 0xYZ value depends on the mnemonic encoding
% Value data    : 32bit encoded value with the MSB first
% Checksum      : sum of all message bytes 
%
% IN      : - com_obj   : serial object used for the communication
%           - nb_bytes  : number of data bytes to read
% IN/OUT  : -
% OUT     : - error_code: status of the last command transmission
%           - error_msg : text message describing the error
%           - data      : returned data of the last command from the motor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Constants: status codes
  NO_ERROR_ID         = int8(100);
  TRANSMISSION_OK_ID  = int8(0);
  WRONG_CHECKSUM_ID   = int8(1);
  INVALID_CMD_ID      = int8(2);
  WRONG_TYPE_ID       = int8(3);
  INVALID_VALUE_ID    = int8(4);
  EEPROM_LOCKED_ID    = int8(5);
  CMD_UNAVAILABLE_ID  = int8(6);
  UNTRUSTED_MSG_ID    = int8(7);
  UNKNOWN_ERROR_ID    = int8(10);
  % Constants: status stings
  TRANSMISSION_OK_TXT = 'The command has been executed successfully.';
  WRONG_CHECKSUM_TXT  = 'Wrong checksum value. Incorrect result of the 8-bit addition of the 8 chunks.';
  INVALID_CMD_TXT     = 'Invalid command sent to the motor. See the mnemonics table for valid commands.';
  WRONG_TYPE_TXT      = 'Wrong type value. In most cases, this value is 0 and it can go up to 5.';
  INVALID_VALUE_TXT   = 'Invalid four-byte field value. The MSB must be the first value chunk to be sent.';
  EEPROM_LOCKED_TXT   = 'The EEPROM''s configuration is locked. Unlock it to change its parameters.';
  CMD_UNAVAILABLE_TXT = 'This command is not available for this mode. Select another command or mode.';
  UNTRUSTED_MSG_TXT   = 'The received message cannot be trusted. Incorrect number of chunks received.';
  UNKNOWN_ERROR_TXT   = 'Unknown error. This error is not listed as a known error.';

  % Read the reply from the module
  [bytes_data,nb_bytes_read] = fread(com_obj,nb_bytes,'uint8');
  % Handling of possible errors
  if (nb_bytes_read ~= nb_bytes)
    % The transmitted data cannot be trusted
    error_code = UNTRUSTED_MSG_ID;
    error_msg  = UNTRUSTED_MSG_TXT;
  else
    % Processing of the received bytes
    switch bytes_data(3)
      case NO_ERROR_ID
        error_code = TRANSMISSION_OK_ID;
        error_msg  = TRANSMISSION_OK_TXT;
      case WRONG_CHECKSUM_ID
        error_code = WRONG_CHECKSUM_ID;
        error_msg  = WRONG_CHECKSUM_TXT;
      case INVALID_CMD_ID
        error_code = INVALID_CMD_ID;
        error_msg  = INVALID_CMD_TXT;
      case WRONG_TYPE_ID
        error_code = WRONG_TYPE_ID;
        error_msg  = WRONG_TYPE_TXT;
      case INVALID_VALUE_ID
        error_code = INVALID_VALUE_ID;
        error_msg  = INVALID_VALUE_TXT;
      case EEPROM_LOCKED_ID
        error_code = EEPROM_LOCKED_ID;
        error_msg  = EEPROM_LOCKED_TXT;
      case CMD_UNAVAILABLE_ID
        error_code = CMD_UNAVAILABLE_ID;
        error_msg  = CMD_UNAVAILABLE_TXT;
      otherwise
        error_code = UNKNOWN_ERROR_ID;
        error_msg  = UNKNOWN_ERROR_TXT;
    end
  end
  
  % FOR DEBUG PURPOSES: display the first 3 fields that are always the same
  % header = bytes_data(1:3)'
  % Get the returned 32bit value from the motor
  data = bytes_data(5:8)';
end
