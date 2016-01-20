/**************************************************************************
 Program:  Register_tanf_2013_07.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   Maia Woluchem	
 Created:  4/23/14
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register TANF extract data set.

 Modifications:

04/17/14 - MSW - Modified for 2013_07 and for the SAS1 server.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( Tanf, local=n )

%let revisions = Updated with Tanf_2013_07.;

/**rsubmit;**/

%Register_tanf_fs( 
  data = tanf_2013_07, 
  revisions = %str(&revisions.) 
)

run;

/**endrsubmit;

signoff;**/
