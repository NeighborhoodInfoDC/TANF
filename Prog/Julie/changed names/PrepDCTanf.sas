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


libname TANF "D:\DCData\Libraries\TANF\Data" ;



proc sort data=TANF.TANF_2004_07_tr00; 
	by geo00;
	run;

data TANF.Issue_scan_04_health_jf_tr00; 
	set TANF.TANF_2004_07_tr00;
	rename geo00=geo2000;
run;
	



