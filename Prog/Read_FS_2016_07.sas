/**************************************************************************
 Program:  Read_fs_2016_07.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Noah Strayer
 Created:  6/26/2017
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Read SNAP (food stamp) case & client raw files into SAS.

 Modifications:
 04/24/14 MSW Modified for the SAS1 Server
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF )


*--- EDIT PARAMETERS BELOW -----------------------------------------;

%Read_fs_mac(
  year = 2016,   
  month = 07,   
  case = DHSA0216.FS201607.csv,   
  client =  DHSA0218.FS201607.csv 
)

run;

