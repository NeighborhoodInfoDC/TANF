/**************************************************************************
 Program:  Read_fs_2011_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   R Grace
 Created:  03/07/2011
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read Food Stamp case & client raw files into SAS.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_fs_mac(
  year = 2011,
  month = 01,
  case =DHSA0216.fs.n0211.txt,
  client= DHSA0218.fs.n0211.txt
);

run;

