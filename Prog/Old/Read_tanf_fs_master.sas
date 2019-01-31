/**************************************************************************
 Program:  Read_tanf_fs_master.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Read TANF and FS raw data files into SAS.

 Modifications:
  09/12/06 PAT Added subtotals by race.
  10/18/06 PAT Revised age group variable names.
  11/19/06 PAT Reordered client data so PI is first name.
               Added Fam_type (family type) variable.
  3/10/08  LWG Added new multiracial variable mult_rac and new ehtnic
               categories.
  9/16/08  PAT Allow tracts from different years.
  12/22/10 PAT Added labels for vars Tract_full and Tract_yr.
**************************************************************************/

%macro Read_tanf_fs_master( 
  prefix =,
  label =,
  abbr =,
  rawfolder = ,
  client = , 
  case = ,  
  year =,  
  month =,
  corrections=
);

** Read in raw client data **;

data TANF.&prefix.client_&year._&month. (label="&label cases, DC, &month/&year, client-level data");

  infile "&rawfolder\&year-&month\&client" stopover lrecl=35 pad;

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

  format partcode $partcod. relcode $relcode. ethnic $tanrace. sex $tansex. dob Filedate mmddyy10.;

  Filedate=mdy (&month,1,&year) ;
  Filedate_year = &year;
  if dob = . then age = .u ;
    else age= floor(max((Filedate - dob)/365.25,0));

  label Filedate="Date of file extract";
  label Filedate_year="Year of file extract";
  LABEL age="Age (years as of &month/&year, UI calculated)";
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
  
  &prefix.client = 1;
  label &prefix.client = "Persons receiving &abbr";

  *I identified which are "IN" or full participants;
  if partcode = "IN" then &prefix.fulpart=1;
  else if partcode ne "" then &prefix.fulpart=0;

  *Made dummy variables for children age ranges ;
  if ChildAge =1 then &prefix.unborn=1;
  else &prefix.unborn=0;
  if ChildAge = 2 then &prefix.0to1=1;
  else &prefix.0to1=0;
  if ChildAge = 3 then &prefix.2to5=1;
  else &prefix.2to5=0;
  if ChildAge =4 then &prefix.6to12=1;
  else &prefix.6to12=0;
  if ChildAge = 5 then &prefix.13to17=1;
  else &prefix.13to17=0;
  
  &prefix.child = sum (&prefix.0to1, &prefix.2to5, &prefix.6to12, &prefix.13to17) ;
  label &prefix.child = "Children <18 years old (excluding unborn) receiving &abbr" ;
  label &prefix.fulpart = "Full &abbr participants" ;
  label &prefix.unborn = "Unborn children receiving &abbr" ;
  label &prefix.0to1 = "Infants <2 years old (excluding unborn) receiving &abbr" ;
  label &prefix.2to5 = "Toddlers 2-5 years old receiving &abbr" ;
  label &prefix.6to12 = "Preteens 6-12 years old receiving &abbr" ;
  label &prefix.13to17 = "Teens 13-17 years old receiving &abbr" ;

  *Make dummy to identify the number of adults;

  if age >=18 then &prefix.adult=1;
  else if age <18 then &prefix.adult=0;
  
  if 18 <= age < 25 then &prefix.18to24=1;
  else if age < 18 or age >= 25 then &prefix.18to24=0;
  
  label 
    &prefix.adult = "Adults 18+ years old receiving &abbr"
    &prefix.18to24 = "Young adults 18-24 years old receiving &abbr";  
  
  *Make dummy to identify the number of Primary informants (seems to be head of household);

  if relcode = "PI" then PI=1 ;
  else if relcode ne "" then PI=0;
  label PI = "Primary Informant";
  
  ** Sort order for clients **;
  
  select ( relcode );
    when ( "PI" ) sort_order = 1;
    when ( "SP" ) sort_order = 2;
    when ( "CP", "PF" ) sort_order = 3;
    otherwise sort_order = 9;
  end;
  
  ** Clients by race **;
  
  if ethnic ~= "UN" then do;
  
    &prefix.black = 0;
    &prefix.white = 0;
    &prefix.hisp = 0;
    &prefix.asian = 0;
    &prefix.oth_rac = 0;
    &prefix.mult_rac = 0;

    select ( ethnic );
      when ( "BL" ) &prefix.black = 1;
      when ( "WH" ) &prefix.white = 1;
      when ( "HI" ) &prefix.hisp = 1;
      when ( "AS" ) &prefix.asian = 1;
      when ( "AI", "OT", "HP" ) &prefix.oth_rac = 1;
	  when ( "AB", "AW", "BW", "MR", "SW") &prefix.mult_rac = 1; 
      otherwise do;
        %warn_put( msg="Invalid race/ethnicity code: " caseid= clientid= ethnic= )
      end;
    end;
    
    &prefix.w_race = 1;
    
  end;
  else do;
    &prefix.w_race = 0;
  end;
  
  label
    &prefix.black = "Non-Hisp. black persons receiving &abbr"
    &prefix.white = "Non-Hisp. white persons receiving &abbr"
    &prefix.hisp = "Hispanic persons receiving &abbr"
    &prefix.asian = "Non-Hisp. Asian persons receiving &abbr"
    &prefix.oth_rac = "Non-Hisp. other race persons receiving &abbr"
    &prefix.w_race = "Persons receiving &abbr with race reported"
    &prefix.mult_rac= "Multiracial persons receiving &abbr";

  %By_race( &prefix.adult, Adults, &prefix, &abbr )
  %By_race( &prefix.child, Children <18 years old (excl. unborn), &prefix, &abbr )
  %By_race( &prefix.unborn, Unborn children, &prefix, &abbr )
  %By_race( &prefix.0to1, Infants <2 years old (excl. unborn), &prefix, &abbr )
  %By_race( &prefix.6to12, Preteens 6-12 years old, &prefix, &abbr )
  %By_race( &prefix.13to17, Teens 13-17 years old, &prefix, &abbr )
  %By_race( &prefix.2to5, Toddlers 2-5 years old, &prefix, &abbr )
  %By_race( &prefix.18to24, Young adults 18-24 years old, &prefix, &abbr )

