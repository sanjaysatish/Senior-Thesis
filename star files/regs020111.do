capture log close
log using regs021411.log, replace
set more off
clear

use star_cleaned

	replace public90 = 1 if flagg3==1 & public90==.
	replace public90 = 0 if public90==.

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
			
	gen g`g'small = 0
	replace g`g'small = 1 if g`g'classt==1
	gen g`g'aide = 0
	replace g`g'aide = 1 if g`g'classt==3
	
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

	gen g`g'small = 0
	replace g`g'small = 1 if g`g'classt==1
	gen g`g'aide = 0
	replace g`g'aide = 1 if g`g'classt==3
			
	}

	gen g3small = 0
	replace g3small = 1 if g3classt==1
	gen g3aide = 0
	replace g3aide = 1 if g3classt==3
	
	drop if gkstarschool3==0 & wave==0
	drop if g1starschool3==0 & wave==1
	drop if g2starschool3==0 & wave==2

	gen g1_leftcell = 1 if wave==0
	replace g1_leftcell = 0 if flagsg1==1 & gkschid==g1schid & gksmall==g1small & wave==0

	gen g2_leftcell = 1 if wave==0 | wave==1
	replace g2_leftcell = 0 if flagsg2==1 & gkschid==g2schid & gksmall==g2small & wave==0
	replace g2_leftcell = 0 if flagsg2==1 & g1schid==g2schid & g1small==g2small & wave==1

	gen g3_leftcell = 1 if wave==0 | wave==1 | wave==2
	replace g3_leftcell = 0 if flagsg3==1 & gkschid==g3schid & gksmall==g3small & wave==0 
	replace g3_leftcell = 0 if flagsg3==1 & g1schid==g3schid & g1small==g3small & wave==1
	replace g3_leftcell = 0 if flagsg3==1 & g2schid==g3schid & g2small==g3small & wave==2
	
	gen g1_leftsch = 1 if wave==0
	replace g1_leftsch = 0 if flagsg1==1 & gkschid==g1schid & wave==0

	gen g2_leftsch = 1 if wave==0 | wave==1
	replace g2_leftsch = 0 if flagsg2==1 & gkschid==g2schid & wave==0
	replace g2_leftsch = 0 if flagsg2==1 & g1schid==g2schid & wave==1

	gen g3_leftsch = 1 if wave==0 | wave==1 | wave==2
	replace g3_leftsch = 0 if flagsg3==1 & gkschid==g3schid & wave==0 
	replace g3_leftsch = 0 if flagsg3==1 & g1schid==g3schid & wave==1
	replace g3_leftsch = 0 if flagsg3==1 & g2schid==g3schid & wave==2
	
	gen leftpublic = 1-public90

* TABLE 2: ATTRITION REGRESSIONS

* PANEL A: ENTERED IN GRADE K

	reg g1_leftcell gksmall gkaide if wave==0 & gkmissing==0, cluster(gktchid)
	xi: reg g1_leftcell gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)

	reg g1_leftsch gksmall gkaide if wave==0 & gkmissing==0, cluster(gktchid)
	xi: reg g1_leftsch gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)

	reg g3_leftcell gksmall gkaide if wave==0 & gkmissing==0, cluster(gktchid)
	xi: reg g3_leftcell gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)

	reg g3_leftsch gksmall gkaide if wave==0 & gkmissing==0, cluster(gktchid)
	xi: reg g3_leftsch gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)

	reg leftpublic gksmall gkaide if wave==0 & gkmissing==0, cluster(gktchid)
	xi: reg leftpublic gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)

* PANEL B: ENTERED IN GRADE 1

	reg g2_leftcell g1small g1aide if wave==1 & g1missing==0, cluster(g1tchid)
	xi: reg g2_leftcell g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	reg g2_leftsch g1small g1aide if wave==1 & g1missing==0, cluster(g1tchid)
	xi: reg g2_leftsch g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	reg g3_leftcell g1small g1aide if wave==1 & g1missing==0, cluster(g1tchid)
	xi: reg g3_leftcell g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	reg g3_leftsch g1small g1aide if wave==1 & g1missing==0, cluster(g1tchid)
	xi: reg g3_leftsch g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	reg leftpublic g1small g1aide if wave==1 & g1missing==0, cluster(g1tchid)
	xi: reg leftpublic g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

* PANEL C: ENTERED IN GRADE 2

	reg g3_leftcell g2small g2aide if wave==2 & g2missing==0, cluster(g2tchid)
	xi: reg g3_leftcell g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)

	reg g3_leftsch g2small g2aide if wave==2 & g2missing==0, cluster(g2tchid)
	xi: reg g3_leftsch g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)

	reg leftpublic g2small g2aide if wave==2 & g2missing==0, cluster(g2tchid)
	xi: reg leftpublic g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)

