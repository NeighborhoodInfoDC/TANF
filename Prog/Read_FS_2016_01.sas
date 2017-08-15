/**************************************************************************
 Program:  Read_fs_2016_01.sas
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
  month = 01,  
  case = DHSA0216.FS201601.csv,    
  client =  DHSA0218.FS201601.csv  
)

run;

