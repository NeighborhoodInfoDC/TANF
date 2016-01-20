/**************************************************************************
 Program:  Register_fs_yyyy_mm.sas
 Library:  Tanf
 Project:  NeighborhoodInfo DC
 Author:   Maia Woluchem
 Created:  04/23/14
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register food stamp extract data set.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( Tanf, local=n )

/**rsubmit;**/

%Register_tanf_fs( 
  data = fs_2013_07, 
  revisions = %str(Updated 2013_07.) 
)

run;

/**endrsubmit;

signoff;**/
