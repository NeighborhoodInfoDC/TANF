/**************************************************************************
 Program:  Read_Tanf_2004_01.sas
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
  client=DATASET2,
  case=DATASET1,
  year =2004,
  month =01
);


run;
