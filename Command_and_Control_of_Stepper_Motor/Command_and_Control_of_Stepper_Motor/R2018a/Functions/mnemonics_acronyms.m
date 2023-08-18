function acronym = mnemonics_acronyms(index)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: mnemonics_acronyms()
% Goal    : Output the selected mnemonics based on the list of all
%           available commands for the TMCM-1160 (same order as in the
%           function "mnemonics_table()").
%
% IN      : - index  : mnemonic encoding in decimal for the command number
% IN/OUT  : -
% OUT     : - acronym: real mnemonic name 
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  acronyms = {'ROR' ,'ROL' ,'MST' ,'MVP' ,'SAP' ,'GAP' ,'STAP',...
              'RSAP','SGP' ,'GGP' ,'STGP','RSGP','RFS' ,'SIO' ,...
              'GIO' ,'CALC','COMP','JC'  ,'JA'  ,'CSUB','RSUB',...
              'EI'  ,'DI'  ,'WAIT','STOP','SCO' ,'GCO' ,'CCO' ,...
              'CALCX','AAP','AGP' ,'CLE' ,'VECT','RETI','ACO' ,...
              'UF0' ,'UF1' ,'UF2' ,'UF3' ,'UF4' ,'UF5' ,'UF6' ,'UF7'};

  acronym = acronyms(index);
end
