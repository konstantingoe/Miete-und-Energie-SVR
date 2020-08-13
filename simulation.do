**** Simulation : 
*****
clear all 
set more off
set scheme s2color8


use "${temp}/temp1.dta", clear

keep if syear == 2018 & exclusion_hh == 0

sum mblq mieter_wkblq eigen_blq eigen_wkblq  [w=hhrf]

gen mblq_initial = mblq
gen eigenblq_initial = eigen_blq

gen miet_wblq_initial = mieter_wkblq
gen eig_wblq_initial = eigen_wkblq_2018

gen hhnet_initial = hgi1hinc

merge 1:1 hid syear using "/Users/kgoebler/Desktop/Miete und Energie Projekt/Vom DIW/Miete und Energie/Miete und Energie/Temp/temp2.dta", keepus(region) keep(3) nogen 

save "${temp}/temp2.dta", replace 

* Annahme: Mietzahlungen, bzw. Tilgunsrate bleibt identisch, HHNettoeinkommen sinkt:

* Zunächst ganze Population absinken von 50€, 100€, 150€, 200€ (ist in entwa: 2.6%, 5,1%, 7.75% 10.3% des mittleren Haushaltsnettoeinkommens der gesamten Population)
* (ist in entwa: 1.5%, 3,1%, 4.6% 6.1% des mittleren Haushaltsnettoeinkommens der Eigentümerpopulation)
* (ist in entwa: 3,1%, 6,1%, 9.1% 12.2% des mittleren Haushaltsnettoeinkommens der Mieterpopulation)


foreach num in 50 100 150 200 {
	gen hhnet_`num' = hhnet_initial - `num' if hhnet_initial > 0 & !missing(hhnet_initial)

	gen mblq_`num' = hgrent/hhnet_`num' * 100 if owner != 1 & hgowner == 2 & hgrent > 0 & !missing(hgrent) & hhnet_`num' > 0 & !missing(hhnet_`num')
	gen miet_wblq_`num' = (hgrent + hgheat + hgelectr) / hhnet_`num' * 100 if owner != 1 & hgowner == 2 & hgrent > 0 & !missing(hgrent) & hgheat > 0 & !missing(hgheat) & hgelectr > 0 & !missing(hgelectr) & hgrent > 0 & !missing(hgrent) & hhnet_`num' > 0 & !missing(hhnet_`num')
	
	gen eigenblq_`num' = (zinshoehe + nebenkosten) / hhnet_`num' * 100 if owner == 1 & belastet == 1 & hhnet_`num' > 0 & !missing(hhnet_`num')
	gen eig_wblq_`num' = (zinshoehe + nebenkosten + heizkosten + stromkosten) / hhnet_`num' * 100 if owner == 1 & belastet == 1 & hhnet_`num' > 0 & !missing(hhnet_`num')
}

sum mblq_initial mblq_50 mblq_100 mblq_150 mblq_200 [w=hhrf]
sum miet_wblq_initial miet_wblq_50 miet_wblq_100 miet_wblq_150 miet_wblq_200 [w=hhrf]

sum eigenblq_initial eigenblq_50 eigenblq_100 eigenblq_150 eigenblq_200 [w=hhrf]
sum eig_wblq_initial eig_wblq_50 eig_wblq_100 eig_wblq_150 eig_wblq_200 [w=hhrf]


sum mblq_initial mblq_50 mblq_100 mblq_150 mblq_200 [w=hhrf] if notrücklagen == 0
sum miet_wblq_initial miet_wblq_50 miet_wblq_100 miet_wblq_150 miet_wblq_200 [w=hhrf] if notrücklagen == 0

sum eigenblq_initial eigenblq_50 eigenblq_100 eigenblq_150 eigenblq_200 [w=hhrf] if notrücklagen == 0
sum eig_wblq_initial eig_wblq_50 eig_wblq_100 eig_wblq_150 eig_wblq_200 [w=hhrf] if notrücklagen == 0

****

*check what share 50, 100, 150, 200 of HHnetincome amounts to:
foreach num in 50 100 150 200 {
	gen share_`num' = `num' / hhnet_initial * 100 if hhnet_initial > 0 & !missing(hhnet_initial)
}

sum share_50 share_100 share_150 share_200  [w=hhrf]

sum share_50 share_100 share_150 share_200  [w=hhrf] if owner == 1 & belastet == 1
sum share_50 share_100 share_150 share_200  [w=hhrf] if owner == 0 & hgowner == 2



graph bar mblq_initial mblq_50 mblq_100 mblq_150 mblq_200 [w=hhrf], /// 
		ytitle("in %", size(medium) margin(right)) ///
		title("Corona-Einkommensschock Scenarien:""Mietbelastungsquote") ///
		legend(order(1 "Ausgangssituation" 2 "50€/Monat Einbuße" 3 "100€/Monat Einbuße" 4 "150€/Monat Einbuße" 5 "200€/Monat Einbuße")pos(6) rows(4))  blabel(bar, position(inside) format(%12.2f)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) bargap(15) bar(1, col(gs5))  bar(2, fi(inten60)) bar(3, fi(inten60)) bar(4, fi(inten60)) bar(5, fi(inten60))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) name("mblq", replace)
	graph save   "${graphs}/mblq_simu.gph", replace	
	graph export "${graphs}/mblq_simu.png", replace	

graph bar miet_wblq_initial miet_wblq_50 miet_wblq_100 miet_wblq_150 miet_wblq_200 [w=hhrf], /// 
		ytitle("in %", size(medium) margin(right)) ///
		title("Corona-Einkommensschock Scenarien:""Wohnbelastungsquote v. Mietern") ///
		legend(order(1 "Ausgangssituation" 2 "50€/Monat Einbuße" 3 "100€/Monat Einbuße" 4 "150€/Monat Einbuße" 5 "200€/Monat Einbuße")pos(6) rows(4))  blabel(bar, position(inside) format(%12.2f)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) bargap(15) bar(1, col(gs5))  bar(2, fi(inten60)) bar(3, fi(inten60)) bar(4, fi(inten60)) bar(5, fi(inten60))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) name("miet_wblq", replace)
	graph save   "${graphs}/miet_wblq_simu.gph", replace	
	graph export "${graphs}/miet_wblq_simu.png", replace	



