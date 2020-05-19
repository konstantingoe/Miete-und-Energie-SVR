*** 

clear all 
set more off
set scheme s2color8



********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************

					**** Retrieving the RAW data ****

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************


* initiate data set
use hid syear hsample sampreg hbleib hhrf hhrf1 using "${data}/hpathl.dta", clear 

* retrieve from hbrutto

merge 1:1 hid syear using "${data}/hbrutto.dta", keepus(regtyp hhgr) keep(1 3) nogen 

* retrieve h variables from hgen:

merge 1:1 hid syear using "${data}/hgen.dta", keep(1 3) nogen

keep hid syear hsample sampreg regtyp hhgr hbleib hhrf hhrf1 hgacquis hgcnstyrmax hgcnstyrmin ///
	 hgelectr hgcondit hgelectrinfo hgeqpinsul hgeqpnobar hgutil hgutilinfo ///
	 hggas hggasinfo hgheat hgheatinfo hgi1hinc hgmoveyr hgnuts1 hgowner    ///
	 hgreduc hgrent hgrentinfo hgreval hgroom hgrsubs hgseval hgsize        ///
	 hgsubsid hgtyp1hh
	 
* retrieve h variables from hl:
local hlvars = "hlf0087_h hlf0088_h hlf0601 hlf0602 hlc0176 hlf0600 hlf0091_h hlf0082 hlf0090_h hlf0603 hlf0084 hlf0604 hlf0186"

merge 1:1 hid syear using "${data}/hl.dta", keep(1 3) nogen keepus(`hlvars')

* retrieve regional data

merge 1:1 hid syear using "${data_reg}/regionl.dta", keep(1 3) nogen keepus(bik ggk )

merge 1:m hid syear using "${data}/ppathl.dta", keep(1 3) nogen keepus(pid gebjahr migback)


gen age = syear - gebjahr if gebjahr > 0 & !missing(gebjahr) & syear >0 & !missing(syear)

drop if age < 18 

bys hid syear: egen max_age = max(age) if age >0 & !missing(age) 
bys hid syear: egen mean_age = mean(age) if age >0 & !missing(age) 

gen mind_mig = (inlist(migback, 2,3)) if migback >0 & !missing(migback) 

bys hid syear: egen migb_hh = max(mind_mig) if mind_mig >=0 & !missing(mind_mig)  

drop gebjahr migback age mind_mig pid 

forval t = 1984 / 2018{
duplicates drop hid if syear == `t', force
}


merge 1:m hid syear using "${data}/pgen.dta", keep(1 3) nogen keepus(pid pgemplst pglfs pgstib)

bys syear hid: gen n = _n

bys syear hid: egen n_hh = max(n) 
drop n

gen exclusion = (inlist(pgstib, 10,11,12,13)) if !missing(pgstib)

bys syear hid: egen exclusion_n = total(exclusion) if !missing(exclusion)

gen exclusion_hh = (exclusion_n== n_hh) if !missing(exclusion_n) & !missing(n_hh)

drop n n_hh exclusion exclusion_n pid

