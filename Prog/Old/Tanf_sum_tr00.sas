/**************************************************************************
 Program:  Tanf_sum_tr00.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/27/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create 2000 tract-level summary indicators from TANF
 case/client data.

 Modifications:
  12/06/06 PAT Updated with new variables.
  12/18/06 PAT Added Tanf_client Tanf_fulpart Tanf_unborn Tanf_0to1 
               Tanf_2to5 Tanf_6to12 Tanf_13to17 Tanf_child Tanf_adult 
               Tanf_18to24.
  08/27/06 PAT Updated with Tanf_2006_07.
  06/04/07 EHG Updated with Tanf_2007_01.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( TANF )

rsubmit;

%let input_data = 
  Tanf.Tanf_1998_01 Tanf.Tanf_1998_07 Tanf.Tanf_1999_07 Tanf.Tanf_2000_07 
  Tanf.Tanf_2001_01 Tanf.Tanf_2001_07 Tanf.Tanf_2002_01 Tanf.Tanf_2002_07 
  Tanf.Tanf_2003_01 Tanf.Tanf_2003_07 Tanf.Tanf_2004_01 Tanf.Tanf_2004_07 
  Tanf.Tanf_2005_01 Tanf.Tanf_2005_07 Tanf.Tanf_2006_01 Tanf.Tanf_2006_07 
  Tanf.Tanf_2007_01;

%let sum_vars = 
  Tanf_client Tanf_fulpart Tanf_unborn Tanf_0to1 Tanf_2to5
  Tanf_6to12 Tanf_13to17 Tanf_child Tanf_adult Tanf_18to24
  Tanf_black Tanf_white Tanf_hisp Tanf_asian Tanf_oth_rac
  Tanf_w_race Tanf_adult_wht Tanf_adult_blk Tanf_adult_hsp
  Tanf_adult_asn Tanf_adult_oth Tanf_adult_w_race
  Tanf_child_wht Tanf_child_blk Tanf_child_hsp Tanf_child_asn
  Tanf_child_oth Tanf_child_w_race Tanf_unborn_wht
  Tanf_unborn_blk Tanf_unborn_hsp Tanf_unborn_asn
  Tanf_unborn_oth Tanf_unborn_w_race Tanf_0to1_wht
  Tanf_0to1_blk Tanf_0to1_hsp Tanf_0to1_asn Tanf_0to1_oth
  Tanf_0to1_w_race Tanf_6to12_wht Tanf_6to12_blk
  Tanf_6to12_hsp Tanf_6to12_asn Tanf_6to12_oth
  Tanf_6to12_w_race Tanf_13to17_wht Tanf_13to17_blk
  Tanf_13to17_hsp Tanf_13to17_asn Tanf_13to17_oth
  Tanf_13to17_w_race Tanf_2to5_wht Tanf_2to5_blk Tanf_2to5_hsp
  Tanf_2to5_asn Tanf_2to5_oth Tanf_2to5_w_race Tanf_18to24_wht
  Tanf_18to24_blk Tanf_18to24_hsp Tanf_18to24_asn
  Tanf_18to24_oth Tanf_18to24_w_race Tanf_case Tanf_client_fsf
  Tanf_client_fsm Tanf_client_fcp Tanf_client_fch
  Tanf_client_fot Tanf_case_fsf Tanf_case_fsm Tanf_case_fcp
  Tanf_case_fch Tanf_case_fot Tanf_unborn_fsf Tanf_unborn_fsm
  Tanf_unborn_fcp Tanf_unborn_fch Tanf_unborn_fot
  Tanf_child_fsf Tanf_child_fsm Tanf_child_fcp Tanf_child_fch
  Tanf_child_fot Tanf_adult_fsf Tanf_adult_fsm Tanf_adult_fcp
  Tanf_adult_fch Tanf_adult_fot       
;

%let sum_vars_wc = Tanf_: ;

** Combine all case/client files **;

%Push_option( compress )

options compress=no;

data all_Tanf;

  set 
    &input_data;
  by filedate uicaseid;
  
  if first.uicaseid then Tanf_case = 1;
  
  label Tanf_case = "TANF cases (families/households)";
 
  format &sum_vars ;
  
  keep uicaseid geo1980 filedate filedate_year &sum_vars;
    
run;

** Create tract-level client summary by file date **;

proc summary data=all_Tanf nway;
  class geo1980 filedate;
  id filedate_year;
  var &sum_vars;
  output out=Tanf_sum_tr80_date sum=;

run;

** Average together data for the same year **;

proc summary data=Tanf_sum_tr80_date nway completetypes;
  class geo1980 / preloadfmt;
  class filedate_year;
  var &sum_vars;
  output out=Tanf_sum_tr80_year mean=;
  format geo1980 $geo80a. &sum_vars suppr5f.;

run;

** Transpose data so individual vars by year **;

%Super_transpose(  
  data=Tanf_sum_tr80_year,
  out=Tanf_sum_tr80,
  var=&sum_vars,
  id=filedate_year,
  by=geo1980,
  mprint=Y
)

** Convert 1980 tracts to 2000 tracts **;

%Transform_geo_data(
    dat_ds_name=Tanf_sum_tr80,
    dat_org_geo=geo1980,
    dat_count_vars=&sum_vars_wc,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_tr80_tr00,
    wgt_org_geo=geo1980,
    wgt_new_geo=geo2000,
    wgt_new_geo_fmt=$geo00a.,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=Tanf_sum_tr00,
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )
  
** Recode missing values to zero (0) **;

%Pop_option( compress )

data Tanf.Tanf_sum_tr00 (label="TANF client/case summary, DC, Census tract (2000)" sortedby=geo2000);

  set Tanf_sum_tr00;
  
  array a{*} &sum_vars_wc;
  
  do i = 1 to dim( a );
    if missing( a{i} ) then a{i} = 0;
  end;
  
  drop i;
  
run;

x "purge [dcdata.tanf.data]Tanf_sum_tr00.*";

%File_info( data=Tanf.Tanf_sum_tr00, printobs=0 )

run;

endrsubmit;

signoff;

