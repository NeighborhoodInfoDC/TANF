/**************************************************************************
 Program:  Read_tanf_mac.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Read TANF raw data files into SAS.

 Modifications:
**************************************************************************/

%macro Read_Tanf_mac( 
  rawfolder = &_dcdata_path\TANF\Raw,
  client = ,
  case = ,  
  year =,  
  month = ,
  corrections = 
);

  %Read_tanf_fs_master(
    prefix = Tanf_,
    label = TANF,
    abbr = TANF,
    rawfolder = &rawfolder,
    client = &client, 
    case = &case,  
    year = &year,
    month = &month
  )

%mend Read_Tanf_mac;

