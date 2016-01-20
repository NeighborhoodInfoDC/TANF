/**************************************************************************
 Program:  Download_tanf_archive.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/25/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Download all TANF & FS data sets to archive.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Tanf )

libname archive 'D:\DCData\Libraries\TANF\Data\Archive';

rsubmit;

proc download status=no
  inlib=Tanf 
  outlib=Archive memtype=(data);
  select Tanf_: Fs_:;

run;

endrsubmit;

signoff;
