capture log close
log using graphs020111.log, replace
set more off
clear
set mem 50m

use star_cleaned


	* initial class type organized by "wave"

	gen g0small = 0
	replace g0small = 1 if gkclasst==1
	gen g0classt = gkclasst

	gen g1small = 0
	replace g1small = 1 if g1classt==1

	gen g2small = 0
	replace g2small = 1 if g2classt==1

	gen g3small = 0
	replace g3small = 1 if g3classt==1	

	gen g0aide = 0
	replace g0aide = 1 if gkclasst==3

	gen g1aide = 0
	replace g1aide = 1 if g1classt==3

	gen g2aide = 0
	replace g2aide = 1 if g2classt==3

	gen g3aide = 0
	replace g3aide = 1 if g3classt==3

	* next, determine whether school and
	* class type are the same by semester
	* organize semesters by s1 to s7

	gen g1_persist = 0 if wave==0
	replace g1_persist = 1 if flagsg1==1 & gkschid==g1schid & g0small==g1small & wave==0

	gen g2_persist = 0 if wave==0 | wave==1
	replace g2_persist = 1 if flagsg2==1 & gkschid==g2schid & g0small==g2small & wave==0
	replace g2_persist = 1 if flagsg2==1 & g1schid==g2schid & g1small==g2small & wave==1

	gen g3_persist = 0 if wave==0 | wave==1 | wave==2
	replace g3_persist = 1 if flagsg3==1 & gkschid==g3schid & g0small==g3small & wave==0 
	replace g3_persist = 1 if flagsg3==1 & g1schid==g3schid & g1small==g3small & wave==1
	replace g3_persist = 1 if flagsg3==1 & g2schid==g3schid & g2small==g3small & wave==2

	forvalues w = 0/2 {
		forvalues t = 1/3 {
			forvalues g = 1/3 {
				disp "WAVE `w', CLASS TYPE `t', GRADE `g'"
				sum g`g'_persist if wave==`w' & g`w'classt==`t'
				}
			}
		}

* FIGURE 3: PIE CHARTS DESCRIBING WHERE PEOPLE END UP
* - THREE PANELS FOR EACH SAMPLE WAVE
* - WITHIN EACH WAVE, ONE PANEL FOR EACH CLASS TYPE

* PANELS K-A, K-B, and K-C: STUDENTS WHO ENTERED IN KINDERGARTEN

	* depending on kindergarten class type, let's predict your situation in 3rd grade

	* restrict sample to those in initial kindergarten cohort.

use star_cleaned, clear
		
	keep if wave==0
	
	* generate gksmall and g3small
	
	gen gksmall = 0
	replace gksmall = 1 if gkclasst==1
	gen g3small = 0
	replace g3small = 1 if g3classt==1

	gen g0classt = gkclasst
	gen g0small = gksmall
	
	* deal with the two observations not in TCAP.
	* one is still in STAR, and the other we'll assume
	* left the system.

	replace public90 = 1 if public90==. & flagsg3==1
	replace public90 = 0 if public90==.
	
	* who left the system?
	
	gen leftsystem = 0
	replace leftsystem = 1 if public90==0 & flagsg3==0 & gkstarschool3==1
	
	* who left star but remained in the public school system?
	* exclude those whose schools left the program.
	
	gen nonprogramschool = 0
	replace nonprogramschool = 1 if public90==1 & gkstarschool3==1 & flagsg3==0

	* whose schools left the program?
	
	gen schoolleft = 0
	replace schoolleft = 1 if gkstarschool3==0
	
	* who changed schools within project star?
	
	gen otherstarschool = 0
	replace otherstarschool = 1 if flagsg3==1 & gkschid~=g3schid & gkstarschool3==1
	
	* who changed class type within school?
	
	gen within_change = 0
	replace within_change = 1 if flagsg3==1 & gkschid==g3schid & gksmall~=g3small
	
	* who's still in program
	
	gen still_in_program = 0
	replace still_in_program = 1 if flagsg3==1 & gkschid==g3schid & gksmall==g3small & gkstarschool3==1
	
	* double-check variables created correctly

	count if schoolleft & otherstarschool
	count if schoolleft & nonprogramschool
	count if schoolleft & leftsystem
	count if schoolleft & within_change
	count if schoolleft & still_in_program

	count if otherstarschool & nonprogramschool
	count if otherstarschool & leftsystem
	count if otherstarschool & within_change
	count if otherstarschool & still_in_program

	count if nonprogramschool & leftsystem
	count if nonprogramschool & within_change
	count if nonprogramschool & still_in_program

	count if leftsystem & within_change
	count if leftsystem & still_in_program

	count if within_change & still_in_program

	count if ~schoolleft & ~otherstarschool & ~nonprogramschool & ~leftsystem & ~within_change & ~still_in_program

	* ok, let's make the pie graph

	tab gkclasst schoolleft
	tab gkclasst otherstarschool
	tab gkclasst nonprogramschool
	tab gkclasst leftsystem
	tab gkclasst within_change
	tab gkclasst still_in_program

* PANELS 1-A, 1-B, and 1-C: STUDENTS WHO ENTERED IN FIRST GRADE

* now let's do the same comparisons for those who entered in first grade

use star_cleaned, clear
	
	* restrict sample to those in first grade cohort.

	keep if wave==1
	
	* create g1small and g3small
	
	gen g1small = 0
	replace g1small = 1 if g1classt==1
	gen g3small = 0
	replace g3small = 1 if g3classt==1

	* deal with the two observations not in TCAP.
	* one is still in STAR, and the other we'll assume
	* left the system.

	replace public90 = 1 if public90==. & flagsg3==1
	replace public90 = 0 if public90==.
	
	* who left the system?
	
	gen leftsystem = 0
	replace leftsystem = 1 if public90==0 & flagsg3==0 & g1starschool3==1
	
	* who left star but remained in the public school system?
	* exclude those whose schools left the program.
	
	gen nonprogramschool = 0
	replace nonprogramschool = 1 if public90==1 & g1starschool3==1 & flagsg3==0

	* whose schools left the program?
	
	gen schoolleft = 0
	replace schoolleft = 1 if g1starschool3==0
	
	* who changed schools within project star?
	
	gen otherstarschool = 0
	replace otherstarschool = 1 if flagsg3==1 & g1schid~=g3schid & g1starschool3==1
	
	* who changed class type within school?
	
	gen within_change = 0
	replace within_change = 1 if flagsg3==1 & g1schid==g3schid & g1small~=g3small
	
	* who's still in program
	
	gen still_in_program = 0
	replace still_in_program = 1 if flagsg3==1 & g1schid==g3schid & g1small==g3small & g1starschool3==1
	
	* double-check variables created correctly

	count if schoolleft & otherstarschool
	count if schoolleft & nonprogramschool
	count if schoolleft & leftsystem
	count if schoolleft & within_change
	count if schoolleft & still_in_program

	count if otherstarschool & nonprogramschool
	count if otherstarschool & leftsystem
	count if otherstarschool & within_change
	count if otherstarschool & still_in_program

	count if nonprogramschool & leftsystem
	count if nonprogramschool & within_change
	count if nonprogramschool & still_in_program

	count if leftsystem & within_change
	count if leftsystem & still_in_program

	count if within_change & still_in_program

	count if ~schoolleft & ~otherstarschool & ~nonprogramschool & ~leftsystem & ~within_change & ~still_in_program

	* ok, let's make the pie graph

	tab g1classt schoolleft
	tab g1classt otherstarschool
	tab g1classt nonprogramschool
	tab g1classt leftsystem
	tab g1classt within_change
	tab g1classt still_in_program

* PANELS 2-A, 2-B, and 2-C: STUDENTS WHO ENTERED IN SECOND GRADE

* now let's do the same comparisons for those who entered in srecond grade

use star_cleaned, clear
	
	* restrict sample to those in second grade cohort.

	keep if wave==2

	* make g2small and g3small
	
	gen g2small = 0
	replace g2small = 1 if g2classt==1
	gen g3small = 0
	replace g3small = 1 if g3classt==1

	* deal with the two observations not in TCAP.
	* one is still in STAR, and the other we'll assume
	* left the system.

	replace public90 = 1 if public90==. & flagsg3==1
	replace public90 = 0 if public90==.
	
	* who left the system?
	
	gen leftsystem = 0
	replace leftsystem = 1 if public90==0 & flagsg3==0 & g2starschool3==1
	
	* who left star but remained in the public school system?
	* exclude those whose schools left the program.
	
	gen nonprogramschool = 0
	replace nonprogramschool = 1 if public90==1 & g2starschool3==1 & flagsg3==0

	* whose schools left the program?
	
	gen schoolleft = 0
	replace schoolleft = 1 if g2starschool3==0
	
	* who changed schools within project star?
	
	gen otherstarschool = 0
	replace otherstarschool = 1 if flagsg3==1 & g2schid~=g3schid & g2starschool3==1
	
	* who changed class type within school?
	
	gen within_change = 0
	replace within_change = 1 if flagsg3==1 & g2schid==g3schid & g2small~=g3small
	
	* who's still in program
	
	gen still_in_program = 0
	replace still_in_program = 1 if flagsg3==1 & g2schid==g3schid & g2small==g3small & g2starschool3==1
	
	* double-check variables created correctly

	count if schoolleft & otherstarschool
	count if schoolleft & nonprogramschool
	count if schoolleft & leftsystem
	count if schoolleft & within_change
	count if schoolleft & still_in_program

	count if otherstarschool & nonprogramschool
	count if otherstarschool & leftsystem
	count if otherstarschool & within_change
	count if otherstarschool & still_in_program

	count if nonprogramschool & leftsystem
	count if nonprogramschool & within_change
	count if nonprogramschool & still_in_program

	count if leftsystem & within_change
	count if leftsystem & still_in_program

	count if within_change & still_in_program

	count if ~schoolleft & ~otherstarschool & ~nonprogramschool & ~leftsystem & ~within_change & ~still_in_program

	* ok, let's make the pie graph

	tab g2classt schoolleft
	tab g2classt otherstarschool
	tab g2classt nonprogramschool
	tab g2classt leftsystem
	tab g2classt within_change
	tab g2classt still_in_program

* FIGURE 4: TRANSITIONS ACROSS CLASS TYPE BY WAVE
	
use star_cleaned, clear

	gen g0classt = gkclasst
	
	* wave 0

	tab gkclasst g3classt if flagsg3==1 & gkschid==g3schid & gkstarschool3==1 & wave==0

	* wave 1

	tab g1classt g3classt if flagsg3==1 & g1schid==g3schid & g1starschool3==1 & wave==1

	* wave 2

	tab g2classt g3classt if flagsg3==1 & g2schid==g3schid & g2starschool3==1 & wave==2

* FIGURE 5: GRADE RETENTION BY WAVE AND CLASS TYPE

	* next, let's focus on grade retention by entry cohort and class type

	gen retained = 0
	replace retained = 1 if gkrepeat==2 | g1promot==2 | g2promot==2 | g3promot==2

	* sample means for retained

	gen g0starschool3 = gkstarschool3
	
	forvalues t = 1/3 {
		forvalues i = 0/2 {
			disp "RETAINED, WAVE == `i'  CLASS TYPE == `t'"
			sum retained if wave==`i' & g`i'classt==`t' & g`i'starschool3==1
			}
		}

	gen tlater = 0
	for N in num 95/97: replace tlater = 1 if publicN==1

	forvalues t = 1/3 {
		forvalues i = 0/2 {
			disp "tlater, WAVE == `i'  CLASS TYPE == `t'"
			sum tlater if wave==`i' & g`i'classt==`t' & g`i'starschool3==1
			}
		}

log close