forval t = 1984 / 2018{
duplicates drop hid if syear == `t', force
}




*** make population restrictions: ***

* this will drop Refugee samples and Heimbewohner
keep if hgowner > 0 & hgowner != 5	& hgrent != -5 
* HHnetincome is only available since 1995
keep if syear >= 1995


* split population into owners and renters

cap drop owner
gen owner = (hgowner == 1) if !missing(hgowner)





********************************************************************************
********************************************************************************
****************************  Mieter  ****************************************** 
********************************************************************************
********************************************************************************


gen bruttowarm = hgrent + hgheat if hgrent > 0 & !missing(hgrent) & hgheat > 0 & !missing(hgheat)
replace bruttowarm = hgrent if hgrent > 0 & !missing(hgrent) & hgheat == -2 & hgheatinfo == 3

gen eq_hhinc = hgi1hinc / round(sqrt(hhgr))
replace eq_hhinc = hgi1hinc if hgi1hinc < 0 

global cpi "75.1 76.1 77.6 78.3 78.8 79.9 81.5 82.6 83.5 84.9 86.2 87.6 89.6 91.9 92.2 93.2 95.2 97.1 98.5 99.5 100.0 100.5 102.0 103.8"


gen real_gross_rent = . // generated rent in real terms
gen real_bruttowarm = .
gen real_elect = .
gen real_hhnet = .
gen real_eq_hhinc = .
gen real_util = .

local v = 1995

foreach val in $cpi {
	
	replace real_gross_rent = hgrent * 100 / `val' if syear == `v' & hgrent != -2
	
	replace real_bruttowarm = bruttowarm * 100 / `val' if syear == `v' & bruttowarm > 0 & !missing(bruttowarm) 
	
	replace real_elect = hgelectr * 100 / `val' if syear == `v' & hgelectr > 0 & !missing(hgelectr) 

	replace real_hhnet = hgi1hinc * 100 / `val' if syear == `v' & hgi1hinc > 0 & !missing(hgi1hinc) 

	replace real_eq_hhinc = eq_hhinc * 100 / `val' if syear == `v' & eq_hhinc > 0 & !missing(eq_hhinc) 

	replace real_util = hgutil * 100 / `val' if syear == `v' & hgutil > 0 & !missing(hgutil) 

		local v = `v' + 1	
}

replace real_gross_rent = hgrent if hgrent == -2
replace real_elect = hgelectr if hgelectr == -2
replace real_eq_hhinc = hgi1hinc if hgi1hinc < 0 
replace real_util = hgutil if hgutil < 0 



********************************************************************************
					******** Kostenstellen Wohnen (Mieter) **********
********************************************************************************	

gen real_rent_sqmtr = real_gross_rent / hgsize if real_gross_rent > 0 & !missing(real_gross_rent)  // generated rent per squaremeter
gen real_bruttowarm_sqmtr = real_bruttowarm / hgsize if real_bruttowarm > 0 & !missing(real_bruttowarm) // generated rent per squaremeter
gen real_wk_ges_sqmtr = (real_bruttowarm + real_elect) / hgsize if real_bruttowarm > 0 & !missing(real_bruttowarm) & real_util > 0 & !missing(real_util)  & real_elect > 0 & !missing(real_elect) // generated living costs per squaremeter

gen real_util_sqmtr = real_util / hgsize if hgutil > 0 / !missing(hgsize) & !missing(real_util) 



********************************************************************************
					******** Belastungsquoten Mieter **********
********************************************************************************	

*** Mietbelastungsquote, Energiebelastungsquote und Wohnkostenbelastungsquote ***

gen mblq = hgrent/hgi1hinc * 100 if owner != 1 & hgowner == 2 & hgrent > 0 & !missing(hgrent) & hgi1hinc > 0 & !missing(hgi1hinc)

gen elect_share = hgelectr/ hgi1hinc * 100 if owner != 1 & hgowner == 2 & hgelectr > 0 & !missing(hgelectr) & hgi1hinc > 0 & !missing(hgi1hinc)

gen energy = hgelectr + hgheat if hgelectr > 0 & !missing(hgelectr) & hgheat > 0 & !missing(hgheat) 
gen energy_blq = energy / hgi1hinc * 100 if owner != 1 & hgowner == 2 & hgrent > 0 & !missing(hgrent) & hgi1hinc > 0 & !missing(hgi1hinc) & energy > 0 & !missing(energy)

gen warmkosten = hgrent + hgheat if hgrent > 0 & !missing(hgrent) & hgheat > 0 & !missing(hgheat)
gen warm_blq = warmkosten/hgi1hinc * 100 if owner != 1 & hgowner == 2 & warmkosten > 0 & !missing(warmkosten) & hgi1hinc > 0 & !missing(hgi1hinc)


gen mieter_wkblq = (hgrent + hgheat + hgelectr) / hgi1hinc * 100 if owner != 1 & hgowner == 2 & hgrent > 0 & !missing(hgrent) & hgheat > 0 & !missing(hgheat) & hgelectr > 0 & !missing(hgelectr)




********************************************************************************
********************************************************************************
****************************  Eigentümer  ************************************** 
********************************************************************************
********************************************************************************


********************************************************************************
			******** Kostenstellen Wohnen (Eigentümer) **********
********************************************************************************
****** Am ende alles ein syear zurücksetzen weil infos bezogen aufs Vorjahr (alle Jährlichen Angaben)
********************************************************************************
********************************************************************************	
*** Monatl. Zins/Tilgungszahlungen
gen belastet =  hlf0087_h if  hlf0087_h >0 & !missing(hlf0087_h)
replace belastet = 1 if hlf0088_h > 0 & !missing(hlf0088_h) & belastet != 1
replace belastet = 0 if belastet == 2
label var belastet "Tilg. Zahlungen für selbstg. Immob." 
#delim ; 
label def belastet 
0 "keine Tilgungszahlungen [0]" 
1 "Tilgungszahlungen [1]", replace; 
#delim cr 
label values belastet belastet

* hier nicht mit cpi bereinigen weil schon eingepreist
gen zinshoehe = hlf0088_h if hlf0088_h >0 & !missing(hlf0088_h)

********************************************************************************
********************************************************************************
*** Modernsisierungskosten letztes Kalenderjahr (nur verfügbar 2016-2018)

gen modern = hlc0176 if hlc0176 >0 & !missing(hlc0176)
replace modern = 1 if hlf0600 >0 & !missing(hlf0600) & modern != 1
replace modern = 0 if modern == 2
label var modern "Letztes Jahr Modernisierungskosten" 
#delim ; 
label def modern 
0 "keine Modern.kost. [0]" 
1 "Modern.kost. [1]", replace; 
#delim cr 
label values modern modern

gen modernhoehe = hlf0600 if hlf0600 >0 & !missing(hlf0600)
replace modernhoehe = 0 if modern == 0 & belastet == 1

********************************************************************************
********************************************************************************
*** Grundsteuer letztes Kalenderjahr

gen grundsteuer = hlf0601 if hlf0601 >0 & !missing(hlf0601)
replace grundsteuer = 0 if hlf0602 == 1


********************************************************************************
********************************************************************************
*** Nebenkosten letztes Kalenderjahr

gen nebenkosten = hlf0091_h if hlf0091_h >0 & !missing(hlf0091_h)
replace nebenkosten = 0 if hlf0082 == 2

********************************************************************************
********************************************************************************
*** Heizkosten letztes Kalenderjahr

gen heizkosten = hlf0090_h if hlf0090_h > 0 & !missing(hlf0090_h)
replace heizkosten = 0 if hlf0603 == 1


********************************************************************************
********************************************************************************
*** Stromkosten letztes Kalenderjahr
gen stromkosten = hlf0084 if hlf0084 > 0 & !missing(hlf0084)
replace stromkosten = 0 if hlf0604 == 1


********************************************************************************
********************************************************************************
*** Alle jährlichen Variablen ein syear zurück setzen und durch 12 teilen
*** Vielleicht doch nicht zurück setzen ist bissi kacke

bys hid: gen n = _n // if owner == 1 & belastet == 1
bys hid: egen maxn = max(n) // if owner == 1 & belastet == 1

gen stromkosten2 = stromkosten[_n+1]
bys hid: replace stromkosten2 = . if n == maxn


foreach var in modernhoehe grundsteuer nebenkosten heizkosten stromkosten {
	replace `var' = `var' / 12 if `var' >= 0 & !missing(`var')
}


