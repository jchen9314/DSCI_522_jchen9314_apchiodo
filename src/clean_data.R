#! /usr/bin/env Rscript 
# data_clean.R
# Anthony Chiodo, Jingyun Chen - Nov, 2018
#
# Import the red wine data set and re-encode the 'quality' variable to only have
# two targets
#
# Usage: Rscript src/clean_data.R

library(readr)
library(dplyr)

# define main function

main <- function(){
  
  # read in data
  data <- read_csv('data/winequality-red.csv')
  
  # print out mean of variable of interest
  data <- data %>%
    mutate(quality_ = case_when(
      quality == 3 ~ 1,
      quality == 4 ~ 2,
      quality == 5 ~ 3,
      quality == 6 ~ 4,
      quality == 7 ~ 5,
      quality == 8 ~ 6,
      TRUE ~ NA_real_
    )) %>%
    mutate(quality = if_else(quality_ <= 3, 0, 1)) %>%
    mutate_at(vars(quality), as.integer)
  
  # print(head(test))
  write_csv(data, "data/cleaned_winequality-red.csv")
  
}


# call main function
main()