run;        

proc sort data= TANF.&prefix.client_&year._&month.  ;
  by caseid sort_order clientid;
  run;

** Determine if spouse present **;

data Spouse;

  set TANF.&prefix.client_&year._&month. (keep=caseid relcode sex age);
  by caseid;
  
  PI_present = 0;
  Female_HHH = 0;
  Male_HHH = 0;
  Spouse_present = 0;
  
  select ( relcode );

    when ( "PI" ) do;

      PI_present = 1;

      if sex = "F" then Female_HHH = 1;
      else if sex = "M" then Male_HHH = 1;
    
    end;
    
    when ( "SP", "CP", "PF" ) do;
    
      Spouse_present = 1;
    
    end;
    
    when ( "CH" ) do;
    
      Child_present = 1;
      
    end;
    
    otherwise do;
    
      if age < 18 then Child_present = 1;
      
    end;
    
  end;

run;

proc summary data=Spouse;
  by caseid;
  var PI_present Female_HHH Male_HHH Spouse_present Child_present;
  output out=Spouse_sum (drop=_type_ _freq_) max=;
run;

** Read in raw case file data **;

data TANF.&prefix.case_&year._&month. (label="&label cases, DC, &month/&year, case-level data");
  
  infile "&rawfolder\&year-&month\&case" stopover lrecl=12 pad;
  
  input @1 caseid $8. @9 tract_DC $3. @12 language $1.;
  
  format language $lang.; 
  
  label  
    tract_DC = "DC census tracts (1980, DC tract number)"
    caseid="IMA case number" 
    language="Language spoken";

