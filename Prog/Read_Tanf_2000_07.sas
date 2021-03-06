/************************************************************************
* Program:  Read_Tanf_2000_07.sas
* Library:  TANF
* Project:  DC Data Warehouse
* Authors:  Julie Fenderson
* Created:  4/13/02 -- based on Kathy's DCTABLES.sas
* Version:  SAS 8.12
* Environment:  Windows
* Description:  This program uses the macro in Read_Tanf_mac.sas to read
*	in raw TANF data, format it, aggregate, and merge. Figures out which cases
*	have PIs and which don't, and figures out the number of adults and kids in each case. 
*	Aggregates client level data to case level and merges them to case data, 
*	which includes DC proxy 1980 tracts. Also, changed DC (proxy) tracts to 1980
*
* Modifications: 2/8 by JF
*
************************************************************************/
%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

**Define libraries**;
%DCData_lib( TANF );

*NEED TO UPDATE THE FOLLOWING VARIABLES -- SHOULD BE ONLY SECTION NECESSARY TO UPDATE;


%Read_Tanf_mac(
rawfolder=D:\DCData\Libraries\TANF\Raw,
client=client200007.txt,
case=case200007.txt,
year =2000,
month =07);
