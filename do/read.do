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

/*we want these six categories
1. hispanic black foreign
2. hispanic white foreign (this category is least meaningful)
3. hispanic other foreign
4. non-hispanic black native
5. non-hispanic white native
6. non-hispanic other native
*/

gen native_foreign_race = nativity_string + " " + race_string
tab native_foreign_race

gen race_native_category = .

* Recode into six categories
replace race_native_category = 1 if native_foreign_race == "foreign-born black hispanic"
replace race_native_category = 2 if native_foreign_race == "foreign-born white hispanic"
replace race_native_category = 3 if native_foreign_race == "foreign-born other hispanic"
replace race_native_category = 4 if native_foreign_race == "native-born black not hispanic"
replace race_native_category = 5 if native_foreign_race == "native-born white not hispanic"
replace race_native_category = 6 if native_foreign_race == "native-born other not hispanic"

replace race_native_category = 7 if inlist(native_foreign_race, "native-born black hispanic", "native-born white hispanic", "native-born other hispanic")

label define category_labels 1 "Hispanic Black Foreign" ///
                             2 "Hispanic White Foreign" ///
                             3 "Hispanic Other Foreign" ///
                             4 "Non-Hispanic Black Native" ///
                             5 "Non-Hispanic White Native" ///
                             6 "Non-Hispanic Other Native" ///
                             7 "All Native Hispanic"

label values race_native_category category_labels

tab native_foreign_race
tab race_native_category, miss

gen married_cohab = (marst == 2) if marst != .

gen years_in_us = 2020 - yrimm
replace years_in_us = . if citizen == 2

gen age_at_immigration = age - years_in_us
replace age_at_immigration = . if citizen == 2

gen is_citizen = (citizen == 3)

gen male = (sex == 1)
gen female = (sex == 2)

gen english_speaker = (speakeng == 1)

decode edattain, gen(edattain_string)

gen less_than_primary_completed = (edattain_string == "less than primary completed")
gen primary_completed = (edattain_string == "primary completed")
gen secondary_completed = (edattain_string == "secondary completed")
gen university_completed = (edattain_string == "university completed")

preserve
***below I will create the age standardization variable***

collapse (sum) perwt, by(age2) //summing by person weight instead of actual n count
egen total_perwt = total(perwt)
gen age_weight = perwt / total_perwt
drop total_perwt
drop perwt

* Summarize age_weight to check if it sums to 1
summarize age_weight

export delimited using "data/us_age_weights.csv", replace
save data/us_age_weights.dta, replace
restore

merge m:1 age2 using us_age_weights.dta

gen perwt_age_standardized = perwt * age_weight

save data/US_65_89.dta, replace

clear

use data/ses.dta

keep if age > 64 & age < 90

gen married_cohab = (marst == 2) if marst != .

*keep if country != 840

save data/international__65_89.dta, replace

clear all

