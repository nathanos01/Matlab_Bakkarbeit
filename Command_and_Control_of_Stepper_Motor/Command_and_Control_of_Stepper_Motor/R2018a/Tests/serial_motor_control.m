%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script  : serial_motor_control
% Goal    : Send a sequence of commands to the TMCM-1160 motor board via
%           serial communication.
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables; clc;

% Mnemonic encoding in decimal for the commands numbers
MNEMONICS  = mnemonics_table();
% Mnemonic encoding in decimal for the available axis parameters
PARAMETERS = axis_parameters_table_r_w_e();

% Parameters of the serial communication
COM_PORT  = 'COM4';
BAUD_RATE = 115200;
PARITY    = 'none';
DATA_BITS = 8;
STOP_BIT  = 1;
% Parameters of the messages for the TMCM-1160
MODULE_ID = 1;
TYPE_ID   = 0;
MOTOR_ID  = 0;

% Clean serial instances
delete(instrfindall());
instrfind();
% Creation of the serial object
TMC_obj = serial(COM_PORT,'BaudRate',BAUD_RATE,'Parity'  ,PARITY,...
                          'Databits',DATA_BITS,'StopBits',STOP_BIT);
% Start the serial port session
fopen(TMC_obj);

% Sequence of messages sent over the serial port
send_serial_command(TMC_obj,MODULE_ID,MNEMONICS.ROR,TYPE_ID,MOTOR_ID,1500,1);
for i=1:50
  [error_code,error_msg,decoded_data] = send_serial_command(...
  TMC_obj,MODULE_ID,MNEMONICS.GAP,PARAMETERS(1).ACTUAL_POSITION,MOTOR_ID,0,1);
  disp(['Index: ' num2str(i) ', Actual position: ' num2str(decoded_data),...
        ', Error: ' num2str(error_code) ', ' error_msg]);
end
% Delete the error variables
clear error_code error_message;

[error_code(1),error_msg(1,:),~] = send_serial_command(TMC_obj,MODULE_ID,...
                                                       MNEMONICS.ROL,TYPE_ID,...
                                                       MOTOR_ID,2000,5);
[error_code(2),error_msg(2,:),~] = send_serial_command(TMC_obj,MODULE_ID,...
                                                       MNEMONICS.MST,TYPE_ID,...
                                                       MOTOR_ID,0);
[error_code(3),error_msg(3,:),~] = send_serial_command(TMC_obj,MODULE_ID,...
                                                       MNEMONICS.MVP,TYPE_ID,...
                                                       MOTOR_ID,2000,5);
[error_code(4),error_msg(4,:),~] = send_serial_command(TMC_obj,MODULE_ID,...
                                                       MNEMONICS.MST,TYPE_ID,...
                                                       MOTOR_ID,0);
if any(error_code ~= 0)
  disp(['The following error code was reported: ' num2str(error_code)]);
  disp(error_msg);
end

% End the serial port session
fclose(TMC_obj);
delete(TMC_obj);
