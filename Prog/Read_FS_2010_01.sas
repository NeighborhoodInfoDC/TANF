/**************************************************************************
 Program:  Read_fs_2010_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Rebecca Grace	
 Created:  12/20/10
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read Food Stamp case & client raw files into SAS.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_fs_mac(
  year = 2010,
  month = 01,
  case = DHSA0216.n201001y.txt,
  client = DHSA0218.n201001y.txt
);

run;

