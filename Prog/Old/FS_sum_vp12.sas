/**************************************************************************
 Program:  FS_sum_vp12.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/20/06
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all summary files from FS tract summary file.

 TEMPORARY PROGRAM TO CREATE VOTER PRECINCT SUMMARY FILE. 

 Modifications:
	06/06/07 EHG Updated with FS_2007_01 data
	12/20/10 RAG Updated with FS_2010_01
    12/21/10 RAG Added missing years
	03/09/11 RAG Updated with FS_2011_01
    10/04/11 RMP Updated with FS_2011_07
  09/09/12 PAT Updated for new 2010/2012 geos.
3/18/13 RMP Updated with FS_2013_01
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( TANF )

rsubmit;

/**************************************************************************
 Program:  Create_all_summary_from_tracts.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/29/06
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Autocall macro for creating all summary level files
 from a tract level summary file.

 Modifications:
  08/27/06 PAT Added REVISIONS= parameter.
  09/26/06 PAT Added LIB= parameter.
  12/22/10 PAT Added MPRINT= parameter.
  07/14/12 PAT Removed casey_nbr2003 and casey_ta2003 from list of geos.
               Added Anc2012, Ward2012, and Psa2010.
               Added TRACT_YR= parameter for specifying source tract year.
               DISABLED ALL GEOS EXCEPT WARDS FOR TESTING.
  07/21/12 PAT Added tract-level summary for 2010 (if based on 2000 tracts)
               or for 2000 (if based on 2010).
  09/09/12 PAT Final production version for all geos.
  12/17/12 PAT Added summary for voting precincts (VoterPre2012).
**************************************************************************/

/** Macro Create_all_summary_from_tracts - Start Definition **/

%macro Create_all_summary_from_tracts( 
  lib=,
  data_pre=,
  data_label=,
  count_vars=, 
  prop_vars=, 
  calc_vars=, 
  calc_vars_labels=,
  tract_yr=2000,
  register=n,
  creator_process=,
  restrictions=,
  revisions=,
  mprint=n
);

  %Create_summary_from_tracts( geo=voterpre2012, 
    lib=&lib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&register, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

%mend Create_all_summary_from_tracts;

/** End Macro Definition **/


%Create_all_summary_from_tracts( 

  /** Change to N for testing, Y for final batch mode run **/
  register=Y,
  
  /** Update with information on latest file revision **/
  /*revisions=%str(Updated with FS_2012_01.),*/
  revisions=%str(Updated with FS_2013_01.),

  lib=Tanf,
  data_pre=FS_sum, 
  data_label=%str(Food Stamp client/case summary, DC),
  count_vars=fs_:, 
  prop_vars=, 
  calc_vars=, 
  calc_vars_labels=,
  creator_process=FS_sum_all.sas,
  restrictions=Confidential
)

run;

endrsubmit;

signoff;

