/**************************************************************************
 Program:  Read_Tanf_yyyy_mm.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Noah Strayer
 Created:  6/26/2017
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
  year = ,    /** 2015 **/
  month = ,   /** 07 **/
  case = ,    /** DHSA0216.AF201507.csv **/
  client =    /** DHSA0218.AF201507.csv **/
)

run;

