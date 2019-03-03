* 2018/12/31

 
***************dataset with demographic factors *************

/*


 use "C:\Users\sdu7\Box Sync\CCHPH\ARIC_General\General\Dataset\aud_clean_10_3.dta" ,clear
 merge 1:1  id using  "Z:\DATA.stata\Visit6\hhi.dta",update
 drop _merge
 merge 1:1  id using  "Z:\DATA.stata\Visit6\hne.dta",update
 drop _merge
  merge 1:1  id using  "Z:\DATA.stata\Visit1\hom.dta",update
 drop _merge
 merge 1:1 id using "Z:\DATA.stata\Visit6\derive61_180912.dta",update
 drop _merge
 merge 1:1 id using "Z:\DATA.stata\Visit1\derive13.dta",update

 
  
 *** gen bpta ****
 
 
 
* four frequency 
// generate average PTA for right & left ear 

gen ptar=(aud4a3 + aud4a7 + aud4a9 + aud4a13)/4				//
	gen ptal=(aud4b3 + aud4b7 + aud4b9 + aud4b13)/4				//
		label var 												///
		ptar 													///
		"PTA Right"												//
	label var 													///
		ptal 													///
		"PTA Left"												//
 
codebook aud4a3	aud4a7 aud4a9 aud4a13 ptar ptal,com // check the vars
	
	
************** Bilateral Hearing Loss (better ear hearing  )*************
	
// generate continuous variable
gen bpta = min(ptar, ptal) ///
if !missing(ptar) & !missing(ptal)
label var bpta "better ear hearing"



// gen binary var 
gen bptacat = (bpta >25 ) if!missing(bpta)
		label var 												///
			bptacat 											///
			"PTA binary <=25 vs. >25"							//
label values bptacat bcat
label define bcat 1 "Hearing impaired"  0 "Normal Hearing"
  
  
  //
  
  

	gen bptacat3 = 0 if bpta <=25 
	replace bptacat3 =1 if bpta >25  & bpta <= 40 
	replace bptacat3 =2 if bpta >40 & !missing(bpta) 
	
	label var bptacat3 "PTA 3 categories, better ear "
	label values bptacat3 cat3
	label define cat3  0 "<=25 db" 										///
			1 ">25 & <=40 db" 									///
			2 ">40 " 									///
			
	codebook bptacat3
	tab bptacat3
	
	


* Quicksin 
**gen quicksin var 
capture drop SNRloss14 SNRloss17 SNRloss
/// Note: Formula (25.5 - the total scores) , for those who are curious about where 25.5 comes from, please check
///  https://drive.google.com/file/d/1fHaD-fsR7hXEEEgLHcqqfhLD66N_pLqw/view?usp=sharing

// track 14  & list 21
gen SNRloss14 = 25.5 - (aud5a+ aud5b+ aud5c+ aud5d + aud5e + aud5f)
//track 17  & list 15
gen SNRloss17 = 25.5 - (aud5g+ aud5h+ aud5i+ aud5j + aud5k + aud5l)

// average of lsit 12 & 15 _ final quicksin score
gen SNRloss = (SNRloss14 + SNRloss17)/2
label var SNRloss "Signal to noise ratio loss scores"

// check the variables
sum SNRloss SNRloss14 SNRloss17

  
 
 keep id   hhi1 - hhi10 /// Self-reported
 ptar ptal bpta SNRloss ///  derived vars 
 v1age01 v6age61 v6date61 /// age & date
 hom54  elevel02 /// highest education obtained & education categories 
 gender racegrp v6center  /// gender ,race, center 
 hypert65 diabts64  /// hypertension and diabetes 

 keep if  !missing(v6date61)  // only keep participants who attended visit 6  


save "C:\Users\sdu7\Box Sync\CCHPH\ARIC_General\General\Dataset\aud_demo_12_31.dta" ,replace



*/ 
 
 
 // 
 
 
 
 * smell 
 
 //  merge 1:1 id using "Z:\DATA.stata\Visit6\ncs.dta" , nogen 
  
 //   ncs14 ncs14a ncs14b ncs14c ncs14c1 ncs14d ncs14e ncs14e1 ncs14f ncs14f1 ncs14f2
 
 
 global root  "C:\Users\sdu7\Box Sync\Edoc"
 
 **********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************

 // OCT data 
 
 import excel "$root\data\ARIC_EYEDOC_20180709_Batch1_New format.xlsx", sheet("Sheet1")  ///
 firstrow  cellrange(A2:DJ58)  case(lower) clear
 
 save "$root\data\OCT1.dta",replace
  
 import excel "$root\data\ARIC_EYEDOC_20180709_Batch2_New_format.xlsx", sheet("Sheet1")  ///
 firstrow  cellrange(A2:DJ58)  case(lower) clear
  save "$root\data\OCT2.dta",replace

  
 import excel "$root\data\ARIC_EYEDOC_20180801_Batch3.xlsx", sheet("Sheet1")  ///
 firstrow  cellrange(A2:DJ58)  case(lower) clear
 
  save "$root\data\OCT3.dta",replace

  
 import excel "$root\data\ARIC_EYEDOC_20181009_Batch4.xlsx", sheet("Sheet1")  ///
 firstrow  cellrange(A2:DJ58)  case(lower) clear
  save "$root\data\OCT4.dta",replace

 
 // append and merge , data manupulation 
 
 use "$root\data\OCT1.dta", clear 
 append   using "$root\data\OCT2.dta", force   
  append   using "$root\data\OCT3.dta", force   
 append   using "$root\data\OCT4.dta", force    

 save "$root\data\OCT_all.dta" , replace 
 
 
 
