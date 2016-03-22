/**************************************************************************
 Program:  Read_tanf_mac.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Read TANF raw data files into SAS.

 Modifications:
**************************************************************************/

%macro Read_Tanf_mac( 
  rawfolder = &_dcdata_r_path\TANF\Raw,
  client = ,
  case = ,  
  year =,  
  month = ,
  corrections = ,
  revisions = New file.
);

  %local outlib;

  %if &_REMOTE_BATCH_SUBMIT %then %do;
    %note_mput( macro=Read_tanf_mac,
                msg=Remote batch submit session. Data set will be finalized and registered with metadata. )
    %let outlib=Tanf;
  %end;
  %else %do;
    %note_mput( macro=Read_tanf_mac,
                msg=Not remote batch submit session. Data set will NOT be finalized. )
    %let outlib=Work;
  %end;

  %Read_tanf_fs_master(
    outlib = &outlib,
    prefix = Tanf_,
    label = TANF,
    abbr = TANF,
    rawfolder = &rawfolder,
    client = &client, 
    case = &case,  
    year = &year,
    month = &month,
    corrections = &corrections,
    revisions = %str(&revisions)
  )

%mend Read_Tanf_mac;

