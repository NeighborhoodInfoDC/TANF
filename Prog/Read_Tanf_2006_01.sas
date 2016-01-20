/**************************************************************************
 Program:  Read_Tanf_2006_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/24/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Read TANF case & client data from raw files into SAS.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_Tanf_mac(
  rawfolder=D:\DCData\Libraries\TANF\Raw,
  client=DHSA0218_AF200601.txt,
  case=DHSA0216_AF200601.txt,
  year =2006,
  month =01
);


run;
