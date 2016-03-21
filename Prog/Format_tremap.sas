/**************************************************************************
 Program:  Format_tremap.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create format $TREMAP. for remapping tracts in 
 TANF/FS files from DC to standard format.

 Modifications:
  09/16/08 PAT Now can use other tract years besides 1980.
  10/03/11 PAT Now runs on Alpha.
  10/13/12 BJL Added new tract definitions
  03/21/16 PAT Updated for SAS1.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF )

** Add missing tracts to file **;

data add_tracts;

  length tract_dc $ 3 geo $ 11;
  
  tract_dc = "071";
  geo = "11001000701";
  output;
  
  tract_dc = "701";
  geo = "11001000701";
  output;
  
  tract_dc = "541";
  geo = "11001005401";
  output;
  
  tract_dc = "571";
  geo = "11001005701";
  output;
  
  tract_dc = "131";
  geo = "11001001301";
  output;
  
  tract_dc = "989";
  geo = "11001009809";
  output;
  
  tract_dc = "621";
  geo = "11001006201";
  output;
  
  tract_dc = "97";
  geo = "11001009700";
  output;
  
  tract_dc = "052";
  geo = "11001000502";
  output;
  
  tract_dc = "532";
  geo = "11001005302";
  output;
  
  tract_dc = "542";
  geo = "11001005402";
  output;
  
  tract_dc = "572";
  geo = "11001005702";
  output;
  
  tract_dc = "091";
  geo = "11001000901";
  output;
  
  tract_dc = "092";
  geo = "11001000902";
  output;
  
  tract_dc = "282";
  geo = "11001002802";
  output;

  tract_dc = "900";
  geo = "11001009000";
  output;

  tract_dc = "021";
  geo = "11001000201";
  output;

  tract_dc = "O17";
  geo = "11001001700";
  output;

  tract_dc = "471";
  geo = "11001004701";
  output;

  tract_dc = "2";
  geo = "11001000200";
  output;

  
run;

data tremap;

  set Tanf.dcconv1980 (rename=(geo80=geo)) add_tracts;
  
run;

%Data_to_format(
  FmtLib=TANF,
  FmtName=$tremap, 
  Desc="Remap tracts from DC to std format",
  InDS=tremap,
  value=Tract_dc, 
  label=geo, 
  otherlabel="", 
  print=y,
  contents=y
)

run;

