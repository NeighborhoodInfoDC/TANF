************************************************************************
* Program:  Child_2004_07.sas
* Library:  Tanf
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  10/19/04
* Version:  SAS 8.2
* Environment:  Windows
* 
* Description:  Number of TANF/Food Stamp child recips. for July 2004.
*
* Modifications:
*  10/22/04  Excluded PIs from TANF kids (consistent w/IMA def.)  PT
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Tanf )
%DCData_lib( General )

%Concat_lib( libname=ncdb2000, path=D:\Data\NCDB2000\Data )

%Data_to_format( FmtName=$Remap, InDS=Tanf.dcconv1980,
  value=TRACT_DC, label=geo80, otherlabel="MISSING", print=n )

data Tanf_tracts;

  merge Tanf.TANFcase200407 (in=in1) Tanf.TANFclie200407;
    by caseid;

  if in1;

  length geo1980 $ 11;
  
  geo1980 = put( tract_dc, $remap. );

run;

proc summary data=Tanf_tracts nway;
  where '01jul2004'd - dob < ( 365.25 * 18 ) and relcode ~= "PI";
  class geo1980;
  output out=Tanf_sum (rename=(_freq_=Tanf_child) drop=_type_);
run;

proc print data=Tanf_sum;
  sum Tanf_child;


data Fstamps_tracts;

  merge Tanf.tanf_2004_07_case (in=in1) Tanf.tanf_2004_07_client;
    by caseid;

  if in1;

  length geo1980 $ 11;
  
  geo1980 = put( tract_dc, $remap. );

run;

proc summary data=Fstamps_tracts nway;
  where '01jul2004'd - dob < ( 365.25 * 18 );
  class geo1980;
  output out=Fstamps_sum (rename=(_freq_=Fstamps_child) drop=_type_);
run;

proc print data=Fstamps_sum;
  sum Fstamps_child;


data tanf_fstamps;

  merge
    tanf_sum
    fstamps_sum;
  by geo1980;  
  
  if tanf_child = . then tanf_child = 0;
  if fstamps_child = . then fstamps_child = 0;
  
run;

proc print data=Tanf_Fstamps;
  sum Tanf_child Fstamps_child;


%Transform_geo_data(
    dat_ds_name = Tanf_fstamps,
    dat_org_geo = geo1980,
    dat_count_vars = Tanf_child Fstamps_child,
    dat_prop_vars  = ,
    calc_vars = ,
    calc_vars_labels = ,
    wgt_ds_name = Ncdb2000.twt80_00,
    wgt_org_geo = geo80,
    wgt_new_geo = geo00,
    wgt_id_vars = ,
    wgt_wgt_var = weight,
    out_ds_name = Tanf_fstamps_tr00,
    out_ds_label = ,
    show_warnings = 10 ,
    keep_nonmatch = Y ,
    print_diag = Y ,
    full_diag = N
  )

proc print data=Tanf_Fstamps_tr00;
  sum Tanf_child Fstamps_child;

%Transform_geo_data(
    dat_ds_name = Tanf_fstamps_tr00,
    dat_org_geo = geo00,
    dat_count_vars = Tanf_child Fstamps_child,
    dat_prop_vars  = ,
    calc_vars = ,
    calc_vars_labels = ,
    wgt_ds_name = General.tr00_wd01,
    wgt_org_geo = geo2000,
    wgt_new_geo = ward2001,
    wgt_id_vars = ,
    wgt_wgt_var = pop_wgt,
    out_ds_name = Tanf.Tanf_fstamps_wd01,
    out_ds_label = ,
    show_warnings = 10 ,
    keep_nonmatch = Y ,
    print_diag = Y ,
    full_diag = N
  )

proc print data=Tanf.Tanf_fstamps_wd01;
  sum Tanf_child Fstamps_child;

