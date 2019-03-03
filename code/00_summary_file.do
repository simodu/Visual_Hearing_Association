

**********************************************************************************************************************
**********************************************************************************************************************

asdoc codebook err11 err12 , save(err sum.doc) replace 

asdoc des , save(err sum.doc)
 
 
 **********************************************************************************************************************
**********************************************************************************************************************

 use "C:\Users\sdu7\Box Sync\Edoc\data\23Jan2019\edoc2_190123.dta" ,clear 
 
 asdoc codebook , save(edoc2 sum.doc)  replace 
**********************************************************************************************************************
**********************************************************************************************************************


global root  "C:\Users\sdu7\Box Sync\Edoc"
 
 use "$root\data\OCT_all.dta" ,clear 
 
  asdoc  ///
   codebook x6macoverallgccthickness x3macoverallgccthickness nflthicknessoverall , save(OCTA.doc )   replace  
 
 
 asdoc  ///
 des, save(OCTA.doc )  
 
 
 
 capture drop dup 
 
 asdoc  duplicates report id  , save(OCTA.doc ) 
 
 
 duplicates tag  id , gen(dup)  
 
 
  
  asdoc   ///
  list id visitdate eye     /// 
  x6macoverallgccthickness x3macoverallgccthickness nflthicknessoverall  ///
  if dup ==1   ,   save(OCTA.doc ) 
 
  
  **********************************************************************************************************************
**********************************************************************************************************************



















