function [type_struct] = get_type_fields(type_family)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: get_type_fields()
% Goal    : Output a structure that contains fields related to a specific
%           type that has been selected.
%
% Structure fields:
% +----------------------------------------------------+
% |Mnemonic name,{Command number, Min value, Max value}|
% +----------------------------------------------------+
%
% IN      : - type_family: index referring to the type of TMCM parameters
%                          to retrieve
% IN/OUT  : -
% OUT     : - type_struct: list of all available parameters for the type
%                          provided with their MIN and MAX values
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  switch type_family
    case  0
      type_struct = struct('DO_NOT_CARE',{0,-1,0});
    case  1
      type_struct = axis_parameters_table_r_w_e();
    case  2
      type_struct = axis_parameters_table_w_e();
    case  3
      type_struct = axis_parameters_table_e();
    case  4
      type_struct = global_parameters_table_r_w_e();
    case  5
      type_struct = global_parameters_table_w_e();
    case  6
      type_struct = global_parameters_table_e();
    case  7
      type_struct = math_operations();
    case  8
      type_struct = test_operations();
    case  9
      type_struct = wait_operations();
    case 10
      type_struct = access_positions();
    case 11
      type_struct = access_flags();
    case 12
      type_struct = access_interrupts();
    case 13
      type_struct = move_to_position();
    case 14
      type_struct = reference_search();
    case 15
      type_struct = access_ios();
    otherwise
      % The selected type is unknown
      type_struct = struct([]);
  end
end

function [math_params] = math_operations()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: math_operations()
% Goal    : Output a structure that contains all the mathematical
%           operations that can be used on the the TMCM-1160.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Constants of 2 power the number of bit
  MAX_31b = 2^31-1;

  math_params = struct('ADD'      ,{ 0,-MAX_31b,MAX_31b},...
                       'SUBSTRACT',{ 1,-MAX_31b,MAX_31b},...
                       'MULTIPLY' ,{ 2,-MAX_31b,MAX_31b},...
                       'DIVIDE'   ,{ 3,-MAX_31b,MAX_31b},...
                       'MODULO'   ,{ 4,-MAX_31b,MAX_31b},...
                       'AND'      ,{ 5,-MAX_31b,MAX_31b},...
                       'OR'       ,{ 6,-MAX_31b,MAX_31b},...
                       'XOR'      ,{ 7,-MAX_31b,MAX_31b},...
                       'NOT'      ,{ 8,-MAX_31b,MAX_31b},...
                       'LOAD'     ,{ 9,-MAX_31b,MAX_31b},...
                       'SWAP'     ,{10,-MAX_31b,MAX_31b});
end

function [test_params] = test_operations()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: test_operations()
% Goal    : Output a structure that contains all the test operations that
%           can be used on the the TMCM-1160.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Constants of 2 power the number of bit
  MAX_31b = 2^31-1;

  test_params = struct('ZERO'            ,{0,0,MAX_31b},...
                       'NOT_ZERO'        ,{1,0,MAX_31b},...
                       'EQUAL'           ,{2,0,MAX_31b},...
                       'NOT_EQUAL'       ,{3,0,MAX_31b},...
                       'GREATER'         ,{4,0,MAX_31b},...
                       'GREATER_OR_EQUAL',{5,0,MAX_31b},...
                       'LOWER'           ,{6,0,MAX_31b},...
                       'LOWER_OR_EQUAL'  ,{7,0,MAX_31b},...
                       'TIME_OUT_ERROR'  ,{8,0,MAX_31b});
end

function [wait_params] = wait_operations()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: wait_operations()
% Goal    : Output a structure that contains all the wait operations that
%           can be used on the the TMCM-1160.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Constants of 2 power the number of bit
  MAX_31b = 2^31-1;

  wait_params = struct('TIMER_TICKS'               ,{0,0,MAX_31b},...
                       'TARGET_POSITION_REACHED'   ,{1,0,MAX_31b},...
                       'REFERENCE_SWITCH'          ,{2,0,MAX_31b},...
                       'LIMIT_SWITCH'              ,{3,0,MAX_31b},...
                       'REFERENCE_SEARCH_COMPLETED',{4,0,MAX_31b});
end

