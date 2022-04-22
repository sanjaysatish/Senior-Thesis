capture log close
log using means020111.log, replace
set more off
clear

use star_cleaned
	
	drop if gkstarschool3==0 & wave==0
	drop if g1starschool3==0 & wave==1
	drop if g2starschool3==0 & wave==2

	gen wg = "k" if wave==0
	replace wg = "1" if wave==1
	replace wg = "2" if wave==2

	gen whiteasian = 1 if race==1 | race==3
	replace whiteasian = 0 if race==2 | race==4 | race==6 | race==7

	gen bdate = string(birthmon) + "/" + string(birthday) + "/" + string(birthyea)
	gen bd = date(bdate,"MDY")

	gen age1985 = 1985-birthyea if birthyea~=.
	replace age1985 = age1985-1 if (birthmon==10 & birthday~=1) | birthmon==11 | birthmon==12

	foreach g in k 1 {

		foreach v in freelu speced specin {
			replace g`g'`v' = 2-g`g'`v'
			}


	gen g`g'twhite = 1 if g`g'trace==1 | g`g'trace==3
	replace g`g'twhite = 0 if g`g'trace==2

	gen g`g'tmasters = 0 if g`g'thighd==1 | g`g'thighd==2
	replace g`g'tmasters = 1 if g`g'thighd>2 & g`g'thighd~=.

	gen g`g'missing = 0

	foreach v in g`g'freelu whiteasian age1985 g`g'classs g`g'urban g`g'twhite /*
*/	g`g'tmasters g`g'tyears g`g'speced g`g'specin g`g'presen g`g'absent {
			replace g`g'missing = 1 if `v'==.
			}

	bysort g`g'classt: sum g`g'freelu whiteasian age1985 g`g'classs      /*
*/    g`g'urban g`g'twhite g`g'tmasters g`g'tyears g`g'speced g`g'specin   /*
*/    g`g'presen g`g'absent if wg=="`g'" & g`g'missing==0

	bysort g`g'classt: sum g`g'missing if wg=="`g'"

	foreach v in g`g'freelu whiteasian age1985 /*
*/    g`g'speced g`g'specin g`g'presen g`g'absent {
		xi: reg `v' i.g`g'classt if wg=="`g'" & g`g'missing==0, robust
		}

	foreach v in g`g'urban {
		xi: reg `v' i.g`g'classt if wg=="`g'" & g`g'missing==0, cluster(g`g'schid)
		}

	foreach v in g`g'classs g`g'twhite g`g'tmasters g`g'tyears {
		xi: reg `v' i.g`g'classt if wg=="`g'" & g`g'missing==0, cluster(g`g'tchid)
		}

	xi: reg g`g'missing i.g`g'classt if wg=="`g'", robust

	foreach v in g`g'freelu whiteasian age1985 /*
*/    g`g'speced g`g'specin g`g'presen g`g'absent {
		xi: reg `v' i.g`g'classt i.g`g'schid if wg=="`g'" & g`g'missing==0, robust
		test _Ig`g'classt_2 _Ig`g'classt_3
		}

	foreach v in g`g'classs g`g'twhite g`g'tmasters g`g'tyears {
		xi: reg `v' i.g`g'classt i.g`g'schid if wg=="`g'" & g`g'missing==0, cluster(g`g'tchid)
		test _Ig`g'classt_2 _Ig`g'classt_3
		}

	xi: reg g`g'missing i.g`g'classt i.g`g'schid if wg=="`g'", robust
	test _Ig`g'classt_2 _Ig`g'classt_3
	}

	foreach g in 2 {

		foreach v in freelu {
			replace g`g'`v' = 2-g`g'`v'
			}

	gen g`g'twhite = 1 if g`g'trace==1 | g`g'trace==3
	replace g`g'twhite = 0 if g`g'trace==2

	gen g`g'tmasters = 0 if g`g'thighd==1 | g`g'thighd==2
	replace g`g'tmasters = 1 if g`g'thighd>2 & g`g'thighd~=.

	gen g`g'missing = 0

	foreach v in g`g'freelu whiteasian age1985 g`g'classs g`g'urban g`g'twhite /*
*/	g`g'tmasters g`g'tyears  {
			replace g`g'missing = 1 if `v'==.
			}

	bysort g`g'classt: sum g`g'freelu whiteasian age1985 g`g'classs      /*
*/    g`g'urban g`g'twhite g`g'tmasters g`g'tyears if wg=="`g'" & g`g'missing==0

	bysort g`g'classt: sum g`g'missing if wg=="`g'"

	foreach v in g`g'freelu whiteasian age1985 {
		xi: reg `v' i.g`g'classt if wg=="`g'" & g`g'missing==0, robust
		}

	foreach v in g`g'urban {
		xi: reg `v' i.g`g'classt if wg=="`g'" & g`g'missing==0, cluster(g`g'schid)
		}

	foreach v in g`g'classs g`g'twhite g`g'tmasters g`g'tyears {
		xi: reg `v' i.g`g'classt if wg=="`g'" & g`g'missing==0, cluster(g`g'tchid)
		}

	xi: reg g`g'missing i.g`g'classt if wg=="`g'", robust

	foreach v in g`g'freelu whiteasian age1985 {
		xi: reg `v' i.g`g'classt i.g`g'schid if wg=="`g'" & g`g'missing==0, robust
		test _Ig`g'classt_2 _Ig`g'classt_3
		}

	foreach v in g`g'classs g`g'twhite g`g'tmasters g`g'tyears {
		xi: reg `v' i.g`g'classt i.g`g'schid if wg=="`g'" & g`g'missing==0, cluster(g`g'tchid)
		test _Ig`g'classt_2 _Ig`g'classt_3
		}

	xi: reg g`g'missing i.g`g'classt i.g`g'schid if wg=="`g'", robust
	test _Ig`g'classt_2 _Ig`g'classt_3

	}

log close

