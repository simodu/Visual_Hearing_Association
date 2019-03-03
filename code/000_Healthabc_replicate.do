


use  "C:\Users\sdu7\Box Sync\dual_sen_cog\HealthABC Data\healthabc_all_02.dta " , clear 

corr bpta fvlogmar fvlcs
corr bpta fvlogmar fvlcs if female == 0
corr bpta fvlogmar fvlcs  if female == 1
 
 
 
 
* lookfor visit date vdate

// vision var checking

  sen_imp anyvimp fvblltrc fvlogmar fv2040 fvlcs fvlcs155 fvlcsalr fvdispar

tab anyvimp fv2040
tab anyvimp fvlcs155
tab anyvimp stereo85
 
  
  

 set scheme s2color  

// vision hearing correlation 
* visual acuity & contrast 

scatter  fvlcs bpta || lowess fvlcs bpta, legend(off) 

* contrast
scatter fvlogmar bpta || lowess fvlogmar bpta, legend(off) 



regress  fvlcs bpta 

regress   bpta fvlcs
// stratify
regress bpta fvlcs155


regress bpta fvlcs if female == 0
regress bpta fvlcs if female == 1

// stratify 

* visual acuity & contrast 

scatter fvlcs bpta if female ==0 ,mcolor(emidblue) msymbol(triangle) msize(tiny ) || lowess fvlcs bpta if female ==0 ,lcolor(emidblue) || ///
scatter  fvlcs bpta if female ==1, mcolor(red)  msize(tiny )   || lowess fvlcs bpta if female ==1  , lcolor(red)  


* contrast
scatter fvlogmar bpta if female ==0 ,mcolor(emidblue) msymbol(triangle) msize(tiny ) || lowess fvlogmar bpta if female ==0 ,lcolor(emidblue) || ///
scatter  fvlogmar bpta if female ==1, mcolor(red)  msize(tiny )   || lowess fvlogmar bpta if female ==1  , lcolor(red)  

regress bpta fvlogmar if female == 0
regress bpta fvlogmar if female == 1



// remove outliers 

* visual acuity & contrast 
keep if bpta < 100 
scatter fvlcs bpta if female ==0 ,mcolor(emidblue) msymbol(triangle) msize(tiny ) || lowess fvlcs bpta if female ==0 ,lcolor(emidblue) || ///
scatter  fvlcs bpta if female ==1, mcolor(red)  msize(tiny )   || lowess fvlcs bpta if female ==1  , lcolor(red)  

regress bpta fvlcs if female == 0
regress bpta fvlcs if female == 1


regress bpta c.fvlcs##i.female


* contrast
scatter fvlogmar bpta if female ==0 ,mcolor(emidblue) msymbol(triangle) msize(tiny ) || lowess fvlogmar bpta if female ==0 ,lcolor(emidblue) || ///
scatter  fvlogmar bpta if female ==1, mcolor(red)  msize(tiny )   || lowess fvlogmar bpta if female ==1  , lcolor(red)  

regress bpta fvlogmar if female == 0
regress bpta fvlogmar if female == 1






// racial differnece 

* visual acuity & contrast 

scatter fvlcs bpta if aa_race ==0 ,mcolor(emidblue) msymbol(triangle) msize(tiny ) || lowess fvlcs bpta if aa_race ==0 ,lcolor(emidblue) || ///
scatter  fvlcs bpta if aa_race ==1, mcolor(red)  msize(tiny )   || lowess fvlcs bpta if aa_race ==1  , lcolor(red)  

regress bpta fvlcs if aa_race == 0
regress bpta fvlcs if aa_race == 1

* contrast
scatter fvlogmar bpta if aa_race ==0 ,mcolor(emidblue) msymbol(triangle) msize(tiny ) || lowess fvlogmar bpta if aa_race ==0 ,lcolor(emidblue) || ///
scatter  fvlogmar bpta if aa_race ==1, mcolor(red)  msize(tiny )   || lowess fvlogmar bpta if aa_race ==1  , lcolor(red)  

regress bpta fvlogmar if aa_race == 0
regress bpta fvlogmar if aa_race == 1

