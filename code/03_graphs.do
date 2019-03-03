

**************************8**************************8
 ************************** **************************
 *********************************** graphs ***********

 
use "C:\Users\sdu7\Box Sync\Edoc\data\01_visual_hearing.dta" , clear 
 
set scheme s1mono 

// va
 foreach v in evs29a evs29b {
 local label:  var label `v'  
 hist  `v', freq normal  title("`label'")
 graph save `v',   replace 
 }
 
 graph combine "evs29a" "evs29b" ,title("visual acuity ")
 graph export  va.png, replace 
 
 // visual contrast 
 
 
  foreach v in evs23 evs25  {
 local label:  var label `v'  
 hist  `v',   freq normal
 graph save `v',   replace 
 }
 
 graph combine "evs23" "evs25" ,title("visual contrast  ")
 graph export  vc.png, replace 
 
 
 
 // distance
 
  
 foreach v in evs1a evs1b {
 local label:  var label `v'  
 hist  `v', freq normal  
 graph save `v',   replace 
 }
 
 graph combine "evs29a" "evs29b" ,title("distance vision ")
 graph export  distance.png, replace 
 
 ***********************88
 *************************** 
 ** stratify by gender ****
 **************************8
 **************************
 
 
 
 
 set scheme s1color 
 
// va
 foreach v in evs29a evs29b {
 local label:  var label `v'  
 hist  `v', discrete fraction by(gender   )  
 graph export `v'.png,   replace 
 }
 
 
 
 
 // vc
  foreach v in evs23 evs25  {
 local label:  var label `v'  
 hist  `v',   discrete fraction by(gender   )    
 graph export `v'.png,   replace 
 }
 
 
 
 
 // distance
 
  
 foreach v in evs1a evs1b {
 local label:  var label `v'  
 hist  `v',  discrete fraction by(gender   )    
 graph export `v'.png,   replace 
 }
  
  
  *******************************
  ************************
 
 //   hearing 
 
   use "C:\Users\sdu7\Box Sync\Edoc\data\01_visual_hearing.dta" , clear 
 
 foreach v in ptar ptal {
 local label:  var label `v'  
 hist  `v',  discrete fraction by(gender   ) 
 graph export `v'.png,   replace 
 }
  
 *******************OCT dataset ******************************
  
 
 use "$root\data\OCT_all.dta" ,clear 
 
 set scheme s2mono
  foreach v in nflthicknessoverall x6macoverallgccthickness x3macoverallgccthickness {
 local label:  var label `v'  
 hist  `v',  frequency normal    
 graph export `v'.png,   replace 
 }
   
 
 
 
 
 *****************Putdocx*************8888***********
 *************************************************
   putdocx clear
 putdocx begin
putdocx paragraph, 
foreach x in   va vc distance   ///
  evs29a evs29b  evs23 evs25 evs1a evs1b  ///
   nflthicknessoverall x6macoverallgccthickness x3macoverallgccthickness ///
   ptar ptal  {
  putdocx image `x'.png
}

 . putdocx save  Eyedoc_EDA_Graphs.docx ,replace

 
 
 
  ************************************  END ***********************************************************

  
 
 
 
 
 
 
 
 
 
 
 
 
 ***********************88
 *************************** 
 ** stratify by gender ****
 **************************8
 **************************
 
 
 
 
 
 
 // better vision 
  
 foreach v in bvc bva {
 local label:  var label `v'  
 hist  `v', freq normal  title("`label'")
 graph save `v',   replace 
 }
 
 graph combine "bvc" "bva" ,title("better visual function ")
 graph export  bvc.png, replace 
 

 

// check the association 

foreach v in evs1a evs1b  evs23 evs25 {
scatter bpta `v' || lowess bpta `v' , legend(off)
graph save `v' , replace 
graph export `v'.png, replace 
}
graph combine "evs1a" "evs1b"  "evs23" "evs25" ,altshrink
graph export scatter.png, replace 


 
 
 
  ***********************88
 *************************** 
 ** stratify by gender ****
 **************************8
 **************************
  
 
// check the association 

foreach v in evs1a evs1b  evs23 evs25 {
scatter bpta `v' || lowess bpta `v' , legend(off)
graph save `v' , replace 
graph export `v'.png, replace 
}
graph combine "evs1a" "evs1b"  "evs23" "evs25" ,altshrink
graph export scatter_F.png, replace 

 

 
***MALE*****


use "C:\Users\sdu7\Box Sync\Edoc\data\01_visual_hearing.dta" , clear 

keep if gender == "M"

// check the distribution 
* acuity
 
hist evs1a ,freq normal 
graph save "visual acuity_R",replace

hist evs1b ,freq normal 
graph save  "visual acuity_L",replace

graph combine "visual acuity_R" "visual acuity_L", altshrink 
graph export va_M.png,replace

* contrast 

hist evs23 ,freq normal 
graph save "visual contrast_R",replace

hist evs25 ,freq normal 
graph save  "visual contrast_L",replace

graph combine "visual contrast_R" "visual contrast_L", altshrink 
graph export vc_M.png,replace




// check the association  __ better visual & better peripheral hearing  

foreach v in bva bvc {
local label : var label `v'
scatter bpta `v' , msize(tiny) jitter(10) || lowess bpta `v' , legend(off) title("`label'")
graph save `v' , replace   
 
}


graph combine "bva" "bvc" // 
 *    title{"scatter plot bpta and visual function"}

graph export scatter_better_visual_better_hearing.png, replace 


//




// better visual & better central hearing  

foreach v in bva bvc {
local label : var label `v'
scatter SNRloss `v' if racegrp == "W"   ,msize(tiny) jitter(10) || lowess SNRloss `v' if racegrp == "W"  , legend(off) title("`label'") 
graph save `v' , replace   
 
}


graph combine "bva" "bvc" // 
 *    title{"scatter plot bpta and visual function"}

graph export scatter_better_visual_quicksin.png, replace 


// check the correlation

corr bva bvc bpta SNRloss 


corr bva bvc bpta SNRloss  if racegrp == "B"
corr bva bvc bpta SNRloss if racegrp == "W"



/* 
regress bpta bva

regress bpta bvc




*/
 



