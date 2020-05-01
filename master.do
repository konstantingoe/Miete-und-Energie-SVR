clear
set more off
set linesize 200
version 15
set memory 500m
set varabbrev on


* DIW 
if c(username) == "kgoebler" {
	global data_raw		"//hume/rdc-prod/distribution/soep-core\soep.v35\stata\raw\"
	global data			"//hume/rdc-prod/distribution/soep-core/soep.v35/stata/"
	global data_reg		"//hume/rdc-prod/restricted\soep-core\soep.v35/"
	global out 			"H:\Miete und Energie\Out\"
	global scripts 		"H:\Miete und Energie\Scripts\"
	global temp			"H:\Miete und Energie\Temp\"
	global graphs		"H:\Miete und Energie\Graphs\"

}

/*
* homeoffice

global data "/Users/kgoebler/Desktop/SOEP_2018/stata/"
global out "/Users/kgoebler/Desktop/Miete und Energie Projekt/Out/"
global scripts "/Users/kgoebler/Desktop/Miete und Energie Projekt/Scripts/"
global temp "/Users/kgoebler/Desktop/Miete und Energie Projekt/temp/"
global graphs "/Users/kgoebler/Desktop/Miete und Energie Projekt/graphs/"
*/
