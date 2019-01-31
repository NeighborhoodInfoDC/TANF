************************************************************************
* Program:  DCtanfdata_200307.sas
* Library:  TANF
* Project:  DC Data Warehouse
* Authors:   Jenn Comey / Julie Fenderson
* Created:  4/13/02 -- based on Kathy's DCTABLES.sas
* Version:  SAS 8.12
* Environment:  Windows
* Description:  This program reads in raw 1998 TANF data, formats it, aggregates, and merges. Figures out which cases have PIs and which don't, and figures out
the number of adults and kids in each case. Aggregates client level data to case level and merges them to case data, which includes DC proxy 1980 tracts. Also, changed DC (proxy) tracts to 1980
FIPS tracts;
* Modifications:4/18/03*/ by JC  9/11/03, 8/30/04 by JF
************************************************************************;

*/Run d:\DCWarehouse\TANF\DCtanfform.sas first
*Need to run "cnvtrct_80_00_tanf.sas" to convert 1980 tracts to 2000;

*Need to change library name to fit correct year folder;
%include "D:\METRO\JFenders\Working TANF\1998\DCtanfform.sas";
libname library "d:\Metro\JFenders\Working TANF\formats";
libname DC_TANF "d:\Metro\JFenders\Working TANF\1998" ;
libname convert "d:\Metro\JFenders\Working TANF\1998\sasprograms";

proc datasets library=convert;
QUIT;
*need library direction to find formats file;

*Need to change title to reflect correct year/month of data;
title "DC TANF 1998 (July) data, DCtanfdata.sas" ;


*NEED TO UPDATE THE FOLLOWING VARIABLES -- SHOULD BE ONLY SECTION NECESSARY TO UPDATE;

%let rawfolder = d:\Metro\JFenders\Working TANF\TANF\1998\raw1998data\;
%let client = client data 199807.txt;
%let case = case data 199807.txt;
%let yearmonth = 199807 ;
%let abyrmonth = 9807;

*Change baseage -- make it the first of January or July, and the year;
%let baseage ='01JUL98'D;
%let agelabel= Age as of July 1, 1998;
%let adultagelab = Age of adult as of 7/1/98;
%let childagelab = Age of child as of 7/1/98 ;


*read in raw client data;

data DC_TANF.TANFclie&yearmonth.;
infile 'd:\Metro\JFenders\Working TANF\1998\dhsa0218jul1998.txt' lrecl=35;
input @1 caseid $8. @9 clientid $10. @19 relcode $2. @21 partcode $2. 
	@23 DOB yymmdd8. @31 ethnic $2. @33 sex $1. @34 educat $2.;

label  caseid= "Case Number"                  
	clientid="client Number"
	dob="Date of birth"
	educat="Educational Level"            
	ethnic="Ethnicity"                         
	partcode="Participation Code"           
	relcode = "Relationship Code"            
        sex="Sex";
 
format partcode $partcod. relcode $relcode. ethnic $ethfmt.;
run;        

*read in raw case file data;
 

data DC_TANF.TANFcase&yearmonth.;
infile 'd:\Metro\JFenders\Working TANF\1998\dhsa0216jul1998.txt' lrecl=12;
input @1 caseid $8. @9 tract_DC $3. @12 language $1.;
	label  tract_DC = "DC census tracts";
run;

proc contents data=DC_Tanf.Tanfclie&yearmonth. ;
	title "Variable description of Client Data";
	

Proc contents data=DC_Tanf.Tanfcase&yearmonth. ;
	title "Variable description of Case Data";
	
	
	run ;

* NEED TO CORRECTLY FORMAT DATE FOR EACH NEW DATA SET. Formatted date of birth to be 
age as of July 1 of the year of the data. In this case, it"s 2003. There are missing
dates that have all 0 -- programmed these to be missing. Then put into age categories;

