filename uiautos "K:\Metro\PTatian\UISUG\Uiautos";
options sasautos=(uiautos sasautos);
libname General "D:\METRO\JFenders\Working TANF\2003\Weighting";
libname DC_TANF "d:\Metro\JFenders\Working TANF\2003" ;
*Equation used for calc_vars Percent=(no_kid_0307 - No_kid_0207) / no_kid_0207*;
** City total **;

%Transform_geo_data(
    dat_ds_name = DC_TANF.Issue_scan_04_health_jf_tr00,
    dat_org_geo = geo2000,
    dat_count_vars = PI_0307 No_kids_0307 No_kids_9807 hh_0307 hh_0207 hh_9907,
    calc_vars = percent=100*(No_kids_0307 - No_kids_9807) / No_kids_9807, 
    calc_vars_labels = percent="Percent change in children receiving TANF, 1998-2003", 
    wgt_ds_name = General.Tr00_city,
    wgt_org_geo = geo2000,
    wgt_new_geo = city,
    wgt_wgt_var = pop_wgt,
    out_ds_name = DC_TANF.Issue_scan_04_health_jf_city,
    out_ds_label = Issue Scan 2004 indicators for health by JF - city total
  );

** East of the River **;

%Transform_geo_data(
    show_warnings = 0,
    print_diag = N,
    dat_ds_name = DC_TANF.Issue_scan_04_health_jf_tr00,
    dat_org_geo = geo2000,
    dat_count_vars = PI_0307 No_kids_0307 No_kids_9807 hh_0307 hh_0207 hh_9907,
    calc_vars = percent=100*(No_kids_0307 - No_kids_9807) / No_kids_9807,
    calc_vars_labels = percent="Percent change in children receiving TANF, 1998-2003",
    wgt_ds_name = General.Tr00_eor,
    wgt_org_geo = geo2000,
    wgt_new_geo = eor2000,
    wgt_wgt_var = pop_wgt,
    out_ds_name = DC_TANF.Issue_scan_04_health_jf_eor,
    out_ds_label = Issue Scan 2004 indicators for health by JF - East of River total
  );

** Wards **;

%Transform_geo_data(
    dat_ds_name = DC_TANF.Issue_scan_04_health_jf_tr00,
    dat_org_geo = geo2000,
    dat_count_vars = PI_0307 No_kids_0307 No_kids_9807 hh_0307 hh_0207 hh_9907,
    calc_vars = percent=100*(No_kids_0307 - No_kids_9807) / No_kids_9807,
    calc_vars_labels = percent="Percent change in children receiving TANF, 1998-2003",
    wgt_ds_name = General.Tr00_wd01,
    wgt_org_geo = geo2000,
    wgt_new_geo = ward2001,
    wgt_wgt_var = pop_wgt,
    out_ds_name = DC_TANF.Issue_scan_04_health_jf_wd01,
    out_ds_label = Issue Scan 2004 indicators for health by JF - wards (2001)
  );

** Issue Scan neighborhoods **;

%Transform_geo_data(
    show_warnings = 0,
    print_diag = N,
    dat_ds_name = DC_TANF.Issue_scan_04_health_jf_tr00,
    dat_org_geo = geo2000,
    dat_count_vars = PI_0307 No_kids_0307 No_kids_9807 hh_0307 hh_0207 hh_9907,
    calc_vars = percent=100*(No_kids_0307 - No_kids_9807) / No_kids_9807,
    calc_vars_labels = percent="Percent change in children receiving TANF, 1998-2003",
    wgt_ds_name = General.Tr00_isn04,
    wgt_org_geo = geo2000,
    wgt_new_geo = isn2004,
    wgt_wgt_var = pop_wgt,
    out_ds_name = DC_TANF.Issue_scan_04_health_jf_isn04,
    out_ds_label = Issue Scan 2004 indicators for health by JF - Issue Scan 2004 neighborhoods
  );

** Clusters **;

%Transform_geo_data(
    dat_ds_name = DC_TANF.Issue_scan_04_health_jf_tr00,
    dat_org_geo = geo2000,
    dat_count_vars = PI_0307 No_kids_0307 No_kids_9807 hh_0307 hh_0207 hh_9907,
    calc_vars = percent=100*(No_kids_0307 - No_kids_9807) / No_kids_9807,
    calc_vars_labels = percent="Percent change in children receiving TANF, 1998-2003",
    wgt_ds_name = General.Tr00_cl00,
    wgt_org_geo = geo2000,
    wgt_new_geo = cluster2000,
    wgt_wgt_var = pop_wgt,
    out_ds_name = DC_TANF.Issue_scan_04_health_jf_cl00,
    out_ds_label = Issue Scan 2004 indicators for health by JF - neighborhood clusters (2000)
  );



