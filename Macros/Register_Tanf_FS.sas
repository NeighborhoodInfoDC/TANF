/**************************************************************************
 Program:  Register_Tanf_FS.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/25/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Autocall macro to upload and register TANF & FS data sets.

 Modifications:

04/17/14 - MW - Modified for the SAS1 Server and for registration in place of upload
**************************************************************************/

/** Macro Register_tanf_fs - Start Definition **/

%macro Register_tanf_fs( data=, lib=TANF, revisions=New file. );

  %if &data = %then %do;
    %err_mput( macro=Upload, msg=Parameter DATA= must be specified. )
    %goto exit;
  %end;

  /**proc upload status=no
  	inlib=&LIB
  	outlib=&LIB memtype=(data);
  	select &data;
  run;**/
  
  /**x "purge [dcdata.&lib..data]&data..*";**/
  
  %Dc_update_meta_file(
    ds_lib=&Lib,
    ds_name=&data,
    creator_process=Read_&data..sas,
    restrictions=Confidential,
    revisions=%str(&revisions)
  )
  
  %exit:
  
%mend Register_tanf_fs;

/** End Macro Definition **/

