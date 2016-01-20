/**************************************************************************
 Program:  Read_Tanf_yyyy_mm.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Maia Woluchem
 Created:  4/24/14
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read TANF case & client data from raw files into SAS.

 Modifications: Modified for the SAS1 Server
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF, local=n )

%Read_Tanf_mac(
  year = 2014,
  month = 01,
  case = DHSA0216.AF201401.txt,
  client = DHSA0218.AF201401.txt
);


run;