**********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************

 
 
 
 
 
 
 
 **********************************************************************************88
  
 global root  "C:\Users\sdu7\Box Sync\Edoc"
  use "$root\data\evs_190123.dta" ,clear 
  
  // rename id for merging 
  rename SubjectID id 
 // visual and hearing function data 
 
 merge 1:1 id using  "C:\Users\sdu7\Box Sync\CCHPH\ARIC_General\General\Dataset\aud_demo_12_31.dta" , update  gen(match) // aud & demo dataset
 
 // select participants 
 
  keep if match ==3 | match == 1  // matched or have vision (without hearing /v6 )  
 
 // change to lower case 
 
  rename EVS* , lower 
 
 
 /*



    Result                           # of obs.
    -----------------------------------------
    not matched                         3,096
        from master                         4  (match==1)
        from using                      3,092  (match==2)

    matched                               911
        not updated                       911  (match==3)
        missing updated                     0  (match==4)
        nonmissing conflict                 0  (match==5)
    -----------------------------------------




*/


****************************************************
****************************************************
************** better visual   *************

// generate continuous variable

* visual contrast 

gen bvc = max(evs23 ,evs25) ///
if !missing(evs23) & !missing(evs25)
label var bvc "better visual contrast"

* visual acuity 

gen bva = max(evs1a, evs1b)  ///
if !missing(evs1a) & !missing(evs1b)
label var bva "better visual acuity"



* visual contrast 

gen wvc = min(evs23 ,evs25) ///
if !missing(evs23) & !missing(evs25)
label var wvc "worse visual contrast"

* visual acuity 

gen wva = min(evs1a, evs1b)  ///
if !missing(evs1a) & !missing(evs1b)
label var wva "worse visual acuity"

 


********************************************************************************************************
********************************************************************************************************


gen black=0 if  racegrp == "B"
replace black=1 if racegrp == "W" 

*** Sex ***
gen female = (gender == "F") if !missing(gender)
  
 *** hearing ****
 
 

