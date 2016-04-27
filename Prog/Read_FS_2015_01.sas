/**************************************************************************
 Program:  Read_fs_yyyy_mm.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Jay Dev
 Created:  04/15/16
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
  year = 2015,    /** 4-digit year **/
  month = 01,   /** 2-digit month **/
  case = dhsa0216 fs201501.txt,    /** SNAP case file (has fs and 0216 in name) **/
  client = dhsa0218 fs201501.txt   /** SNAP client file (has fs and 0218 in name) **/
)

run;

