/**************************************************************************
 Program:  FS_sum_tr00.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/18/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create 2000 tract-level summary indicators from 
 Food Stamp case/client data.

 Modifications:
  12/06/06 PAT Updated with new variables.
  06/06/07 EHG Updated with FS data from 01/01/2007
  09/17/08 PAT Added support for tracts in different years.
  09/19/08 LWG Updated with 2008_01 data
  10/03/08 LWG Updated with 2008_07 data
  12/20/10 RAG Updated with fs_2010_01.
  12/21/20 RAG Added missing years.
  03/08/11 RAG Updated with fs_2011_01.
  09/30/11 RMP Updated with fs_2011_07.
  09/30/12 BJL Updated with fs_2012_07.
  03/18/13 BJL Updated with fs_2013_01.
  04/23/14 MSW Updated with fs_2013_07 and modified for SAS1 Server.
  04/24/14 MSW Updated with fs_2014_01.
  04/15/16 JD Updated with fs_2014_07.
  04/15/16 JD Updated with fs_2015_01.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF )


%Sum_tr_mac( 

  /** Change to N for testing, Y for final batch mode run **/
  finalize = Y,

  /** Update with information on latest file revision **/
  revisions = %str(Updated with FS_2015_01.),

  /** Add new update data sets to this list **/
  input_data = 
    Tanf.FS_2000_07 (rename=(geo1980=tract_full))
    Tanf.FS_2001_01 (rename=(geo1980=tract_full)) 
    Tanf.FS_2001_07 (rename=(geo1980=tract_full)) 
    Tanf.FS_2002_01 (rename=(geo1980=tract_full))
    Tanf.FS_2002_07 (rename=(geo1980=tract_full))
    Tanf.FS_2003_01 (rename=(geo1980=tract_full))
    Tanf.FS_2003_07 (rename=(geo1980=tract_full))
    Tanf.FS_2004_01 (rename=(geo1980=tract_full))
    Tanf.FS_2004_07 (rename=(geo1980=tract_full))
    Tanf.FS_2005_01 (rename=(geo1980=tract_full))
    Tanf.FS_2005_07 (rename=(geo1980=tract_full))
    Tanf.FS_2006_01 (rename=(geo1980=tract_full))
    Tanf.FS_2006_07 (rename=(geo1980=tract_full))
    Tanf.FS_2007_01 (rename=(geo1980=tract_full)) 
    Tanf.FS_2007_07 (rename=(geo1980=tract_full)) 
    /** No rename after this point **/
    Tanf.FS_2008_01
    Tanf.FS_2008_07
	Tanf.FS_2009_01
	Tanf.FS_2009_07
	Tanf.FS_2010_01
	Tanf.FS_2010_07
	Tanf.FS_2011_01
	Tanf.FS_2011_07
	Tanf.FS_2012_01
	Tanf.FS_2012_07
	Tanf.FS_2013_01
	Tanf.FS_2013_07
	Tanf.FS_2014_01
	Tanf.FS_2014_07
	Tanf.FS_2015_01
	,

  /*---------- DO NOT CHANGE BELOW THIS LINE ----------*/

  sum_vars = 
    Fs_client Fs_fulpart Fs_unborn Fs_0to1 Fs_2to5 Fs_6to12
    Fs_13to17 Fs_child Fs_adult Fs_18to24 Fs_black Fs_white
    Fs_hisp Fs_asian Fs_oth_rac Fs_w_race Fs_adult_wht
    Fs_adult_blk Fs_adult_hsp Fs_adult_asn Fs_adult_oth
    Fs_adult_w_race Fs_child_wht Fs_child_blk Fs_child_hsp
    Fs_child_asn Fs_child_oth Fs_child_w_race Fs_unborn_wht
    Fs_unborn_blk Fs_unborn_hsp Fs_unborn_asn Fs_unborn_oth
    Fs_unborn_w_race Fs_0to1_wht Fs_0to1_blk Fs_0to1_hsp
    Fs_0to1_asn Fs_0to1_oth Fs_0to1_w_race Fs_6to12_wht
    Fs_6to12_blk Fs_6to12_hsp Fs_6to12_asn Fs_6to12_oth
    Fs_6to12_w_race Fs_13to17_wht Fs_13to17_blk Fs_13to17_hsp
    Fs_13to17_asn Fs_13to17_oth Fs_13to17_w_race Fs_2to5_wht
    Fs_2to5_blk Fs_2to5_hsp Fs_2to5_asn Fs_2to5_oth
    Fs_2to5_w_race Fs_18to24_wht Fs_18to24_blk Fs_18to24_hsp
    Fs_18to24_asn Fs_18to24_oth Fs_18to24_w_race Fs_case
    Fs_client_fsf Fs_client_fsm Fs_client_fcp Fs_client_fch
    Fs_client_fot Fs_case_fsf Fs_case_fsm Fs_case_fcp
    Fs_case_fch Fs_case_fot Fs_unborn_fsf Fs_unborn_fsm
    Fs_unborn_fcp Fs_unborn_fch Fs_unborn_fot Fs_child_fsf
    Fs_child_fsm Fs_child_fcp Fs_child_fch Fs_child_fot
    Fs_adult_fsf Fs_adult_fsm Fs_adult_fcp Fs_adult_fch
    Fs_adult_fot
    ,

  prefix = FS,

  label = Food Stamp

);


