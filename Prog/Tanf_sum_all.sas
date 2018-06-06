/**************************************************************************
 Program:  Tanf_sum_all.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/20/06
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all summary files from TANF tract summary file.

 Modifications:
 08/20/06 PT  Updated with Tanf_2006_07.
 06/04/07 EHG Updated with Tanf_2007_01.
 12/20/10 RAG Updated with Tanf_2010_01.
 12/21/10 RAG Added missing years.
 03/07/11 RAG Updated with Tanf_2011_01.
 10/04/11 RMP Updated with Tanf_2011_07.
  09/09/12 PAT Updated for new 2010/2012 geos.
10/04/12 BJL Updated with Tanf_2012_07.
03/18/13 BJL Updated with Tanf_2013_01.
04/23/14 MSW Updated with Tanf_2013_07.
04/24/14 MSW Updated with Tanf_2014_01.
04/15/16 JD Updated with Tanf_2014_07.
04/15/16 JD Updated with Tanf_2015_01.
08/01/17 RP Updated through Tanf_2016_07.
06/04/18 YS Updated to include Stanton Commons in summary
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF )


%Create_all_summary_from_tracts( 

  /** Change to N for testing, Y for final batch mode run **/
  finalize=Y,
  
  /** Update with information on latest file revision **/
  revisions=%str(Add StantonCommons to Summary),

  /*---------- DO NOT CHANGE BELOW THIS LINE ----------*/

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

