filename uiautos "K:\Metro\PTatian\UISUG\Uiautos";
options sasautos=(uiautos sasautos);
libname General "D:\DCData\Libraries\TANF\Data\Weighting";
libname TANF "d:\DCData\Libraries\TANF\Data" ;
*Equation used for calc_vars Percent=(no_kid_0307 - No_kid_0207) / no_kid_0207*;
** City total **;

%Transform_geo_data(
    dat_ds_name = TANF.Issue_scan_04_health_jf_tr00,
    dat_org_geo = geo2000,
    dat_count_vars = ADULT_2004_07 FULPART_2004_07 INFANT_2004_07 
	No_kids_2004_07 PI_2004_07 PRETEEN_2004_07  TEEN_2004_07 TODD_2004_07 
	UNBORN_2004_07 hh_2004_07,
    calc_vars = , 
    calc_vars_labels = , 
    wgt_ds_name = General.Tr00_city,
    wgt_org_geo = geo2000,
    wgt_new_geo = city,
    wgt_wgt_var = pop_wgt,
    out_ds_name = TANF.Issue_scan_04_health_jf_city,
    out_ds_label = Issue Scan 2004 indicators for health by JF - city total
  );

** East of the River **;

%Transform_geo_data(
    show_warnings = 0,
    print_diag = N,
    dat_ds_name = TANF.Issue_scan_04_health_jf_tr00,
    dat_org_geo = geo2000,
    dat_count_vars = ADULT_2004_07 FULPART_2004_07 INFANT_2004_07 
	No_kids_2004_07 PI_2004_07 PRETEEN_2004_07  TEEN_2004_07 TODD_2004_07 
	UNBORN_2004_07 hh_2004_07,
    calc_vars = ,
    calc_vars_labels = ,
    wgt_ds_name = General.Tr00_eor,
    wgt_org_geo = geo2000,
    wgt_new_geo = eor2000,
    wgt_wgt_var = pop_wgt,
    out_ds_name = TANF.Issue_scan_04_health_jf_eor,
    out_ds_label = Issue Scan 2004 indicators for health by JF - East of River total
  );

** Wards **;

%Transform_geo_data(
    dat_ds_name = TANF.Issue_scan_04_health_jf_tr00,
    dat_org_geo = geo2000,
    dat_count_vars = ADULT_2004_07 FULPART_2004_07 INFANT_2004_07 
	No_kids_2004_07 PI_2004_07 PRETEEN_2004_07  TEEN_2004_07 TODD_2004_07 
	UNBORN_2004_07 hh_2004_07,
    calc_vars = ,
    calc_vars_labels = ,
    wgt_ds_name = General.Tr00_wd01,
    wgt_org_geo = geo2000,
    wgt_new_geo = ward2001,
    wgt_wgt_var = pop_wgt,
    out_ds_name = TANF.Issue_scan_04_health_jf_wd01,
    out_ds_label = Issue Scan 2004 indicators for health by JF - wards (2001)
  );

** Issue Scan neighborhoods **;

%Transform_geo_data(
    show_warnings = 0,
    print_diag = N,
    dat_ds_name = TANF.Issue_scan_04_health_jf_tr00,
    dat_org_geo = geo2000,
    dat_count_vars = ADULT_2004_07 FULPART_2004_07 INFANT_2004_07 
	No_kids_2004_07 PI_2004_07 PRETEEN_2004_07  TEEN_2004_07 TODD_2004_07 
	UNBORN_2004_07 hh_2004_07,
    calc_vars = ,
    calc_vars_labels = ,
    wgt_ds_name = General.Tr00_isn04,
    wgt_org_geo = geo2000,
    wgt_new_geo = isn2004,
    wgt_wgt_var = pop_wgt,
    out_ds_name = TANF.Issue_scan_04_health_jf_isn04,
    out_ds_label = Issue Scan 2004 indicators for health by JF - Issue Scan 2004 neighborhoods
  );

** Clusters **;

%Transform_geo_data(
    dat_ds_name = TANF.Issue_scan_04_health_jf_tr00,
    dat_org_geo = geo2000,
    dat_count_vars = ADULT_2004_07 FULPART_2004_07 INFANT_2004_07 
	No_kids_2004_07 PI_2004_07 PRETEEN_2004_07  TEEN_2004_07 TODD_2004_07 
	UNBORN_2004_07 hh_2004_07,
    calc_vars = ,
    calc_vars_labels = ,
    wgt_ds_name = General.Tr00_cl00,
    wgt_org_geo = geo2000,
    wgt_new_geo = cluster2000,
    wgt_wgt_var = pop_wgt,
    out_ds_name = TANF.Issue_scan_04_health_jf_cl00,
    out_ds_label = Issue Scan 2004 indicators for health by JF - neighborhood clusters (2000)
  );



