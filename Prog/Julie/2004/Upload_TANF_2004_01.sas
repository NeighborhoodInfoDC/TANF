/**************************************************************************
 Program:  Upload_TANF_2004_01
 Library:  TANF
 Project:  DC Data Warehouse
 Author:   Julie Fenderson	
 Created:  March 21, 2005
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description: Uploading TANF datasets and formats to Alpha 

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( TANF )

rsubmit;

proc upload status=no
	inlib=TANF
	outlib=TANF memtype=(data);
	select tanf_2004_01;
run;


proc upload status=no
	inlib=TANF
	outlib=TANF memtype=(catalog);
	select formats;
	
run;

%Dc_update_meta_file(
  ds_lib=Tanf,
  ds_name=Tanf_2004_01,
  creator_process=Tanf_2004_01.sas,
  restrictions=Confidential,
  revisions=Initial file creation.
);

endrsubmit;

signoff;
