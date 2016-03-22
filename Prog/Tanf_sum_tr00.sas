/**************************************************************************
 Program:  Tanf_sum_tr00.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/27/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create 2000 tract-level summary indicators from TANF
 case/client data.

 Modifications:
  12/06/06 PAT Updated with new variables.
  12/18/06 PAT Added Tanf_client Tanf_fulpart Tanf_unborn Tanf_0to1 
               Tanf_2to5 Tanf_6to12 Tanf_13to17 Tanf_child Tanf_adult 
               Tanf_18to24.
  08/27/06 PAT Updated with Tanf_2006_07.
  06/04/07 EHG Updated with Tanf_2007_01.
  09/17/08 PAT Added support for tracts in different years.
  09/19/08 LWG Updated with tanf_2008_01.
  10/03/08 LWG Updated with tanf_2008_07.
  12/20/10 RAG Updated with tanf_2010_01.
  12/21/10 RAG Added missing years.
  03/04/11 RAG Updated with tanf_2011_01.
  09/30/11 RMP Updated with tanf_2011_07.
10/08/12 BJL Updated with tanf_2012_07.
03/18/13 BJL Updated with tanf_2013_01.
04/17/14 MSW Updated with tanf_2013_07 and for the SAS1 Server.
04/24/14 MSW Updated with tanf_2014_01. 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF )


%Sum_tr_mac( 

  /** Change to N for testing, Y for final batch mode run **/
  finalize = Y,

  /** Update with information on latest file revision **/
  revisions = %str(Updated with Tanf_2014_01.),

  /** Add new update data sets to this list **/
  input_data = 
    Tanf.Tanf_1998_01 (rename=(geo1980=tract_full)) 
    Tanf.Tanf_1998_07 (rename=(geo1980=tract_full)) 
    Tanf.Tanf_1999_07 (rename=(geo1980=tract_full)) 
    Tanf.Tanf_2000_07 (rename=(geo1980=tract_full))
    Tanf.Tanf_2001_01 (rename=(geo1980=tract_full)) 
    Tanf.Tanf_2001_07 (rename=(geo1980=tract_full)) 
    Tanf.Tanf_2002_01 (rename=(geo1980=tract_full))
    Tanf.Tanf_2002_07 (rename=(geo1980=tract_full))
    Tanf.Tanf_2003_01 (rename=(geo1980=tract_full))
    Tanf.Tanf_2003_07 (rename=(geo1980=tract_full))
    Tanf.Tanf_2004_01 (rename=(geo1980=tract_full))
    Tanf.Tanf_2004_07 (rename=(geo1980=tract_full))
    Tanf.Tanf_2005_01 (rename=(geo1980=tract_full))
    Tanf.Tanf_2005_07 (rename=(geo1980=tract_full))
    Tanf.Tanf_2006_01 (rename=(geo1980=tract_full))
    Tanf.Tanf_2006_07 (rename=(geo1980=tract_full))
    Tanf.Tanf_2007_01 (rename=(geo1980=tract_full)) 
    Tanf.Tanf_2007_07 (rename=(geo1980=tract_full)) 
    /** No rename after this point **/
    Tanf.Tanf_2008_01
    Tanf.Tanf_2008_07
	Tanf.Tanf_2009_01
	Tanf.Tanf_2009_07
	Tanf.Tanf_2010_01
	Tanf.Tanf_2010_07
	Tanf.Tanf_2011_01
	Tanf.Tanf_2011_07
	Tanf.Tanf_2012_01
	Tanf.Tanf_2012_07
	Tanf.Tanf_2013_01
	Tanf.Tanf_2013_07
	Tanf.Tanf_2014_01
    ,

  /*---------- DO NOT CHANGE BELOW THIS LINE ----------*/

  sum_vars = 
    Tanf_client Tanf_fulpart Tanf_unborn Tanf_0to1 Tanf_2to5
    Tanf_6to12 Tanf_13to17 Tanf_child Tanf_adult Tanf_18to24
    Tanf_black Tanf_white Tanf_hisp Tanf_asian Tanf_oth_rac
    Tanf_w_race Tanf_adult_wht Tanf_adult_blk Tanf_adult_hsp
    Tanf_adult_asn Tanf_adult_oth Tanf_adult_w_race
    Tanf_child_wht Tanf_child_blk Tanf_child_hsp Tanf_child_asn
    Tanf_child_oth Tanf_child_w_race Tanf_unborn_wht
    Tanf_unborn_blk Tanf_unborn_hsp Tanf_unborn_asn
    Tanf_unborn_oth Tanf_unborn_w_race Tanf_0to1_wht
    Tanf_0to1_blk Tanf_0to1_hsp Tanf_0to1_asn Tanf_0to1_oth
    Tanf_0to1_w_race Tanf_6to12_wht Tanf_6to12_blk
    Tanf_6to12_hsp Tanf_6to12_asn Tanf_6to12_oth
    Tanf_6to12_w_race Tanf_13to17_wht Tanf_13to17_blk
    Tanf_13to17_hsp Tanf_13to17_asn Tanf_13to17_oth
    Tanf_13to17_w_race Tanf_2to5_wht Tanf_2to5_blk Tanf_2to5_hsp
    Tanf_2to5_asn Tanf_2to5_oth Tanf_2to5_w_race Tanf_18to24_wht
    Tanf_18to24_blk Tanf_18to24_hsp Tanf_18to24_asn
    Tanf_18to24_oth Tanf_18to24_w_race Tanf_case Tanf_client_fsf
    Tanf_client_fsm Tanf_client_fcp Tanf_client_fch
    Tanf_client_fot Tanf_case_fsf Tanf_case_fsm Tanf_case_fcp
    Tanf_case_fch Tanf_case_fot Tanf_unborn_fsf Tanf_unborn_fsm
    Tanf_unborn_fcp Tanf_unborn_fch Tanf_unborn_fot
    Tanf_child_fsf Tanf_child_fsm Tanf_child_fcp Tanf_child_fch
    Tanf_child_fot Tanf_adult_fsf Tanf_adult_fsm Tanf_adult_fcp
    Tanf_adult_fch Tanf_adult_fot       
    ,

  prefix = Tanf,

  label = TANF

);


