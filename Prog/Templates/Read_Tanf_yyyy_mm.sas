/**************************************************************************
 Program:  Read_Tanf_yyyy_mm.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   
 Created:  
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
  year = ,    /** 4-digit year **/
  month = ,   /** 2-digit month **/
  case = ,    /** TANF case file (has af and 0216 in name) **/
  client =    /** TANF client file (has af and 0218 in name) **/
)

run;

