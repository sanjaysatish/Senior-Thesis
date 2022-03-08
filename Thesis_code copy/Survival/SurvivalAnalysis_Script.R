#===========================================================================================================
# Overview:
# This script generates all the necessary regression models and figures used in my paper for the survival analysis section. 
# The script saves the plots as R objects and Latex code that can be subsequently saved into other file formats or copied
# into a word processor. No datasets are saved directly though the datasets and subsets created in the script are utilized locally with the R environment
# created by this script. 
# _________________________________________________________________________________________________________
# AUTHOR: SANJAY SATISH
# DUKE UNIVERSITY
# March 2022
# _________________________________________________________________________________________________________
# Inputs
# Stur students, schools, and comparison students datasets
# 
# _________________________________________________________________________________________________________
# Outputs
# All outputs are unique to the R environment you are using. 
# 
#==========================================================================================================

# Note: the directory structure is not relative, so please change the pathnames as noted to reflect where the data used is located on your device

#========================
#Setup
#========================
# If these packages are unavailable on your local server, utilize the install.packages("PackageName") function
#       in base R to load these packages. They are all available through the global, standard CRAN R repository

library(tidyverse)
library(dplyr)
library(flextable)
library(grid)
library(gridExtra)
library(cowplot)
library(stargazer)
library(scales)
library(pROC)
library(patchwork)
library(survminer)
library(survival)
library(foreign)
library(kableExtra)
library(ggplot2)
library(broom)
library(GGally)
library(tidyr)
library(knitr)
library(xtable)

#========================
#Part 1: Reading and Cleaning Dataset
#========================

# Reading in datasets
students <- read.table("/Users/Sanscubed/Desktop/Thesis/Thesis_data/STAR_Archive/STAR_Students.tab", header = T, sep = "\t", fill = TRUE)
schools <- read.table("/Users/Sanscubed/Desktop/Thesis/Thesis_data/STAR_Archive/STAR_K-3_Schools.tab", header = T, sep = "\t", fill = TRUE)
comparison_students <- read.table("/Users/Sanscubed/Desktop/Thesis/Thesis_data/STAR_Archive/Comparison_Students.tab", header = T, sep = "\t", fill = TRUE)


# Converting test scores to numeric types
students$g1tmathss <- as.numeric(students$g1tmathss)
students$g1treadss <- as.numeric(students$g1treadss)
students$g1tlistss <- as.numeric(students$g1tlistss)
students$g1wordskillss <- as.numeric(students$g1wordskillss)

students$gktmathss <- as.numeric(students$gktmathss)
students$gktreadss <- as.numeric(students$gktreadss)
students$gktlistss <- as.numeric(students$gktlistss)
students$gkwordskillss <- as.numeric(students$gkwordskillss)

students$g2tmathss <- as.numeric(students$g2tmathss)
students$g3tmathss <- as.numeric(students$g3tmathss)

# If score NA, resetting to 0 to allow for missing value sums
students$g1tmathss[is.na(students$g1tmathss)] = 0
students$g2tmathss[is.na(students$g2tmathss)] = 0
students$g3tmathss[is.na(students$g3tmathss)] = 0
students$gktmathss[is.na(students$gktmathss)] = 0

# Main data renaming
students <- students %>%
  rename(flagsgk = var6, flagsg1 = var7, flagsg2 = var8, flagsg3 = var9) 

# Filtering for unneeded observations
students_survival <- students %>%
  filter(yearsstar != 0)




