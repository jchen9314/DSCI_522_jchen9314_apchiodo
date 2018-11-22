#! /usr/bin/env Rscript 
# data_clean.R
# Anthony Chiodo, Jingyun Chen - Nov, 2018
#
# Import the red wine data set and re-encode the 'quality' variable to only have
# two targets
#
# Usage: Rscript src/clean_data.R data/winequality-red.csv data/cleaned_winequality-red.csv

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
  
  # print out mean of variable of interest
  data <- data %>%
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
  
  # print(head(test))
  write_csv(data, output_file)
  
}


# call main function
main()