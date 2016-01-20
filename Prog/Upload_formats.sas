/**************************************************************************
 Program:  Upload_formats.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/25/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Upload format catalog to Alpha.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( TANF )

rsubmit;

proc upload status=no
  inlib=TANF 
  outlib=TANF memtype=(catalog);
  select formats;

proc catalog catalog=Tanf.formats;
  contents;

quit;

run;

endrsubmit;

signoff;
