/**************************************************************************
 Program:  Read_Tanf_2007_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   E. Guernsey
 Created:  5/16/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read TANF case & client data from raw files into SAS.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_Tanf_mac(
  year=2007,
  month=01,
  case=urban1.txt,
  client=urban3.txt
)


run;


