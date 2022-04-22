capture log close
log using regs021611.log, replace
set more off
clear

use star_cleaned

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

	gen g1_changes = 1 if wave==0
	replace g1_changes = 0 if flagsg1==1 & gkschid==g1schid & wave==0
	
	gen g1_changet = 0 if wave==0
	replace g1_changet = 1 if flagsg1==1 & gkschid==g1schid & gkclasst~=g1classt & wave==0

	gen g2_changes = 1 if wave==0 | wave==1
	replace g2_changes = 0 if flagsg2==1 & gkschid==g2schid & wave==0
	replace g2_changes = 0 if flagsg2==1 & g1schid==g2schid & wave==1
	replace g2_changes = 0 if g1promot==2 & (wave==0 | wave==1)
	
	gen g2_changet = 0 if wave==0 | wave==1
	replace g2_changet = 1 if flagsg2==1 & gkschid==g2schid & gkclasst~=g2classt & wave==0
	replace g2_changet = 1 if flagsg2==1 & g1schid==g2schid & g1classt~=g2classt & wave==1

	gen g2_retained = 0 if wave==0 | wave==1
	replace g2_retained = 1 if g1promot==2 & (wave==0 | wave==1)

	gen g3_changes = 1 if wave==0 | wave==1 | wave==2
	replace g3_changes = 0 if flagsg3==1 & gkschid==g3schid & wave==0
	replace g3_changes = 0 if flagsg3==1 & g1schid==g3schid & wave==1
	replace g3_changes = 0 if flagsg3==1 & g2schid==g3schid & wave==2
	replace g3_changes = 0 if (g1promot==2 | g2promot==2) & (wave==0 | wave==1 | wave==2)
	
	gen g3_changet = 0 if wave==0 | wave==1 | wave==2
	replace g3_changet = 1 if flagsg3==1 & gkschid==g3schid & gkclasst~=g3classt & wave==0
	replace g3_changet = 1 if flagsg3==1 & g1schid==g3schid & g1classt~=g3classt & wave==1
	replace g3_changet = 1 if flagsg3==1 & g2schid==g3schid & g2classt~=g3classt & wave==2
	
	gen g3_retained = 0 if wave==0 | wave==1 | wave==2
	replace g3_retained = 1 if (g1promot==2 | g2promot==2) & (wave==0 | wave==1 | wave==2)
	
	gen leftpublic = 1-public90

* TABLE 2: ATTRITION REGRESSIONS

* PANEL A: ENTERED IN GRADE K

	foreach v in g1_changes g1_changet g3_changes g3_changet g3_retained leftpublic {
		reg `v' gksmall gkaide if wave==0 & gkmissing==0, cluster(gktchid)
		areg `v' gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears if wave==0 & gkmissing==0, cluster(gktchid) absorb(gkschid)
		}

* PANEL B: ENTERED IN GRADE 1

	foreach v in g2_changes g2_changet g2_retained g3_changes g3_changet g3_retained leftpublic {
		reg `v' g1small g1aide if wave==1 & g1missing==0, cluster(g1tchid)
		areg `v' g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears if wave==1 & g1missing==0, cluster(g1tchid) absorb(g1schid)
		}

* PANEL C: ENTERED IN GRADE 2

	foreach v in g3_changes g3_changet g3_retained leftpublic {
		reg `v' g2small g2aide if wave==2 & g2missing==0, cluster(g2tchid)
		areg `v' g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears if wave==2 & g2missing==0, cluster(g2tchid) absorb(g2schid)
		}

