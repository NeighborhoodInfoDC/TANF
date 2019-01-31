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
"DW"= "Child-Jobs Sanction"
"DF"= "Disqualified-fraud"
"DI"= "Disqualified- not for fraud";

 value $relcode
"AC" = "PIs Adult child >20 yrs"
"AU" = "Aunt or Uncle of PI"
"CH" = "PIs Child"
"CP" = "Childs parent, but not PI spouse"
"CO" = "Cousin of PI"
"FC" = "Foster Child of PI"
"GC" = "Grandchild of PI"
"GG" = "PIs Great-grandchild"
"GR" = "Grandparent of PI"
"HA" = "PIs half or step sibling"
"IL" = "In-law of PI"
"NN" = "Niece/Nephew of PI"
"NR" = "Not related to PI"
"OR" = "Other related"
"PA" = "Parent of PI"
"PC" = "Pregnant child of PI"
"PI" = "Primary Information Person"
"SB" = "PIs sibling"
"SC" = "Step-child of PI"
"SP" = "PIs spouse"
"ST" = "Step-Parent of PI";

value agefmt
low-<0 = "Unborn child"
0-<2 = "Infant to 1"
2-<4= "Child 2-3"    	
4-<6= "Child 4-5"    	
6-<13= "Child 6-12"    	
13-<18 = "Teenager 13-17"    	
18-<25 ="Young adult 18-24"
25-<40="Adult 25-39"
40-<55="Adult 40-54"
55-high="Adult 55 plus"	; 


value $agegrp
"g1" =  "Child Age <=1"      
"g2" =  "Child Age 2-3"      
"g3" =  "Child Age 4-5"       
"g4" =  "Child Age 6-12"      
"g5" =  "Child Age 13-17"     
"g6" =  "Child Age over 18"  ;

value adulfmt
1 =  "Adult Age 18-24"      
2 =  "Adult Age 25-39"      
3 =  "Adult Age 40-54"       
4 =  "Adult Age >55";	
	
value chilfmt
1 =  "Child Age unborn"   
2 =  "Child Age 0-1" 
3 =  "Child Age 2-5"         
4 =  "Child Age 6-12"      
5 =  "Child Age 13-18" ;

value $ethfmt
"AS" = "Asian"
"BL" = "Black"
"HI" = "Hispanic"
"OT" = "Other"
"UN" = "Unknown"
"WH" = "White" ;

value $lang
"E" = "English"
"S" = "Spanish";

value dyesno
    0 = "No"
    1 = "Yes";
run; 