graph bar eigenblq_initial eigenblq_50 eigenblq_100 eigenblq_150 eigenblq_200 [w=hhrf], /// 
		ytitle("in %", size(medium) margin(right)) ///
		title("Corona-Einkommensschock Scenarien:""Bruttokalte Wohnbelastungsq. v. Eigent.") ///
		legend(order(1 "Ausgangssituation" 2 "50€/Monat Einbuße" 3 "100€/Monat Einbuße" 4 "150€/Monat Einbuße" 5 "200€/Monat Einbuße")pos(6) rows(4))  blabel(bar, position(inside) format(%12.2f)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) bargap(15) bar(1, col(gs5))  bar(2, fi(inten60)) bar(3, fi(inten60)) bar(4, fi(inten60)) bar(5, fi(inten60))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) name("bk_wblq", replace)
	graph save   "${graphs}/eigenblq_simu.gph", replace	
	graph export "${graphs}/eigenblq_simu.png", replace	

graph bar eig_wblq_initial eig_wblq_50 eig_wblq_100 eig_wblq_150 eig_wblq_200 [w=hhrf], /// 
		ytitle("in %", size(medium) margin(right)) ///
		title("Corona-Einkommensschock Scenarien:""Wohnbelastungsquote v. Eigentümern") ///
		legend(order(1 "Ausgangssituation" 2 "50€/Monat Einbuße" 3 "100€/Monat Einbuße" 4 "150€/Monat Einbuße" 5 "200€/Monat Einbuße")pos(6) rows(4))  blabel(bar, position(inside) format(%12.2f)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) bargap(15) bar(1, col(gs5))  bar(2, fi(inten60)) bar(3, fi(inten60)) bar(4, fi(inten60)) bar(5, fi(inten60))  ///
		plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) name("eig_wblq", replace)
	graph save   "${graphs}/eig_wblq_simu.gph", replace	
	graph export "${graphs}/eig_wblq_simu.png", replace	


 graph combine mblq bk_wblq miet_wblq eig_wblq, xcommon cols(2)
	graph save   "${graphs}/simu_combined.gph", replace	
	graph export "${graphs}/simu_combined.png", replace	












