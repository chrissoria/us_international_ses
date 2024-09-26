capture cd "/hdir/0/chrissoria/ses_international"
capture cd "C:\Users\Ty\Desktop\ses_international"

clear all
capture log close

use data/international__65_89.dta

preserve

collapse (mean) married_cohab yrschool sex age [aweight=perwt], by(country)
list
export delimited using "tables/I_nativity_table.csv", replace

restore

preserve

collapse married_cohab yrschool age [aweight=perwt], by(country sex)
export delimited using "tables/I_nativity_table_by_sex.csv", replace
list

restore

collapse married_cohab yrschool [aweight=perwt], by(country age2 sex)
export delimited using "tables/I_nativity_table_by_sex_and_age_group.csv", replace
list

*table 2
clear all 
use data/US_65_89.dta

preserve

*nativities of interest in the US as migrants
collapse (mean) married_cohab yrschool sex age [aweight=perwt], by(bplcountry)
list
export delimited using "tables/US_nativity_table.csv", replace

restore

preserve
*nativities of interest in the US as migrants by sex

collapse (mean) married_cohab yrschool age [aweight=perwt], by(bplcountry sex)
list
export delimited using "tables/US_nativity_table_by_sex.csv", replace

restore

preserve

collapse (mean) married_cohab yrschool sex age [aweight=perwt], by(native_foreign_race)
list

export delimited using "tables/US_racial_nativity_table.csv", replace

restore

preserve

collapse (mean) married_cohab yrschool age [aweight=perwt], by(native_foreign_race sex)
list

export delimited using "tables/US_racial_nativity_table_by_sex.csv", replace

restore

preserve

*lumping all of our nativities of interest into one category
collapse (mean) married_cohab yrschool sex age [aweight=perwt], by(nativity)
list

export delimited using "tables/US_nativity_binary_table.csv", replace

restore
