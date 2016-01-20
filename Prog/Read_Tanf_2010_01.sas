/**************************************************************************
 Program:  Read_Tanf_2010_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Rebecca Grace	
 Created:  12/17/2010
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read TANF case & client data from raw files into SAS.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_Tanf_mac(
  year = 2010,
  month = 01,
  case = DHSA0216.n201001x.txt,
  client = DHSA0218.n201001x.txt
);

run;

