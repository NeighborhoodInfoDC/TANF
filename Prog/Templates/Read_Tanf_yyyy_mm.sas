/**************************************************************************
 Program:  Read_Tanf_yyyy_mm.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   
 Created:  
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read TANF case & client data from raw files into SAS.

 Modifications:
 04/24/14 MSW Modified for SAS1 Server
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF, local=n )

%Read_Tanf_mac(
  year = yyyy,
  month = mm,
  case = DHSA0216AF.txt,
  client = DHSA0218AF.txt
);


run;
