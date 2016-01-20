************************************************************************
* Program:  Merge_Tanf_2004_07_tr80.sas
* Library:  TANF
* Project:  DC Data Warehouse
* Authors:   Jenn Comey / Julie Fenderson
* Created:  4/13/02 -- based on Kathy's DCTABLES.sas
* Version:  SAS 8.12
* Environment:  Windows
* Description:  This program aggregates client level data to case level and merges them to case data, which includes DC proxy 1980 tracts. Also, changed DC (proxy) tracts to 1980
* FIPS tracts. Only used Full Participants. Need to run "cnvtrct_80_00_tanf.sas" to convert 1980 tracts to 2000
* Modifications:4/18/03 by JC  9/11/03, 8/30/04 by JF
*
************************************************************************;
%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%DCData_lib (TANF);




proc sort data= Tanf.Tanf_&year._&month._client  ;
	by caseid ;
	
proc summary data =Tanf.Tanf_&year._&month._client  (where=(FULPART_&year._&month.=1));
	var FULPART_&year._&month. PI_&year._&month. UNBORN_&year._&month. INFANT_&year._&month. TODD_&year._&month. PRETEEN_&year._&month.
	TEEN_&year._&month. No_kids_&year._&month. ADULT_&year._&month. ;
	by caseid ;
	output out=aggr2004clie sum= ;
	run;
	
proc print data =aggr2004clie (obs=20);
	title "Aggregate of different aged children, PI and Full Participants by case id" ;
	

proc freq data=aggr2004clie ;
	tables ADULT_&year._&month. ;
	title "Frequency of 0, 1, and 2 adult caseloads"; 

proc print data = aggr2004clie (obs=20);
	where ADULT_&year._&month.=0;
	title "First 20 observations where there is no adult" ;
	run;

	proc freq data = aggr2004clie ;
	table PI_&year._&month.;
	title "Frequency of PI" ;

	proc print data = aggr2004clie (obs=20);
	where PI_&year._&month.=0;
	title "First 20 observations where there is no PI" ;
	run;

*figure out child only cases; 

proc print data = aggr2004clie ;
	where PI_&year._&month.=0 and ADULT_&year._&month.=0 ;
	title "Child only cases: Observations where there is no PI and no adult";
	
	run; 

*want to know who are the child PIs ;

proc print data = aggr2004clie ;
	where PI_&year._&month. =1 and ADULT_&year._&month. = 0 and TEEN_&year._&month.=1 ;
	title "Teenage PI" ;
	
run ;

proc print data = aggr2004clie ;
	where PI_&year._&month. =1 and ADULT_&year._&month. = 0 and TEEN_&year._&month.=1 and (INFANT_&year._&month.=1 or TODD_&year._&year._&month.=1);
	title "Teenage PI with infant or toddler" ;
	
run ;

*Summarize the number of kids ;

proc freq data = aggr2004clie;
	table No_kids_&year._&month. ;
	title "Number of kids per case" ;
	
run ;

proc print data = aggr2004clie ;
	where No_kids_&year._&month.=0 and UNBORN_&year._&month.=1;
	 run ;
	 
proc print data = aggr2004clie ;
	where No_kids_&year._&month.=0 and UNBORN_&year._&month.=0 and PI_&year._&month.=0;
	 run ;
	 
	 
*Merging aggregated client data to case data set, which has 1980 proxy census
tracks;

proc sort data=aggr2004clie ;
by caseid;
run;

proc sort data=TANF.TANF_&year._&month._case  ;
by caseid;
run;


*insert#1;
data TANF_&year._&month.;
merge aggr2004clie (in=in1)
	TANF.TANF_&year._&month._case (in=in2);
	by caseid;
	if in1;

/*made the temporary flags permanent variables to check if anything missing*/

	in_clie = in1;
	in_case = in2;
	hh_&year._&month.=1;
run ;

proc contents data=TANF_&year._&month.;

run;

*ran the proc print below to check if merge went ok;

proc print data=TANF_&year._&month.;
	var caseid ;
	where in_clie=0 or in_case =0;
	
run ;


*change the DC tracts -- proxy tracts -- to 1980 FIPS;

option mprint mlogic;
proc sort data=TANF_&year._&month.;
by tract_DC;
run;
	
proc sort data=tanf.dcconv1980 ;
by tract_DC;
run;

data tract2 ;
merge TANF_&year._&month. (in=ina)
tanf.dcconv1980;
by tract_DC;
run;

proc sort data=tract2;
by geo80;
run;
*insert #2;
proc summary data=tract2;
   by geo80;
   var hh_&year._&month. FULPART_&year._&month. PI_&year._&month. UNBORN_&year._&month. INFANT_&year._&month. TODD_&year._&month. PRETEEN_&year._&month. TEEN_&year._&month. No_kids_&year._&month. ADULT_&year._&month.;
   output out = TANF_&year._&month._80tracts sum=;
   run;
  

data TANF.TANF_&year._&month._80tracts ;
set TANF_&year._&month._80tracts ;

	array kid0 {*} UNBORN_&year._&month. INFANT_&year._&month. TODD_&year._&month. PRETEEN_&year._&month. TEEN_&year._&month. ;
	
	do i = 1 to dim(kid0);
	if kid0{i} in (.) then kid0{i}=0;
	
	end;
		
	*insert #3;
	array miss0 {*} hh_&year._&month. PI_&year._&month. FULPART_&year._&month. No_kids_&year._&month. ADULT_&year._&month.;
	do i = 1 to dim(miss0) ;
	if miss0{i} in (.) then miss0{i} =0 ;
	end;

	label HH_&year._&month. = "TANF households";
	label ADULT_&year._&month. = "Adult TANF clients (>=18 years old)";
	label FULPART_&year._&month. = "Full TANF participants (includes kids and adults)";
	label No_kids_&year._&month. = "Child TANF clients (<18 year olds) (not including unborn)";
	label PI_&year._&month. = "Primarily informants of children receiving TANF";
	label INFANT_&year._&month. = "Infant TANF clients (< 1 year olds)";
	label PRETEEN_&year._&month. = "PRETEEN_&year._&month. TANF clients (>6 to 12 year olds)";
	label TEEN_&year._&month. = "Teen TANF clients (>13 to 17 year olds)";
	label TODD_&year._&month. = "Toddler TANF clients (1-5 year olds)";
	label UNBORN_&year._&month. = "Expected TANF children (pregnancies)";
	run;
	
	

	
proc print data = TANF.TANF_&year._&month._80tracts  (obs=10);
	title "2004 (July) TANF Data in 1980 tracts" ;
run;


proc contents data = TANF.TANF_&year._&month._80tracts  ;
run ;

proc print data = TANF.TANF_&year._&month._80tracts  ;
	where (No_kids_&year._&month. + ADULT_&year._&month.) ne FULPART_&year._&month. ; 
	title "Observations where #Kids and #Adults Don't = Fullparticipants" ;
run ;

proc print data = TANF.TANF_&year._&month._80tracts  ;
where FULPART_&year._&month.=0;
run;


*Final step is in next sas program, cnvtrct_80_00_tanf.sas, to convert the 1980 tracts
to 2000;