* TABLE 3: EFFECT OF INITIAL CLASS TYPE ON YEARS IN TYPE, STAYERS
		
	* identify "stayers" who didn't change schools or grades

	gen stayer = 0 if wave==0 | wave==1 | wave==2
	replace stayer = 1 if flagg3==1 & gkschid==g3schid & wave==0
	replace stayer = 1 if flagg3==1 & g1schid==g3schid & wave==1
	replace stayer = 1 if flagg3==1 & g2schid==g3schid & wave==2

	* generate years in small or aide classes

	foreach v in small aide {
		gen g0`v' = gk`v'
		}
	
	foreach t in small aide {
		gen years_`t' = 0 if wave==0 | wave==1 | wave==2
		forvalues g = 0/2 {
			for G in num `g'/3: replace years_`t' = years_`t' + 1 if gG`t'==1 & wave==`g'
			}
		}
		
	reg years_small gksmall gkaide if stayer==1 & wave==0 & gkmissing==0, cluster(gktchid)
	areg years_small gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears if stayer==1 & wave==0 & gkmissing==0, cluster(gktchid) absorb(gkschid)

	reg years_aide gksmall gkaide if stayer==1 & wave==0 & gkmissing==0, cluster(gktchid)
	areg years_aide gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears if stayer==1 & wave==0 & gkmissing==0, cluster(gktchid) absorb(gkschid)
	
	reg years_small g1small g1aide if stayer==1 & wave==1 & g1missing==0, cluster(g1tchid)
	areg years_small g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears if stayer==1 & wave==1 & g1missing==0, cluster(g1tchid) absorb(g1schid)

	reg years_aide g1small g1aide if stayer==1 & wave==1 & g1missing==0, cluster(g1tchid)
	areg years_aide g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears if stayer==1 & wave==1 & g1missing==0, cluster(g1tchid) absorb(g1schid)
		
	reg years_small g2small g2aide if stayer==1 & wave==2 & g2missing==0, cluster(g2tchid)
	areg years_small g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears if stayer==1 & wave==2 & g2missing==0, cluster(g2tchid) absorb(g2schid)

	reg years_aide g2small g2aide if stayer==1 & wave==2 & g2missing==0, cluster(g2tchid)
	areg years_aide g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears if stayer==1 & wave==2 & g2missing==0, cluster(g2tchid) absorb(g2schid)

