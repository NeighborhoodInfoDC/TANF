/**************************************************************************
 Program:  Read_fs_2009_07.sas
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
  year = 2009,
  month = 07,
  case = AUDIT2.TXT,
  client = AUDIT4.TXT
);

run;

