/**************************************************************************
 Program:  Read_Tanf_yyyy_mm.sas
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
  year = 2015,    /** 4-digit year **/
  month = 01,   /** 2-digit month **/
  case = dhsa0216 af201501.txt,    /** TANF case file (has af and 0216 in name) **/
  client = dhsa0218 af201501.txt   /** TANF client file (has af and 0218 in name) **/
)

run;