data DC_Tanf.Tanfclie&yearmonth. ;
set DC_Tanf.Tanfclie&yearmonth.  ;
ENDDATE=&baseage ;
if dob = . then age = . ;
	else age= (ENDDATE - dob)/365.25;

LABEL age="&agelabel";
format age agefmt.; 

run;

*Check to see if there are any missings;

proc freq data=DC_Tanf.Tanfclie&yearmonth. ;
	tables age;

data DC_Tanf.Tanfclie&yearmonth. ;
set DC_Tanf.Tanfclie&yearmonth.  ;

if age ne . then do;
	if age > 55 then AdultAge=4;
	if age >40 and age <=55 then AdultAge=3;
	if age >25 and age <=40 then AdultAge=2;
	if age >=18 and age <=25 then AdultAge=1;

	if age > 12 and age <18  then ChildAge=5;
	if age >= 6 and age <=12  then ChildAge=4;
	if age > 1 and age <6  then ChildAge=3;
	if age > 0 and age <= 1  then ChildAge=2;
	if age <= 0 then ChildAge=1;
	end;
				
label AdultAge= "&adultagelab" ;
label ChildAge= "&childagelab";

format AdultAge adulfmt. ChildAge chilfmt.;
run;

proc freq data = DC_TANF.Tanfclie&yearmonth. ;
	tables age AdultAge ChildAge partcode relcode ethnic sex educat;	
	format age agefmt. AdultAge adulfmt. ChildAge chilfmt. 
	partcode $partcod. relcode $relcode. ethnic $ethfmt. ;

	title "Frequency of Client Characteristics";
run ;
	
proc freq data = DC_TANF.Tanfcase&yearmonth.  ;
	table language ;
	title "Frequency of Case Characteristics";
	run ;
	

*I identified which are "IN" or full participants;


data DC_Tanf.Tanfclie&yearmonth.  ;
set DC_Tanf.Tanfclie&yearmonth. ;
	
	if partcode = "IN" then FULPART_&abyrmonth.=1;
	else if partcode ne "" then FULPART_&abyrmonth.=0;

proc freq data=DC_Tanf.Tanfclie&yearmonth. ;
	table FULPART_&abyrmonth. ;


run;

*Made dummy variables for children age ranges ;

data DC_Tanf.Tanfclie&yearmonth. ;
set DC_Tanf.Tanfclie&yearmonth. ;

	
	if ChildAge =1 then UNBORN_&abyrmonth. =1;
	else UNBORN_&abyrmonth.=0;
	if ChildAge = 2 then INFANT_&abyrmonth.=1;
	else INFANT_&abyrmonth.=0;
	if ChildAge = 3 then TODD_&abyrmonth.=1;
	else TODD_&abyrmonth.=0;
	if ChildAge =4 then PRETEEN_&abyrmonth.=1;
	else PRETEEN_&abyrmonth.=0;
	if ChildAge = 5 then TEEN_&abyrmonth. =1;
	else TEEN_&abyrmonth.=0;
	
	No_kids_&abyrmonth. = sum (INFANT_&abyrmonth., TODD_&abyrmonth., PRETEEN_&abyrmonth., TEEN_&abyrmonth.) ;
	label No_kids_&abyrmonth. = "Number of children per case (does not include unborn)" ;
	
*This array didn"t work, need to fix;
*I was trying to learn arrays;

	*if ChildAge =1 then UNBORN_&abyrmonth. =1;
	*if ChildAge = 2 then INFANT_&abyrmonth.=1;
	*if ChildAge = 3 then TODD_&abyrmonth.=1;
	*if ChildAge =4 then PRETEEN_&abyrmonth.=1;
	*else if ChildAge = 5 then TEEN_&abyrmonth. =1;
	
	*array 0child {*} ChildAge1-ChildAge5 ;
	*do i=0 to dim(0child) ;

 * other option -- array;
	*array numvalu{5}_TEMPORARY_(1 2 3 4 5) ;
	*array childcat{*} UNBORN_&abyrmonth. INFANT_&abyrmonth. TODD_&abyrmonth. PRETEEN_&abyrmonth. TEEN_&abyrmonth. ;

	*do i=1 to dim(numvalu) ;
	*if ChildAge = numvalu {i} then childcat {i} =1 ;
	*else childcat {i} = 0;
	*end ;
	
