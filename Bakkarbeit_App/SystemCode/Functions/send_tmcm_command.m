function [error_id,error_txt,decoded_data] = send_tmcm_command(...
    serial_port,address,command,type,motor,value_data,wait_time)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: send_tmcm_command()
% Goal    : Send an instruction via serial communication
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
% IN      : - serial_port: serial object used for the communication
%           - address    : module identifier code (1 for a motor)
%           - command    : mnemonic encoding in decimal
%           - type       : always 0 excepted for axis parameters
%           - motor      : motor identifier (0 for one motor only)
%           - value_data : position, speed or acceleration data to the motor
%           - wait_time  : time to wait before stopping the command in [s]
%                          this parameter is optional
% IN/OUT  : -
% OUT     : - error_id    : contains the error code of the last command
%           - error_txt   : contains the error message of the last command
%           - decoded_data: contains the output value of the last command
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Constants
BYTE              = 8;
NB_BYTES          = 9;
NB_VALUE_BYTES    = 4;
NO_CONNECTION_ID  = int8(8);
NO_CONNECTION_TXT = ['No connection could be established.',...
    newline,...
    'Maybe the wrong COM port has been selected.'];
CONN_FAULT     = MException('MATLAB:COM','No serial connection');

    % Optional waiting time parameter
    if ~exist('wait_time','var')
        wait_time = 0; % If no waiting time is defined, the default value is 0
    end
    
    % Initialization
    value     = zeros(1, NB_VALUE_BYTES);
    value_sum = 0;
    
    % Serial Byte chunks preparation
    value_4B = dec2bin(typecast(int32(value_data), 'uint32'), (NB_VALUE_BYTES * BYTE));
    value_4B = arrayfun(@(i) bin2dec(value_4B((i-1)*BYTE+1:i*BYTE)), NB_VALUE_BYTES:-1:1);
    value_sum = sum(value_4B);
    
    % Checksum calculation
    checksum = mod(sum([address, command, type, motor, value_sum]), 256);
    
    % Message construction
    message = uint8([address, command, type, motor, value_4B, checksum]);
    
    try
        % Send the well-formatted message
        write(serial_port,message,'uint8');
        % Read the reply from the module
        [error_id,error_txt,read_value] = read_tmcm_response(serial_port,NB_BYTES);
    catch CONN_FAULT
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