* TABLE 3: ALTERNATIVE OUTCOME VARIABLES

	gen retained = 0
	replace retained = 1 if gkrepeat==2 | g1promot==2 | g2promot==2 | g3promot==2

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	gen tlater = 0
	for N in num 95/97: replace tlater = 1 if publicN==1

	egen gkavg = rmean(gktread gktmath)
	sum gkavg, detail
	gen g1leftbelow = g1_leftsch & gkavg~=.
	replace g1leftbelow = 0 if gkavg>=r(p50) & gkavg~=.
	gen g1leftabove = g1_leftsch & gkavg~=.
	replace g1leftabove = 0 if gkavg<r(p50) & gkavg~=.

	egen g1avg = rmean(g1tread g1tmath)
	sum g1avg, detail
	gen g2leftbelow = g2_leftsch if g1avg~=.
	replace g2leftbelow = 0 if g1avg>=r(p50) & g1avg~=.
	gen g2leftabove = g2_leftsch & g1avg~=.
	replace g2leftabove = 0 if g1avg<r(p50) & g1avg~=.

	egen g2avg = rmean(g2tread g2tmath)
	sum g2avg, detail
	gen g3leftbelow = g3_leftsch if g2avg~=.
	replace g3leftbelow = 0 if g2avg>=r(p50) & g2avg~=.
	gen g3leftabove = g3_leftsch & g2avg~=.
	replace g3leftabove = 0 if g2avg<r(p50) & g2avg~=.

	gen tabove = 0
	replace tabove = 1 if public90 & tcapg90>=4 & tcapg90~=.

	gen tbelow = 0
	replace tbelow = 1 if public90 & tcapg90<4

* PANEL A: ENTERED IN GRADE K

	* IN PROGRAM IN SMALL CLASS AFTER FIRST YEAR

	xi: reg g1small gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)

	* IN PROGRAM IN SMALL CLASS IN THIRD GRADE

	xi: reg g3small gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)	

	* IN PROGRAM IN CLASS WITH AIDE AFTER FIRST YEAR

	xi: reg g1aide gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)	

	* IN PROGRAM IN CLASS WITH AIDE IN THIRD GRADE

	xi: reg g3aide gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)	

	* LEFT PROGRAM AND ABOVE MEDIAN TEST

	xi: reg g1leftabove gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)	

	* LEFT PROGRAM AND BELOW MEDIAN TEST

	xi: reg g1leftbelow gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)	

	* RECOMMENDED TO REPEAT GRADE WHILE IN PROJECT STAR

	xi: reg retained gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)	

	* TOOK TCAP IN 1995 OR LATER

	xi: reg tlater gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)	

	* IN PUBLIC SCHOOL ABOVE OR AT GRADE LEVEL IN 1990

	xi: reg tabove gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)	

	* IN PUBLIC SCHOOL BELOW GRADE LEVEL IN 1990

	xi: reg tbelow gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0, cluster(gktchid)	

* PANEL B: ENTERED IN GRADE 1

	* IN PROGRAM IN SMALL CLASS AFTER FIRST YEAR

	xi: reg g2small g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	* IN PROGRAM IN SMALL CLASS IN THIRD GRADE

	xi: reg g3small g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	* IN PROGRAM IN CLASS WITH AIDE AFTER FIRST YEAR

	xi: reg g2aide g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	* IN PROGRAM IN CLASS WITH AIDE IN THIRD GRADE

	xi: reg g3aide g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	* LEFT PROGRAM AND ABOVE MEDIAN TEST

	xi: reg g2leftabove g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	* LEFT PROGRAM AND BELOW MEDIAN TEST

	xi: reg g2leftbelow g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	* RECOMMENDED TO REPEAT GRADE WHILE IN PROJECT STAR

	xi: reg retained g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	* TOOK TCAP IN 1995 OR LATER

	xi: reg tlater g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	* IN PUBLIC SCHOOL ABOVE OR AT GRADE LEVEL IN 1990

	xi: reg tabove g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

	* IN PUBLIC SCHOOL BELOW GRADE LEVEL IN 1990

	xi: reg tbelow g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0, cluster(g1tchid)

* PANEL C: ENTERED IN GRADE 2

	* IN PROGRAM IN SMALL CLASS IN THIRD GRADE

	xi: reg g3small g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)

	* IN PROGRAM IN CLASS WITH AIDE IN THIRD GRADE

	xi: reg g3aide g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)

	* LEFT PROGRAM AND ABOVE MEDIAN TEST

	xi: reg g3leftabove g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)

	* LEFT PROGRAM AND BELOW MEDIAN TEST

	xi: reg g3leftbelow g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)

	* RECOMMENDED TO REPEAT GRADE WHILE IN PROJECT STAR

	xi: reg retained g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)

	* TOOK TCAP IN 1995 OR LATER

	xi: reg tlater g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)

	* IN PUBLIC SCHOOL ABOVE OR AT GRADE LEVEL IN 1990

	xi: reg tabove g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)

	* IN PUBLIC SCHOOL BELOW GRADE LEVEL IN 1990

	xi: reg tbelow g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0, cluster(g2tchid)


log close

