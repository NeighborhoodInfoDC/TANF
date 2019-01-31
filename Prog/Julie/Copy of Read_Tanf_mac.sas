/**********************************************************************
* Program:  Read_Tanf_mac.sas
* Library:  TANF
* Project:  DC Data Warehouse
* Authors:   Julie Fenderson
* Created:  1/24/05 
* Version:  SAS 8.12
* Environment:  Windows
* Description:  This program is a SAS autocall macro 
* Modifications:4/18/03 by JC  9/11/03, 10/04 by JF
*
************************************************************************/

%macro Read_Tanf_mac( rawfolder =, client =, case =,  year =,  month =);

**Define libraries**;
%DCData_lib( TANF );

*read in raw client data;

data TANF.TANF_&year._&month._client (label="TANF cases, DC, &month/&year, client-level data");
infile "&rawfolder\&client" truncover lrecl=35;
input @1 caseid $8. @9 clientid $10. @19 relcode $2. @21 partcode $2. 
	@23 DOB yymmdd8. @31 ethnic $2. @33 sex $1. @34 educat $2.;

label  caseid= "IMA Case Number"                  
	clientid="IMA client Number"
	dob="Date of birth"
	educat="Educational Level"            
	ethnic="Ethnicity"                         
	partcode="Participation Code"           
	relcode = "Relationship Code"            
        sex="Sex";

format partcode $partcod. relcode $relcode. ethnic $ethfmt. dob Filedate mmddyy10.;


Filedate=mdy (&month,1,&year) ;
if dob = . then age = .u ;
	else age= floor(max((Filedate - dob)/365.25,0));

label Filedate="Date of file extract";
LABEL age="Age (years) as of &month/&year";
format age agefmt.; 

if not missing (age) then 
 do;
	if age > 55 then AdultAge=4;
	else if age >40 and age <=55 then AdultAge=3;
	else if age >25 and age <=40 then AdultAge=2;
	else if age >=18 and age <=25 then AdultAge=1;
	else if age >=0 then AdultAge =.n;

	if age > 12 and age <18  then ChildAge=5;
	else if age >= 6 and age <=12  then ChildAge=4;
	else if age > 1 and age <6  then ChildAge=3;
	else if age > 0 and age <= 1  then ChildAge=2;
	else if age <= 0 then ChildAge=1;
	else if age >=18 then ChildAge=.n;
 end;
else 
 do;
	AdultAge=.u;
	ChildAge=.u;
 end;
				
	label AdultAge= "Adult age category (as of &month/&year)" ;
	label ChildAge= "Child age category (as of &month/&year)";

	format AdultAge adulfmt. ChildAge chilfmt.;

*I identified which are "IN" or full participants;
	if partcode = "IN" then FULPART=1;
	else if partcode ne "" then FULPART=0;

*Made dummy variables for children age ranges ;
	if ChildAge =1 then UNBORN=1;
	else UNBORN=0;
	if ChildAge = 2 then INFANT=1;
	else INFANT=0;
	if ChildAge = 3 then TODD=1;
	else TODD=0;
	if ChildAge =4 then PRETEEN=1;
	else PRETEEN=0;
	if ChildAge = 5 then TEEN=1;
	else TEEN=0;
	
	Child = sum (INFANT, TODD, PRETEEN, TEEN) ;
	label Child = "Child <18 years (does not include unborn)" ;
	label Fulpart = "Full participant" ;
	label Unborn = "Unborn child" ;
	label Infant = "Infant" ;
	label Todd = "Toddler" ;
	label Preteen = "Preteen" ;
	label Teen = "Teen" ;

*Make dummy to identify the number of adults;

	if age >=18 then ADULT=1;
	else if age <18 then ADULT=0;
	label adult = "Adult >=18 years";	
*Make dummy to identify the number of Primary informants (seems to be head
of household);


	if relcode = "PI" then PI=1 ;
	else if relcode ne "" then PI=0;
	label PI = "Primary Informant";
run;        
proc sort data= Tanf.Tanf_&year._&month._client  ;
	by caseid clientid;
	run;

*read in raw case file data;
 
%Data_to_format (FmtName=$remap, InDS=Tanf.dcconv1980, value=Tract_dc, label=geo80, otherlabel=" ", print=n)

data TANF.TANF_&year._&month._case (label="TANF cases, DC, &month/&year, case-level data");
	infile "&rawfolder\&case" truncover lrecl=12;
	input @1 caseid $8. @9 tract_DC $3. @12 language $1.;
	format language $lang.; 
	label  tract_DC = "DC census tracts" (caseid="IMA Case Number" language="Language Spoken");
	length geo1980 $11;
	geo1980 = put(Tract_dc, $remap. );
	label geo1980="Full census tract ID (1980): ssccctttttt";
run;

proc sort data= Tanf.Tanf_&year._&month._case  ;
	by caseid;
	run;
*Julie, check to see if syntax is correct;
data Tanf.Tanf_&Year._&month (label="TANF client case data &month/&year, DC" drop=dob clientid caseid);
merge TANF.TANF_&year._&month._case (in=case) TANF.TANF_&year._&month._client (in=client);
	by caseid;
	if case and not client then put caseid= 'Caseid that does not have a matching client record';
	else if client and not case then put client= 'Clientid that does not have a matching case record';
	retain uicaseid uiclientid 0;
	if first.caseid then 
	 do;
		uicaseid=uicaseid+1;
		uiclientid=1;
	 end;
	else 
	 do;
		uiclientid=uiclientid+1;
	 end;
	label 	uicaseid = "UI Case Number"
			uiclientid = "UI Client Number";
run;


%File_info( data=Tanf.Tanf_&year._&month._case, stats=, freqvars=language )
%File_info( data=Tanf.Tanf_&year._&month._client, freqvars=educat ethnic 
	partcode relcode sex AdultAge ChildAge Fulpart Unborn Infant Todd Preteen 
	Teen Child Adult PI)
%File_info( data=Tanf.Tanf_&Year._&month )
%mend Read_Tanf_mac;

