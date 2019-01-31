************************************************************************
* Program:  Tanf_2004_07.sas
* Library:  TANF
* Project:  DC Data Warehouse
* Authors:   Jenn Comey / Julie Fenderson
* Created:  4/13/02 -- based on Kathy's DCTABLES.sas
* Version:  SAS 8.12
* Environment:  Windows
* Description:  This program reads in raw TANF data, formats it, aggregates, and merges. Figures out which cases have PIs and which don't, and figures out
* the number of adults and kids in each case. Aggregates client level data to case level and merges them to case data, which includes DC proxy 1980 tracts. Also, changed DC (proxy) tracts to 1980
* FIPS tracts;
* Modifications:4/18/03 by JC  9/11/03, 10/04 by JF
*Run d:\DCWarehouse\TANF\DCtanfform.sas first
*Need to run "cnvtrct_80_00_tanf.sas" to convert 1980 tracts to 2000
************************************************************************;
%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

*NEED TO UPDATE THE FOLLOWING VARIABLES -- SHOULD BE ONLY SECTION NECESSARY TO UPDATE;

%let rawfolder = D:\DCData\Libraries\TANF\Raw;
%let client = client data 200407.txt;
%let case = case data 200407.txt;
%let year = 2004 ;
%let month = 07;

*Change baseage -- make it the first of January or July, and the year;
%let baseage ='01JUL04'D;
%let agelabel= Age as of July 1, 2004;
%let adultagelab = Age of adult as of 7/1/04;
%let childagelab = Age of child as of 7/1/04 ;


*read in raw client data;

data TANF.TANF_&year._&month._client;
infile "D:\DCData\Libraries\TANF\Raw\DHSA0218_FS200407.txt" truncover lrecl=35;
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
 

data TANF.TANF_&year._&month._case;
infile "D:\DCData\Libraries\TANF\Raw\DHSA0216_FS200407.txt" truncover lrecl=12;
input @1 caseid $8. @9 tract_DC $3. @12 language $1.;

	label  tract_DC = "DC census tracts";
run;
proc contents data=Tanf.Tanf_&year._&month._client ;
	title "Variable description of Client Data";
	

Proc contents data=TANF.TANF_&year._&month._case; ;
	title "Variable description of Case Data";
	
	
	run ;

* NEED TO CORRECTLY FORMAT DATE FOR EACH NEW DATA SET. Formatted date of birth to be 
age as of July 1 of the year of the data. In this case, it"s 2004. There are missing
dates that have all 0 -- programmed these to be missing. Then put into age categories;

data Tanf.Tanf_&year._&month._client ;
set Tanf.Tanf_&year._&month._client  ;
ENDDATE=&baseage ;
if dob = . then age = . ;
	else age= (ENDDATE - dob)/365.25;

LABEL age="&agelabel";
format age agefmt.; 

run;

*Check to see if there are any missings;

proc freq data=Tanf.Tanf_&year._&month._client ;
	tables age;

data Tanf.Tanf_&year._&month._client ;
set Tanf.Tanf_&year._&month._client  ;

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

proc freq data = Tanf.Tanf_&year._&month._client ;
	tables age AdultAge ChildAge partcode relcode ethnic sex educat;	
	format age agefmt. AdultAge adulfmt. ChildAge chilfmt. 
	partcode $partcod. relcode $relcode. ethnic $ethfmt. ;

	title "Frequency of Client Characteristics";
run ;
	
proc freq data = TANF.TANF_&year._&month._case  ;
	table language ;
	title "Frequency of Case Characteristics";
	run ;
	

*I identified which are "IN" or full participants;


data Tanf.Tanf_&year._&month._client  ;
set Tanf.Tanf_&year._&month._client ;
	
	if partcode = "IN" then FULPART_&year._&month.=1;
	else if partcode ne "" then FULPART_&year._&month.=0;

proc freq data=Tanf.Tanf_&year._&month._client ;
	table FULPART_&year._&month. ;


run;

*Made dummy variables for children age ranges ;

data Tanf.Tanf_&year._&month._client ;
set Tanf.Tanf_&year._&month._client ;

	
	if ChildAge =1 then UNBORN_&year._&month. =1;
	else UNBORN_&year._&month.=0;
	if ChildAge = 2 then INFANT_&year._&month.=1;
	else INFANT_&year._&month.=0;
	if ChildAge = 3 then TODD_&year._&month.=1;
	else TODD_&year._&month.=0;
	if ChildAge =4 then PRETEEN_&year._&month.=1;
	else PRETEEN_&year._&month.=0;
	if ChildAge = 5 then TEEN_&year._&month. =1;
	else TEEN_&year._&month.=0;
	
	No_kids_&year._&month. = sum (INFANT_&year._&month., TODD_&year._&month., PRETEEN_&year._&month., TEEN_&year._&month.) ;
	label No_kids_&year._&month. = "Number of children per case (does not include unborn)" ;
	
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

	if age >=18 then ADULT_&year._&month.=1;
	else if age <18 then ADULT_&year._&month.=0;
		
*Make dummy to identify the number of Primary informants (seems to be head
of household);


	if relcode = "PI" then PI_&year._&month.=1 ;
	else if relcode ne "" then PI_&year._&month.=0;
	

proc freq data=Tanf.Tanf_&year._&month._client ;
	tables 	UNBORN_&year._&month. INFANT_&year._&month. TODD_&year._&month. PRETEEN_&year._&month. TEEN_&year._&month. No_kids_&year._&month. ADULT_&year._&month. PI_&year._&month.;
	
	run;

	