*** 3530_carol_analysis
local suffix pool
keep if inlist(race, 1, 2, 3) // 3 = Hispanic

** Macro
* DV
local mental health_ment  
local cantril well_cantril_now well_cantril_af5yr 
local stress health_ment_stress2 /*health_ment_anxious2*/ /*health_ment_worry2 health_ment_weariness2 health_ment_hopeless2*/  
local fear covid_fear /*covid_infect covid_death*/
local socdis /*socdis_home*/ socdis_mask  socdis_gather socdis_inform

* Interaction
local interact i.wave##i.race
local margin i.wave#i.race

* Coviariates
local cluster division

local cov i.gender age agesq i.livewithpartner i.dependent i.education i.uninsured /*i.anyjobloss*/ i.anyhardship lcovidcases30  ldensity i.`cluster'


** Model macro
local weighted unweighted	
local weight /*[pweight=weight]*/
		

local vce vce(cluster division) /*vce(robust)*/

local optionp label unstack replace b(%9.3f) pr2(%9.3f) aic(%9.1f) bic(%9.1f) html se nobase numbers brackets compress
local optiona label unstack replace b(%9.3f) ar2(%9.3f) aic(%9.1f) bic(%9.1f) html se nobase numbers brackets compress

** Plots
* Graph
local scheme scheme(burd) 
local font xtitle("{bf:Time}",size(15pt))
local legend legend(rows(1) size(15pt))
local ratio xsize(5) ysize(8) 
local ratio2 xsize(5) ysize(8) 
local label xlabel(.90 " " 1 "May2020" 2 "Aug2020" 3 "Nov2020" 4 "Feb2021" 4.1 " " , labs(15pt)) 

local color1 gs4
local color2 blue
local color3 green

local plot1 plot1opts(m(Oh) mc(`color1') lc(`color1')) ci1opts(lc(`color1'))
local plot2 plot2opts(m(Dh) mc(`color2') lc(`color2')) ci2opts(lc(`color2'))
local plot3 plot3opts(m(Sh) mc(`color3') lc(`color3')) ci3opts(lc(`color3'))
local plot `plot1' `plot2' `plot3'
local recast recast(connected)

local resolution width(1000) height(1600) as(jpg)

local level level(90)

local note /*note("90% level of confidence", size(9pt))*/

* Title
local thealth_ment "Mental health" 

local tcovid_fear "COVID-19 related fear"
local tcovid_infect "COVID-19 infection concern"
local tcovid_death "COVID-19 death concern"

local tsocdis_home "Staying home"
local tsocdis_mask "Wearing a mask"
local tsocdis_gather "Avoiding gatherings"
local tsocdis_inform "Informing COVID-19 symptoms"

local twell_cantril_now "Life satisfaction"
local twell_cantril_af3mo "Optimism, 3 months after" 
local twell_cantril_af5yr "Optimism, 5 years after"
local tdcantril "Life-satifaction, Actual vs Expected"

local thealth_ment_anxious2 "Feel nervous/anxious"
local thealth_ment_worry2 "Cannot stop worrying"
local thealth_ment_weariness2 "Feel weariness"
local thealth_ment_hopeless2 "Feel down or hopeless"
local thealth_ment_stress2 "Get stressed"

local tphq_total "PHQ-4"

local income1 "Low income"
local income2 "Moderate income"
local income3 "Middle/high income"

local note2 addnote("Gender, age, living arrangements, educational attainment, health insurance status, hardships experience," ///
					"geographic attributes (at the country level), and division fixed effects controlled")

*** Analysis 
** A. Mental health by income 
local var health_ment
log using results/Carol/log/A1_`var'_raceXwave_`suffix'_`weighted', replace
log off

eststo clear
* overall
		eststo: reg `var' `interact' `cov' `weight', `vce'
			log on
			disp "{bf:`t`var'', Overall}"
			margins `margin' 
			marginsplot, title("{bf:`t`var'', Overall} ({it:OLS})", size(11pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level' ///
				ytitle("{bf:Mental health}", size(10pt)) ///
				ylabel(0 "Poor" 1 "Fair" 2 "Good" 3 "Very good" 4 "Excellent" ,labs(10pt)) 
			log off
			graph export results/Carol/margins/A1_`var'_racexwave_all_`suffix'_`weighted'.jpg, replace `resolution'

* by income
forvalue i=1/3 {
		eststo: reg `var' `interact' `cov' `weight' if income3==`i', `vce'
			log on
			disp "{bf:`t`var'', income`i'}"
			margins `margin' 
			marginsplot, title("{it:`income`i''} ({it:OLS})", size(18pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio2' `note' `level' ///
				ytitle("{bf:Mental health}", size(15pt)) ///
				ylabel(0 "Poor" 1 "Fair" 2 "Good" 3 "Very good" 4 "Excellent" ,labs(15pt)) 
			log off
			//graph export results/Carol/margins/A1_`var'_racexwave_income`i'_`suffix'_`weighted'.jpg, replace `resolution'
			graph save 	"C:/Users/$name/Box/1_wustl/1_spi/3_covid19/Carol/Wave4/figures_07302021/temp/`var'_`i'", replace 
	}
esttab 	using results/Carol/tables/A1_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'.html, `optiona' ///
			title("OLS Results - Mental health over time, `weighted'") ///
			mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
			drop(*`cluster'*)
esttab 	using results/Carol/tables/A1_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'_reduced.html, `optiona' `note2' ///
			title("OLS Results - Mental health over time, `weighted'") ///
			mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
			keep(*.wave *.race *.wave#*.race)
			
log close

** B. Cantril ladder	
* Life satisfaction
foreach var of local cantril {
	log using results/Carol/log/B1_`var'_raceXwave_`suffix'_`weighted', replace
	log off
	eststo clear
	* overall
	eststo: reg `var' `interact' `cov' `weight', `vce'
		log on
		disp "{bf:`t`var'', Overall}"
		margins `margin' 
		marginsplot, title("{bf:`t`var'', Overall} ({it:OLS})", size(11pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level'  ///
				ytitle("{bf:Cantril ladder (0-10)}", size(10pt)) ///
				ylabel(5(1)10, labs(10pt)) 
		log off
		graph export results/Carol/margins/B1_`var'_racexwave_all_`suffix'_`weighted'.jpg, replace `resolution'	
	* by income	
	forvalue i=1/3 {
		eststo: reg `var' `interact' `cov' `weight' if income3==`i', `vce'
			log on
			disp "{bf:`t`var'', income`i'}"
			margins `margin' 
			marginsplot, title("{it:`income`i''} ({it:OLS})", size(18pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level' ///
				ytitle("{bf:Cantril ladder (0-10)}", size(15pt)) ///
				ylabel(5(1)10, labs(15pt)) 
			log off
			//graph export results/Carol/margins/B1_`var'_racexwave_income`i'_`suffix'_`weighted'.jpg, replace `resolution'
			graph save 	"C:/Users/$name/Box/1_wustl/1_spi/3_covid19/Carol/Wave4/figures_07302021/temp/`var'_`i'", replace 
		}
	esttab 	using results/Carol/tables/B1_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'.html, `optiona' ///
				title("OLS Results - `t`var'', `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				drop(*`cluster'*)	
	esttab 	using results/Carol/tables/B1_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'_reduced.html, `optiona' `note2' ///
				title("OLS Results - `t`var'', `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				keep(*.wave *.race *.wave#*.race)
	log close
}

/* B2. Life satisfaction expectation 
local label xlabel(1.9 " "  2 "Aug2020" 3 "Nov2020" 4 "Feb2021" 4.1 " " , labs(10pt)) 

foreach var of var dcantril {
	log using results/Carol/log/B2_`var'_raceXwave_`suffix'_`weighted', replace
	log off
	eststo clear
	* overall
	eststo: reg `var' `interact' `cov' `weight', `vce'
		log on
		disp "{bf:`t`var'', Overall}"
		margins `margin' 
		marginsplot, title("{bf:`t`var'', Overall} ({it:OLS})", size(11pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level'  ///
			ytitle("{bf:Change in cantril ladder}", size(10pt)) ///
				ylabel(-2(.5)2, labs(10pt)) yline(0, lcolor(red))
		log off
		graph export results/Carol/margins/B3_`var'_racexwave_all_`suffix'_`weighted'.jpg, replace `resolution'	
	* by income	
	forvalue i=1/3 {
		eststo: reg `var' `interact' `cov' `weight' if income3==`i', `vce'
			log on
			disp "{bf:`t`var'', income`i'}"
			margins `margin' 
			marginsplot, title("{it:`income`i''} ({it:OLS})", size(18pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level' ///
				ytitle("{bf:Change in cantril ladder}", size(15pt)) ///
				ylabel(-2(.5)2, labs(15pt)) yline(0, lcolor(red))
			log off
			graph export results/Carol/margins/B3_`var'_racexwave_income`i'_`suffix'_`weighted'.jpg, replace `resolution'
		}
	esttab 	using results/Carol/tables/B3_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'.html, `optiona' ///
				title("OLS Results - `t`var'', `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				drop(*`cluster'*)	
	esttab 	using results/Carol/tables/B3_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'_reduced.html, `optiona' `note2' ///
				title("OLS Results - `t`var'', `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				keep(*.wave *.race *.wave#*.race)
	log close
}
*/
/** C. Stress (logit)	
local label xlabel(1.9 " "  2 "Aug2020" 3 "Nov2020" 4 "Feb2021" 4.1 " " , labs(10pt)) 

* Life satisfaction
foreach var of local stress {
	log using results/Carol/log/C1_`var'_raceXwave_`suffix'_`weighted', replace
	log off
	eststo clear
	* overall
	eststo: logit `var' `interact' `cov' `weight', `vce'
		log on
		disp "{bf:`t`var'', Overall}"
		margins `margin' 
		marginsplot, title("{bf:`t`var'', Overall} ({it:Logit})", size(11pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level'  ///
			ytitle("{bf:Probability}", size(10pt)) ///
			ylabel(0 "0" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1 "100%", labs(10pt)) 
		log off
		graph export results/Carol/margins/C1_`var'_racexwave_all_`suffix'_`weighted'.jpg, replace `resolution'	
	* by income	
	forvalue i=1/3 {
		eststo: logit `var' `interact' `cov' `weight' if income3==`i', `vce'
			log on
			disp "{bf:`t`var'', income`i'}"
			margins `margin' 
			marginsplot, title("{it:`income`i''} ({it:Logit})", size(18pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level' ///
				ytitle("{bf:Probability}", size(15pt)) ///
				ylabel(0 "0" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1 "100%", labs(15pt)) 
			log off
			graph export results/Carol/margins/C1_`var'_racexwave_income`i'_`suffix'_`weighted'.jpg, replace `resolution'
		}
	esttab 	using results/Carol/tables/C1_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'.html, eform `optionp' ///
				title("Logit Results - `t`var'', Odds ratios, `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				drop(*`cluster'*)	
	esttab 	using results/Carol/tables/C1_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'_reduced.html, eform `optionp' `note2' ///
				title("Logit Results - `t`var'', Odds ratios, `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				keep(*.wave *.race *.wave#*.race)
	log close
}
*/
** C2. PHQ-4
local label xlabel(1.9 " "  2 "Aug2020" 3 "Nov2020" 4 "Feb2021" 4.1 " " , labs(10pt)) 

local var phq_total
	log using results/Carol/log/C2_`var'_raceXwave_`suffix'_`weighted', replace
	log off
	eststo clear
	* overall
	eststo: reg `var' `interact' `cov' `weight', `vce'
		log on
		disp "{bf:`t`var'', Overall}"
		margins `margin' 
		marginsplot, title("{bf:`t`var'', Overall} ({it:OLS})", size(11pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level'  ///
				ytitle("{bf:PHQ-4} (0-2: Normal; 3-5: Mild; 6-8: Moderate; 9-12: Severe)", size(10pt)) ///
				ylabel(0 "0" 2 "2: Normal" 5 "5: Mild" 8 "8: Moderate" 12 "12: Severe", labs(10pt)) 
		log off
		graph export results/Carol/margins/C2_`var'_racexwave_all_`suffix'_`weighted'.jpg, replace `resolution'	
	* by income	
	forvalue i=1/3 {
		eststo: reg `var' `interact' `cov' `weight' if income3==`i', `vce'
			log on
			disp "{bf:`t`var'', income`i'}"
			margins `margin' 
			marginsplot, title("{it:`income`i''} ({it:OLS})", size(18pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level' ///
				ytitle("{bf:PHQ-4} (0-2: Normal; 3-5: Mild; 6-8: Moderate; 9-12: Severe)", size(15pt)) ///
				ylabel(0 "0" 2 "2: Normal" 5 "5: Mild" 8 "8: Moderate" 12 "12: Severe", labs(15pt)) 
			log off
			//graph export results/Carol/margins/C2_`var'_racexwave_income`i'_`suffix'_`weighted'.jpg, replace `resolution'
			graph save 	"C:/Users/$name/Box/1_wustl/1_spi/3_covid19/Carol/Wave4/figures_07302021/temp/`var'_`i'", replace 
		}
	esttab 	using results/Carol/tables/C2_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'.html, `optiona' ///
				title("OLS Results - `t`var'', `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				drop(*`cluster'*)	
	esttab 	using results/Carol/tables/C2_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'_reduced.html, `optiona' `note2' ///
				title("OLS Results - `t`var'', `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				keep(*.wave *.race *.wave#*.race)
	log close


** D. COVID fear
local label xlabel(.90 " " 1 "May2020" 2 "Aug2020" 3 "Nov2020" 4 "Feb2021" 4.1 " " , labs(10pt)) 

foreach var of local fear {
	log using results/Carol/log/D1_`var'_raceXwave_`suffix'_`weighted', replace
	log off

	eststo clear
	* overall
			eststo: reg `var' `interact' `cov' `weight', `vce'
				log on
				disp "{bf:`t`var'', Overall}"
				margins `margin' 
				marginsplot, title("{bf:`t`var'', Overall} ({it:OLS})", size(11pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level' ///
					ytitle("{bf:How afraid are your of ... (0-100)}", size(10pt)) ///
					ylabel(0(20)100 ,labs(10pt)) 
				log off
				graph export results/Carol/margins/D1_`var'_racexwave_all_`suffix'_`weighted'.jpg, replace `resolution'

	* by income
	forvalue i=1/3 {
			eststo: reg `var' `interact' `cov' `weight' if income3==`i', `vce'
				log on
				disp "{bf:`t`var'', income`i'}"
				margins `margin' 
				marginsplot, title("{it:`income`i''} ({it:OLS})", size(18pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level' ///
					ytitle("{bf:How afraid are your of ... (0-100)}", size(15pt)) ///
					ylabel(0(20)100 ,labs(15pt)) 
				log off
				//graph export results/Carol/margins/D1_`var'_racexwave_income`i'_`suffix'_`weighted'.jpg, replace `resolution'
				graph save 	"C:/Users/$name/Box/1_wustl/1_spi/3_covid19/Carol/Wave4/figures_07302021/temp/`var'_`i'", replace 
		}
	esttab 	using results/Carol/tables/D1_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'.html, `optiona' ///
				title("OLS Results - COVID related concerns - `t`var'', `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				drop(*`cluster'*)
	esttab 	using results/Carol/tables/D1_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'_reduced.html, `optiona' `note2' ///
				title("OLS Results - COVID related concerns - `t`var'', `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				keep(*.wave *.race *.wave#*.race)
				
	log close
}

** E. Social distancing 
foreach var of local socdis {
	log using results/Carol/log/E1_`var'_raceXwave_`suffix'_`weighted', replace
	log off

	eststo clear
	* overall
			eststo: reg `var' `interact' `cov' `weight', `vce'
				log on
				disp "{bf:`t`var'', Overall}"
				margins `margin' 
				marginsplot, title("{bf:`t`var'', Overall} ({it:OLS})", size(11pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level' ///
					ytitle("{bf:Compliance score (0-100)}", size(10pt)) ///
					ylabel(0(20)100 ,labs(10pt)) 
				log off
				graph export results/Carol/margins/E1_`var'_racexwave_all_`suffix'_`weighted'.jpg, replace `resolution'

	* by income
	forvalue i=1/3 {
			eststo: reg `var' `interact' `cov' `weight' if income3==`i', `vce'
				log on
				disp "{bf:`t`var'', income`i'}"
				margins `margin' 
				marginsplot, title("{it:`income`i''} ({it:OLS})", size(18pt) position(11)) `scheme' `font' `label' `plot' `legend' `recast' `ratio' `note' `level' ///
					ytitle("{bf:Compliance score (0-100)}", size(15pt)) ///
					ylabel(0(20)100 ,labs(15pt)) 
				log off
				//graph export results/Carol/margins/E1_`var'_racexwave_income`i'_`suffix'_`weighted'.jpg, replace `resolution'
				graph save 	"C:/Users/$name/Box/1_wustl/1_spi/3_covid19/Carol/Wave4/figures_07302021/temp/`var'_`i'", replace 
		}
	esttab 	using results/Carol/tables/E1_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'.html, `optiona' ///
				title("OLS Results - Social distancing behavior - `t`var'', `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				drop(*`cluster'*)
	esttab 	using results/Carol/tables/E1_SCORE_`var'_OLS_racexincome_`suffix'_`weighted'_reduced.html, `optiona' `note2' ///
				title("OLS Results - COVID related concerns - `t`var'', `weighted'") ///
				mtitle ("All" "Lower income" "Moderate income" "Middle/High income") ///
				keep(*.wave *.race *.wave#*.race)
				
	log close
}
