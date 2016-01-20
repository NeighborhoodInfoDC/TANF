/**************************************************************************
 Program:  FS_sum_all.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/20/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all summary files from FS 2000 tract summary file.

 Modifications:
	06/06/07 EHG Updated with FS_2007_01 data
	12/20/10 RAG Updated with FS_2010_01
    12/21/10 RAG Added missing years
	03/09/11 RAG Updated with FS_2011_01
    10/04/11 RMP Updated with FS_2011)07
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
  revisions=%str(Updated with FS_2011_07),

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

libname archive "D:\DCData\Libraries\TANF\Data\Archive";

proc compare base=archive.fs_sum_wd02 compare=tanf.fs_sum_wd02 maxprint=(40,32000);
  id ward2002;
run;

/***endrsubmit;***/

/***signoff;***/

