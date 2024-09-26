capture cd "/hdir/0/chrissoria/ses_international"
capture include cd "C:\Users\Ty\Desktop\ses_international"
clear all
capture log close
use data/ipumsi_00002.dta

keep if age > 64 & age < 90

keep if (bplcountry == 23050 | bplcountry == 21080 | bplcountry == 21100 | bplcountry == 22030 | bplcountry == 22040 | bplcountry == 22050 | bplcountry == 22060 | bplcountry == 21180 | bplcountry == 24040)

decode nativity, gen(nativity_string)
decode race, gen(race_string)
decode hispan, gen(hispan_string)

replace hispan_string = "hispanic" if hispan_string != "not hispanic"

replace race_string = "other" if race_string != "white" & race_string != "black"
replace race_string = race_string + " " + hispan_string

replace race_string = "hispanic" if race_string == "black hispanic" | race_string == "other hispanic" | race_string == "white hispanic"

replace race_string = "other" if race_string == "other not hispanic"

tab race_string

gen native_foreign_race = nativity_string + " " + race_string
tab native_foreign_race

gen married_cohab = (marst == 2) if marst != .

save data/US_65_89.dta, replace

***below I will create the age standardization variable***

collapse (sum) perwt, by(age2) //summing by person weight instead of actual n count
egen total_perwt = total(perwt)
gen age_weight = perwt / total_perwt
drop total_perwt


export delimited using "data/us_age_weights.csv", replace

clear

use data/ses.dta

keep if age > 64 & age < 90

gen married_cohab = (marst == 2) if marst != .

*keep if country != 840

save data/international__65_89.dta, replace

clear all

