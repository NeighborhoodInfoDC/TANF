/**************************************************************************
 Program:  Download_tanf_sum.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/19/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Download all TANF summary files from Alpha.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Tanf )

rsubmit;

proc download status=no
  inlib=Tanf 
  outlib=Tanf memtype=(data);
  select Tanf_sum_:;

run;

endrsubmit;

signoff;
