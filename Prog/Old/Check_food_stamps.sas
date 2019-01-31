************************************************************************
* Program:  Check_food_stamps.sas
* Library:  Tanf
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  10/19/04
* Version:  SAS 8.2
* Environment:  Windows
* 
* Description:  Check food stamp data prepared by Julie.
*
* Modifications:
************************************************************************;

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Tanf )

%File_info( data=Tanf.tanf_2004_07_client )
%File_info( data=Tanf.tanf_2004_07_case )
%File_info( data=Tanf.dcconv1980 )

run;
