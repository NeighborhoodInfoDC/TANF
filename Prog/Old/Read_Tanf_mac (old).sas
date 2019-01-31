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
   08/20/06  PAT Renamed summary variables ADULT, CHILD,... to 
                 TANF_ADULT, TANF_CHILD,...
************************************************************************/

%macro Read_Tanf_mac( 
  rawfolder = D:\DCData\Libraries\TANF\Raw,
  client = DHSA0218AF.txt, 
  case = DHSA0216AF.txt,  
  year =,  
  month =
);

** Read in raw client data **;

data TANF.TANF_&year._&month._client (label="TANF cases, DC, &month/&year, client-level data");

infile "&rawfolder\&year-&month\&client" truncover lrecl=35;
input @1 caseid $8. @9 clientid $10. @19 relcode $2. @21 partcode $2. 
	@23 DOB yymmdd8. @31 ethnic $2. @33 sex $1. @34 educat 2.;

** Recode missing values **;

if ethnic = "" then ethnic = "UN";
if sex = "" then sex = "U";

label  caseid= "IMA case number"                  
	clientid="IMA client number"
	dob="Date of birth"
	educat="Educational level (years of education)"            
	ethnic="Race/ethnicity"                         
	partcode="Participation code"           
	relcode = "Relationship code"            
      sex="Sex";

format partcode $partcod. relcode $relcode. ethnic $ethfmt. sex $sex. dob Filedate mmddyy10.;


Filedate=mdy (&month,1,&year) ;
Filedate_year = &year;
if dob = . then age = .u ;
	else age= floor(max((Filedate - dob)/365.25,0));

label Filedate="Date of file extract";
label Filedate_year="Year of file extract";
LABEL age="Age (years as of &month/&year)";
**format age agefmt.; 

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
	
	Tanf_client = 1;
	label Tanf_client = "Persons receiving TANF benefits";

*I identified which are "IN" or full participants;
	if partcode = "IN" then Tanf_fulpart=1;
	else if partcode ne "" then Tanf_fulpart=0;

*Made dummy variables for children age ranges ;
	if ChildAge =1 then Tanf_unborn=1;
	else Tanf_unborn=0;
	if ChildAge = 2 then Tanf_infant=1;
	else Tanf_infant=0;
	if ChildAge = 3 then Tanf_todd=1;
	else Tanf_todd=0;
	if ChildAge =4 then Tanf_preteen=1;
	else Tanf_preteen=0;
	if ChildAge = 5 then Tanf_teen=1;
	else Tanf_teen=0;
	
	Tanf_child = sum (Tanf_infant, Tanf_todd, Tanf_preteen, Tanf_teen) ;
	label Tanf_child = "Children <18 years old (excluding unborn) receiving TANF" ;
	label Tanf_fulpart = "Full TANF participants" ;
	label Tanf_unborn = "Unborn children receiving TANF" ;
	label Tanf_infant = "Infants <2 years old (does not include unborn) receiving TANF" ;
	label Tanf_todd = "Toddlers 2-5 years old receiving TANF" ;
	label Tanf_preteen = "Preteens 6-12 years old receiving TANF" ;
	label Tanf_teen = "Teens 13-17 years old receiving TANF" ;

*Make dummy to identify the number of adults;

	if age >=18 then Tanf_adult=1;
	else if age <18 then Tanf_adult=0;
	label Tanf_adult = "Adults 18+ years old receiving TANF";	
*Make dummy to identify the number of Primary informants (seems to be head
of household);


	if relcode = "PI" then PI=1 ;
	else if relcode ne "" then PI=0;
	label PI = "Primary Informant";
run;        
proc sort data= Tanf.Tanf_&year._&month._client  ;
	by caseid clientid;
	run;

** Read in raw case file data **;

data TANF.TANF_&year._&month._case (label="TANF cases, DC, &month/&year, case-level data");
	
	infile "&rawfolder\&year-&month\&case" truncover lrecl=12;
	
	input @1 caseid $8. @9 tract_DC $3. @12 language $1.;
	
	format language $lang.; 
	
	label  
	  tract_DC = "DC census tracts (1980, IMA pseudo-tract number)"
	  caseid="IMA case number" 
	  language="Language spoken";
	  
	** Create standard 1980 tract ID **;
	  
	length geo1980 $11;
	
	geo1980 = put(Tract_dc, $tremap. );
	
	if tract_dc ~= "" and geo1980 = "" then do;
	  %warn_put( msg="Invalid tract ID: " _n_= caseid= tract_dc= )
	end;
	
	label geo1980="Full census tract ID (1980): ssccctttttt";
	
run;

proc sort data= Tanf.Tanf_&year._&month._case  ;
	by caseid;
	run;

** Combine client & case data into single file **;

data Tanf.Tanf_&Year._&month 
       (label="TANF client/case records, &month/&year, DC" 
        drop=dob clientid caseid
        sortedby=uicaseid uiclientid);

  length uicaseid uiclientid 8;

  merge 
    TANF.TANF_&year._&month._case (in=case) 
    TANF.TANF_&year._&month._client (in=client);
  by caseid;
	
	** Check for mismatched case/client records **;
	
	if case and not client then do;
	  %warn_put( msg=caseid= 'Caseid does not have a matching client record' );
	end;  
	else if client and not case then do;
	  %warn_put( msg=client= 'Clientid does not have a matching case record' );
	end;
	
	** Create unique case and client ID numbers to replace IMA ID numbers **;
	
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
	label 	uicaseid = "UI-generated case number"
			uiclientid = "UI-generated client number";
			
	format tanf_: pi dyesno. ;
	
run;


/*
%File_info( data=Tanf.Tanf_&year._&month._case, stats=, freqvars= )
%File_info( data=Tanf.Tanf_&year._&month._client)
*/

%File_info( data=Tanf.Tanf_&Year._&month, freqvars=filedate educat ethnic language
	partcode relcode sex AdultAge ChildAge PI Tanf_: )

proc freq data=Tanf.Tanf_&Year._&month;
  tables age;
  format age agefmt.;
  label age = "Age by groups";

run;
	
%mend Read_Tanf_mac;

