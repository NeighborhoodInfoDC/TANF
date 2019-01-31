************************************************************************
* Program:  PrepDCTanf.sas
* Library:  TANF
* Project:  DC Data Warehouse
* Authors:  Beata Bednarz and Julie Fenderson
* Created:  9/11/03
* Version:  SAS 8.12
* Environment:  Windows
* Description:  This program sorts the data by the 2000 Census tract and merges 
*				the different years (1998,1999,2000 and 2003 data).
* Modifications:
************************************************************************;

libname library "d:\Metro\JFenders\Working TANF\formats";

libname DC_TANF "d:\Metro\JFenders\Working TANF\2003" ;
libname DC_TANF2 "d:\Metro\JFenders\Working TANF\2002";
libname DC_TANF8 "d:\Metro\JFenders\Working TANF\1998";
libname DC_TANF9 "d:\Metro\JFenders\Working TANF\1999";

*proc contents data=DC_TANF.TANF_0307_tr00; 
*run;
*proc contents data=DC_TANF8.TANF_1998_tr00; 
*run;
proc sort data=DC_TANF.TANF_0307_tr00; 
	by geo00;
proc sort data=DC_TANF2.tanf_0207_tr00; 
	by geo00;
proc sort data=DC_TANF8.tanf_1998_tr00; 
	by geo00;
proc sort data=DC_TANF9.tanf_9907_tr00; 
	by geo00;
run;
data Issue_scan_04_health_jf_tr00; 
	merge DC_TANF8.tanf_1998_tr00 (keep=No_kids_9807 geo00 pi_9807)
			DC_TANF.TANF_0307_tr00 (keep= No_kids_0307 PI_0307 geo00 hh_0307)
			DC_TANF2.TANF_0207_tr00 (keep= No_kids_0207 PI_0207 geo00 hh_0207)
			DC_TANF9.TANF_9907_tr00 (keep= No_kids_9907 PI_9907 geo00 hh_9907)
; 
by geo00;
run;
	
data DC_TANF.Issue_scan_04_health_jf_tr00;
set Issue_scan_04_health_jf_tr00 (rename= (geo00=geo2000) );
run;



