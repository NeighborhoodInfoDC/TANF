/**************************************************************************
 Program:  Read_Tanf_2008_01.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   L.Getsinger
 Created:  3/06/08
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read TANF case & client data from raw files into SAS.

 Modifications: LWG 9/19/08 Re-run program after makign modification to support mutiple tract year 
							rawfolder= E:\DCData\Libraries\TANF\Raw,
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

%Read_Tanf_mac(
  rawfolder= E:\DCData\Libraries\TANF\Raw,
  year = 2008,
  month = 01,
  case = DHSA0216AF.0208.txt,
  client = DHSA0218AF.0208.txt
);


run;
