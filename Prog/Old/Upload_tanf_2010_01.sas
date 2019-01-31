/**************************************************************************
 Program:  Upload_tanf_2010_01.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   Rebecca Grace
 Created:  12/20/2010
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register TANF extract data set.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Tanf )

rsubmit;

%Upload_tanf_fs( 
  data = tanf_2010_01, 
  revisions = %str(New file.) 
)

run;

endrsubmit;

signoff;
