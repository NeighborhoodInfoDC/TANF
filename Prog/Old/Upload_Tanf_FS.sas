/**************************************************************************
 Program:  Upload_Tanf_FS.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/25/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register TANF & FS data sets.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Tanf )

rsubmit;

/** Macro Upload - Start Definition **/

%macro Upload( data=, revisions=Updated file format. );

  %if &data = %then %do;
    %err_mput( macro=Upload, msg=Parameter DATA= must be specified. )
    %goto exit;
  %end;

  proc upload status=no
  	inlib=TANF
  	outlib=TANF memtype=(data);
  	select &data;
  run;
  
  x "purge [dcdata.tanf.data]&data..*";
  
  %Dc_update_meta_file(
    ds_lib=Tanf,
    ds_name=&data,
    creator_process=Read_&data..sas,
    restrictions=Confidential,
    revisions=%str(&revisions)
  )
  
  %exit:
  
%mend Upload;

/** End Macro Definition **/


** Upload files **;

%Upload( data=fs_2000_07 )
%Upload( data=fs_2001_01 )
%Upload( data=fs_2001_07 )
%Upload( data=fs_2002_01 )
%Upload( data=fs_2002_07 )
%Upload( data=fs_2003_01 )
%Upload( data=fs_2003_07 )
%Upload( data=fs_2004_01 )
%Upload( data=fs_2004_07 )
%Upload( data=fs_2005_01 )
%Upload( data=fs_2005_07 )
%Upload( data=fs_2006_01 )
%Upload( data=fs_2006_07 )

%Upload( data=tanf_1998_01 )
%Upload( data=tanf_1998_07 )
%Upload( data=tanf_1999_07 )
%Upload( data=tanf_2000_07 )
%Upload( data=tanf_2001_01 )
%Upload( data=tanf_2001_07 )
%Upload( data=tanf_2002_01 )
%Upload( data=tanf_2002_07 )
%Upload( data=tanf_2003_01 )
%Upload( data=tanf_2003_07 )
%Upload( data=tanf_2004_01 )
%Upload( data=tanf_2004_07 )
%Upload( data=tanf_2005_01 )
%Upload( data=tanf_2005_07 )
%Upload( data=tanf_2006_01 )
%Upload( data=tanf_2006_07 )

run;

endrsubmit;

signoff;
