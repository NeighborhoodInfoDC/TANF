/**************************************************************************
 Program:  Register_tanf_yyyy_mm.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   
 Created:  
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register TANF extract data set.

 Modifications: 
 04/24/14 MSW Modified for SAS1 server and changed "Upload_tanf_fs" to "Register_tanf_fs"
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( Tanf, local=n )

/**rsubmit;**/

%Register_tanf_fs( 
  data = tanf_yyyy_mm, 
  revisions = %str(New file.) 
)

run;

/**endrsubmit;

signoff;**/
