/**************************************************************************
 Program:  Read_Tanf_2011_07.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  09/30/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read TANF case & client data from raw files into SAS.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_Tanf_mac(
  year = 2011,
  month = 07,
  case = dhsa0216.af.0711.txt,
  client = dhsa0218.af.0711.txt
);


run;
