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
#      - Clean data set: data/cleaned_winequality-red.csv
#
# Outputs:
#      - A violin plot showing distribution of data on original targets and on
#        re-encoded targets ("low quality", "high quality"; alcohol chosen as
#        arbitrary feature for visualization): eda_data_balance.png
#
#
# Dependencies: tidyverse
# 
# Arguments: 
#      - arg1: input_file
#      - arg2: output_dir
#
# Usage: Rscript src/02_wine_data_viz.R data/cleaned_winequality-red.csv results/figures


# load libraries
library(tidyverse)

# read in command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_dir <- args[2]

# define main function
main <- function(){
  
  # read in data
  data <- read_csv(input_file)
  
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
  
  # data2 <- data %>%
  #   select(-quality_old) %>%
  #   gather(key = "characteristic", value = "value", -quality)
  
  # explore_all_density <- ggplot(data2, aes(x = value)) +
  #   geom_density(aes(group = factor(quality), fill = factor(quality)), alpha = 0.5) +
  #   facet_wrap(~characteristic, scales = "free") +
  #   labs(fill = "Quality") +
  #   theme_bw() +
  #   theme(axis.title.x = element_blank())
  
  # save plots
  ggsave(paste0(output_dir, '/eda_data_balance.png'), combine_original_new, width = 11)
  # ggsave(paste0(output_dir, '/eda_all_vars_density.png'), explore_all_density)
  
}

# call main function
main()