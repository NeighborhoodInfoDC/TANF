/**************************************************************************
 Program:  Read_Tanf_2005_07.sas
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
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_Tanf_mac(
  rawfolder=&_dcdata_path\TANF\Raw,
  client=DHSA0218.AF200507.txt,
  case=DHSA0216.AF200507.txt,
  year =2005,
  month =07
);


run;
