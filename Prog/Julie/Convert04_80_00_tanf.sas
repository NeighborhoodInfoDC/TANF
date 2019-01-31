*  Program:  Convert04_80_00.SAS - Census 2000 Tract Conversion
*  Library: TANF 
*  Project: DC Data Warehouse
*  Authors: Peter A. Tatian
*  Created: 09/18/01 
*  Version 2.02
*  Environment: Windows
*  Description: Converts 1980 Census data to 2000 tract definitions.
*  				Uses Geolytics-derived tract weights in file TWT80_00.
*     			This program sorts the data by the 2000 Census tract 
				NB:  You must edit the PROGRAM PARAMETER DEFINITIONS 
				below to specify the name of the input data set and variables you wish to convert.
*       		See the file CNVTRCT_NOTES.TXT for details.
*  Modifications: 
*
**************************************************************************;
%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )
libname TANF v8 "d:\DCData\Libraries\TANF\Data" ;

title 'CNVTRCT_80_00:  Census 2000 Tract Conversion';





**** Data set names and locations ****;

** Input data set (source data --converting data set) **;
%let in_dat = TANF.TANF_2004_07_80tracts    ;

** Input data tract ID variable (SSCCCTTTTTT) **;
%let in_trid = geo80;

** Input data set year (YYYY) **;
%let in_year = 1980;

** Output data set (input data mapped to new tracts) **;
%let out_dat = TANF.TANF_2004_07_tr00 ;


** Output data set year (YYYY) **;
%let out_year = 2000;

** Output data set label **;
%let out_lbl = TANF cases, 2004 July, tracts (2000);

**** Variables to be converted ****;
*insert  #4;
** Total Population Count variables **;
%let popvar =
    unborn_2004_07 infant_2004_07 todd_2004_07 preteen_2004_07 teen_2004_07 PI_2004_07 FULPART_2004_07
    No_kids_2004_07 adult_2004_07 hh_2004_07;

** White Population Count variables **;
%let wpopvar =
    ;

** Black Population Count variables **;
%let bpopvar =
    ;

** Native American Population Count variables **;
%let npopvar =
    ;

** Asian/PI Population Count variables **;
%let apopvar =
    ;

** Other Race Population Count variables **;
%let opopvar =
    ;

** Hispanic Population Count variables **;
%let hpopvar =
    ;

** Child (0-17) Population Count variables **;
%let chpopvar =
    ;

** Adult (18+) Population Count variables **;
%let adpopvar =
     ;

** Housing Units Variables **;
%let huvar =
    ;
  
      
** Households Variables**;
%let hhvar =
   ;
    

**Owner-occ. housing units Variables**;
%let owoccvar =
    ;        
**Renter-occ. housing units Variables**;
%let rtoccvar =
     ; 

**Owner Occupied housing unit values Variables**;
%let hvalvar =
    ; 
    
**Housing unit rent value Variables**;
%let  rthuvar =
   ; 
 


**** Tract comparability & weighting file ****;

** Tract comparability file **;
%let tcompf = Tanf.TWT80_00 ;


******** END OF PROGRAM PARAMETER DEFINITIONS ********;


******** START PROGRAM ********;

options mprint symbolgen nomlogic;


***************************************************************************
** Macro definitions;

** Global Macro Variables **;

%let allvars = &popvar &wpopvar &bpopvar &npopvar &apopvar &opopvar &hpopvar
               &chpopvar &adpopvar &huvar &hhvar &owoccvar &rtoccvar &hvalvar &rthuvar;
               
** Variable weights **;
%let popwt = pop;
%let wpopwt = white;
%let bpopwt = black;
%let npopwt = natam;
%let apopwt = aspac;
%let opopwt = other;
%let hpopwt = hisp;
%let chpopwt = pop17;
%let adpopwt = pop18p;
%let hupopwt = hu ;    
%let hhpopwt = hh;
%let oocpopwt = huownocc;
%let rocpopwt = hurntocc;
%let hvlpopwt = huvalue;
%let urtpopwt = hurent;
      
%let allwts  = &popwt &wpopwt &bpopwt &npopwt &apopwt &opopwt &hpopwt
               &chpopwt &adpopwt &hupopwt &hhpopwt &oocpopwt &rocpopwt &hvlpopwt &urtpopwt;
               
%let shin_yr  = %substr( &in_year, 3, 2 );
%let shout_yr = %substr( &out_year, 3, 2 );

%let st_in    = state&shin_yr;
%let st_out   = state&shout_yr;

%let trct_in  = geo&shin_yr;
%let trct_out = geo&shout_yr;
%let trct_chg = tch&shin_yr._&shout_yr;

** APPRTN() macro is needed to prevent processing empty variable lists **;

%macro apprtn( arryn, arrydef, factor );

  %if %length( &&arrydef ) > 0 %then %do;
    array &arryn{*} &&arrydef;
    do i = 1 to dim( &arryn );
      &arryn{ i } = ( &factor ) * &arryn{ i };
    end;
  %end;

%mend apprtn;


**************************************************************************
** Merge input data with tract comparability file;
** Apportion input data according to tract changes;

data in_dat;

  set &in_dat (keep=&in_trid &allvars);
  
  ** Create state code (used for test tabulations) **;
  
  length &st_in $ 2;
  
  &st_in = &in_trid;

run;

proc sort data=in_dat;
  by &in_trid;

run;

** For some reason, this doesn't work unless you do it in two data steps;

data A;

  merge
    in_dat (in=in1 rename=(&in_trid=&trct_in))
    &tcompf (in=in2 keep=&trct_in &trct_out &trct_chg &allwts);
  by &trct_in;

  if in1;

  in_1 = in1;
  in_2 = in2;

