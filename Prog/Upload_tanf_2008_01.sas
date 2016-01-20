/**************************************************************************
 Program:  Upload_tanf_2008_01.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   L. Getsinger
 Created:  3/10/08
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register TANF extract data set.

 Modifications: 09/19/08 LWG Updated with Tanf_2008_01.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Tanf )

rsubmit;

%Upload_tanf_fs( 
  data = tanf_2008_01, 
  revisions = %str(Added support for multiple tract years.) 
)

run;

endrsubmit;

signoff;
