/**************************************************************************
 Program:  FS_sum_all.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/20/06
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all summary files from FS tract summary file.

 Modifications:
	06/06/07 EHG Updated with FS_2007_01 data
	12/20/10 RAG Updated with FS_2010_01
    12/21/10 RAG Added missing years
	03/09/11 RAG Updated with FS_2011_01
    10/04/11 RMP Updated with FS_2011_07
    09/09/12 PAT Updated for new 2010/2012 geos.
    03/18/13 RMP Updated with FS_2013_01
    04/23/14 MSW Updated for FS_2013_07 and modified for SAS server
    04/24/14 MSW Updated for FS_2014_01
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF, local=n )

/**rsubmit;**/

%Create_all_summary_from_tracts( 

  /** Change to N for testing, Y for final batch mode run **/
  register=Y,
  
  /** Update with information on latest file revision **/
  /*revisions=%str(Updated with FS_2012_01.),*/
  revisions=%str(Updated with FS_2014_01.),

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

/**endrsubmit;

signoff;**/

