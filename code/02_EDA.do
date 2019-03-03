

cd "C:\Users\sdu7\Box Sync\Edoc\results"
use "C:\Users\sdu7\Box Sync\Edoc\data\01_visual_hearing.dta" , clear 
 
 

* near acuity 

 // check the distribution 
 
 set scheme s2color
  
 
**********************************************************************************************************************
**********************************************************************************************************************
use "C:\Users\sdu7\Box Sync\Edoc\data\01_visual_hearing.dta" , clear 
 
 
**********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************
 


graph box bvc, over(bptacat3) 
graph save bvc_box



graph box bva, over(bptacat3) 
graph save bva_box

table1_mc, by(bptacat3)  ///
vars(bvc contn \ bva contn \ v6age61 contn \  female bin \ black bin ) 


 
regress bvc  bpta 

regress bvc  bpta v6age61 female black 
 

  
regress bva  SNRloss 

regress bva  SNRloss v6age61 female black 
 

scatter bva bvc 
sum bva bvc ,det
 

 
***********************************************************
          ************* SNR & visual *********
***********************************************************

hist SNRloss, freq  normal 

graph export SNRloss.png ,replace 



**************************OCT data exploration *********************************
**************************OCT data exploration *********************************


* Edoc *
global root  "C:\Users\sdu7\Box Sync\Edoc"

use "$root\data\02_visual_hearing.dta" ,clear 

// codebook 

codebook nflthicknessoverall supnflthickness infnflthickness nfl1thickness ///
nfl2thickness nfl3thickness nfl4thickness nfl5thickness nfl6thickness nfl7thickness nfl8thickness ///
 x6macinfgccthickness x6macgcc1thickness x6macgcc2thickness x6macgcc3thickness x6macgcc4thickness ///
 x3macoverallgccthickness x3macsupgccthickness x3macinfgccthickness nflthicknessoverall , com 

 
 
 // check the duplicates 
 
 
 use "$root\data\OCT_all.dta" ,clear 
 
  duplicates report id 
 

 
 
 
 // check the distribution 
 
 hist nflthicknessoverall , freq normal 
 graph save ngl,replace 
 hist x3macoverallgccthickness, freq normal 
 graph save gcc, replace 
 graph combine "ngl" "gcc" , altshrink  
 graph export oct_hist.png, replace 
 
 
 //  check the correlation 
 
 sum nflthicknessoverall x3macoverallgccthickness ///
 bpta SNRloss bvc bva
 
  
  corr nflthicknessoverall x3macoverallgccthickness 
   corr nflthicknessoverall SNRloss  bpta 
  corr   x3macoverallgccthickness SNRloss  bpta 

  
  
************************* *********************************
************************* *********************************
************************* *********************************

// check the better vision / worse vision 

codebook bvc bva  wvc wvc  

scatter bvc bva 
scatter  wvc wva  



// check the overlap 

foreach v in evs1a evs1b evs23 evs25 SNRloss {
count if !missing(bpta) & !missing(`v')
}

table1_mc if !missing(bpta), vars(evs1a contn \ evs1b  contn \ evs23  contn \ evs25  contn  )

table1_mc if !missing(SNRloss), vars(evs1a contn \ evs1b  contn \ evs23  contn \ evs25  contn   )


* 746 


// check pop charateristic

tab gender 

****************************************************

// check the correlation 


corr SNRloss bpta bvc bva  wvc wvc  

corr evs1a evs1b evs23 evs25   ptar ptal 


* male
corr  SNRloss bpta bvc bva  wvc wvc    if gender == "M"
*female
corr  SNRloss bpta bvc bva  wvc wvc    if gender == "F"




//  regression model 

foreach v in evs1a evs1b evs23 evs25  {
regress bpta `v' 
}

foreach v in evs1a evs1b evs23 evs25  {
regress bpta `v' if gender == "M"
}

foreach v in evs1a evs1b evs23 evs25  {
regress bpta `v' if gender == "F"
}



codebook evs6a evs7a evs8a evs9a evs10a evs11a evs12a evs13a   ///
evs6b evs7b evs8b evs9b evs10b evs11b evs12b evs13b   ,com 


// near acuity
* time to read 
corr evs6a evs7a evs8a evs9a evs10a evs11a evs12a evs13a   
*error
corr evs6b evs7b evs8b evs9b evs10b evs11b evs12b evs13b  

* time & error

corr evs6a evs7a evs8a evs9a evs10a evs11a evs12a evs13a ///
evs6b evs7b evs8b evs9b evs10b evs11b evs12b evs13b 
 

// correlation cronbach's alpha


alpha  evs6a evs7a evs8a evs9a evs10a evs11a evs12a evs13a  ,det 
alpha evs6b evs7b evs8b evs9b evs10b evs11b evs12b evs13b  ,det 

// ICC
icc evs6a evs7a evs8a evs9a evs10a evs11a evs12a evs13a
icc evs6b evs7b evs8b evs9b evs10b evs11b evs12b evs13b  