function [pos_params] = access_positions()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: access_positions()
% Goal    : Output a structure that contains the number of positions to
%           access on the the TMCM-1160.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Constants of 2 power the number of bit
  MAX_31b = 2^31-1;

  pos_params = struct('ZERO_POSITION'      ,{ 0,-MAX_31b,MAX_31b},...
                      'ONE_POSITION'       ,{ 1,-MAX_31b,MAX_31b},...
                      'TWO_POSITIONS'      ,{ 2,-MAX_31b,MAX_31b},...
                      'THREE_POSITIONS'    ,{ 3,-MAX_31b,MAX_31b},...
                      'FOUR_POSITIONS'     ,{ 4,-MAX_31b,MAX_31b},...
                      'FIVE_POSITIONS'     ,{ 5,-MAX_31b,MAX_31b},...
                      'SIX_POSITIONS'      ,{ 6,-MAX_31b,MAX_31b},...
                      'SEVEN_POSITIONS'    ,{ 7,-MAX_31b,MAX_31b},...
                      'EIGHT_POSITIONS'    ,{ 8,-MAX_31b,MAX_31b},...
                      'NINE_POSITIONS'     ,{ 9,-MAX_31b,MAX_31b},...
                      'TEN_POSITIONS'      ,{10,-MAX_31b,MAX_31b},...
                      'ELEVEN_POSITIONS'   ,{11,-MAX_31b,MAX_31b},...
                      'TWELVE_POSITIONS'   ,{12,-MAX_31b,MAX_31b},...
                      'THIRTEEN_POSITIONS' ,{13,-MAX_31b,MAX_31b},...
                      'FOURTEEN_POSITIONS' ,{14,-MAX_31b,MAX_31b},...
                      'FIFTHTEEN_POSITIONS',{15,-MAX_31b,MAX_31b},...
                      'SIXTEEN_POSITIONS'  ,{16,-MAX_31b,MAX_31b},...
                      'SEVENTEEN_POSITIONS',{17,-MAX_31b,MAX_31b},...
                      'EIGHTEEN_POSITIONS' ,{18,-MAX_31b,MAX_31b},...
                      'NINETEEN_POSITIONS' ,{19,-MAX_31b,MAX_31b},...
                      'TWENTY_POSITIONS'   ,{20,-MAX_31b,MAX_31b});
end

function [flag_params] = access_flags()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: access_flags()
% Goal    : Output a structure that contains all the flags parameters that
%           that can be used on the the TMCM-1160.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  flag_params = struct('ALL_FLAGS'     ,{0,-1,0},...
                       'TIMEOUT_FLAG'  ,{1,-1,0},...
                       'DEVIATION_FLAG',{3,-1,0});
end

function [isr_params] = access_interrupts()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: access_interrupts()
% Goal    : Output a structure that contains all the interrupt service
%           routines that can be used on the the TMCM-1160.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Constants of 2 power the number of bit
  MAX_31b = 2^31-1;

  isr_params = struct('TIMER_0'                ,{ 0,0,MAX_31b},...
                      'TIMER_1'                ,{ 1,0,MAX_31b},...
                      'TIMER_2'                ,{ 2,0,MAX_31b},...
                      'TARGET_POSITION_REACHED',{ 3,0,MAX_31b},...
                      'STALLGUARD_2'           ,{15,0,MAX_31b},...
                      'DEVIATION'              ,{21,0,MAX_31b},...
                      'STOP_LEFT'              ,{27,0,MAX_31b},...
                      'STOP_RIGHT'             ,{28,0,MAX_31b},...
                      'IN_0_CHANGE'            ,{39,0,MAX_31b},...
                      'IN_1_CHANGE'            ,{40,0,MAX_31b});
end

function [motion_params] = move_to_position()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: move_to_position()
% Goal    : Output a structure that contains the various ways of going from
%           an initial to a final position on the the TMCM-1160.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Constants of 2 power the number of bit
  MAX_31b = 2^31-1;

  motion_params = struct('ABSOLUTE'  ,{0,-MAX_31b,MAX_31b},...
                         'RELATIVE'  ,{1,-MAX_31b,MAX_31b},...
                         'COORDINATE',{2,0,20});
end

function [motion_params] = reference_search()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: reference_search()
% Goal    : Output a structure that contains all the operations search a
%           reference position on the the TMCM-1160.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  motion_params = struct('START' ,{0,-1,0},...
                         'STOP'  ,{1,-1,0},...
                         'STATUS',{2, 0,1});
end

function [ios_params] = access_ios()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: access_ios()
% Goal    : Output a structure that contains all the IOs that can be used
%           on the the TMCM-1160.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  ios_params = struct('IN_0',{0,0,1},...
                      'IN_1',{1,0,1});
end
