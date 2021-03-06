/**************************************************************************
 Program:  Read_fs_2011_07.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  09/30/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read Food Stamp case & client raw files into SAS.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_fs_mac(
  year = 2012,
  month = 07,
  case = dhsa0218.fs201207.txt,
  client = dhsa0218.fs201207.txt
);

run;

