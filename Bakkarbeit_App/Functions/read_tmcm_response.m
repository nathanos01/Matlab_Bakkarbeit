function [error_code,error_msg,data] = read_tmcm_response(com_obj,nb_bytes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: read_tmcm_response()
% Goal    : Read the feedback message from the TMCM-6212 via serial
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
% Status        : 100 = no error, 1 to 6 are errors, 101 load to EEPROM
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
    TRANSMISSION_OK_ID   = int8(100);
    CMD_LOADED_EEPROM_ID = int8(101);
    WRONG_CHECKSUM_ID    = int8(1);
    INVALID_CMD_ID       = int8(2);
    WRONG_TYPE_ID        = int8(3);
    INVALID_VALUE_ID     = int8(4);
    EEPROM_LOCKED_ID     = int8(5);
    CMD_UNAVAILABLE_ID   = int8(6);
    WRONG_ERROR_ID;
    
    % Constants: status stings
    TRANSMISSION_OK_TXT   = 'The command has been executed successfully.';
    CMD_LOADED_EEPROM_TXT = 'The command has been loaded into the EEPROM successfully';
    WRONG_CHECKSUM_TXT    = 'Wrong checksum value.';
    INVALID_CMD_TXT       = 'Anvalid command sent to the motor.';
    WRONG_TYPE_TXT        = 'Wrong type value.';
    INVALID_VALUE_TXT     = 'Invalid four-byte field value. The MSB must be the first value chunk to be sent.';
    EEPROM_LOCKED_TXT     = 'The EEPROM''s configuration is locked. Unlock it to change its parameters.';
    CMD_UNAVAILABLE_TXT   = 'This command is not available for this mode. Select different command or mode.';
    WRONG_ERROR_TXT       = 'The returned status code is not known.';
    
    % Read the reply from the module
    [bytes_data,~] = read(com_obj,nb_bytes,'uint8');
    
    
    % Processing of the received bytes
    switch bytes_data(3)
        case TRANSMISSION_OK_ID
            error_code = TRANSMISSION_OK_ID;
            error_msg  = TRANSMISSION_OK_TXT;
        case CMD_LOADED_EEPROM_ID
            error_code = CMD_LOADED_EEPROM_ID;
            error_msg  = CMD_LOADED_EEPROM_TXT;
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
            error_code = WRONG_ERROR_ID;
            error_msg  = WRONG_ERROR_TXT;
    end

    % Get the returned 32bit value from the motor
    data = bytes_data(5:8)';
end