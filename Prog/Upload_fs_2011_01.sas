/**************************************************************************
 Program:  Upload_fs_2011_01.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   R Grace		
 Created:  03/08/2011
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register food stamp extract data set.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Tanf )

rsubmit;

%Upload_tanf_fs( 
  data = fs_2011_01, 
  revisions = %str(Fixed problem caused by missing client record.) 
)

run;

endrsubmit;

signoff;
