function [commands] = commands_table()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: commands_table()
% Goal    : Output a structure that contains all the available commands
%           that can be sent to the TMCM-1160.
%
% Structure fields:
% +-----------------------------------------------------------------+
% |Mnemonic name,{Command number, Min value, Max value, Type family}|
% +-----------------------------------------------------------------+
%
% IN      : -
% IN/OUT  : -
% OUT     : - mnemonics: list of all available commands for the TMCM-1160 
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Constants of 2 power the number of bit
  MAX_0b = 2^0 -1; MAX_1b = 2^1 -1; MAX_11b = 2^11-1; MAX_31b = 2^31-1;

  % Mnemonic encoding in decimal for the command number
  commands = struct(...
             'ROTATE_ON_RIGHT'                     ,{ 1,-MAX_11b,MAX_11b, 0},...
             'ROTATE_ON_LEFT'                      ,{ 2,-MAX_11b,MAX_11b, 0},...
             'MOTOR_STOP'                          ,{ 3,  MAX_0b, MAX_1b, 0},...
             'MOVE_TO_POSITION'                    ,{ 4,-MAX_31b,MAX_31b,13},...
             'SET_AXIS_PARAMETER'                  ,{ 5,-MAX_31b,MAX_31b, 2},...
             'GET_AXIS_PARAMETER'                  ,{ 6,  MAX_0b, MAX_1b, 1},...
             'STORE_AXIS_PARAMETER_INTO_EEPROM'    ,{ 7,  MAX_0b, MAX_1b, 3},...
             'RESTORE_AXIS_PARAMETER_FROM_EEPROM'  ,{ 8,  MAX_0b, MAX_1b, 3},...
             'SET_GLOBAL_PARAMETER'                ,{ 9,-MAX_31b,MAX_31b, 5},...
             'GET_GLOBAL_PARAMETER'                ,{10,  MAX_0b, MAX_1b, 4},...
             'STORE_GLOBAL_PARAMETER_INTO_EEPROM'  ,{11,  MAX_0b, MAX_1b, 6},...
             'RESTORE_GLOBAL_PARAMETER_FROM_EEPROM',{12,  MAX_0b, MAX_1b, 6},...
             'REFERENCE_SEARCH'                    ,{13,  MAX_0b, MAX_1b,14},...
             'SET_OUTPUT_VALUE'                    ,{14,  MAX_0b, MAX_1b,15},...
             'GET_INPUT_VALUE'                     ,{15,  MAX_0b, MAX_1b,15},...
             'CALCULATE_ACCUMULATOR_AND_CONSTANT'  ,{19,-MAX_31b,MAX_31b, 7},...
             'COMPARE_ACCUMULATOR_WITH_CONSTANT'   ,{20,-MAX_31b,MAX_31b, 0},...
             'JUMP_CONDITIONAL'                    ,{21,  MAX_0b,MAX_31b, 8},...
             'JUMP_ALWAYS'                         ,{22,  MAX_0b,MAX_31b, 0},...
             'CALL_FROM_SUBROUTINE'                ,{23,  MAX_0b,MAX_31b, 0},...
             'RETURN_FROM_SUBROUTINE'              ,{24,  MAX_0b, MAX_1b, 0},...
             'ENABLE_INTERRUPT'                    ,{25,  MAX_0b, MAX_1b,12},...
             'DISABLE_INTERRUPT'                   ,{26,  MAX_0b, MAX_1b,12},...
             'WAIT_FOR_SPECIFIED_EVENT'            ,{27,  MAX_0b,MAX_31b, 9},...
             'STOP_TMCL_PROGRAM'                   ,{28,  MAX_0b, MAX_1b, 0},...
             'STORE_COORDINATE'                    ,{30,-MAX_31b,MAX_31b,10},...
             'GET_COORDINATE'                      ,{31,  MAX_0b, MAX_1b,10},...
             'CAPTURE_COORDINATE'                  ,{32,  MAX_0b, MAX_1b,10},...
             'CALCULATE_USING_ACCU_AND_X_REGISTER' ,{33,  MAX_0b, MAX_1b, 7},...
             'COPY_ACCUMULATOR_TO_AXIS_PARAMETER'  ,{34,  MAX_0b, MAX_1b, 2},...
             'COPY_ACCUMULATOR_TO_GLOBAL_PARAMETER',{35,  MAX_0b, MAX_1b, 2},...
             'CLEAR_ERROR_FLAGS'                   ,{36,  MAX_0b, MAX_1b,11},...
             'SET_INTERRUPT_VECTOR'                ,{37,  MAX_0b,MAX_31b,12},...
             'RETURN_FROM_INTERRUPT'               ,{38,  MAX_0b, MAX_1b, 0},...
             'COPY_ACCUMULATOR_TO_COORDINATE'      ,{39,  MAX_0b, MAX_1b,10},...
             'USER_DEFINED_FUNCTION_0'             ,{64,  MAX_0b, MAX_1b, 0},...
             'USER_DEFINED_FUNCTION_1'             ,{65,  MAX_0b, MAX_1b, 0},...
             'USER_DEFINED_FUNCTION_2'             ,{66,  MAX_0b, MAX_1b, 0},...
             'USER_DEFINED_FUNCTION_3'             ,{67,  MAX_0b, MAX_1b, 0},...
             'USER_DEFINED_FUNCTION_4'             ,{68,  MAX_0b, MAX_1b, 0},...
             'USER_DEFINED_FUNCTION_5'             ,{69,  MAX_0b, MAX_1b, 0},...
             'USER_DEFINED_FUNCTION_6'             ,{70,  MAX_0b, MAX_1b, 0},...
             'USER_DEFINED_FUNCTION_7'             ,{71,  MAX_0b, MAX_1b, 0});
end
