************************************************************************
* Program:  Kids_count_table.sas
* Library:  Tanf
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  10/19/04
* Version:  SAS 8.2
* Environment:  Windows
* 
* Description:  Kids Count table for TANF and food stamps data.
*
* Modifications:
*  10/22/04  Excluded PIs from TANF kids (consistent w/IMA def.)  PT
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Tanf )

proc format;
value $ethfmt (notsorted)
"WH" = "White" 
"BL" = "Black"
"HI" = "Hispanic"
"OT","AI","AS" = "Other"
"UN", "  " = "Unknown"
;

proc tabulate data=Tanf.tanfclie200407 noseps missing;
  where '01jul2004'd - dob < ( 365.25 * 18 ) and relcode ~= "PI";
  class ethnic /preloadfmt order=data;
  table
    n='Number of Children rec. TANF'*f=comma12.0
    rowpctn='% of child rec.'*f=comma12.2,
    all='Total' ethnic;
  title3 'Welfare Indicators (July 2004)';
  title4 'By Race/Ethnicity';

run;

proc tabulate data=Tanf.tanf_2004_07_client noseps missing;
  where '01jul2004'd - dob < ( 365.25 * 18 );
  class ethnic /preloadfmt order=data;
  table
    n='Number of Children rec. Food Stamps'*f=comma12.0
    rowpctn='% of child rec.'*f=comma12.2,
    all='Total' ethnic;

run;

proc tabulate data=Tanf.Tanf_fstamps_wd01 noseps missing;
  where ward2001 ~= 'M';
  class ward2001;
  var tanf_child fstamps_child;
  table
    sum='Number of Children rec. TANF'*tanf_child=' '*f=comma8.0
    rowpctsum='% of child rec.'*tanf_child=' '*f=comma8.1,
    all='Total' ward2001='Wards';
  table
    sum='Number of Children rec. Food Stamps'*fstamps_child=' '*f=comma8.0
    rowpctsum='% of child rec.'*fstamps_child=' '*f=comma8.1,
    all='Total' ward2001='Wards';
  title3 'Welfare Indicators (July 2004)';
  title4 'By Ward';

run;
