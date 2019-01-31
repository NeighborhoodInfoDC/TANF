/************************************************************************
* Program:  Read_FS_2004_07.sas
* Library:  TANF
* Project:  DC Data Warehouse
* Authors:  Julie Fenderson
* Created:  6/16/05
* Version:  SAS 8.12
* Environment:  Windows
* Description:  This program uses the macro in Read_FS_mac.sas to read
*	in raw TANF data, format it, aggregate, and merge. Figures out which cases
*	have PIs and which don't, and figures out the number of adults and kids in each case. 
*	Aggregates client level data to case level and merges them to case data, 
*	which includes DC proxy 1980 tracts. Also, changed DC (proxy) tracts to 1980
*
* Modifications: 1/25 by JF
*
************************************************************************/
%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

**Define libraries**;
%DCData_lib( TANF );

*NEED TO UPDATE THE FOLLOWING VARIABLES -- SHOULD BE ONLY SECTION NECESSARY TO UPDATE;


%Read_FS_mac(
rawfolder=D:\DCData\Libraries\TANF\Raw,
client=DHSA0218_FS200407.txt,
case=DHSA0216_FS200407.txt,
year =2004,
month =07);
