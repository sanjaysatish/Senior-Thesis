library(tidyverse)
library(dplyr)
library(flextable)
library(grid)
library(gridExtra)
library(cowplot)
library(stargazer)
library(scales)
library(patchwork)
library(survminer)
library(survival)
library(kableExtra)
library(ggplot2)
library(broom)
library(tidyr)
library(knitr)
library(xtable)

students <- read.table("/Users/Sanscubed/Desktop/Thesis/Thesis_data/STAR_Archive/STAR_Students.tab", header = T, sep = "\t", fill = TRUE)
schools <- read.table("/Users/Sanscubed/Desktop/Thesis/Thesis_data/STAR_Archive/STAR_K-3_Schools.tab", header = T, sep = "\t", fill = TRUE)

students$g1tmathss <- as.numeric(students$g1tmathss)
students$g1treadss <- as.numeric(students$g1treadss)
students$g1tlistss <- as.numeric(students$g1tlistss)
students$g1wordskillss <- as.numeric(students$g1wordskillss)

students$gktmathss <- as.numeric(students$gktmathss)
students$gktreadss <- as.numeric(students$gktreadss)
students$gktlistss <- as.numeric(students$gktlistss)
students$gkwordskillss <- as.numeric(students$gkwordskillss)

# Grade 1 Summary Table
small<- students %>%
  filter(g1classtype == 1)

regular <- students %>%
  filter(g1classtype == 2)

regularaide <- students %>%
  filter(g1classtype == 3) 



n.small <- nrow(small)
n.reg <- nrow(regular)
n.rega <- nrow(regularaide)

# Building Table
nyears <- c(paste0(format(round(mean(small$yearsstar), digits = 1),nsmall = 1), "±", format(round(sd(small$yearsstar), digits =1), nsmall = 1)), paste0(format(round(mean(regular$yearsstar), digits = 1),nsmall = 1), "±", format(round(sd(regular$yearsstar), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$yearsstar), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$yearsstar), digits =1), nsmall = 1)))
nyears_small <- c(paste0(format(round(mean(small$yearssmall), digits = 1),nsmall = 1), "±", format(round(sd(small$yearssmall), digits =1), nsmall = 1)), paste0(format(round(mean(regular$yearssmall), digits = 1),nsmall = 1), "±", format(round(sd(regular$yearssmall), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$yearssmall), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$yearssmall), digits =1), nsmall = 1)))
  
  # School Urbanicity
