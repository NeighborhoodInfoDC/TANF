/**************************************************************************
 Program:  Sum_tr_mac.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/17/08
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to summarize TANF/FS data to tract-
 level.  Works with tracts for different years (1970-2000).

 Modifications:
  12/22/10 PAT Added MPRINT= parameter.
  10/12/12 PAT Updated for 2010 tracts. 
  03/21/16 PAT Updated for new SAS1 setup.
**************************************************************************/

%macro Sum_tr_mac(  
  finalize=N,
  revisions=,
  input_data=,
  sum_vars=,
  prefix=,
  label=,
  mprint=n
);

  %local sum_vars_wc outlib;

  %let sum_vars_wc = &prefix._: ;
  
  %if %mparam_is_yes( &finalize ) and not &_REMOTE_BATCH_SUBMIT %then %do; 
    %warn_mput( macro=Sum_tr_mac, msg=%str(Not a remote batch submit session. Finalize will be set to N.) )
    %let Finalize = N;
  %end;

  %if %mparam_is_yes( &finalize ) %then %let outlib = TANF;
  %else %let outlib = WORK;

  ** Combine all case/client files **;

  data _&prefix._all;

    set 
      &input_data;
    by filedate uicaseid;
    
    if first.uicaseid then &prefix._case = 1;
    
    ** For files before 2008, all tracts were 1980 def. **;
    
    if filedate_year < 2008 then tract_yr = 1980;
    
    label &prefix._case = "&label cases (families/households)";
   
    format &sum_vars ;
    
    keep uicaseid Tract_full Tract_yr filedate filedate_year &sum_vars;
      
  run;

  ** Create tract-level client summary by file date **;

  proc summary data=_&prefix._all nway;
    class Tract_yr Tract_full filedate;
    id filedate_year;
    var &sum_vars;
    output out=_&prefix._sum_tr_date sum=;

  run;

  ** Average together data for the same year **;

  proc summary data=_&prefix._sum_tr_date nway;
    class Tract_yr Tract_full;
    class filedate_year;
    var &sum_vars;
    output out=_&prefix._sum_tr_year mean=;
    format &sum_vars suppr5f.;

  run;

  ** Transpose data so individual vars by year **;

  %Super_transpose(  
    data=_&prefix._sum_tr_year,
    out=_&prefix._sum_tr,
    var=&sum_vars,
    id=filedate_year,
    by=Tract_yr Tract_full,
    mprint=&mprint
  )

  ** Prepare for transforming tracts **;

  data _&prefix._sum_tr70 (compress=no) _&prefix._sum_tr80 (compress=no) 
       _&prefix._sum_tr90 (compress=no) _&prefix._sum_tr00 (compress=no) 
       _&prefix._sum_tr10 (compress=no) 
       _&prefix._sum_notr (compress=no);

    set _&prefix._sum_tr;
    
    select ( tract_yr );
      when ( 1980 ) output _&prefix._sum_tr80;
      when ( 2000 ) output _&prefix._sum_tr00;
      when ( 1990 ) output _&prefix._sum_tr90;
      when ( 1970 ) output _&prefix._sum_tr70;
      when ( 2010 ) output _&prefix._sum_tr10;
      otherwise output _&prefix._sum_notr;
    end;

  run;
  
  ** Transform earlier tracts to 2000 def. **;

  %Transform_geo_data(
      dat_ds_name=_&prefix._sum_tr70,
      dat_org_geo=tract_full,
      dat_count_vars=&sum_vars_wc,
      wgt_ds_name=General.wt_tr70_tr00,
      wgt_org_geo=geo1970,
      wgt_new_geo=geo2000,
      wgt_wgt_var=popwt,
      out_ds_name=_&prefix._sum_tr70_tr00,
      mprint=&mprint
    )

  %Transform_geo_data(
      dat_ds_name=_&prefix._sum_tr80,
      dat_org_geo=tract_full,
      dat_count_vars=&sum_vars_wc,
      wgt_ds_name=General.wt_tr80_tr00,
      wgt_org_geo=geo1980,
      wgt_new_geo=geo2000,
      wgt_wgt_var=popwt,
      out_ds_name=_&prefix._sum_tr80_tr00,
      mprint=&mprint
    )

  %Transform_geo_data(
      dat_ds_name=_&prefix._sum_tr90,
      dat_org_geo=tract_full,
      dat_count_vars=&sum_vars_wc,
      wgt_ds_name=General.wt_tr90_tr00,
      wgt_org_geo=geo1990,
      wgt_new_geo=geo2000,
      wgt_wgt_var=popwt,
      out_ds_name=_&prefix._sum_tr90_tr00,
      mprint=&mprint
    )

  %Transform_geo_data(
      dat_ds_name=_&prefix._sum_tr10,
      dat_org_geo=tract_full,
      dat_count_vars=&sum_vars_wc,
      wgt_ds_name=General.wt_tr10_tr00,
      wgt_org_geo=geo2010,
      wgt_new_geo=geo2000,
      wgt_wgt_var=popwt,
      out_ds_name=_&prefix._sum_tr10_tr00,
      mprint=&mprint
    )

  run;

  ** Combine transformed tract data into single file **;

  data Tract_sums;

    set 
      _&prefix._sum_tr70_tr00 
      _&prefix._sum_tr80_tr00 
      _&prefix._sum_tr90_tr00 
      _&prefix._sum_tr10_tr00 
      _&prefix._sum_tr00 (rename=(tract_full=geo2000));
    
  run;

  proc summary data=Tract_sums nway completetypes;
    class geo2000 / preloadfmt;
    var &sum_vars_wc;
    output out=_&prefix._sum_tr00 sum=;
    format geo2000 $geo00a.;
  run;


  ** Recode missing values to zero (0) **;

  data &prefix._sum_tr00 (label="&label client/case summary, DC, Census tract (2000)" sortedby=geo2000);

    set _&prefix._sum_tr00;
    
    array a{*} &sum_vars_wc;
    
    do i = 1 to dim( a );
      if missing( a{i} ) then a{i} = 0;
    end;
    
    drop i _type_ _freq_;
    
  run;
  
  %File_info( data=&prefix._sum_tr00, printobs=0 )

  run;
  
  %** If final file, register with metadata **;
  
  /*%if %mparam_is_yes( &finalize ) %then %do;*/
  
    ** Finalize dataset **;

	%Finalize_data_set(
    data=&prefix._sum_tr00,
    out=&prefix._sum_tr00,
    outlib=tanf,
    label=:"&label client/case summary, DC, Census tract (2000)",
    sortby=geo2000,
    /** Metadata parameters **/
    revisions=%str(&revisions),
    /** File info parameters **/
    printobs=0
  )
    
  /*%end;*/
  
  run;

%mend Sum_tr_mac;


