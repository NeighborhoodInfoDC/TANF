/**************************************************************************
 Program:  Upload_dcconv1980.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  10/03/11
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register file containing tract ID conversion
 crosswalk for TANF/FS data from DC IMA.

 Data set is used in creating the $TREMAP format.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( TANF )

** Start submitting commands to remote server **;

rsubmit;

** Upload data set **;

proc upload status=no
  data=TANF.dcconv1980 
  out=dcconv1980;
run;

** Add data set and variable labels **;

proc datasets library=Work memtype=(data) nolist;
  modify dcconv1980 (label="1980 census tract ID conversion crosswalk for TANF/FS records");
  label 
    NAME80 = '1980 tract ID'
    PSEUDOCT = 'Pseudo-census tract flag'
    TRACT_DC = '1980 census tract ID in IMA TANF/FS records'
    geo80 = 'Full census tract ID (1980): ssccctttttt';
quit;

** Copy data set to TANF library **;

proc copy in=Work out=TANF memtype=(data);
  select dcconv1980;
run;

%File_info( data=tanf.dcconv1980, stats=, printobs=200, freqvars=pseudoct )

** Register with metadata **;

%Dc_update_meta_file(
  ds_lib=TANF,
  ds_name=dcconv1980,
  creator_process=Unknown,
  restrictions=None,
  revisions=%str(New file.)
)

run;

endrsubmit;

** End submitting commands to remote server **;

run;

signoff;
