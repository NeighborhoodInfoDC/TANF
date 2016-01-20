/**************************************************************************
 Program:  Register_tanf_yyyy_mm.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   Maia Woluchem
 Created:  4/24/14
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register TANF extract data set.

 Modifications: 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( Tanf, local=n )

/**rsubmit;**/

%Register_tanf_fs( 
  data = tanf_2014_01, 
  revisions = %str(Updated with Tanf_2014_01) 
)

run;

/**endrsubmit;

signoff;**/
