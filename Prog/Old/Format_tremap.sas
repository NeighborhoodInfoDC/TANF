/**************************************************************************
 Program:  Format_tremap.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create format $TREMAP. for remapping tracts in 
 TANF/FS files from DC to standard format.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

** Add missing tracts to file **;

data add_tracts;

  length tract_dc $ 3 geo80 $ 11;
  
  tract_dc = "071";
  geo80 = "11001000701";
  
  output;
  
  tract_dc = "701";
  geo80 = "11001000701";
  
  output;
  
  tract_dc = "541";
  geo80 = "11001005401";
  
  output;
  
  tract_dc = "571";
  geo80 = "11001005701";
  
  output;
  
  tract_dc = "131";
  geo80 = "11001001301";
  
  output;
  
  tract_dc = "989";
  geo80 = "11001009809";
  
  output;
  
  tract_dc = "621";
  geo80 = "11001006201";
  
  output;
  
  tract_dc = "97";
  geo80 = "11001009700";
  
  output;
  
  tract_dc = "052";
  geo80 = "11001000502";
  
  output;
  
  tract_dc = "532";
  geo80 = "11001005302";
  
  output;
  
  tract_dc = "542";
  geo80 = "11001005402";
  
  output;
  
  tract_dc = "572";
  geo80 = "11001005702";
  
  output;
  
  tract_dc = "091";
  geo80 = "11001000901";
  
  output;
  
  tract_dc = "092";
  geo80 = "11001000902";
  
  output;
  
run;

data tremap;

  set Tanf.dcconv1980 add_tracts;
  
run;

%Data_to_format(
  FmtLib=TANF,
  FmtName=$tremap, 
  Desc="Remap 1980 tracts from DC to std format",
  InDS=tremap,
  value=Tract_dc, 
  label=geo80, 
  otherlabel="", 
  print=y,
  contents=y
)

run;
