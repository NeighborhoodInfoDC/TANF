/**************************************************************************
 Program:  Download_tanf_formats.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/30/07
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Download format catalog from Alpha TANF library.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Tanf )

** Start submitting commands to remote server **;

rsubmit;

proc download status=no
  inlib=Tanf 
  outlib=Tanf memtype=(catalog);
  select formats;

run;

endrsubmit;

** End submitting commands to remote server **;

proc catalog catalog=Tanf.formats;
  contents;
quit;

run;

signoff;
