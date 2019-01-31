/**************************************************************************
 Program:  Upload_fs_2008_01.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   Liza Getsinger, Peter Tatian
 Created:  
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
  data = fs_2008_01, 
  revisions = %str(New file.) 
)

run;

endrsubmit;

signoff;
