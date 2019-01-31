/**************************************************************************
 Program:  Read_fs_2010_07.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   
 Created:  
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read Food Stamp case & client raw files into SAS.

 Modifications: LWG 10/30/2009
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_fs_mac(
  rawfolder= E:\DCData\Libraries\TANF\Raw,
  year = 2010,
  month = 07,
  case = dhsa0216-fs1110.txt,
  client = dhsa0218-fs1110.TXT
);

run;

