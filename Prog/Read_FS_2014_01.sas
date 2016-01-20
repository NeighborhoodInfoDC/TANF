/**************************************************************************
 Program:  Read_fs_yyyy_mm.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Maia Woluchem
 Created:  04/24/14
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read Food Stamp case & client raw files into SAS.

 Modifications:
 04/24/14 MSW Modified for the SAS1 Server
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF, local=n )

%Read_fs_mac(
  year = 2014,
  month = 01,
  case = DHSA0216.FS201401.txt,
  client = DHSA0218.FS201401.txt
);

run;

