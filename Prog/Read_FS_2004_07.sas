/**************************************************************************
 Program:  Read_Tanf_2004_07.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/24/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Read food stamp case & client from raw files into SAS.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_fs_mac(
  rawfolder=D:\DCData\Libraries\TANF\Raw,
  client=DHSA0218_FS200407.txt,
  case=DHSA0216_FS200407.txt,
  year =2004,
  month =07
);


run;
