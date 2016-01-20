/**************************************************************************
 Program:  Print_tremap_format.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  10/12/12
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Print contents of $tremap format.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Tanf )

** Start submitting commands to remote server **;

rsubmit;

proc format library=Tanf fmtlib;
  select $tremap;
run;


run;

endrsubmit;

** End submitting commands to remote server **;


signoff;
