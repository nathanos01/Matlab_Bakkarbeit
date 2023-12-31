function [global_params] = global_parameters_table_w_e()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: global_parameters_table_w_e()
% Goal    : Output a structure that contains all the global parameters that
%           can be written and written to the EEPROM of the TMCM-1160.
%
% Structure fields:
% +-------------------------------------------------------+
% |Parameter name,{Parameter number, Min value, Max value}|
% +-------------------------------------------------------+
%
% IN      : -
% IN/OUT  : -
% OUT     : - global_params: list of all write/EEPROM global parameters for
%                            the TMCM-1160 with their MIN and MAX values
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Constants of 2 power the number of bit
  MAX_0b  = 2^0 -1; MAX_1b  = 2^1 -1; MAX_2b  = 2^2 -1;
  MAX_8b  = 2^8 -1; MAX_11b = 2^11-1; MAX_31b = 2^31-1; MAX_32b = 2^32-1;
  
  % Mnemonic encoding in decimal for the available global parameters
  global_params = struct(...
                  'EEPROM_MAGIC'                   ,{ 64,MAX_0b, MAX_8b},...
                  'RS485_BAUD_RATE'                ,{ 65,MAX_0b,     11},...
                  'SERIAL_ADDRESS'                 ,{ 66,MAX_0b, MAX_8b},...
                  'ASCII_MODE'                     ,{ 67,MAX_0b, MAX_1b},...
                  'SERIAL_HEARTBEAT'               ,{ 68,MAX_0b, MAX_1b},...
                  'CAN_BIT_RATE'                   ,{ 69,     2,      8},...
                  'CAN_REPLY_ID'                   ,{ 70,MAX_0b,MAX_11b},...
                  'CAN_ID'                         ,{ 71,MAX_0b,MAX_11b},...
                  'CONFIGURATION_EEPROM_LOCK_FLAG' ,{ 70,MAX_0b, MAX_1b},...
                  'TELEGRAM_PAUSE_TIME'            ,{ 75,MAX_0b, MAX_8b},...
                  'SERIAL_HOST_ADDRESS'            ,{ 76,MAX_0b, MAX_8b},...
                  'AUTO_START_MODE'                ,{ 77,MAX_0b, MAX_1b},...
                  'END_SWITCH_POLARITY'            ,{ 79,MAX_0b, MAX_1b},...
                  'TMCL_CODE_PROTECTION'           ,{ 81,MAX_0b, MAX_2b},...
                  'CAN_SECONDARY_ADDRESS'          ,{ 83,MAX_0b, MAX_8b},...
                  'CCORDINATE_STORAGE'             ,{ 84,MAX_0b, MAX_1b},...
                  'DO_NOT_RESTORE_USER_VARIABLES'  ,{ 85,MAX_0b, MAX_1b},...
                  'SERIAL_SECONDARY_ADDRESS'       ,{ 87,MAX_0b, MAX_8b},...
                  'TICK_TIMER'                     ,{132,MAX_0b,MAX_32b},...
                  'RANDOM_NUMBER'                  ,{133,MAX_0b,MAX_31b},...
                  'TIMER_0_PERIOD'                 ,{  0,MAX_0b,MAX_32b},...
                  'TIMER_1_PERIOD'                 ,{  1,MAX_0b,MAX_32b},...
                  'TIMER_2_PERIOD'                 ,{  2,MAX_0b,MAX_32b},...
                  'STOP_LEFT_0_TRIGGER_TRANSITION' ,{ 27,MAX_0b, MAX_2b},...
                  'STOP_RIGHT_0_TRIGGER_TRANSITION',{ 28,MAX_0b, MAX_2b},...
                  'INPUT_0_TRIGGER_TRANSITION'     ,{ 39,MAX_0b, MAX_2b},...
                  'INPUT_1_TRIGGER_TRANSITION'     ,{ 40,MAX_0b, MAX_2b});
end
