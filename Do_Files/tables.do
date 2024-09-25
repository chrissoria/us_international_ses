cd "/hdir/0/chrissoria/ses_international/data"
clear all
capture log close

use international__65_89.dta

collapse (mean) married_cohab yrschool sex age [aweight=perwt], by(country)
list
