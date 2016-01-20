/**************************************************************************
 Program:  By_race.sas
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/10/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to generate summary variables by race.

 Modifications: Modified 3/10/08 by LWG, added new multiracial category
**************************************************************************/

/** Macro By_race - Start Definition **/

/**%By_race( Tanf_adult, adults, TANF )**/

%macro By_race( var, cat, prefix, type );

  %let lcat = %lowcase(&cat);

  &var._wht = &var * &prefix.white;
  &var._blk = &var * &prefix.black;
  &var._hsp = &var * &prefix.hisp;
  &var._asn = &var * &prefix.asian;
  &var._oth = &var * &prefix.oth_rac;
  &var._mlt = &var * &prefix.mult_rac;

  label 
    &var._wht = "Non-Hisp. white &lcat receiving &type"
    &var._blk = "Non-Hisp. black &lcat receiving &type"
    &var._hsp = "Hispanic &lcat receiving &type"
    &var._asn = "Asian &lcat receiving &type"
    &var._oth = "Non-Hisp. other race &lcat receiving &type"
	&var._mlt = "Multiracial &lcat receiving &type"
  ;
  
  &var._w_race = &var * &prefix.w_race;
  
  label &var._w_race = "&cat with race reported receiving &type";
    
%mend By_race;

/** End Macro Definition **/

