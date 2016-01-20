/**************************************************************************
 Program:  Read_Tanf_2011_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Rebecca Grace	
 Created:  03/01/2011
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
  month = 01,
  case = DHSA0216.af.n0211.txt,
  client = DHSA0218.af.n0211.txt
);

run;

