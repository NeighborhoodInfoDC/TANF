/**************************************************************************
 Program:  Upload_tanf_yyyy_mm.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   E. Guernsey
 Created:  6/4/07
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
  data = tanf_2007_01, 
  revisions = %str(New file.) 
)

run;

endrsubmit;

signoff;
