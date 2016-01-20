/**************************************************************************
 Program:  Read_fs_2006_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Read Food Stamp case & client raw files into SAS.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_fs_mac(
  rawfolder=D:\DCData\Libraries\Tanf\Raw,
  client=DHSA0218_FS200601.txt,
  case=DHSA0216_FS200601.txt,
  year =2006,
  month =01
);


run;
