/**************************************************************************
 Program:  Read_Tanf_2014_07.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Jay Dev
 Created:  04/15/16
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Read TANF case & client data from raw files into SAS.

 Modifications:
 04/24/14 MSW Modified for SAS1 Server
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF )


*--- EDIT PARAMETERS BELOW -----------------------------------------;

%Read_Tanf_mac(
  year = 2014,
  month = 07, 
  case = dhsa0216 af201407.txt, 
  client = dhsa0218 af201407.txt 
)

run;

