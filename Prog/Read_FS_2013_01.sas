/**************************************************************************
 Program:  Read_fs_2013_01.sas
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
  year = 2013,
  month = 01,
  case = dhsa0216.fs.n030513.txt,
  client = dhsa0218fs.n030513.txt
);

run;

