/**************************************************************************
 Program:  Read_fs_2007_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   E. Guernsey
 Created:  06/04/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read Food Stamp case & client raw files into SAS.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )
%Read_fs_mac(
  year = 2007,
  month = 01,
  case = urban2.txt,
  client = urban4.txt,
  corrections= if uicaseid=10059 and uiclientid=7 then pi=0;
    if uicaseid=39669 and uiclientid=3 then pi=0;
);

run;

