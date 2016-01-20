/**************************************************************************
 Program:  Read_Tanf_2009_07.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   
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
  year = 2009,
  month = 07,
  case = dhsaafx_2.txt,
  client = dhsaafx_1.txt
);


run;
