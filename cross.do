*****
clear all 
set more off
set scheme s2color8


use "${temp}/temp1.dta", clear



**** Aufbau: 

* 3. Bezahlbarkeit: Wohnkosten: 

* Mieter: 

**** Aufgliederung Miet- und Wohnkosten (Mittelwert)

preserve

collapse (mean) real_rent_sqmtr (semean) se_1 = real_rent_sqmtr (mean) real_bruttowarm_sqmtr  (semean) se_2 = real_bruttowarm_sqmtr (mean) real_wk_ges_sqmtr (semean) se_3 = real_wk_ges_sqmtr [w=round(hhrf1)] if owner != 1 & hgowner == 2 & syear != 2014 , by(syear)

local i = 1
foreach var in real_rent_sqmtr real_bruttowarm_sqmtr real_wk_ges_sqmtr{
	gen high_`i' = `var' + 1.96*se_`i'
	gen low_`i' = `var' - 1.96*se_`i'
		local i = `i' + 1
}

foreach var in real_rent_sqmtr real_bruttowarm_sqmtr real_wk_ges_sqmtr{
	foreach i in 1998 2008 2018{ 
		qui sum `var' if syear == `i'
			local `i'_`var' = round(`r(mean)',.15)
	}
}
drop se*
twoway  (rarea high_1 low_1 syear , color(gs9) fi(inten60) asty(background)) ///
		(rarea high_2 low_2 syear , color(gs9) fi(inten60) asty(background)) ///
		(rarea high_3 low_3 syear , color(gs9) fi(inten60) asty(background)) ///
		(line real_wk_ges_sqmtr syear, text(`1998_real_wk_ges_sqmtr' 1998 "`1998_real_wk_ges_sqmtr'", place(bottom) size(small)) text(`2008_real_wk_ges_sqmtr' 2008 "`2008_real_wk_ges_sqmtr'", place(top) size(small)) text(`2018_real_wk_ges_sqmtr' 2018 "`2018_real_wk_ges_sqmtr'", place(bottom) size(small))) ///
		(line real_bruttowarm_sqmtr syear, text(`1998_real_bruttowarm_sqmtr' 1998 "`1998_real_bruttowarm_sqmtr'", place(bottom) size(small)) text(`2008_real_bruttowarm_sqmtr' 2008 "`2008_real_bruttowarm_sqmtr'", place(top) size(small)) text(`2018_real_bruttowarm_sqmtr' 2018 "`2018_real_bruttowarm_sqmtr'", place(top) size(small))) ///
		(line real_rent_sqmtr syear , text(`1998_real_rent_sqmtr' 1998 "`1998_real_rent_sqmtr'", place(bottom) size(small)) text(`2008_real_rent_sqmtr' 2008 "`2008_real_rent_sqmtr'", place(top) size(small)) text(`2018_real_rent_sqmtr' 2018 "`2018_real_rent_sqmtr'", place(top) size(small))), ///
		ytitle("EUR/qm", size(medium) margin(right)) xlabel(1995 (5) 2018) ///
		xtitle("Jahr") title("Aufgliederung Miet- und Wohnkosten (Mittelwert) Mieter") ///
		legend(order(4 "Gesamte Wohnkosten" 5 "Bruttowarmmiete" 6 "Bruttokaltmiete") pos(6) rows(4)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/miet_wohn.gph", replace	
	graph export "${graphs}/miet_wohn.png", replace

restore 

**** Aufgliederung Miet- und Wohnkosten (Median)

preserve

collapse (median) real_rent_sqmtr (semean) se_1 = real_rent_sqmtr (median) real_bruttowarm_sqmtr  (semean) se_2 = real_bruttowarm_sqmtr (median) real_wk_ges_sqmtr (semean) se_3 = real_wk_ges_sqmtr [w=round(hhrf1)] if owner != 1 & hgowner == 2 & syear != 2014 , by(syear)

local i = 1
foreach var in real_rent_sqmtr real_bruttowarm_sqmtr real_wk_ges_sqmtr{
	gen high_`i' = `var' + 1.96*se_`i'
	gen low_`i' = `var' - 1.96*se_`i'
		local i = `i' + 1
}

foreach var in real_rent_sqmtr real_bruttowarm_sqmtr real_wk_ges_sqmtr{
	foreach i in 1998 2008 2018{ 
		qui sum `var' if syear == `i'
			local `i'_`var' = round(`r(mean)',.19)
	}
}
drop se*
twoway  (rarea high_1 low_1 syear , color(gs9) fi(inten60) asty(background)) ///
		(rarea high_2 low_2 syear , color(gs9) fi(inten60) asty(background)) ///
		(rarea high_3 low_3 syear , color(gs9) fi(inten60) asty(background)) ///
		(line real_wk_ges_sqmtr syear, text(`1998_real_wk_ges_sqmtr' 1998 "`1998_real_wk_ges_sqmtr'", place(bottom) size(small)) text(`2008_real_wk_ges_sqmtr' 2008 "`2008_real_wk_ges_sqmtr'", place(top) size(small)) text(`2018_real_wk_ges_sqmtr' 2018 "`2018_real_wk_ges_sqmtr'", place(bottom) size(small))) ///
		(line real_bruttowarm_sqmtr syear, text(`1998_real_bruttowarm_sqmtr' 1998 "`1998_real_bruttowarm_sqmtr'", place(bottom) size(small)) text(`2008_real_bruttowarm_sqmtr' 2008 "`2008_real_bruttowarm_sqmtr'", place(top) size(small)) text(`2018_real_bruttowarm_sqmtr' 2018 "`2018_real_bruttowarm_sqmtr'", place(top) size(small))) ///
		(line real_rent_sqmtr syear , text(`1998_real_rent_sqmtr' 1998 "`1998_real_rent_sqmtr'", place(bottom) size(small)) text(`2008_real_rent_sqmtr' 2008 "`2008_real_rent_sqmtr'", place(top) size(small)) text(`2018_real_rent_sqmtr' 2018 "`2018_real_rent_sqmtr'", place(top) size(small))), ///
		ytitle("EUR/qm", size(medium) margin(right)) xlabel(1995 (5) 2018) ///
		xtitle("Jahr") title("Aufgliederung Miet- und Wohnkosten (Median) Mieter") ///
		legend(order(4 "Gesamte Wohnkosten" 5 "Bruttowarmmiete" 6 "Bruttokaltmiete") pos(6) rows(4)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/miet_wohn_med.gph", replace	
	graph export "${graphs}/miet_wohn_med.png", replace

restore 


/*
**** Aufgliederung Miet- und Wohnkosten (Standardabweichung)

preserve

collapse (sd) real_rent_sqmtr (sd) real_bruttowarm_sqmtr (sd) real_wk_ges_sqmtr [w=round(hhrf1)] if owner != 1 & hgowner == 2 & syear != 2014, by(syear)

twoway  (line real_rent_sqmtr syear) ///
		(line real_bruttowarm_sqmtr syear) ///
		(line real_wk_ges_sqmtr syear), ///
		ytitle("Standardabweichung in EUR", size(medium) margin(right)) ///
		xtitle("Jahr") title("Entwicklung von Miet- und Wohnkosten Unsicherheit") ///
		legend(order(1 "Bruttokaltmiete" 2 "Bruttowarmmiete" 3 "Gesamte Wohnkosten") pos(6) rows(3)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/miet_wohn_sd.gph", replace	
	graph export "${graphs}/miet_wohn_sd.png", replace

restore 


**** Aufgliederung Miet- und Wohnkosten (Standardabweichung und erst ab 2000)

preserve

collapse (sd) real_rent_sqmtr (sd) real_bruttowarm_sqmtr (sd) real_wk_ges_sqmtr [w=round(hhrf1)] if owner != 1 & hgowner == 2 & syear >= 2000 & !missing(syear), by(syear)

twoway  (line real_rent_sqmtr syear) ///
		(line real_bruttowarm_sqmtr syear) ///
		(line real_wk_ges_sqmtr syear), ///
		ytitle("Standardabweichung in EUR", size(medium) margin(right)) ///
		xtitle("Jahr") title("Entwicklung von Miet- und Wohnkosten Unsicherheit") ///
		legend(order(1 "Bruttokaltmiete" 2 "Bruttowarmmiete" 3 "Gesamte Wohnkosten") pos(6) rows(3)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/miet_wohn_sdno2000.gph", replace	
	graph export "${graphs}/miet_wohn_sdno2000.png", replace

restore 
*/


* Eigentümer


*** Wohnkosten Aufstellung

preserve

collapse (mean) wohnbruttokalt_sqmtr (semean) se_1 = wohnbruttokalt_sqmtr (mean) wohnbruttowarm_sqmtr  (semean) se_2 = wohnbruttowarm_sqmtr (mean) wohnkosten_sqmtr (semean) se_3 = wohnkosten_sqmtr [w=round(hhrf1)] if owner == 1 & belastet == 1, by(syear)

local i = 1
foreach var in wohnbruttokalt_sqmtr wohnbruttowarm_sqmtr wohnkosten_sqmtr{
	gen high_`i' = `var' + 1.96*se_`i'
	gen low_`i' = `var' - 1.96*se_`i'
		local i = `i' + 1
}

foreach var in wohnbruttokalt_sqmtr wohnbruttowarm_sqmtr wohnkosten_sqmtr{
	foreach i in 1998 2008 2018{ 
		qui sum `var' if syear == `i'
			local `i'_`var' = round(`r(mean)',.15)
	}
}
drop se*
twoway  (rarea high_1 low_1 syear , color(gs9) fi(inten60) asty(background)) ///
		(rarea high_2 low_2 syear , color(gs9) fi(inten60) asty(background)) ///
		(rarea high_3 low_3 syear , color(gs9) fi(inten60) asty(background)) ///
		(line wohnkosten_sqmtr syear, text(`1998_wohnkosten_sqmtr' 1998 "`1998_wohnkosten_sqmtr'", place(bottom) size(small)) text(`2008_wohnkosten_sqmtr' 2008 "`2008_wohnkosten_sqmtr'", place(top) size(small)) text(`2018_wohnkosten_sqmtr' 2018 "`2018_wohnkosten_sqmtr'", place(bottom) size(small))) ///
		(line wohnbruttowarm_sqmtr syear, text(`1998_wohnbruttowarm_sqmtr' 1998 "`1998_wohnbruttowarm_sqmtr'", place(bottom) size(small)) text(`2008_wohnbruttowarm_sqmtr' 2008 "`2008_wohnbruttowarm_sqmtr'", place(top) size(small)) text(`2018_wohnbruttowarm_sqmtr' 2018 "`2018_wohnbruttowarm_sqmtr'", place(top) size(small))) ///
		(line wohnbruttokalt_sqmtr syear , text(`1998_wohnbruttokalt_sqmtr' 1998 "`1998_wohnbruttokalt_sqmtr'", place(bottom) size(small)) text(`2008_wohnbruttokalt_sqmtr' 2008 "`2008_wohnbruttokalt_sqmtr'", place(top) size(small)) text(`2018_wohnbruttokalt_sqmtr' 2018 "`2018_wohnbruttokalt_sqmtr'", place(top) size(small))), ///
		ytitle("EUR/qm", size(medium) margin(right)) xlabel(1995 (5) 2018) ///
		xtitle("Jahr") title("Aufgliederung Miet- und Wohnkosten (Mittelwert)" "Eigentümer") ///
		legend(order(4 "Gesamte Wohnkosten" 5 "Wohnkosten bruttowarm" 6 "Wohnkosten bruttokalt") pos(6) rows(4)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/wk_eigentuemer.gph", replace	
	graph export "${graphs}/wk_eigentuemer.png", replace

restore 


*** median 
preserve

collapse (median) wohnbruttokalt_sqmtr (semean) se_1 = wohnbruttokalt_sqmtr (median) wohnbruttowarm_sqmtr  (semean) se_2 = wohnbruttowarm_sqmtr (median) wohnkosten_sqmtr (semean) se_3 = wohnkosten_sqmtr [w=round(hhrf1)] if owner == 1 & belastet == 1, by(syear)

local i = 1
foreach var in wohnbruttokalt_sqmtr wohnbruttowarm_sqmtr wohnkosten_sqmtr{
	gen high_`i' = `var' + 1.96*se_`i'
	gen low_`i' = `var' - 1.96*se_`i'
		local i = `i' + 1
}

foreach var in wohnbruttokalt_sqmtr wohnbruttowarm_sqmtr wohnkosten_sqmtr{
	foreach i in 1998 2008 2018{ 
		qui sum `var' if syear == `i'
			local `i'_`var' = round(`r(mean)',.12)
	}
}
drop se*
twoway  (rarea high_1 low_1 syear , color(gs9) fi(inten60) asty(background)) ///
		(rarea high_2 low_2 syear , color(gs9) fi(inten60) asty(background)) ///
		(rarea high_3 low_3 syear , color(gs9) fi(inten60) asty(background)) ///
		(line wohnkosten_sqmtr syear, text(`1998_wohnkosten_sqmtr' 1998 "`1998_wohnkosten_sqmtr'", place(bottom) size(small)) text(`2008_wohnkosten_sqmtr' 2008 "`2008_wohnkosten_sqmtr'", place(bottom) size(small)) text(`2018_wohnkosten_sqmtr' 2018 "`2018_wohnkosten_sqmtr'", place(bottom) size(small))) ///
		(line wohnbruttowarm_sqmtr syear, text(`1998_wohnbruttowarm_sqmtr' 1998 "`1998_wohnbruttowarm_sqmtr'", place(bottom) size(small)) text(`2008_wohnbruttowarm_sqmtr' 2008 "`2008_wohnbruttowarm_sqmtr'", place(bottom) size(small)) text(`2018_wohnbruttowarm_sqmtr' 2018 "`2018_wohnbruttowarm_sqmtr'", place(bottom) size(small))) ///
		(line wohnbruttokalt_sqmtr syear , text(`1998_wohnbruttokalt_sqmtr' 1998 "`1998_wohnbruttokalt_sqmtr'", place(bottom) size(small)) text(`2008_wohnbruttokalt_sqmtr' 2008 "`2008_wohnbruttokalt_sqmtr'", place(bottom) size(small)) text(`2018_wohnbruttokalt_sqmtr' 2018 "`2018_wohnbruttokalt_sqmtr'", place(top) size(small))), ///
		ytitle("EUR/qm", size(medium) margin(right)) xlabel(1995 (5) 2018) ///
		xtitle("Jahr") title("Aufgliederung Miet- und Wohnkosten (Median)" "Eigentümer") ///
		legend(order(4 "Gesamte Wohnkosten" 5 "Wohnkosten bruttowarm" 6 "Wohnkosten bruttokalt") pos(6) rows(4)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/wk_eigentuemer_med.gph", replace	
	graph export "${graphs}/wk_eigentuemer_med.png", replace

restore 






















**** Eigentumsquote *****

preserve
replace owner = owner * 100

collapse (mean) owner [w=round(hhrf)], by(syear)

	twoway line owner syear, ///
	ytitle("Anteil in %", size(medium) margin(right)) ///
	xtitle("Jahr") title("Eigentumsquote in Deutschland") ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/eigentumsq.gph", replace	
	graph export "${graphs}/eigentumsq.png", replace	
restore 



**** Eigentumsquote nach Ost/West *****

preserve
replace owner = owner * 100

collapse (mean) owner [w=round(hhrf)], by(syear sampreg)

	twoway  (line owner syear if sampreg == 1) ///
			(line owner syear if sampreg == 2), ///
			ytitle("Anteil in %", size(medium) margin(right)) ///
			xtitle("Jahr") title("Eigentumsquote in Deutschland") ///
			graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
			legend(order(1 "Alte Bundesländer" 2 "Neue Bundesländer") pos(6) rows(2)) ///
			plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
			graph save   "${graphs}/eigentumsq_wo.gph", replace	
			graph export "${graphs}/eigentumsq_wo.png", replace	
restore 



*** Armutseisiko 
preserve
replace arisiko = arisiko * 100

collapse (mean) arisiko [w=round(hhrf)], by(syear)

	twoway line arisiko syear, ///
	ytitle("Anteil in %", size(medium) margin(right)) ///
	xtitle("Jahr") title("Armutsrisikoquote in Deutschland") ylab(0 (5) 20) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/arisikoq.gph", replace	
	graph export "${graphs}/arisikoq.png", replace	
restore 

*** Armutseisiko nach Eigentumsstatus

preserve
replace arisiko = arisiko * 100
gen owner_bel = .
replace owner_bel = 0 if owner == 0
replace owner_bel = 1 if owner == 1 & belastet == 0

collapse (mean) arisiko [w=round(hhrf)], by(syear owner_bel)

	twoway 	(line arisiko syear if owner_bel == 0) ///
			(line arisiko syear if owner_bel == 1), ///
			ytitle("Anteil in %", size(medium) margin(right)) ///
			xtitle("Jahr") title("Armutsrisikoquote nach Eigentümer in Deutschland") ///
			graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
			legend(order(1 "Keine Wohneigentümer" 2 "Wohneigentümer") pos(6) rows(2)) ///
			plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
			graph save   "${graphs}/arisikoq_eigent.gph", replace	
			graph export "${graphs}/arisikoq_eigent.png", replace	
restore 



*** Scatterplot mblq und wohnbelastungsquote: 
qui corr mblq mieter_wkblq
local corr : di %4.3f r(rho)

sort mblq mieter_wkblq

graph twoway (scatter mblq mieter_wkblq if syear == 2018 & owner == 0 & hgowner == 2, msymbol(Oh)) ///
			 (lfit mblq mieter_wkblq if syear == 2018 & owner == 0 & hgowner == 2 ), /// 
			ytitle("Mietbelastungsquote", size(medium) margin(right)) subtitle("Korrelation: `corr'") ///
			xtitle("Wohnkostenbelastungsquote", size(medium) margin(right)) ///
			title("Scatterplot Mietbelastungsquote vs. Wohnbelastungsquote" "von Hauptmieterhaushalten") ///
			legend(order(1 "Mietbelastunsquote" 2 "Fitted values" ) pos(6) rows(2)) ///
			graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
			plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
			graph save   "${graphs}/scatter_mieter.gph", replace	
			graph export "${graphs}/scatter_mieter.png", replace	




*** Scatterplot bruttokalteblq und wohnbelastungsquote: 
qui corr eigen_blq eigen_wkblq
local corr : di %4.3f r(rho)

sort eigen_blq eigen_wkblq

graph twoway (scatter eigen_blq eigen_wkblq if syear == 2018 & owner == 1 & belastet == 1, msymbol(Oh)) ///
			 (lfit eigen_blq eigen_wkblq if syear == 2018 & owner == 1 & belastet == 1), /// 
			ytitle("Bruttokaltbelastungsquote", size(medium) margin(right)) subtitle("Korrelation: `corr'") ///
			xtitle("Wohnkostenbelastungsquote", size(medium) margin(right)) ///
			title("Scatterplot Bruttokaltbelastungsquote vs. Wohnbelastungsquote" "von Eigentümerhaushalten") ///
			legend(order(1 "Bruttokaltbelastungsquote" 2 "Fitted values" ) pos(6) rows(2)) ///
			graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
			plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
			graph save   "${graphs}/scatter_eig.gph", replace	
			graph export "${graphs}/scatter_eig.png", replace	



*********** 
/*
-	Einkommensquintile (möglicher Fokus: armutsnahe Haushalte)
-	Mieter vs. Eigentümer
-	3 Städtekategorien
-	Haushaltsgröße: Alleinlebend bzw. alleinerziehend vs. Rest
-	Alter: z. B. 65+ vs. Rest
-	Einzugsjahr (hierfür eine sinnvolle Schwelle finden, z. B. 2010?)
*/


********************************************************************************
********************************************************************************
****************************  Mieter  ****************************************** 
********************************************************************************
********************************************************************************



*** Wohndauer 
preserve

collapse (median) real_rent_sqmtr [w=round(hhrf)] if owner == 0 & hgowner == 2 & region == 3 & syear != 2014, by(syear wohndauer)

	twoway 	(line real_rent_sqmtr syear if wohndauer==1) ///
			(line real_rent_sqmtr syear if wohndauer==2) ///
			(line real_rent_sqmtr syear if wohndauer==3) ///
			(line real_rent_sqmtr syear if wohndauer==4) ///
			(line real_rent_sqmtr syear if wohndauer==5), ///
	ytitle("in %", size(medium) margin(right)) ///
	xtitle("Jahr") title("Bruttokaltmiete pro qm in Großstädten nach Einzugsjahr") ///
	legend(order(1 "< 1980" 2 "1980-1990" 3 "1990 - 2000" 4 "2000 - 2010" 5 "2010- 2018") pos(6) rows(3)) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/wohndauer.gph", replace	
	graph export "${graphs}/wohndauer.png", replace	
restore 



*** Entwicklung der Bruttokaltmiete 

preserve

collapse (mean) real_rent_sqmtr [w=round(hhrf1)] if owner != 1 & hgowner == 2 & real_rent_sqmtr > 0 & !missing(real_rent_sqmtr), by(syear)

	twoway line real_rent_sqmtr syear, ///
	ytitle("Bruttokaltmiete/m^2 in 2015 EUR ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Bruttokaltmiete pro Quadratmeter in 2015 Euros") ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/miete_pro_qm_hgen.gph", replace	
	graph export "${graphs}/miete_pro_qm_hgen.png", replace

restore 

*** Entwicklugg der Mietbelastungsquote 


preserve

collapse (mean) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear)

	twoway line mblq syear, ///
	ytitle("Miebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote in Deutschland (Mittelwert)") ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_hgen.gph", replace	
	graph export "${graphs}/mblq_hgen.png", replace

restore 

* Energiebelastungsquote

preserve

collapse (mean) energy_blq [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear)

	twoway line energy_blq syear, ///
	ytitle("Energiebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Energiebelastungsquote in Deutschland (Mittelwert)") ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/energy_blq.gph", replace	
	graph export "${graphs}/energy_blq.png", replace

restore 

* Nebenkostenentwicklung 
preserve

collapse (mean) real_util_sqmtr [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear region)

	twoway 	(line real_util_sqmtr syear if region == 1) ///
			(line real_util_sqmtr syear if region == 2) ///
			(line real_util_sqmtr syear if region == 3), ///
	ytitle("Nebenkosten pro QM in € ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Nebenkostenentwicklung in Deutschland (Mittelwert)") ///
		legend(order(1 "Unter 50.000 Einw." 2 "50.000 - 500.000 Einw." 3 "500.000+ Einw.") pos(6) rows(3)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/nebenk.gph", replace	
	graph export "${graphs}/nebenk.png", replace

restore 

* Wohnbelastungsquote

preserve

collapse (mean) warm_blq [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear)

	twoway line warm_blq syear, ///
	ytitle("Mietbelastungsquote (warm) in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Mietbelastungsquote (warm) in Deutschland (Mittelwert)") ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/warm_blq.gph", replace	
	graph export "${graphs}/warm_blq.png", replace

restore 

*tabstat mblq if owner != 1 & hgowner == 2 [fw=round(hhrf1)], s(mean) by(syear)


preserve

collapse (mean) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear hhinc_group)

twoway  (line mblq syear if hhinc_group == 1) ///
		(line mblq syear if hhinc_group == 2) ///
		(line mblq syear if hhinc_group == 3) ///
		(line mblq syear if hhinc_group == 4), ///
		ytitle("Miebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote nach Hh-Nettoeinkommensgruppen") ///
		legend(order(1 "0-1000€" 2 "1000-2000€" 3 "2000-3000€ " 4 "Mehr als 3000€") pos(6) rows(4)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_group.gph", replace	
	graph export "${graphs}/mblq_group.png", replace

restore 

*** nach Fallzahl schauen 
preserve

collapse (mean) warm_blq  [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear hhinc_group)

twoway  (line warm_blq syear if hhinc_group == 1) ///
		(line warm_blq syear if hhinc_group == 2) ///
		(line warm_blq syear if hhinc_group == 3) ///
		(line warm_blq syear if hhinc_group == 4), ///
		ytitle("Wohnbelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Wohnbelastungsquote nach Hh-Nettoeinkommensgruppen") ///
		legend(order(1 "0-1000€" 2 "1000-2000€" 3 "2000-3000€ " 4 "Mehr als 3000€") pos(6) rows(4)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/warmblq_group.gph", replace	
	graph export "${graphs}/warmblq_group.png", replace

restore 

*** Ost / West BLQ

preserve

collapse (mean) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear sampreg)

twoway  (line mblq syear if sampreg == 1) ///
		(line mblq syear if sampreg == 2), ///
		ytitle("Miebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote nach Hh-Nettoeinkommensgruppen") ///
		legend(order(1 "Wohnung liegt in den alten Bundesländern" 2 "Wohnung liegt in den neuen Bundesländern") pos(6) rows(2)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_west.gph", replace	
	graph export "${graphs}/mblq_west.png", replace

restore 


*** Notfallrücklagen

preserve

collapse (mean) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear notrücklagen)

twoway  (line mblq syear if notrücklagen == 0) ///
		(line mblq syear if notrücklagen == 1), ///
		ytitle("Miebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote nach Hauhsalten die Rücklagen bilden") ///
		legend(order(1 "keine Rücklagen gebildet" 2 "Rücklagen gebildet") pos(6) rows(2)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_notfall.gph", replace	
	graph export "${graphs}/mblq_notfall.png", replace

restore 


*** Migrationshaushalt BLQ
preserve

collapse (mean) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2 & syear != 2014, by(syear migb_hh)

twoway  (line mblq syear if migb_hh == 0) ///
		(line mblq syear if migb_hh == 1), ///
		ytitle("Miebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote nach Migrationshaushalt") ///
		legend(order(1 "Keine Person im HH mit Migback" 2 "Mind. 1 Pers. mit Migback") pos(6) rows(2)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_mig.gph", replace	
	graph export "${graphs}/mblq_mig.png", replace

restore 

*** Migrationshaushalt Bruttokaltmiete
preserve

collapse (mean) real_rent_sqmtr [w=round(hhrf1)] if owner != 1 & hgowner == 2 & syear != 2014, by(syear migb_hh)

twoway  (line real_rent_sqmtr syear if migb_hh == 0) ///
		(line real_rent_sqmtr syear if migb_hh == 1), ///
		ytitle("Bruttokaltmiete in €", size(medium) margin(right)) ///
		xtitle("Jahr") title("Bruttokaltmiete nach Migrationshaushalt") ///
		legend(order(1 "Keine Person im HH mit Migback" 2 "Mind. 1 Pers. mit Migback") pos(6) rows(2)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/rent_mig.gph", replace	
	graph export "${graphs}/rent_mig.png", replace

restore 


*** Altersgruppen MBLQ

preserve

collapse (mean) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2 & syear != 2014, by(syear age_group)

twoway  (line mblq syear if age_group == 1) ///
		(line mblq syear if age_group == 2) ///
		(line mblq syear if age_group == 3) ///
		(line mblq syear if age_group == 4), ///
		ytitle("Miebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote nach HH-Altersgruppen") ///
		legend(order(1 "<35" 2 "35-50" 3 "50-65" 4 ">65") pos(6) rows(4)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_age.gph", replace	
	graph export "${graphs}/mblq_age.png", replace

restore 

*** Altersgruppen Bruttokaltmiete

preserve

collapse (mean) real_rent_sqmtr [w=round(hhrf1)] if owner != 1 & hgowner == 2 & syear != 2014, by(syear age_group)

twoway  (line real_rent_sqmtr syear if age_group == 1) ///
		(line real_rent_sqmtr syear if age_group == 2) ///
		(line real_rent_sqmtr syear if age_group == 3) ///
		(line real_rent_sqmtr syear if age_group == 4), ///
		ytitle("Bruttokaltmiete in €/qm", size(medium) margin(right)) ///
		xtitle("Jahr") title("Bruttokaltmiete nach HH-Altersgruppen") ///
		legend(order(1 "<35" 2 "35-50" 3 "50-65" 4 ">65") pos(6) rows(4)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/rent_age.gph", replace	
	graph export "${graphs}/rent_age.png", replace

restore 


****

preserve

collapse (mean) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear regtyp)

twoway  (line mblq syear if regtyp == 1) ///
		(line mblq syear if regtyp == 2), ///
		ytitle("Miebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Mietbelastungsquote nach Hh-Nettoeinkommensgruppen") ///
		legend(order(1 "Wohnung liegt in städtischem Raum" 2 "Wohnung liegt in ländlichem Raum") pos(6) rows(2)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_stadt_land.gph", replace	
	graph export "${graphs}/mblq_stadt_land.png", replace

restore 



preserve

collapse (median) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear region)

twoway  (line mblq syear if region == 1) ///
		(line mblq syear if region == 2) ///
		(line mblq syear if region == 3), ///
		ytitle("Mietbelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote nach Regiongrößen") ///
		legend(order(1 "Unter 50.000 Einw." 2 "50.000 - 500.000 Einw." 3 "500.000+ Einw.") pos(6) rows(2)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_region.gph", replace	
	graph export "${graphs}/mblq_region.png", replace

restore 


preserve

collapse (sd) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2 & syear >= 2000 & !missing(syear), by(syear region)

twoway  (line mblq syear if region == 1) ///
		(line mblq syear if region == 2) ///
		(line mblq syear if region == 3), ///
		ytitle("Standardabweichung in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote nach Regiongrößen") ///
		legend(order(1 "Unter 50.000 Einw." 2 "50.000 - 500.000 Einw." 3 "500.000+ Einw.") pos(6) rows(2)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_region_sd.gph", replace	
	graph export "${graphs}/mblq_region_sd.png", replace

restore 




preserve

collapse (mean) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear hhtyp)

twoway  (line mblq syear if hhtyp == 1) ///
		(line mblq syear if hhtyp == 2) ///
		(line mblq syear if hhtyp == 3) ///
		(line mblq syear if hhtyp == 4), ///
		ytitle("Miebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote nach HH-Typen") ///
		legend(order(1 "1-Pers. HH" 2 "Alleinerz. HH" 3 "Paar HH ohne K." 4 "Paar HH mit K.") pos(6) rows(4)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_hhtyp.gph", replace	
	graph export "${graphs}/mblq_hhtyp.png", replace

restore 



*** Wohndauer 
preserve

collapse (mean) mblq [w=round(hhrf)] if owner == 0 & hgowner == 2 & syear != 2014, by(syear wohndauer)

	twoway 	(line mblq syear if wohndauer==1) ///
			(line mblq syear if wohndauer==2) ///
			(line mblq syear if wohndauer==3) ///
			(line mblq syear if wohndauer==4), ///
	ytitle("in %", size(medium) margin(right)) ///
	xtitle("Jahr") title("Mietbelastungsquote nach Einzugsjahr in Prozent") ///
	legend(order(1 "Vor 1990" 2 "1990 - 2000" 3 "2000 - 2010" 4 "2010- 2018") pos(6) rows(3)) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/move_mblq.gph", replace	
	graph export "${graphs}/move_mblq.png", replace	
restore 



*** Wohndauer 
preserve

collapse (mean) real_rent_sqmtr [w=round(hhrf)] if owner == 0 & hgowner == 2 & syear != 2014, by(syear wohndauer)

	twoway 	(line real_rent_sqmtr syear if wohndauer==1) ///
			(line real_rent_sqmtr syear if wohndauer==2) ///
			(line real_rent_sqmtr syear if wohndauer==3) ///
			(line real_rent_sqmtr syear if wohndauer==4), ///
	ytitle("in €", size(medium) margin(right)) ///
	xtitle("Jahr") title("Bruttomiete (real) pro QM nach Einzugsjahr") ///
	legend(order(1 "Vor 1990" 2 "1990 - 2000" 3 "2000 - 2010" 4 "2010- 2018") pos(6) rows(3)) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/move_rent.gph", replace	
	graph export "${graphs}/move_rent.png", replace	
restore 


*** HH-nettoeinkommen und Bruttokaltmiete auf 100 normalisiert

preserve

collapse (median) hhnet100 (median) rent100 [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear)

	twoway  (line rent100 syear) ///
			(line hhnet100 syear), ///
			ytitle("HHnettoeinkommen (1995 = 100)", size(medium) margin(right)) ///
			xtitle("Jahr") title("HHnettoeinkommen und Bruttokaltmiete in Deutschland (1995 = 100)") ///
			legend(order(1 "Bruttokaltmiete" 2 "Haushaltsnettoeinkommen") pos(6) rows(2)) ///
			graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
			plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/hhnet100.gph", replace	
	graph export "${graphs}/hhnet100.png", replace

restore 



*** HH-nettoeinkommen und Bruttokaltmiete  prozentuale Veränderung

preserve

collapse (mean) real_hhnet (mean) real_gross_rent [w=round(hhrf1)] if owner != 1 & hgowner == 2, by(syear)

	gen hhinc_change = 100*(real_hhnet[_n]-real_hhnet[_n-1])/real_hhnet[_n-1]
	gen rent_change = 100*(real_gross_rent[_n]-real_gross_rent[_n-1])/real_gross_rent[_n-1]

	twoway  (line rent_change syear) ///
			(line hhinc_change syear), ///
			ytitle("Wachstum in %", size(medium) margin(right)) ///
			xtitle("Jahr") title("HHnettoeinkommenswachtum und Bruttokaltmiete in Deutschland jährl. Wachstum", span justification(left)) ///
			legend(order(1 "Bruttokaltmiete" 2 "Haushaltsnettoeinkommen") pos(6) rows(2)) ///
			graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
			plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/hhchange.gph", replace	
	graph export "${graphs}/hhchange.png", replace

restore 


*** Mietbelastungsquote und Barrierefreiheit
preserve

collapse (mean) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2 & hgeqpnobar > 0 & !missing(hgeqpnobar), by(syear hgeqpnobar)

twoway  (line mblq syear if hgeqpnobar == 1) ///
		(line mblq syear if hgeqpnobar == 2), ///
		ytitle("Miebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote nach Hh-Nettoeinkommensgruppen") ///
		legend(order(1 "Wohnung ist Barrierefrei" 2 "Wohnung ist nicht Barrierefrei") pos(6) rows(2)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_barriere.gph", replace	
	graph export "${graphs}/mblq_barriere.png", replace

restore 


*** Mietbelastungsquote und Wärmedämmung
preserve

collapse (mean) mblq [w=round(hhrf1)] if owner != 1 & hgowner == 2 & hgeqpinsul > 0 & !missing(hgeqpinsul), by(syear hgeqpinsul)

twoway  (line mblq syear if hgeqpinsul == 1) ///
		(line mblq syear if hgeqpinsul == 2), ///
		ytitle("Miebelastungsquote in % ", size(medium) margin(right)) ///
		xtitle("Jahr") title("Miebelastungsquote nach Hh-Nettoeinkommensgruppen") ///
		legend(order(1 "Wohnung besitzt Wärmedämmung" 2 "Wohnung besitzt keine Wärmedämmung") pos(6) rows(2)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/mblq_daemmung.gph", replace	
	graph export "${graphs}/mblq_daemmung.png", replace

restore 



********************************************************************************
********************************************************************************
****************************  Eigentümer  ************************************** 
********************************************************************************
********************************************************************************



*** Zins- und Tilgungszahlungen 
preserve

collapse (median) zins_sqmtr [w=round(hhrf)] if owner == 1 & belastet == 1, by(syear)

	twoway line zins_sqmtr syear, ///
	ytitle("in €", size(medium) margin(right)) ///
	xtitle("Jahr") title("Monatl. Tilgungszahlungen in Deutschland (Mittelwert)") ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/tilgung.gph", replace	
	graph export "${graphs}/tilgung.png", replace	
restore 




*** Bruttokalte Wohnkostenbelastungsquote vs. Zins- und Tilgungszahlungen 
preserve

collapse (mean) eigen_blq (mean) zins_sqmtr [w=round(hhrf)] if owner == 1 & belastet == 1, by(syear)

	twoway 	(line eigen_blq syear, yaxis(1) ytitle("in %", axis(1) size(medium) margin(right))) ///
			(line zins_sqmtr syear, yaxis(2) ytitle("in € / m^2", axis(2) size(medium) margin(right))), ///
	xtitle("Jahr") title("Belastungsquote Monatl. Tilgungsz.") ///
	legend(order(1 "Tilgungsbelastungsq." 2 "Tilgunszahlung") pos(6) rows(2)) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/tilgungs_blq.gph", replace	
	graph export "${graphs}/tilgungs_blq.png", replace	
restore 



*** Prozentuale Veränderung Haushaltsnettoeinkommen vs Zins- und Tilgungszahlungen  
preserve

collapse (mean) real_hhnet (mean) zinshoehe [w=round(hhrf)] if owner == 1 & belastet == 1, by(syear)
	gen hhinc_change = 100*(real_hhnet[_n]-real_hhnet[_n-1])/real_hhnet[_n-1]
	gen zins_change = 100*(zinshoehe[_n]-zinshoehe[_n-1])/zinshoehe[_n-1]

	twoway 	(line hhinc_change syear /*, yaxis(1) ytitle("in %", axis(1) size(medium) margin(right))*/ ) ///
			(line zins_change syear /*, yaxis(2) ytitle("in %", axis(2) size(medium) margin(right))*/ ), ///
	xtitle("Jahr") title("HH-nettoeink. & Monatl. Tilgungsz.") ///
	legend(order(1 "HH-Nettoeinkommenswachstum" 2 "Tilgunszahlungswachtum") pos(6) rows(2)) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/tilgung_hhnet.gph", replace	
	graph export "${graphs}/tilgung_hhnet.png", replace	
restore 






********************************************************************************
********************************************************************************
********************  Eigentümer vs. Mieter  *********************************** 
********************************************************************************
********************************************************************************


**** Belastungsquoten gegenüberstellung:

*** Hier soll eine Gegenüberstellung von 3 Größen stattfinden:

*1) wie hier: mblq vs. Eigenbelastungsquote
*2) Energieblq vs Eigenenergieblq
*3) Wohnkostenblq Mieter vs. Eigentümer



* 1) Miet vs. Tilgung BLQ 
preserve

collapse (mean) mblq (mean) eigen_blq  [w=round(hhrf)] if syear != 2014, by(syear)

	twoway 	(line mblq syear) ///
			(line eigen_blq syear), ///
	ytitle("in %", size(medium) margin(right)) ///
	xtitle("Jahr") title("Belastungsquote von Bruttokaltmiete und Bruttokalten" "Wohnkosten von Eigentümern") xlabel(1995 (5) 2018) ///
	legend(order(1 "Mieter" 2 "Eigentümer") pos(6) rows(2)) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/blq_miet_eig.gph", replace	
	graph export "${graphs}/blq_miet_eig.png", replace	
restore 


* 2) Energieblq : Mieter vs Eigentümer
preserve

collapse (mean) energy_blq (mean) eigen_energieblq  [w=round(hhrf)] if syear != 2014 & syear > = 2010, by(syear)

	twoway 	(line energy_blq syear) ///
			(line eigen_energieblq syear), ///
	ytitle("in %", size(medium) margin(right)) ///
	xtitle("Jahr") title("Energiebelastungsquote Mieter vs. Eigentümer") xlabel(2010 (2) 2018) ///
	legend(order(1 "Mieter" 2 "Eigentümer") pos(6) rows(2)) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/energy_miet_eig.gph", replace	
	graph export "${graphs}/energy_miet_eig.png", replace	
restore 


* 3) Wohnkblq: : Mieter vs Eigentümer

preserve

collapse (mean) mieter_wkblq  (mean)  eigen_wkblq [w=round(hhrf)] if syear != 2014 & syear > = 2010, by(syear)

	twoway 	(line mieter_wkblq syear) ///
			(line eigen_wkblq syear), ///
	ytitle("in %", size(medium) margin(right)) ///
	xtitle("Jahr") title("Wohnkostenbelastungsquote Mieter vs. Eigentümer") xlabel(2010 (2) 2018) ///
	legend(order(1 "Mieter" 2 "Eigentümer") pos(6) rows(2)) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  ///
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save   "${graphs}/wk_miet_eig.gph", replace	
	graph export "${graphs}/wk_miet_eig.png", replace	
restore 






