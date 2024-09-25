capture include cd "/hdir/0/chrissoria/ses_international/data"
capture include cd "C:\Users\Ty\Desktop\ses_international"
clear all
capture log close
use data_in/ipumsi_00002.dta

keep if age > 64 & age < 90

keep if (bplcountry == 23050 | bplcountry == 21080 | bplcountry == 21100 | bplcountry == 22030 | bplcountry == 22040 | bplcountry == 22050 | bplcountry == 22060 | bplcountry == 21180 | bplcountry == 24040)

save data_out/US_65_89.dta, replace

clear

use data_in/ses.dta

keep if age > 64 & age < 90

gen married_cohab = (marst == 2) if marst != .

*keep if country != 840

save data_out/international__65_89.dta, replace

clear all

