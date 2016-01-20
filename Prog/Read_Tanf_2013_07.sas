/**************************************************************************
 Program:  Read_Tanf_yyyy_mm.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Maia Woluchem
 Created:  04/17/14
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read TANF case & client data from raw files into SAS.

 Modifications:

 04/17/14 - MW - Modified for SAS1 Server
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF, local=n )

%Read_Tanf_mac(
  year = 2013,
  month = 07,
  case = DHSA0216.af201307.txt,
  client = DHSA0218.af201307.txt
);


run;
