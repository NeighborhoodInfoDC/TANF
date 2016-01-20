/**************************************************************************
 Program:  Read_fs_2009_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   L. Getsinger
 Created:  10/14/09
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read Food Stamp case & client raw files into SAS.

 Modifications: LWG 10/30/09 
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_fs_mac(
  rawfolder= E:\DCData\Libraries\TANF\Raw,
  year = 2009,
  month = 01,
  case = AUDIT1.TXT,
  client = AUDIT3.TXT,
  corrections=if caseid=00504411 then delete;
);

run;

