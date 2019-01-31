************************************************************************
* Program: Format_TANF.sas
* Library: TANF
* Project: DC Data Warehouse
* Author: Jenn Comey
* Created: 9/17/98
* Version:
* Environment: Windows
* Description: These are the formats of participants, relations, and for ages
* Modifications: 04/09/02 by JC and 8/30/04 by JF
***********************************************************************;
%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( TANF )

 


proc format library=TANF;
 
 value $partcod
"IN"= "Full participation"
"UB"= "Unborn child"
"DW"= "Child/jobs sanction"
"DF"= "Disqualified, fraud"
"DI"= "Disqualified, not for fraud";

 value $relcode (notsorted)
   "PI" = "Primary information (PI) person"
   "CH" = "Child (0-20 yrs) of PI"
   "AC" = "Adult child (>20 yrs) of PI"
   "PC" = "Pregnant child of PI"
   "SC" = "Step-child of PI"
   "FC" = "Foster child of PI"
   "GC" = "Grandchild of PI"
   "GG" = "Great-grandchild of PI"

   "CP" = "Child's parent, but not PI spouse"
   "PF" = "Putative father of PI"
   "AU" = "Aunt/uncle of PI"
   "CO" = "Cousin of PI"
   "GR" = "Grandparent of PI"
   "HA" = "Half-/step-sibling of PI"
   "IL" = "In-law of PI"
   "NN" = "Niece/nephew of PI"
   "PA" = "Parent of PI"
   "SB" = "Sibling of PI"
   "SP" = "Spouse of PI"
   "ST" = "Step-Parent of PI"
   "OR" = "Other relative of PI"
   "NR" = "Not related to PI"
 ;

value agefmt
low-<0 = "Unborn child"
0-<2 = "Infant to 1 year"
2-<4= "Child 2-3 years"    	
4-<6= "Child 4-5"    	
6-<13= "Child 6-12"    	
13-<18 = "Teenager 13-17"    	
18-<25 ="Young adult 18-24"
25-<40="Adult 25-39"
40-<55="Adult 40-54"
55-high="Adult 55 plus"	; 


value $agegrp
"g1" =  "Child age <=1"      
"g2" =  "Child age 2-3"      
"g3" =  "Child age 4-5"       
"g4" =  "Child age 6-12"      
"g5" =  "Child age 13-17"     
"g6" =  "Child age over 18"  ;

value adulfmt
1 =  "Adult age 18-24"      
2 =  "Adult age 25-39"      
3 =  "Adult age 40-54"       
4 =  "Adult age >55";	
	
value chilfmt
1 =  "Child age unborn"   
2 =  "Child age 0-1" 
3 =  "Child age 2-5"         
4 =  "Child age 6-12"      
5 =  "Child age 13-18" ;

value $ethfmt (notsorted)
"BL" = "Black"
"WH" = "White"
"HI" = "Hispanic"
"AS" = "Asian"
"AI" = "American Indian"
"OT" = "Other race"
"UN" = "Unknown"
 ;

value $lang
"E" = "English"
"S" = "Spanish";

value $sex
  "F" = "Female"
  "M" = "Male"
  "O" = "Other"
  "U" = "Unknown";
  
run; 


proc catalog catalog=tanf.formats;
  contents;
  quit;

