** 3514_carol_plot
clear 
local dir "C:/Users/$name/Box/1_wustl/1_spi/3_covid19/Carol/Wave4/figures_11112021"
local option2 scheme(burd) xcommon ycommon  

graph combine 	`dir'/temp/well_cantril_now_1.gph ///
					`dir'/temp/well_cantril_now_3.gph ///
					, `option2' row(1) xsize(10) ysize(8) note("90% confidence interval", size(12pt)) ///
					title("{bf:Life satisfaction}", size(16pt)) 
graph export 	"`dir'/Fig2.tiff", replace as(tif) width(1500) height(1200)

graph combine 	`dir'/temp/well_cantril_af5yr_1.gph ///
					`dir'/temp/well_cantril_af5yr_3.gph ///
					, `option2' row(1) xsize(10) ysize(8) note("90% confidence interval", size(12pt)) ///
					title("{bf:Optimism, 5 years after}", size(16pt)) 
					graph export 	"`dir'/Fig3.tiff", replace as(tif) width(1500) height(1200)

graph combine 	`dir'/temp/health_ment_1.gph ///
					`dir'/temp/health_ment_3.gph ///
					, `option2' row(1) xsize(10) ysize(8) note("90% confidence interval", size(12pt)) ///
					title("{bf:Mental health}", size(16pt))
graph export 	"`dir'/Fig4.tiff", replace as(tif) width(1500) height(1200)

graph combine 	`dir'/temp/phq_total_1.gph ///
					`dir'/temp/phq_total_3.gph ///
					, `option2' row(1) xsize(10) ysize(8) note("90% confidence interval", size(12pt)) ///
					title("{bf:PHQ-4}", size(16pt))
graph export 	"`dir'/Fig5.tiff", replace as(tif) width(1500) height(1200)

graph combine 	`dir'/temp/covid_fear_1.gph ///
					`dir'/temp/covid_fear_3.gph ///
					, `option2' row(1) xsize(10) ysize(8) note("90% confidence interval", size(12pt)) ///
					title("{bf:COVID-19 related fear}", size(16pt))
graph export 	"`dir'/Fig6.tiff", replace as(tif) width(1500) height(1200)

graph combine 	`dir'/temp/socdis_mask_1.gph ///
					`dir'/temp/socdis_mask_3.gph ///
					, `option2' row(1) xsize(10) ysize(8) note("90% confidence interval", size(12pt)) ///
					title("{bf:Wearing a mask}", size(16pt))
graph export 	"`dir'/Fig7.tiff", replace as(tif) width(1500) height(1200)

graph combine 	`dir'/temp/socdis_gather_1.gph ///
					`dir'/temp/socdis_gather_3.gph ///
					, `option2' row(1) xsize(10) ysize(8) note("90% confidence interval", size(12pt)) ///
					title("{bf:Avoiding gatherings}", size(16pt))
graph export 	"`dir'/Fig8.tiff", replace as(tif) width(1500) height(1200)

graph combine 	`dir'/temp/socdis_inform_1.gph ///
					`dir'/temp/socdis_inform_3.gph ///
					, `option2' row(1) xsize(10) ysize(8) note("90% confidence interval", size(12pt)) ///
					title("{bf:Informing COVID-19 Symptoms}", size(16pt))
graph export 	"`dir'/Fig9.tiff", replace as(tif) width(1500) height(1200)