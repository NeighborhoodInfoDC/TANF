/**************************************************************************
 Program:  Tanf_sum_all.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/20/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all summary files from TANF 2000 tract summary file.

 Modifications:
 08/20/06 PT  Updated with Tanf_2006_07.
 06/04/07 EHG Updated with Tanf_2007_01.
 12/20/10 RAG Updated with Tanf_2010_01.
 12/21/10 RAG Added missing years.
 03/07/11 RAG Updated with Tanf_2011_01.
 10/04/11 RMP Updated with Tanf_2011_07.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
/***%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;***/

** Define libraries **;
%DCData_lib( TANF )

/***************** MACRO TESTING ******************/
filename MacTest 'D:\DCData\SAS\Macros\Test';
%MacroSearch( cat=MacTest, action=B )
/**************************************************/

/***rsubmit;***/

%Create_all_summary_from_tracts( 

  register=N,
  revisions=%str(Updated with Tanf_2011_07),

  lib=Tanf,
  data_pre=Tanf_sum, 
  data_label=%str(TANF client/case summary, DC),
  count_vars=tanf_:, 
  prop_vars=, 
  calc_vars=, 
  calc_vars_labels=,
  creator_process=Tanf_sum_all.sas,
  restrictions=Confidential
)

run;

libname archive "D:\DCData\Libraries\TANF\Data\Archive";

proc compare base=archive.tanf_sum_wd02 compare=tanf.tanf_sum_wd02 maxprint=(40,32000);
  id ward2002;
run;

/***endrsubmit;***/

/***signoff;***/