*run;

*Make dummy to identify the number of adults;

	if age >=18 then ADULT_&abyrmonth.=1;
	else if age <18 then ADULT_&abyrmonth.=0;
		
*Make dummy to identify the number of Primary informants (seems to be head
of household);


	if relcode = "PI" then PI_&abyrmonth.=1 ;
	else if relcode ne "" then PI_&abyrmonth.=0;
	

proc freq data=DC_Tanf.Tanfclie&yearmonth. ;
	tables 	UNBORN_&abyrmonth. INFANT_&abyrmonth. TODD_&abyrmonth. PRETEEN_&abyrmonth. TEEN_&abyrmonth. No_kids_&abyrmonth. ADULT_&abyrmonth. PI_&abyrmonth.;
	
	run;

*Aggregated the client data by case with counts of the dummy variables.
Only used Full Participants;


proc sort data= DC_Tanf.Tanfclie&yearmonth.  ;
	by caseid ;
	
proc summary data =DC_Tanf.Tanfclie&yearmonth.  (where=(FULPART_&abyrmonth.=1));
	var FULPART_&abyrmonth. PI_&abyrmonth. UNBORN_&abyrmonth. INFANT_&abyrmonth. TODD_&abyrmonth. PRETEEN_&abyrmonth.
	TEEN_&abyrmonth. No_kids_&abyrmonth. ADULT_&abyrmonth. ;
	by caseid ;
	output out=aggr1998clie sum= ;
	run;
	
proc print data =aggr1998clie (obs=20);
	title "Aggregate of different aged children, PI and Full Participants by case id" ;
	

proc freq data=aggr1998clie ;
	tables ADULT_&abyrmonth. ;
	title "Frequency of 0, 1, and 2 adult caseloads"; 

proc print data = aggr1998clie (obs=20);
	where ADULT_&abyrmonth.=0;
	title "First 20 observations where there is no adult" ;
	run;

	proc freq data = aggr1998clie ;
	table PI_&abyrmonth.;
	title "Frequency of PI" ;

	proc print data = aggr1998clie (obs=20);
	where PI_&abyrmonth.=0;
	title "First 20 observations where there is no PI" ;
	run;

*figure out child only cases; 

proc print data = aggr1998clie ;
	where PI_&abyrmonth.=0 and ADULT_&abyrmonth.=0 ;
	title "Child only cases: Observations where there is no PI and no adult";
	
	run; 

*want to know who are the child PIs ;

proc print data = aggr1998clie ;
	where PI_&abyrmonth. =1 and ADULT_&abyrmonth. = 0 and TEEN_&abyrmonth.=1 ;
	title "Teenage PI" ;
	
run ;

proc print data = aggr1998clie ;
	where PI_&abyrmonth. =1 and ADULT_&abyrmonth. = 0 and TEEN_&abyrmonth.=1 and (INFANT_&abyrmonth.=1 or TODD_&abyrmonth.=1);
	title "Teenage PI with infant or toddler" ;
	
run ;

*Summarize the number of kids ;

proc freq data = aggr1998clie;
	table No_kids_&abyrmonth. ;
	title "Number of kids per case" ;
	
run ;

proc print data = aggr1998clie ;
	where No_kids_&abyrmonth.=0 and UNBORN_&abyrmonth.=1;
	 run ;
	 
proc print data = aggr1998clie ;
	where No_kids_&abyrmonth.=0 and UNBORN_&abyrmonth.=0 and PI_&abyrmonth.=0;
	 run ;
	 
	 
*Merging aggregated client data to case data set, which has 1980 proxy census
tracks;

proc sort data=aggr1998clie ;
by caseid;
run;