sch_inner <- c(paste0(format(round((sum(small$g1surban ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$g1surban ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$g1surban ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
sch_suburban <- c(paste0(format(round((sum(small$g1surban ==2, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$g1surban ==2, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$g1surban ==2, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
sch_rural <- c(paste0(format(round((sum(small$g1surban ==3, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$g1surban ==3, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$g1surban ==3, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
sch_urb <- c(paste0(format(round((sum(small$g1surban ==4, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$g1surban ==4, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$g1surban ==4, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
  
  #Teacher Characteristics
teach_f <- c(paste0(format(round((sum(small$g1tgen ==2, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$g1tgen ==2, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$g1tgen ==2, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
teach_white <- c(paste0(format(round((sum(small$g1trace ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$g1trace ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$g1trace ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
teach_yoe <- c(paste0(format(round(mean(small$g1tyears, na.rm=TRUE), digits = 1),nsmall = 1), "±", format(round(sd(small$g1tyears, na.rm=TRUE), digits =1), nsmall = 1)), paste0(format(round(mean(regular$g1tyears), digits = 1),nsmall = 1), "±", format(round(sd(regular$g1tyears), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$g1tyears), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$g1tyears), digits =1), nsmall = 1)))

  #Class and Student Characteristics 
class_s<- c(paste0(format(round(mean(small$g1classsize), digits = 1),nsmall = 1), "±", format(round(sd(small$g1classsize), digits =1), nsmall = 1)), paste0(format(round(mean(regular$g1classsize), digits = 1),nsmall = 1), "±", format(round(sd(regular$g1classsize), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$g1classsize), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$g1classsize), digits =1), nsmall = 1)))
freelunch <- c(paste0(format(round((sum(small$g1freelunch ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$g1freelunch ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$g1freelunch ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
speced <- c(paste0(format(round((sum(small$g1speced ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$g1speced ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$g1speced ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
math <- c(paste0(format(round(mean(small$g1tmathss, na.rm=T), digits = 1),nsmall = 1), "±", format(round(sd(small$g1tmathss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$g1tmathss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$g1tmathss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$g1tmathss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$g1tmathss, na.rm = T), digits =1), nsmall = 1)))
reading <- c(paste0(format(round(mean(small$g1treadss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(small$g1treadss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$g1treadss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$g1treadss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$g1treadss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$g1treadss, na.rm = T), digits =1), nsmall = 1)))
listening <- c(paste0(format(round(mean(small$g1tlistss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(small$g1tlistss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$g1tlistss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$g1tlistss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$g1tlistss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$g1tlistss, na.rm = T), digits =1), nsmall = 1)))
wordstudy <- c(paste0(format(round(mean(small$g1wordskillss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(small$g1wordskillss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$g1wordskillss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$g1wordskillss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$g1wordskillss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$g1wordskillss, na.rm = T), digits =1), nsmall = 1)))

  
#Table construction
table <- matrix(c(nyears, nyears_small, sch_inner, sch_suburban, sch_rural, sch_urb, teach_f, teach_white, teach_yoe, class_s, freelunch, speced, math, reading, listening, wordstudy), ncol =3, byrow = TRUE)
colnames(table) <- c("Small Class", "Regular Class", "Regular Class with Aide" )
rownames(table) <- c("Number of Years in STAR", "Number of Years in Small Classes", "Inner City", "Suburban", "Rural", "Urban", "Female", "White", "Years of Experience", "Class Size", "Recieves Free Lunch", "Special Education", "Math SAT Scaled Score", "Reading SAT Scaled Score", "Listening SAT Scaled Score", "Word Study Skills SAT Scaled Score")

table <- kable(table, booktabs = T, "latex") %>% 
  pack_rows("Expiriment Characteristics", 1, 2, latex_gap_space = "0.25em") %>% 
  pack_rows("School Urbanicity", 3, 6, latex_gap_space = "0.25em") %>%
  pack_rows("Teacher Characteristics", 7, 10, latex_gap_space = "0.25em") 

#Attrition Summary Table 
star_students <- students %>%
  filter(flaggk == 1)

attrition_1st <- star_students %>%
  filter(flagg1 == 0, is.na(g1classtype) == TRUE)

# Grade K Summary Table
small<- attrition_1st %>%
  filter(gkclasstype == 1)

regular <- attrition_1st %>%
  filter(gkclasstype == 2)

regularaide <- attrition_1st %>%
  filter(gkclasstype == 3) 


# Attrition Statistics
n.small <- nrow(small)
n.reg <- nrow(regular)
n.rega <- nrow(regularaide)

# Building Table
nyears <- c(paste0(format(round(mean(small$yearsstar), digits = 1),nsmall = 1), "±", format(round(sd(small$yearsstar), digits =1), nsmall = 1)), paste0(format(round(mean(regular$yearsstar), digits = 1),nsmall = 1), "±", format(round(sd(regular$yearsstar), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$yearsstar), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$yearsstar), digits =1), nsmall = 1)))
nyears_small <- c(paste0(format(round(mean(small$yearssmall), digits = 1),nsmall = 1), "±", format(round(sd(small$yearssmall), digits =1), nsmall = 1)), paste0(format(round(mean(regular$yearssmall), digits = 1),nsmall = 1), "±", format(round(sd(regular$yearssmall), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$yearssmall), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$yearssmall), digits =1), nsmall = 1)))

# School Urbanicity
sch_inner <- c(paste0(format(round((sum(small$gksurban ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gksurban ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gksurban ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
sch_suburban <- c(paste0(format(round((sum(small$gksurban ==2, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gksurban ==2, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gksurban ==2, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
sch_rural <- c(paste0(format(round((sum(small$gksurban ==3, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gksurban ==3, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gksurban ==3, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
sch_urb <- c(paste0(format(round((sum(small$gksurban ==4, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gksurban ==4, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gksurban ==4, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))

#Teacher Characteristics
teach_f <- c(paste0(format(round((sum(small$gktgen ==2, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gktgen ==2, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gktgen ==2, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
teach_white <- c(paste0(format(round((sum(small$gktrace ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gktrace ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gktrace ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
teach_yoe <- c(paste0(format(round(mean(small$gktyears, na.rm=TRUE), digits = 1),nsmall = 1), "±", format(round(sd(small$gktyears, na.rm=TRUE), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gktyears), digits = 1),nsmall = 1), "±", format(round(sd(regular$gktyears), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gktyears, na.rm=T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gktyears, na.rm=T), digits =1), nsmall = 1)))

#Class and Student Characteristics 
class_s<- c(paste0(format(round(mean(small$gkclasssize), digits = 1),nsmall = 1), "±", format(round(sd(small$gkclasssize), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gkclasssize), digits = 1),nsmall = 1), "±", format(round(sd(regular$gkclasssize), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gkclasssize), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gkclasssize), digits =1), nsmall = 1)))
freelunch <- c(paste0(format(round((sum(small$gkfreelunch ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gkfreelunch ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gkfreelunch ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
speced <- c(paste0(format(round((sum(small$gkspeced ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gkspeced ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gkspeced ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
math <- c(paste0(format(round(mean(small$gktmathss, na.rm=T), digits = 1),nsmall = 1), "±", format(round(sd(small$gktmathss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gktmathss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$gktmathss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gktmathss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gktmathss, na.rm = T), digits =1), nsmall = 1)))
reading <- c(paste0(format(round(mean(small$gktreadss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(small$gktreadss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gktreadss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$gktreadss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gktreadss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gktreadss, na.rm = T), digits =1), nsmall = 1)))
listening <- c(paste0(format(round(mean(small$gktlistss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(small$gktlistss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gktlistss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$gktlistss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gktlistss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gktlistss, na.rm = T), digits =1), nsmall = 1)))
wordstudy <- c(paste0(format(round(mean(small$gkwordskillss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(small$gkwordskillss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gkwordskillss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$gkwordskillss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gkwordskillss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gkwordskillss, na.rm = T), digits =1), nsmall = 1)))


#Table construction
table_katrit <- matrix(c(nyears, nyears_small, sch_inner, sch_suburban, sch_rural, sch_urb, teach_f, teach_white, teach_yoe, class_s, freelunch, speced, math, reading, listening, wordstudy), ncol =3, byrow = TRUE)
colnames(table_katrit) <- c("Small Class (N=453)", "Regular Class (N=603)", "Regular Class with Aide (N=580)" )
rownames(table_katrit) <- c("Number of Years in STAR", "Number of Years in Small Classes", "Inner City", "Suburban", "Rural", "Urban", "Female", "White", "Years of Experience", "Class Size", "Recieves Free Lunch", "Special Education", "Math SAT Scaled Score", "Reading SAT Scaled Score", "Listening SAT Scaled Score", "Word Study Skills SAT Scaled Score")

table_katrit <- kable(table_katrit, booktabs = T, "latex") %>% 
  pack_rows("Expiriment Characteristics", 1, 2, latex_gap_space = "0.25em") %>% 
  pack_rows("Kindergarten School Urbanicity", 3, 6, latex_gap_space = "0.25em") %>%
  pack_rows("Kindergarten Teacher Characteristics", 7, 10, latex_gap_space = "0.25em") 

#Table for students who stayed in k=1 and g=1

#Attrition Summary Table 
stayed_1st <- students %>%
  filter(flaggk == 1, flagg1 == 1)

# Grade K Summary Table
small<- stayed_1st %>%
  filter(gkclasstype == 1)

regular <- stayed_1st %>%
  filter(gkclasstype == 2)

regularaide <- stayed_1st %>%
  filter(gkclasstype == 3) 


# Attrition Statistics
n.small <- nrow(small)
n.reg <- nrow(regular)
n.rega <- nrow(regularaide)

# Building Table
nyears <- c(paste0(format(round(mean(small$yearsstar), digits = 1),nsmall = 1), "±", format(round(sd(small$yearsstar), digits =1), nsmall = 1)), paste0(format(round(mean(regular$yearsstar), digits = 1),nsmall = 1), "±", format(round(sd(regular$yearsstar), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$yearsstar), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$yearsstar), digits =1), nsmall = 1)))
nyears_small <- c(paste0(format(round(mean(small$yearssmall), digits = 1),nsmall = 1), "±", format(round(sd(small$yearssmall), digits =1), nsmall = 1)), paste0(format(round(mean(regular$yearssmall), digits = 1),nsmall = 1), "±", format(round(sd(regular$yearssmall), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$yearssmall), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$yearssmall), digits =1), nsmall = 1)))

# School Urbanicity
sch_inner <- c(paste0(format(round((sum(small$gksurban ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gksurban ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gksurban ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
sch_suburban <- c(paste0(format(round((sum(small$gksurban ==2, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gksurban ==2, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gksurban ==2, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
sch_rural <- c(paste0(format(round((sum(small$gksurban ==3, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gksurban ==3, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gksurban ==3, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
sch_urb <- c(paste0(format(round((sum(small$gksurban ==4, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gksurban ==4, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gksurban ==4, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))

#Teacher Characteristics
teach_f <- c(paste0(format(round((sum(small$gktgen ==2, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gktgen ==2, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gktgen ==2, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
teach_white <- c(paste0(format(round((sum(small$gktrace ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gktrace ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gktrace ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
teach_yoe <- c(paste0(format(round(mean(small$gktyears, na.rm=TRUE), digits = 1),nsmall = 1), "±", format(round(sd(small$gktyears, na.rm=TRUE), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gktyears), digits = 1),nsmall = 1), "±", format(round(sd(regular$gktyears), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gktyears, na.rm=T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gktyears, na.rm=T), digits =1), nsmall = 1)))

#Class and Student Characteristics 
class_s<- c(paste0(format(round(mean(small$gkclasssize), digits = 1),nsmall = 1), "±", format(round(sd(small$gkclasssize), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gkclasssize), digits = 1),nsmall = 1), "±", format(round(sd(regular$gkclasssize), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gkclasssize), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gkclasssize), digits =1), nsmall = 1)))
freelunch <- c(paste0(format(round((sum(small$gkfreelunch ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gkfreelunch ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gkfreelunch ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
speced <- c(paste0(format(round((sum(small$gkspeced ==1, na.rm = TRUE )/nrow(small) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regular$gkspeced ==1, na.rm = TRUE )/nrow(regular) * 100), digits = 1), nsmall = 1), "\\%"), paste0(format(round((sum(regularaide$gkspeced ==1, na.rm = TRUE )/nrow(regularaide) * 100), digits = 1), nsmall = 1), "\\%"))
math <- c(paste0(format(round(mean(small$gktmathss, na.rm=T), digits = 1),nsmall = 1), "±", format(round(sd(small$gktmathss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gktmathss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$gktmathss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gktmathss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gktmathss, na.rm = T), digits =1), nsmall = 1)))
reading <- c(paste0(format(round(mean(small$gktreadss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(small$gktreadss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gktreadss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$gktreadss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gktreadss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gktreadss, na.rm = T), digits =1), nsmall = 1)))
listening <- c(paste0(format(round(mean(small$gktlistss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(small$gktlistss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gktlistss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$gktlistss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gktlistss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gktlistss, na.rm = T), digits =1), nsmall = 1)))
wordstudy <- c(paste0(format(round(mean(small$gkwordskillss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(small$gkwordskillss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regular$gkwordskillss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regular$gkwordskillss, na.rm = T), digits =1), nsmall = 1)), paste0(format(round(mean(regularaide$gkwordskillss, na.rm = T), digits = 1),nsmall = 1), "±", format(round(sd(regularaide$gkwordskillss, na.rm = T), digits =1), nsmall = 1)))


#Table construction
table_stayed1 <- matrix(c(nyears, nyears_small, sch_inner, sch_suburban, sch_rural, sch_urb, teach_f, teach_white, teach_yoe, class_s, freelunch, speced, math, reading, listening, wordstudy), ncol =3, byrow = TRUE)
colnames(table_stayed1) <- c("Small Class (N=1303)", "Regular Class (N=1425)", "Regular Class with Aide (N=1490)")
rownames(table_stayed1) <- c("Number of Years in STAR", "Number of Years in Small Classes", "Inner City", "Suburban", "Rural", "Urban", "Female", "White", "Years of Experience", "Class Size", "Recieves Free Lunch", "Special Education", "Math SAT Scaled Score", "Reading SAT Scaled Score", "Listening SAT Scaled Score", "Word Study Skills SAT Scaled Score")

table_stayed1 <- kable(table_stayed1, booktabs = T, "latex") %>% 
  pack_rows("Expiriment Characteristics", 1, 2, latex_gap_space = "0.25em") %>% 
  pack_rows("Kindergarten School Urbanicity", 3, 6, latex_gap_space = "0.25em") %>%
  pack_rows("Kindergarten Teacher Characteristics", 7, 10, latex_gap_space = "0.25em") 

# Pie Chart
small<- star_students %>%
  filter(gkclasstype ==1)
nrow(small)
small_3rd <- small %>%
  filter(g3classtype ==1)
nrow(small_3rd)