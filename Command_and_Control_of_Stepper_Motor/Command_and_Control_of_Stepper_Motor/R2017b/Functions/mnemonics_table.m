function [commands] = mnemonics_table()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: mnemonics_table()
% Goal    : Output a structure that contains all the available mnemonics
%           that can be sent to the TMCM-1160.
%
% Structure fields:
% +----------------------------+
% |Mnemonic name,Command number|
% +----------------------------+
%
% IN      : -
% IN/OUT  : -
% OUT     : - commands: list of all available commands for the TMCM-1160 
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Mnemonic encoding in decimal for the command number
  commands = struct('ROR'  , 1,...
                    'ROL'  , 2,...
                    'MST'  , 3,...
                    'MVP'  , 4,...
                    'SAP'  , 5,...
                    'GAP'  , 6,...
                    'STAP' , 7,...
                    'RSAP' , 8,...
                    'SGP'  , 9,...
                    'GGP'  ,10,...
                    'STGP' ,11,...
                    'RSGP' ,12,...
                    'RFS'  ,13,...
                    'SIO'  ,14,...
                    'GIO'  ,15,...
                    'CALC' ,19,...
                    'COMP' ,20,...
                    'JC'   ,21,...
                    'JA'   ,22,...
                    'CSUB' ,23,...
                    'RSUB' ,24,...
                    'EI'   ,25,...
                    'DI'   ,26,...
                    'WAIT' ,27,...
                    'STOP' ,28,...
                    'SCO'  ,30,...
                    'GCO'  ,31,...
                    'CCO'  ,32,...
                    'CALCX',33,...
                    'AAP'  ,34,...
                    'AGP'  ,35,...
                    'CLE'  ,36,...
                    'VECT' ,37,...
                    'RETI' ,38,...
                    'ACO'  ,39,...
                    'UF0'  ,64,...
                    'UF_1' ,65,...
                    'UF_2' ,66,...
                    'UF_3' ,67,...
                    'UF_4' ,68,...
                    'UF_5' ,69,...
                    'UF_6' ,70,...
                    'UF_7' ,71);
end