** end data A **;

run;

data B;

  set A;

  if in_2 then do;                     ** Changed tracts **;

    %apprtn( pop_a, &popvar, &popwt );
    %apprtn( wpop_a, &wpopvar, &wpopwt );
    %apprtn( bpop_a, &bpopvar, &bpopwt );
    %apprtn( npop_a, &npopvar, &npopwt );
    %apprtn( apop_a, &apopvar, &apopwt );
    %apprtn( opop_a, &opopvar, &opopwt );
    %apprtn( hpop_a, &hpopvar, &hpopwt );
    %apprtn( chpop_a, &chpopvar, &chpopwt );
    %apprtn( adpop_a, &adpopvar, &adpopwt );
    %apprtn( hupop_a, &huvar,  &hupopwt);
    %apprtn( hhpop_a, &hhvar,  &hhpopwt);
    %apprtn( ocpop_a, &owoccvar, &oocpopwt);
    %apprtn( ropop_a, &rtoccvar, &rocpopwt);
    %apprtn( hvpop_a, &hvalvar, &hvlpopwt);
    %apprtn( urpop_a, &rthuvar, &urtpopwt);  

    flag = 1;

  end;

  else do;                             ** Unchanged tracts **;

    &trct_out = &trct_in;
    
    flag = 0;
    &trct_chg = 0;

  end;

** end data B **;

run;


** Aggregate to new tracts **;

proc sort data=B; 
  by &trct_out;

proc summary data=B;
  var &allvars flag;
  by &trct_out;
  id &trct_chg;
  output out=B2
    sum(&allvars)=
    max(flag)=;

data &out_dat (label="&out_lbl");

  set B2 (drop=_type_ _freq_);

  length &st_out $ 2;
  
  &st_out = &trct_out;

  label 
    flag = "Tract conversion flag (0=Unchanged)"
    &st_out = "FIPS state code &out_year";
run;
** end data &out_dat **;


proc contents data=&out_dat;
  title2 "File=%upcase(&out_dat) (&out_year Tracts)";

proc means n sum mean min max data=&out_dat;

proc format;
  value flag
    0 = '0 -> Tract unchanged'
    1 = '1 -> Tract converted';
  value trctchg
    0 = "No change"
    1 = "1 to 1 (renamed)"
    2 = "Many to 1 (combined)"
    3 = "1 to many (split)"
    4 = "Many to many";
    
run;    
    

proc freq data=&out_dat;
  tables flag &trct_chg;
  format flag flag. &trct_chg trctchg.;  
  label flag = "Tract conversion flag";
  title2 "File=%upcase(&out_dat) (&out_year Tracts)";

run;


**** TESTS ****;

** State totals **;

proc format;
  value $statefp
    "01" = "Alabama"
    "02" = "Alaska"
    "04" = "Arizona"
    "05" = "Arkansas"
    "06" = "California"
    "08" = "Colorado"
    "09" = "Connecticut"
    "10" = "Delaware"
    "11" = "District of Columbia"
    "12" = "Florida"
    "13" = "Georgia"
    "15" = "Hawaii"
    "16" = "Idaho"
    "17" = "Illinois"
    "18" = "Indiana"
    "19" = "Iowa"
    "20" = "Kansas"
    "21" = "Kentucky"
    "22" = "Louisiana"
    "23" = "Maine"
    "24" = "Maryland"
    "25" = "Massachusetts"
    "26" = "Michigan"
    "27" = "Minnesota"
    "28" = "Mississippi"
    "29" = "Missouri"
    "30" = "Montana"
    "31" = "Nebraska"
    "32" = "Nevada"
    "33" = "New Hampshire"
    "34" = "New Jersey"
    "35" = "New Mexico"
    "36" = "New York"
    "37" = "North Carolina"
    "38" = "North Dakota"
    "39" = "Ohio"
    "40" = "Oklahoma"
    "41" = "Oregon"
    "42" = "Pennsylvania"
    "44" = "Rhode Island"
    "45" = "South Carolina"
    "46" = "South Dakota"
    "47" = "Tennessee"
    "48" = "Texas"
    "49" = "Utah"
    "50" = "Vermont"
    "51" = "Virginia"
    "53" = "Washington"
    "54" = "West Virginia"
    "55" = "Wisconsin"
    "56" = "Wyoming"
    "72" = "Puerto Rico"
    "78" = "Virgin Islands";
    
proc tabulate data=in_dat noseps format=comma12.0;
  var &allvars;
  class &st_in;
  tables all &st_in='-By State-', 
    n="&in_year Tracts"*f=comma8.0 sum=' ' * (&allvars) / condense;
  keylabel
    all = 'Total';
  format &st_in $statefp.;
  title2 "File=%upcase(&in_dat) (&in_year Tracts)";
  title3 "Totals should match those in next table";

proc tabulate data=&out_dat noseps format=comma12.0;
  var &allvars;
  class &st_out;
  tables all &st_out='-By State-', 
    n="&out_year Tracts"*f=comma8.0 sum=' ' * (&allvars) / condense;
  keylabel
    all = 'Total';
  format &st_out $statefp.;
  title2 "File=%upcase(&out_dat) (&out_year Tracts)";
  title3 "Totals should match those in previous table";

run;
proc sort data=TANF.TANF_2004_07_tr00; 
	by geo00;
	run;

data TANF.Issue_scan_04_health_jf_tr00; 
	set TANF.TANF_2004_07_tr00;
	rename geo00=geo2000;
run;
	
******** END OF PROGRAM ********;

