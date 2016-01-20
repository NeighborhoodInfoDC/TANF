/**************************************************************************
 Program:  Read_fs_2008_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Liza Getsinger, Peter Tatian
 Created:  9/28/08
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read Food Stamp case & client raw files into SAS.

 Modifications:  Added "rawfolder= E:\DCData\Libraries\TANF\Raw"
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_fs_mac(
  rawfolder= E:\DCData\Libraries\TANF\Raw,
  year = 2008,
  month = 01,
  case = DHSA0216FS.0208.txt,
  client = DHSA0218FS.0208.txt
);

run;

