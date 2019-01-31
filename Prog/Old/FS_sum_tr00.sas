/**************************************************************************
 Program:  FS_sum_tr00.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/18/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create 2000 tract-level summary indicators from 
 Food Stamp case/client data.

 Modifications:
  12/06/06 PAT Updated with new variables.
  06/06/07 EHG Updated with FS data from 01/01/2007
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

rsubmit;

%let input_data = 
  Tanf.FS_2000_07
  Tanf.FS_2001_01 Tanf.FS_2001_07 Tanf.FS_2002_01 Tanf.FS_2002_07 
  Tanf.FS_2003_01 Tanf.FS_2003_07 Tanf.FS_2004_01 Tanf.FS_2004_07 
  Tanf.FS_2005_01 Tanf.FS_2005_07 Tanf.FS_2006_01 Tanf.FS_2006_07
  Tanf.FS_2007_01;

%let sum_vars = 
  Fs_client Fs_fulpart Fs_unborn Fs_0to1 Fs_2to5 Fs_6to12
  Fs_13to17 Fs_child Fs_adult Fs_18to24 Fs_black Fs_white
  Fs_hisp Fs_asian Fs_oth_rac Fs_w_race Fs_adult_wht
  Fs_adult_blk Fs_adult_hsp Fs_adult_asn Fs_adult_oth
  Fs_adult_w_race Fs_child_wht Fs_child_blk Fs_child_hsp
  Fs_child_asn Fs_child_oth Fs_child_w_race Fs_unborn_wht
  Fs_unborn_blk Fs_unborn_hsp Fs_unborn_asn Fs_unborn_oth
  Fs_unborn_w_race Fs_0to1_wht Fs_0to1_blk Fs_0to1_hsp
  Fs_0to1_asn Fs_0to1_oth Fs_0to1_w_race Fs_6to12_wht
  Fs_6to12_blk Fs_6to12_hsp Fs_6to12_asn Fs_6to12_oth
  Fs_6to12_w_race Fs_13to17_wht Fs_13to17_blk Fs_13to17_hsp
  Fs_13to17_asn Fs_13to17_oth Fs_13to17_w_race Fs_2to5_wht
  Fs_2to5_blk Fs_2to5_hsp Fs_2to5_asn Fs_2to5_oth
  Fs_2to5_w_race Fs_18to24_wht Fs_18to24_blk Fs_18to24_hsp
  Fs_18to24_asn Fs_18to24_oth Fs_18to24_w_race Fs_case
  Fs_client_fsf Fs_client_fsm Fs_client_fcp Fs_client_fch
  Fs_client_fot Fs_case_fsf Fs_case_fsm Fs_case_fcp
  Fs_case_fch Fs_case_fot Fs_unborn_fsf Fs_unborn_fsm
  Fs_unborn_fcp Fs_unborn_fch Fs_unborn_fot Fs_child_fsf
  Fs_child_fsm Fs_child_fcp Fs_child_fch Fs_child_fot
  Fs_adult_fsf Fs_adult_fsm Fs_adult_fcp Fs_adult_fch
  Fs_adult_fot
;

%let sum_vars_wc = FS_: ;

** Combine all case/client files **;

data all_Tanf;

  set 
    &input_data;
  by filedate uicaseid;
  
  if first.uicaseid then FS_case = 1;
  
  label FS_case = "TANF cases (families/households)";
 
  format &sum_vars ;
  
  keep uicaseid geo1980 filedate filedate_year &sum_vars;
    
run;

** Create tract-level client summary by file date **;

proc summary data=all_Tanf nway;
  class geo1980 filedate;
  id filedate_year;
  var &sum_vars;
  output out=FS_sum_tr80_date sum=;

run;

** Average together data for the same year **;

proc summary data=FS_sum_tr80_date nway completetypes;
  class geo1980 / preloadfmt;
  class filedate_year;
  var &sum_vars;
  output out=FS_sum_tr80_year mean=;
  format geo1980 $geo80a. &sum_vars suppr5f.;

run;

** Transpose data so individual vars by year **;

%Super_transpose(  
  data=FS_sum_tr80_year,
  out=FS_sum_tr80,
  var=&sum_vars,
  id=filedate_year,
  by=geo1980,
  mprint=Y
)

** Convert 1980 tracts to 2000 tracts **;

%Transform_geo_data(
    dat_ds_name=FS_sum_tr80,
    dat_org_geo=geo1980,
    dat_count_vars=&sum_vars_wc,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_tr80_tr00,
    wgt_org_geo=geo1980,
    wgt_new_geo=geo2000,
    wgt_new_geo_fmt=$geo00a.,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=FS_sum_tr00,
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )
  
** Recode missing values to zero (0) **;

data Tanf.FS_sum_tr00 (label="Food Stamp client/case summary, DC, Census tract (2000)" sortedby=geo2000);

  set FS_sum_tr00;
  
  array a{*} &sum_vars_wc;
  
  do i = 1 to dim( a );
    if missing( a{i} ) then a{i} = 0;
  end;
  
  drop i;
  
run;

%File_info( data=Tanf.FS_sum_tr00, printobs=0 )

run;

endrsubmit;

signoff;

