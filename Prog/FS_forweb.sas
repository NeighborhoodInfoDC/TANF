/**************************************************************************
 Program:  FS_forweb
 Library:  TANF
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  11/13/2017
 Version:  SAS 9.4
 Environment:  Windows
 Modifications: 

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( TANF )
%DCData_lib( Web )


/***** Update the let statements for the data you want to create CSV files for *****/

%let library = tanf; /* Library of the summary data to be transposed */
%let outfolder = fs; /* Name of folder where output CSV will be saved */
%let sumdata = fs_sum; /* Summary dataset name (without geo suffix) */
%let start = 2000; /* Start year */
%let end = 2015; /* End year */
%let keepvars = fs_client; /* Summary variables to keep and transpose */


/***** Update the web_varcreate marcro if you need to create final indicators for the website after transposing *****/

%macro web_varcreate;

label Fs_client = "Persons receiving food stamps";

%mend web_varcreate;



/**************** DO NOT UPDATE BELOW THIS LINE ****************/

%macro csv_create(geo);
			 
%web_transpose(&library., &outfolder., &sumdata., &geo., &start., &end., &keepvars. );

/* Load transposed data, create indicators for profiles */
data &sumdata._&geo._long_allyr;
	set &sumdata._&geo._long;
	%web_varcreate;
	label start_date = "Start Date"
		  end_date = "End Date"
		  timeframe = "Year of Data";
run;

/* Create metadata for the dataset */
proc contents data = &sumdata._&geo._long_allyr out = &sumdata._&geo._metadata noprint;
run;

/* Output the metadata 
ods csv file ="&_dcdata_default_path.\web\output\&outfolder.\&outfolder._&geo._metadata..csv";
	proc print data =&sumdata._&geo._metadata noobs;
	run;
ods csv close;*/


/* Output the CSV 
ods csv file ="&_dcdata_default_path.\web\output\&outfolder.\&outfolder._&geo..csv";
	proc print data =&sumdata._&geo._long_allyr noobs;
	run;
ods csv close*/


%mend csv_create;
%csv_create (tr10);
%csv_create (tr00);
%csv_create (anc12);
%csv_create (wd02);
%csv_create (wd12);
%csv_create (city);
%csv_create (psa12);
%csv_create (zip);
%csv_create (cltr00);
%csv_create (cl17);