/****    
  ** Create standard 1980 tract ID **;
    
  length geo1980 $11;
  
  geo1980 = put( put(Tract_dc, $tremap. ), $geo80v. );
  
  if tract_dc ~= "" and geo1980 = "" then do;
    %warn_put( msg="Invalid tract ID: " _n_= caseid= tract_dc= )
  end;
  
  ** Correct tract **;
  
  if Tract_dc = '7299' then geo1980 = '11001007200';
  
  label geo1980="Full census tract ID (1980): ssccctttttt";
*****/

  ** Create standard tract IDs **;

  length Tract_full $ 11;

  Tract_full = put( Tract_dc, $tremap. );

  if tract_full ~= "" then do;
    if put( tract_full, $geo80v. ) ~= "" then
      Tract_yr = 1980;
    else if put( tract_full, $geo00v. ) ~= "" then
      Tract_yr = 2000;
    else if put( tract_full, $geo90v. ) ~= "" then
      Tract_yr = 1990;
    else if put( tract_full, $geo70v. ) ~= "" then
      Tract_yr = 1970;
    else do;
      %warn_put( msg="Invalid tract ID: " _n_= caseid= tract_dc= tract_full= )
      tract_full = "";
    end;
  end;
  else if tract_dc not in ( "", "000" ) then do;
      %warn_put( msg="Invalid tract ID: " _n_= caseid= tract_dc= )
  end;
  
  label
    Tract_full = "Full census tract ID: ssccctttttt"
    Tract_yr   = "Year for census tract";

run;

%Dup_check(
  data=TANF.&prefix.case_&year._&month.,
  by=caseid,
  id=tract_dc language
)

proc sort data= TANF.&prefix.case_&year._&month. nodupkey;
  by caseid;
  run;

** Combine client & case data into single file **;

