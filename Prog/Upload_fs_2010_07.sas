/**************************************************************************
 Program:  Upload_fs_2010_01.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   Peter Tatian
 Created:  12/22/2010
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
  data = fs_2010_07, 
  revisions = %str(Corrected tract problem.) 
)

run;

endrsubmit;

signoff;
