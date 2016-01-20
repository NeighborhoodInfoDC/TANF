/**************************************************************************
 Program:  Read_fs_mac.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Read Food Stamps raw data files into SAS.

 Modifications:
**************************************************************************/

%macro Read_fs_mac( 
  rawfolder = &_dcdata_path\TANF\Raw,
  client = DHSA0218FS.txt, 
  case = DHSA0216FS.txt,  
  year =,  
  month =,
  corrections=
);

  %Read_tanf_fs_master(
    prefix = Fs_,
    label = Food stamp,
    abbr = food stamps,
    rawfolder = &rawfolder,
    client = &client, 
    case = &case,  
    year = &year,
    month = &month,
	corrections= &corrections
  )

%mend Read_fs_mac;