// gen 3& 4 & 5 categorical vars for better ear hearing 



	gen bptacat3 = 0 if bpta <=25 
	replace bptacat3 =1 if bpta >25  & bpta <= 40 
	replace bptacat3 =2 if bpta >40 & !missing(bpta) 
	
	label var bptacat3 "PTA 3 categories, better ear "
	label values bptacat3 cat3
	label define cat3  0 "<=25 db" 										///
			1 ">25 & <=40 db" 									///
			2 ">40 " 									///
			
	codebook bptacat3
	tab bptacat3
	
	
	
	
	gen bptacat4 = 0 if bpta <=25 
	replace bptacat4 =1 if bpta >25  & bpta <= 40 
	replace bptacat4 =2 if bpta >40 & bpta <=60 
	replace bptacat4 =3 if bpta > 60 & !missing(bpta)
	
	label var bptacat4 "PTA 4 categories, better ear "
	label values bptacat4 cat4
	label define cat4  0 "<=25 db" 										///
			1 ">25 & <=40 db" 									///
			2 ">40 & <=60 db" 									///
			3 ">60 db"	
	codebook bptacat4
	tab bptacat4
	
save "C:\Users\sdu7\Box Sync\Edoc\data\00_visual_hearing.dta", replace 


 **********************************************************************************************************************
**********************************Variables & Participants Selection ********************************************************** 
**********************************************************************************************************************
use "C:\Users\sdu7\Box Sync\Edoc\data\00_visual_hearing.dta" , clear 

keep id v6center gender racegrp v6date61 v6age61 diabts64 hypert65 elevel02 female black /// covariates 
ptar ptal bpta bptacat3 bptacat4 SNRloss   ///
evs0a - evs33b  ///
 bvc bva wvc wva 
 
save "C:\Users\sdu7\Box Sync\Edoc\data\01_visual_hearing.dta", replace 

/*
asdoc list if missing(v6date61)  ///
, save(analytic_datset_codebook.doc)  
*/ 


 **********************************************************************************************************************
**********************************2. two eyes, long dataset ********************************************************** 
**********************************************************************************************************************


use "C:\Users\sdu7\Box Sync\Edoc\data\01_visual_hearing.dta" , clear 

// rename right eye /ear as 1 & left eye/ear as 0  

rename ptar pat1 
rename ptal pat2 

rename evs1a evs_dis1  
rename evs1b evs_dis2  

rename evs23  evs_cs1
rename evs25  evs_cs2

rename evs29a   evs_va1
rename evs29b   evs_va2

// reshape  
 
asdoc des   , save(analytic_datset_codebook.doc)  replace 
asdoc codebook   id pat*  evs_dis* evs_cs* evs_va*  , save(analytic_datset_codebook.doc) 

 
 // reshape from wide to long 
 
 reshape long pta evs_dis evs_cs evs_va , i(id) j(eye) 

save "C:\Users\sdu7\Box Sync\Edoc\data\03_visual_hearing_long.dta" , replace  


 

**********************************************************************************************************************
**********************************3. visual function & OCT data********************************************************** 
**********************************************************************************************************************

 
 // check the duplicates 
 
 use "$root\data\OCT_all.dta" ,clear 
  
  // tag duplicates 
  
  
 duplicates   tag id eye ,gen(dup) 
  codebook dup 
  list id visitdate eye if dup ==1 
  
  
  // 
   duplicates  drop subjectid eye ,force  
   // merge with hearing and visual function dataset 


   
   
 merge 1:1 id eye using "$root\data\03_visual_hearing_long.dta" ,gen(overlap) 
 
 save "$root\data\02_visual_hearing.dta" ,replace  

 

**********************************************************************************************************************
**********************************************************************************************************************

* check the 4 people missing visit 6 date

capture log close
log using v6date_4_participant_checking.log
 

list id v6date61   if missing( v6date61 )  noob
list id evs0a -  elevel02 if missing( v6date61 ) noob


capture log close 



**********************************************************************************************************************
use "C:\Users\sdu7\Box Sync\Edoc\data\01_visual_hearing.dta" , clear 

 foreach v in evs29a evs29b {
 local label:  var label `v'  
 hist  `v', freq normal  title("`label'")
 graph save `v',   replace 
 }
 
 graph combine "evs29a" "evs29b" ,title("visual acuity ")
 graph export  vc.png, replace 
 
 
 rename ptar pat1 
rename ptal pat2 

rename evs1a evs_dis1  
rename evs1b evs_dis2  

rename evs23  evs_cs1
rename evs25  evs_cs2

rename evs29a   evs_va1
rename evs29b   evs_va2