data Tanf.&prefix.&Year._&month 
       (label="&label client/case records, &month/&year, DC" 
        sortedby=uicaseid uiclientid);

  length uicaseid uiclientid 8;

  merge 
    TANF.&prefix.case_&year._&month. (in=case) 
    TANF.&prefix.client_&year._&month. (in=client)
    Spouse_sum;
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
    &prefix.case = 1;
    uicaseid=uicaseid+1;
    uiclientid=1;
   end;
  else 
   do;
    uiclientid=uiclientid+1;
   end;
   
  label   
    &prefix.case = "&abbr cases"
    uicaseid = "UI-generated case number"
    uiclientid = "UI-generated client number";
   
  ***Anytime need to make correct to a specific file; 
  &corrections;

 
  ** Family type **;
  
  length Fam_type $ 1;
  
  if PI_present then do;
  
    if Child_present then do;
    
      if Spouse_present then Fam_type = "3";
      else do;
        if Female_HHH then Fam_type = "1";
        else if Male_HHH then Fam_type = "2";
        else Fam_type = "5";
      end;
      
    end;
    else do;
    
      Fam_type = "5";
    
    end;
    
  end;
  else Fam_type = "4";

  label
    Fam_type = "Family (case) type (UI recode)";
  
  ** Family type summary variables **;

  &prefix.client_fsf = 0;
  &prefix.client_fsm = 0;
  &prefix.client_fcp = 0;
  &prefix.client_fch = 0;
  &prefix.client_fot = 0;
  
  select ( Fam_type );
    when ( "1" ) &prefix.client_fsf = 1;
    when ( "2" ) &prefix.client_fsm = 1;
    when ( "3" ) &prefix.client_fcp = 1;
    when ( "4" ) &prefix.client_fch = 1;
    when ( "5" ) &prefix.client_fot = 1;
  end;
  
  &prefix.case_fsf = &prefix.case * &prefix.client_fsf;
  &prefix.case_fsm = &prefix.case * &prefix.client_fsm;
  &prefix.case_fcp = &prefix.case * &prefix.client_fcp;
  &prefix.case_fch = &prefix.case * &prefix.client_fch;
  &prefix.case_fot = &prefix.case * &prefix.client_fot;
    
  &prefix.unborn_fsf = &prefix.unborn * &prefix.client_fsf;
  &prefix.unborn_fsm = &prefix.unborn * &prefix.client_fsm;
  &prefix.unborn_fcp = &prefix.unborn * &prefix.client_fcp;
  &prefix.unborn_fch = &prefix.unborn * &prefix.client_fch;
  &prefix.unborn_fot = &prefix.unborn * &prefix.client_fot;
    
  &prefix.child_fsf = &prefix.child * &prefix.client_fsf;
  &prefix.child_fsm = &prefix.child * &prefix.client_fsm;
  &prefix.child_fcp = &prefix.child * &prefix.client_fcp;
  &prefix.child_fch = &prefix.child * &prefix.client_fch;
  &prefix.child_fot = &prefix.child * &prefix.client_fot;
    
  &prefix.adult_fsf = &prefix.adult * &prefix.client_fsf;
  &prefix.adult_fsm = &prefix.adult * &prefix.client_fsm;
  &prefix.adult_fcp = &prefix.adult * &prefix.client_fcp;
  &prefix.adult_fch = &prefix.adult * &prefix.client_fch;
  &prefix.adult_fot = &prefix.adult * &prefix.client_fot;
  
  label
    &prefix.client_fsf = "Persons in single-female families receiving &abbr"
    &prefix.client_fsm = "Persons in single-male families receiving &abbr"
    &prefix.client_fcp = "Persons in couple families receiving &abbr"
    &prefix.client_fch = "Persons in child-only cases receiving &abbr"
    &prefix.client_fot = "Persons in other families receiving &abbr"
    &prefix.case_fsf = "&abbr cases, single-female families"
    &prefix.case_fsm = "&abbr cases, single-male families" 
    &prefix.case_fcp = "&abbr cases, couple families"
    &prefix.case_fch = "&abbr child-only cases"
    &prefix.case_fot = "&abbr cases, other family types"
    &prefix.unborn_fsf = "Unborn children in single-female families receiving &abbr"
    &prefix.unborn_fsm = "Unborn children in single-male families receiving &abbr"
    &prefix.unborn_fcp = "Unborn children in couple families receiving &abbr"
    &prefix.unborn_fch = "Unborn children in child-only cases receiving &abbr"
    &prefix.unborn_fot = "Unborn children in other families receiving &abbr"
    &prefix.child_fsf = "Children <18 years old (excl. unborn) in single-female families receiving &abbr"
    &prefix.child_fsm = "Children <18 years old (excl. unborn) in single-male families receiving &abbr"
    &prefix.child_fcp = "Children <18 years old (excl. unborn) in couple families receiving &abbr"
    &prefix.child_fch = "Children <18 years old (excl. unborn) in child-only cases receiving &abbr"
    &prefix.child_fot = "Children <18 years old (excl. unborn) in other families receiving &abbr"
    &prefix.adult_fsf = "Adults 18+ years old in single-female families receiving &abbr"
    &prefix.adult_fsm = "Adults 18+ years old in single-male families receiving &abbr"
    &prefix.adult_fcp = "Adults 18+ years old in couple families receiving &abbr"
    &prefix.adult_fch = "Adults 18+ years old in adult-only cases receiving &abbr"
    &prefix.adult_fot = "Adults 18+ years old in other families receiving &abbr";
  
  format pi dyesno. Fam_type $tanfam.;
  
  drop dob clientid caseid sort_order PI_present Female_HHH Male_HHH Spouse_present Child_present;
        
run;

** File summary statistics **;

proc print data=Tanf.&prefix.&Year._&month;
  where missing( tract_yr );
  var uicaseid uiclientid tract_DC Tract_full Tract_yr;
  title2 "Cases with missing tract";
run;

title2;

%File_info( data=Tanf.&prefix.&Year._&month, freqvars=filedate tract_yr educat ethnic language
  partcode relcode sex AdultAge ChildAge PI Fam_type )

proc freq data=Tanf.&prefix.&Year._&month;
  tables age;
  format age agefmt.;
  label age = "Age by groups";

run;
  
%mend Read_tanf_fs_master;