proc sort data=DC_TANF.Tanfcase&yearmonth.  ;
by caseid;
run;

data TANFDC&yearmonth.;
merge aggr1998clie (in=in1)
	DC_TANF.Tanfcase&yearmonth. (in=in2);
	by caseid;
	if in1;

/*made the temporary flags permanent variables to check if anything missing*/

	in_clie = in1;
	in_case = in2;
	*hshld=1;
run ;

proc contents data=TANFDC&yearmonth.;

run;

*ran the proc print below to check if merge went ok;

proc print data=TANFDC&yearmonth.;
	var caseid ;
	where in_clie=0 or in_case =0;
	
run ;


*change the DC tracts -- proxy tracts -- to 1980 FIPS;

option mprint mlogic;
proc sort data=TANFDC&yearmonth.;
by tract_DC;
run;
	
proc sort data=convert.dcconv1980 ;
by tract_DC;
run;

data tract2 ;
merge TANFDC&yearmonth. (in=ina)
convert.dcconv1980;
by tract_DC;
run;

proc sort data=tract2;
by geo80;
run;

proc summary data=tract2;
   by geo80;
   var FULPART_&abyrmonth. PI_&abyrmonth. UNBORN_&abyrmonth. INFANT_&abyrmonth. TODD_&abyrmonth. PRETEEN_&abyrmonth. TEEN_&abyrmonth. No_kids_&abyrmonth. ADULT_&abyrmonth.;
   output out = DC_TANF.TANF&yearmonth._80tracts sum=;
   run;
  

data DC_TANF.TANF&yearmonth._80tracts ;
set DC_TANF.TANF&yearmonth._80tracts ;

	array kid0 {*} UNBORN_&abyrmonth. INFANT_&abyrmonth. TODD_&abyrmonth. PRETEEN_&abyrmonth. TEEN_&abyrmonth. ;
	
	do i = 1 to dim(kid0);
	if kid0{i} in (.) then kid0{i}=0;
	
	end;
	
	array miss0 {*} PI_&abyrmonth. FULPART_&abyrmonth. No_kids_&abyrmonth. ADULT_&abyrmonth.;
	do i = 1 to dim(miss0) ;
	if miss0{i} in (.) then miss0{i} =0 ;
	end;

	label ADULT_&abyrmonth. = "Adult TANF clients (>=18 years old)";
	label FULPART_&abyrmonth. = "Full TANF participants (includes kids and adults)";
	label No_kids_&abyrmonth. = "Child TANF clients (<18 year olds) (not including unborn)";
	label PI_&abyrmonth. = "Primarily informants of children receiving TANF";
	label INFANT_&abyrmonth. = "Infant TANF clients (< 1 year olds)";
	label PRETEEN_&abyrmonth. = "PRETEEN_&abyrmonth. TANF clients (>6 to 12 year olds)";
	label TEEN_&abyrmonth. = "Teen TANF clients (>13 to 17 year olds)";
	label TODD_&abyrmonth. = "Toddler TANF clients (1-5 year olds)";
	label UNBORN_&abyrmonth. = "Expected TANF children (pregnancies)";
	run;
	
	

	
proc print data = DC_TANF.TANF&yearmonth._80tracts  (obs=10);
	title "1998 (July) TANF Data in 1980 tracts" ;
run;


proc contents data = DC_TANF.TANF&yearmonth._80tracts  ;
run ;

proc print data = DC_TANF.TANF&yearmonth._80tracts  ;
	where (No_kids_&abyrmonth. + ADULT_&abyrmonth.) ne FULPART_&abyrmonth. ; 
	title "Observations where #Kids and #Adults Don't = Fullparticipants" ;
run ;

proc print data = DC_TANF.TANF&yearmonth._80tracts  ;
where FULPART_&abyrmonth.=0;
run;


*Final step is in next sas program, cnvtrct_80_00_tanf.sas, to convert the 1980 tracts
to 2000;