gen real_modern = .
gen real_grundsteuer = .
gen real_nebenkosten = .
gen real_heizkosten = .
gen real_stromkosten = .
local v = 1995

foreach val in $cpi {
	
	replace real_modern = modernhoehe * 100 / `val' if syear == `v' & modernhoehe >= 0 & !missing(modernhoehe)
	replace real_grundsteuer = grundsteuer * 100 / `val' if syear == `v' & grundsteuer >= 0 & !missing(grundsteuer)
	replace real_nebenkosten = nebenkosten * 100 / `val' if syear == `v' & nebenkosten >= 0 & !missing(nebenkosten)
	replace real_heizkosten = heizkosten * 100 / `val' if syear == `v' & heizkosten >= 0 & !missing(heizkosten)
	replace real_stromkosten = stromkosten * 100 / `val' if syear == `v' & stromkosten >= 0 & !missing(stromkosten)

		local v = `v' + 1	
}

********************************************************************************
					******** Eigentümeraggregate **********
********************************************************************************	
*** Bruttokalte Wohnkosten

gen wohnbruttokalt_nackt = zinshoehe + real_nebenkosten

gen wohnbruttokalt = zinshoehe + real_modern + real_grundsteuer + real_nebenkosten

*** Wohngeld 
gen wohngeld = real_modern + real_nebenkosten

*** Bruttowarme Wohnkosten Bruttokalt + Frage 23 

gen bruttowarm_nackt = wohnbruttokalt_nackt + real_heizkosten

gen bruttowarm_eigent = wohnbruttokalt + real_heizkosten


*** Wohnkosten gesamt 

gen wohnk_nackt = bruttowarm_nackt + real_stromkosten

gen wohnk_gesamt = bruttowarm_eigent + real_stromkosten


****** Auf quadratmeter normalisieren

gen zins_sqmtr = zinshoehe / hgsize if zinshoehe >0 & !missing(zinshoehe) & hgsize > 0 & !missing(hgsize) 
gen wohnbruttokalt_sqmtr = wohnbruttokalt_nackt / hgsize if wohnbruttokalt_nackt >0 & !missing(wohnbruttokalt_nackt) & hgsize > 0 & !missing(hgsize) 
gen wohnbruttowarm_sqmtr = bruttowarm_nackt / hgsize if bruttowarm_nackt >0 & !missing(bruttowarm_nackt) & hgsize > 0 & !missing(hgsize) 
gen wohnkosten_sqmtr = wohnk_nackt / hgsize if wohnk_nackt >0 & !missing(wohnk_nackt) & hgsize > 0 & !missing(hgsize) 


********************************************************************************
					******** Belastungsquoten Eigentümer **********
********************************************************************************	

* Bruttokalte Wohnkosten BLQ
gen eigen_blq = (zinshoehe + nebenkosten) / hgi1hinc * 100 if owner == 1 & belastet == 1 & hgi1hinc > 0 & !missing(hgi1hinc)

* Energiekosten BLQ
gen eigen_energieblq = (heizkosten + stromkosten) / hgi1hinc * 100 if owner == 1 & belastet == 1 & hgi1hinc > 0 & !missing(hgi1hinc)

* Gesamte Wohnkosten BLQ
gen eigen_wkblq = (zinshoehe + nebenkosten + heizkosten + stromkosten) / hgi1hinc * 100 if owner == 1 & belastet == 1 & hgi1hinc > 0 & !missing(hgi1hinc)
gen eigen_wkblq_2018 = (zinshoehe + nebenkosten + heizkosten + stromkosten + grundsteuer) / hgi1hinc * 100 if owner == 1 & belastet == 1 & hgi1hinc > 0 & !missing(hgi1hinc)




********************************************************************************
					******** Subgruppenbildung **********
********************************************************************************	

**** Haushaltsnettoeinkommensgruppen

gen hhinc_group = .
replace hhinc_group = 1 if hgi1hinc > 0 & hgi1hinc <= 1500 & !missing(hgi1hinc)
replace hhinc_group = 2 if hgi1hinc > 1500 & hgi1hinc <= 3000 & !missing(hgi1hinc)
replace hhinc_group = 3 if hgi1hinc > 3000 & hgi1hinc <= 4000 & !missing(hgi1hinc)
replace hhinc_group = 4 if hgi1hinc > 4000 & !missing(hgi1hinc)

label var hhinc_group "HH-Einkommensgruppen" 
#delim ; 
label def hhinc_group 
1 "bis 1500€ [1]" 
2 "1500€ - 3000€ [2]" 
3 "3000€ - 4000€ Einw. [3]" 
4 "mehr als 4000€ [4]", replace; 
#delim cr 
label values hhinc_group hhinc_group


* HH typen

gen hhtyp = .
replace hhtyp = 1 if hgtyp1hh == 1
replace hhtyp = 2 if hgtyp1hh == 3
replace hhtyp = 3 if hgtyp1hh == 2
replace hhtyp = 4 if inlist(hgtyp1hh, 4,5,6)

label var hhtyp "HH Typen" 
#delim ; 
label def hhtyp 
1 "1 Pers. HH [1]" 
2 "Alleinerz. HH [2]" 
3 "Paar HH ohne K. [3]" 
4 "Paar HH mit K. [4]", replace; 
#delim cr 
label values hhtyp hhtyp


*** regional size

gen region = .
replace region = 1 if inrange(bik, 6,9)
replace region = 2 if inlist(bik, 4,5,2,3)
replace region = 3 if inlist(bik, 0,1)
label var region "Region Größe" 
#delim ; 
label def region 
1 "Unter 50.000 Einw. [1]" 
2 "50.000 - 500.000 Einw. [2]" 
3 "500.000+ Einw. [3]", replace; 
#delim cr 
label values region region



	cap drop wohndauer
gen wohndauer = .
replace wohndauer = 1 if hgmoveyr <= 1990
replace wohndauer = 2 if hgmoveyr > 1990 & hgmoveyr <= 2000
replace wohndauer = 3 if hgmoveyr > 2000 & hgmoveyr <= 2010
replace wohndauer = 4 if hgmoveyr > 2010 & !missing(hgmoveyr)
replace wohndauer = . if hgmoveyr <= 0
label var wohndauer "Region Größe" 
#delim ; 
label def wohndauer 
1 "Vor 1990 [1]" 
2 "1990 - 2000 [2]" 
3 "2000 - 2010 [3]"
4 "2010 - 2018 [4]", replace; 
#delim cr 
label values wohndauer wohndauer


**** Armutsrisikoquote 
	cap drop schwelle
gen schwelle =.
forval t = 1995 / 2018 {
	qui sum eq_hhinc [w=hhrf1] if eq_hhinc >0 & !missing(eq_hhinc) & syear == `t', d
	scalar hhmed = r(p50)
		replace schwelle = 0.6 * hhmed if syear == `t'
}

	cap drop arisiko
gen arisiko = 0
replace arisiko = 1 if eq_hhinc < schwelle
replace arisiko = . if missing(schwelle) | missing(eq_hhinc)


**** Plot HH-Nettoeinkommensentwicklung und Bruttokalt bzw Bruttowarmmietentwicklung


qui sum real_hhnet [w=round(hhrf1)] if syear == 1995 & owner != 1 & hgowner == 2, d
scalar hhinc_mean = r(p50)

gen hhnet100 = real_hhnet / hhinc_mean * 100  

qui sum real_gross_rent [w=round(hhrf1)] if syear == 1995 & owner != 1 & hgowner == 2, d
scalar rent_mean = r(p50)

gen rent100 = real_gross_rent / rent_mean * 100  

**** Durchschnittsalter im Haushalt
lab var mean_age "Durchschnittsalter des Haushalts (o. Kinder)"

	cap drop age_group
gen age_group = .
replace age_group = 1 if mean_age > 0 & mean_age < 35
replace age_group = 2 if mean_age >= 35  & mean_age < 50
replace age_group = 3 if mean_age >= 50  & mean_age < 65
replace age_group = 4 if mean_age >= 65  & !missing(mean_age)

label var age_group "Altersgruppen HH" 
#delim ; 
label def age_group 
1 "<35 [1]" 
2 "35 - 50 [2]" 
3 "50 - 65 [3]"
4 ">65 [4]", replace; 
#delim cr 
label values age_group age_group




**** Mind. eine Person mit (in)direktem Migrationshintergrund

lab var migb_hh "Mig. HH (mind. 1. Pers.)"


*** Notlagen 
	cap drop notrücklagen
gen notrücklagen = .
replace notrücklagen = 0 if hlf0186 == 2
replace notrücklagen = 1 if hlf0186 == 1 
lab var notrücklagen "Rücklagen für Notfälle"





save "${temp}/temp1.dta", replace


