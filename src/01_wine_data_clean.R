#!/usr/bin/env Rscript 
# 
# 01_wine_data_clean.R
# 
# Anthony Chiodo, Jingyun Chen - Nov, 2018
#
# Purpose: This script imports the raw red wine data set link and re-encodes the 'quality' variable to only have
#          two targets(1: "high quality" if the value of quality is greater than 5; otherwise 0: "low quality")
#
# Input: 
#      - Raw data set link: https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv
#
# Output:
#      - Cleaned data set: data/cleaned_winequality-red.csv
#
# Dependencies: readr, dplyr
# 
# Arguments: 
#      - arg1: input_file
#      - arg2: output_file
#
# Usage: Rscript src/01_wine_data_clean.R https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv data/cleaned_winequality-red.csv


# load libraries
library(readr)
library(dplyr)

# read in command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]

# define main function
main <- function(){
  
  # read in data
  data <- read_csv(input_file)
  
  # re-encode data
  data <- data %>%
    mutate(quality_old = quality) %>%
    mutate(quality = case_when(
      quality == 3 ~ 1,
      quality == 4 ~ 2,
      quality == 5 ~ 3,
      quality == 6 ~ 4,
      quality == 7 ~ 5,
      quality == 8 ~ 6,
      TRUE ~ NA_real_
    )) %>%
    mutate(quality = if_else(quality <= 3, 0, 1)) %>%
    mutate_at(vars(quality, `total sulfur dioxide`), as.integer)
  
  # save to file
  write_csv(data, output_file)
  
}


# call main function
main()