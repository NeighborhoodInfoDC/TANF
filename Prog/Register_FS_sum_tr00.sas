/**************************************************************************
 Program:  Register_FS_sum_tr00.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/06/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Register metadata for the FS_sum_tr00 data set.

 Modifications:
 12/20/10 RAG Updated with FS_2010_01
 12/21/10 RAG Added missing years
 03/09/11 RAG Updated with FS_2011_01
 09/30/11 RMP Updated with FS_2011_07
 09/30/12 BJL Updated with FS_2012_07
 03/18/13 BJL Updated with FS_2013_01
 04/23/14 MSW Updated with FS_2013_07
 04/24/14 MSW Updated with FS_2014_01
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( Tanf, local=n )

/**rsubmit;**/

%let revisions = Updated with FS_2014_01.;

%Dc_update_meta_file(
  ds_lib=Tanf,
  ds_name=FS_sum_tr00,
  creator_process=FS_sum_tr00.sas,
  restrictions=Confidential,
  revisions=%str(&revisions)
)

run;

/**endrsubmit;

signoff;**/
