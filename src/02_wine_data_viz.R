#!/usr/bin/env Rscript 
# 
# 02_wine_data_viz.R
# 
# Anthony Chiodo, Jingyun Chen - Nov, 2018
#
# Purpose: This script imports the cleaned red wine data set and creates a violin plot for the
#         'alcohol' feature with original classes and with re-encoded classes.
#
# Input: 
#      - db name: WinesDB.db 
#
# Output:
#      - A violin plot showing distribution of data on original targets and on
#        re-encoded targets ("low quality", "high quality"; alcohol chosen as
#        arbitrary feature for visualization): eda_data_balance.png
#
#
# Dependencies: tidyverse
# 
# Arguments: 
#      - arg1: input_table
#      - arg2: output_dir
#
# Usage: Rscript src/02_wine_data_viz.R WinesDB.db results/figures


# load libraries
library(tidyverse)
library(RSQLite)

# read in command line arguments
args <- commandArgs(trailingOnly = TRUE)
db_name <- args[1]
output_dir <- args[2]

# define main function
main <- function(){

  conn <- dbConnect(RSQLite::SQLite(), db_name)
  # read in data
  data <- dbGetQuery(conn, "SELECT * FROM WineCleanedData")
  
  # create plots
  original_target_violin <- ggplot(data, aes(x = factor(x = quality_old), alcohol)) +
    geom_violin(fill = "#f8766d", alpha = 0.5) +
    geom_jitter(width = 0.4, alpha = 0.5, size = 0.75) +
    labs(x = "Quality",
         y = "Alcohol (%)",
         subtitle = "A") +
    theme_bw()
  
  new_target_violin <- ggplot(data, aes(x = factor(x = quality), alcohol)) +
    geom_violin(fill = "#f8766d", alpha = 0.5) +
    geom_jitter(width = 0.4, alpha = 0.5, size = 1) +
    scale_x_discrete(labels = c('low quality', 'high quality')) +
    labs(x = "Quality (re-encoded)",
         y = "Alcohol (%)",
         subtitle = "B") +
    theme_bw()
  
  combine_original_new <- gridExtra::grid.arrange(original_target_violin, new_target_violin, nrow=1)
  
  # save plots
  ggsave(paste0(output_dir, '/eda_data_balance.png'), combine_original_new, width = 11)
  
}

# call main function
main()