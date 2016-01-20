/**************************************************************************
 Program:  Temp.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/17/08
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Tanf )

** Start submitting commands to remote server **;

rsubmit;

proc upload status=no
  inlib=Tanf 
  outlib=Tanf memtype=(data);
  select Fs_2008_01;


run;

endrsubmit;

** End submitting commands to remote server **;




run;

signoff;
