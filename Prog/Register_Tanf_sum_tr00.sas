/**************************************************************************
 Program:  Register_Tanf_sum_tr00.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/06/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Register metadata for the Tanf_sum_tr00 data set.

 Modifications:
  12/06/06 PT  Updated with Tanf_2006_07.
  06/04/07 EHG Updated with Tanf_2007_01.
  10/31/2008 LWG Added missing multiracial variables
  12/20/10 RAG Updated with Tanf_2010_01.
  12/21/10 RAG Added missing years.
  03/07/2011 RAG Updated with Tanf_2011_01.
  09/30/11 RMP Updated with tanf_2011_07.
09/30/12 BJL Updated with tanf_2012_07.
03/18/13 BJL Updated with tanf_2013_01
04/18/14 MSW Updated with tanf_2013_07.
04/24/14 MSW Updated with tanf_2014_01.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 


** Define libraries **;
%DCData_lib( Tanf, local=n )

/**rsubmit;**/

%let revisions = Updated with Tanf_2014_01.;

%Dc_update_meta_file(
  ds_lib=Tanf,
  ds_name=Tanf_sum_tr00,
  creator_process=Tanf_sum_tr00.sas,
  restrictions=Confidential,
  revisions=%str(&revisions.)
)

run;

/**endrsubmit;

signoff;**/