* TABLE 5: ATTRITION EFFECT PER YEAR OF CLASS TYPE
		
	forvalues g = 1/3 {
		gen g`g'_changest = max(g`g'_changes,g`g'_changet)
		}
	
	* given responses to small and aide assignments, we can compute
	* the value of a year of small or aide classes as:
	
	* r_small - response to small assignment
	* r_aide - response to aide assignment
	
	* v_small - value of a year in small
	* v_aide - value of a year in aide
	
	* assume that:
	
	* years_small = b0 + b1*gsmall + b2*gaide
	* years_aide = a0 + a1*gsmall + a2*gaide
	
	* r_small = v_small*b1 + v_aide*a1
	* r_aide = v_small*b2 + v_aide*a2
	
	* we then obtain:
	
	* v_small = (r_small-(a1/a2)*r_aide)/(b1-(a1/a2)*b2)
	* v_aide = (r_aide-(b2/b1)*r_small)/(a2-(b2/b1)*a1)

	* now, we repeat our attrition regressions, save the estimation equations, and
	* run suest & suest to estimate v_small and v_aide.
	
	reg years_small gksmall gkaide if stayer==1 & wave==0 & gkmissing==0
	estimates store ysmallk
	reg years_aide gksmall gkaide if stayer==1 & wave==0 & gkmissing==0
	estimates store yaidek
	reg g1_changes gksmall gkaide if wave==0 & gkmissing==0
	estimates store g1_changes
	suest ysmallk yaidek g1_changes, cluster(gktchid)
	nlcom ([g1_changes_mean]gksmall -([yaidek_mean]gksmall/[yaidek_mean]gkaide)*[g1_changes_mean]gkaide)/([ysmallk_mean]gksmall-([yaidek_mean]gksmall/[yaidek_mean]gkaide)*[ysmallk_mean]gkaide)
	nlcom ([g1_changes_mean]gkaide -([ysmallk_mean]gkaide/[ysmallk_mean]gksmall)*[g1_changes_mean]gksmall)/([yaidek_mean]gkaide-([ysmallk_mean]gkaide/[ysmallk_mean]gksmall)*[ysmallk_mean]gksmall)
	
	xi: reg years_small gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if stayer==1 & wave==0 & gkmissing==0
	estimates store ysmallctrlk
	xi: reg years_aide gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if stayer==1 & wave==0 & gkmissing==0
	estimates store yaidectrlk
	xi: reg g1_changes gksmall gkaide gkfreelu whiteasian age1985 gkurban gktwhite gktmasters gktyears i.gkschid if wave==0 & gkmissing==0
	estimates store g1_changes_ctrl
	suest ysmallctrlk yaidectrlk g1_changes_ctrl, cluster(gktchid)
	nlcom ([g1_changes_ctrl_mean]gksmall -([yaidectrlk_mean]gksmall/[yaidectrlk_mean]gkaide)*[g1_changes_ctrl_mean]gkaide)/([ysmallctrlk_mean]gksmall-([yaidectrlk_mean]gksmall/[yaidectrlk_mean]gkaide)*[ysmallctrlk_mean]gkaide)
	nlcom ([g1_changes_ctrl_mean]gkaide -([ysmallctrlk_mean]gkaide/[ysmallctrlk_mean]gksmall)*[g1_changes_ctrl_mean]gksmall)/([yaidectrlk_mean]gkaide-([ysmallctrlk_mean]gkaide/[ysmallctrlk_mean]gksmall)*[ysmallctrlk_mean]gksmall)
	
	reg years_small g1small g1aide if stayer==1 & wave==1 & g1missing==0
	estimates store ysmall1
	reg years_aide g1small g1aide if stayer==1 & wave==1 & g1missing==0
	estimates store yaide1
	reg g2_changes g1small g1aide if wave==1 & g1missing==0
	estimates store g2_changes
	suest ysmall1 yaide1 g2_changes, cluster(g1tchid)
	nlcom ([g2_changes_mean]g1small -([yaide1_mean]g1small/[yaide1_mean]g1aide)*[g2_changes_mean]g1aide)/([ysmall1_mean]g1small-([yaide1_mean]g1small/[yaide1_mean]g1aide)*[ysmall1_mean]g1aide)
	nlcom ([g2_changes_mean]g1aide -([ysmall1_mean]g1aide/[ysmall1_mean]g1small)*[g2_changes_mean]g1small)/([yaide1_mean]g1aide-([ysmall1_mean]g1aide/[ysmall1_mean]g1small)*[ysmall1_mean]g1small)
	reg g2_changest g1small g1aide if wave==1 & g1missing==0
	estimates store g2_changest
	suest ysmall1 yaide1 g2_changest, cluster(g1tchid)
	nlcom ([g2_changest_mean]g1small -([yaide1_mean]g1small/[yaide1_mean]g1aide)*[g2_changest_mean]g1aide)/([ysmall1_mean]g1small-([yaide1_mean]g1small/[yaide1_mean]g1aide)*[ysmall1_mean]g1aide)
	nlcom ([g2_changest_mean]g1aide -([ysmall1_mean]g1aide/[ysmall1_mean]g1small)*[g2_changest_mean]g1small)/([yaide1_mean]g1aide-([ysmall1_mean]g1aide/[ysmall1_mean]g1small)*[ysmall1_mean]g1small)
	
	xi: reg years_small g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if stayer==1 & wave==1 & g1missing==0
	estimates store ysmallctrl1
	xi: reg years_aide g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if stayer==1 & wave==1 & g1missing==0
	estimates store yaidectrl1
	xi: reg g2_changes g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0
	estimates store g2_changes_ctrl
	suest ysmallctrl1 yaidectrl1 g2_changes_ctrl, cluster(g1tchid)
	nlcom ([g2_changes_ctrl_mean]g1small -([yaidectrl1_mean]g1small/[yaidectrl1_mean]g1aide)*[g2_changes_ctrl_mean]g1aide)/([ysmallctrl1_mean]g1small-([yaidectrl1_mean]g1small/[yaidectrl1_mean]g1aide)*[ysmallctrl1_mean]g1aide)
	nlcom ([g2_changes_ctrl_mean]g1aide -([ysmallctrl1_mean]g1aide/[ysmallctrl1_mean]g1small)*[g2_changes_ctrl_mean]g1small)/([yaidectrl1_mean]g1aide-([ysmallctrl1_mean]g1aide/[ysmallctrl1_mean]g1small)*[ysmallctrl1_mean]g1small)
	xi: reg g2_changest g1small g1aide g1freelu whiteasian age1985 g1urban g1twhite g1tmasters g1tyears i.g1schid if wave==1 & g1missing==0
	estimates store g2_changest_ctrl
	suest ysmallctrl1 yaidectrl1 g2_changest_ctrl, cluster(g1tchid)
	nlcom ([g2_changest_ctrl_mean]g1small -([yaidectrl1_mean]g1small/[yaidectrl1_mean]g1aide)*[g2_changest_ctrl_mean]g1aide)/([ysmallctrl1_mean]g1small-([yaidectrl1_mean]g1small/[yaidectrl1_mean]g1aide)*[ysmallctrl1_mean]g1aide)
	nlcom ([g2_changest_ctrl_mean]g1aide -([ysmallctrl1_mean]g1aide/[ysmallctrl1_mean]g1small)*[g2_changest_ctrl_mean]g1small)/([yaidectrl1_mean]g1aide-([ysmallctrl1_mean]g1aide/[ysmallctrl1_mean]g1small)*[ysmallctrl1_mean]g1small)
	
	reg years_small g2small g2aide if stayer==1 & wave==2 & g2missing==0
	estimates store ysmall2
	reg years_aide g2small g2aide if stayer==1 & wave==2 & g2missing==0
	estimates store yaide2
	reg g3_changes g2small g2aide if wave==2 & g2missing==0
	estimates store g3_changes
	suest ysmall2 yaide2 g3_changes, cluster(g2tchid)
	nlcom ([g3_changes_mean]g2small -([yaide2_mean]g2small/[yaide2_mean]g2aide)*[g3_changes_mean]g2aide)/([ysmall2_mean]g2small-([yaide2_mean]g2small/[yaide2_mean]g2aide)*[ysmall2_mean]g2aide)
	nlcom ([g3_changes_mean]g2aide -([ysmall2_mean]g2aide/[ysmall2_mean]g2small)*[g3_changes_mean]g2small)/([yaide2_mean]g2aide-([ysmall2_mean]g2aide/[ysmall2_mean]g2small)*[ysmall2_mean]g2small)
	reg g3_changest g2small g2aide if wave==2 & g2missing==0
	estimates store g3_changest
	suest ysmall2 yaide2 g3_changest, cluster(g2tchid)
	nlcom ([g3_changest_mean]g2small -([yaide2_mean]g2small/[yaide2_mean]g2aide)*[g3_changest_mean]g2aide)/([ysmall2_mean]g2small-([yaide2_mean]g2small/[yaide2_mean]g2aide)*[ysmall2_mean]g2aide)
	nlcom ([g3_changest_mean]g2aide -([ysmall2_mean]g2aide/[ysmall2_mean]g2small)*[g3_changest_mean]g2small)/([yaide2_mean]g2aide-([ysmall2_mean]g2aide/[ysmall2_mean]g2small)*[ysmall2_mean]g2small)
	
	xi: reg years_small g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if stayer==1 & wave==2 & g2missing==0
	estimates store ysmallctrl2
	xi: reg years_aide g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if stayer==1 & wave==2 & g2missing==0
	estimates store yaidectrl2
	xi: reg g3_changes g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0
	estimates store g3_changes_ctrl
	suest ysmallctrl2 yaidectrl2 g3_changes_ctrl, cluster(g2tchid)
	nlcom ([g3_changes_ctrl_mean]g2small -([yaidectrl2_mean]g2small/[yaidectrl2_mean]g2aide)*[g3_changes_ctrl_mean]g2aide)/([ysmallctrl2_mean]g2small-([yaidectrl2_mean]g2small/[yaidectrl2_mean]g2aide)*[ysmallctrl2_mean]g2aide)
	nlcom ([g3_changes_ctrl_mean]g2aide -([ysmallctrl2_mean]g2aide/[ysmallctrl2_mean]g2small)*[g3_changes_ctrl_mean]g2small)/([yaidectrl2_mean]g2aide-([ysmallctrl2_mean]g2aide/[ysmallctrl2_mean]g2small)*[ysmallctrl2_mean]g2small)
	xi: reg g3_changest g2small g2aide g2freelu whiteasian age1985 g2urban g2twhite g2tmasters g2tyears i.g2schid if wave==2 & g2missing==0
	estimates store g3_changest_ctrl
	suest ysmallctrl2 yaidectrl2 g3_changest_ctrl, cluster(g2tchid)
	nlcom ([g3_changest_ctrl_mean]g2small -([yaidectrl2_mean]g2small/[yaidectrl2_mean]g2aide)*[g3_changest_ctrl_mean]g2aide)/([ysmallctrl2_mean]g2small-([yaidectrl2_mean]g2small/[yaidectrl2_mean]g2aide)*[ysmallctrl2_mean]g2aide)
	nlcom ([g3_changest_ctrl_mean]g2aide -([ysmallctrl2_mean]g2aide/[ysmallctrl2_mean]g2small)*[g3_changest_ctrl_mean]g2small)/([yaidectrl2_mean]g2aide-([ysmallctrl2_mean]g2aide/[ysmallctrl2_mean]g2small)*[ysmallctrl2_mean]g2small)
	
log close

