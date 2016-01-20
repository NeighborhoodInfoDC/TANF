/**************************************************************************
 Program:  Read_Tanf_2010_07.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   KF
 Created:  
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read TANF case & client data from raw files into SAS.

 Modifications: LWG 10/15/09
**************************************************************************/
%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_Tanf_mac(
  rawfolder= E:\DCData\Libraries\TANF\Raw,
  year = 2010,
  month = 07,
  case = dhsa0216-af1110.txt,
  client = dhsa0218-af1110.txt
);


run;
