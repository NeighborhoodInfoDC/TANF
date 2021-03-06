/**************************************************************************
 Program:  Upload_fs_2013_01.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   
 Created:  
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register food stamp extract data set.

 Modifications: 10/30/09 LWG Uploaded with 2009_01 data
Modifications: 3/18/13 BJL Uploaded with 2013_01 data
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Tanf )

rsubmit;

%Upload_tanf_fs( 
  data = fs_2013_01, 
  revisions = %str(New file.) 
)

run;

endrsubmit;

signoff;
