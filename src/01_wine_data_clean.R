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
#      - SQLite db file: WinesDB.db
#
# Dependencies: readr, dplyr
# 
# Arguments: 
#      - arg1: input_file
#      - arg2: db_name
#
# Usage: Rscript src/01_wine_data_clean.R https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv WinesDB.db


# load libraries
library(readr)
library(dplyr)
library(stringr)
library(RSQLite)

# read in command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
db_name <- args[2]

# define main function
main <- function(){
  
  # read in data
  data <- read.delim(input_file, sep = ";")
  
  # create vectors to re-format column names
  old_names <- names(data)
  new_names <- names(data) %>%
    str_replace_all("\\.", " ")
  
  # re-encode data
  data <- data %>%
    rename_at(vars(old_names), ~new_names) %>%
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
  
  # create a connection to our new database, WinesDB.db
  # you can check that the .db file has been created on your working directory
  conn <- dbConnect(RSQLite::SQLite(), db_name)
  
  # dump data to db
  dbWriteTable(conn, 'WineCleanedData', data)
  
}


# call main function
main()