#! /usr/bin/env Rscript 
# data_clean.R
# Anthony Chiodo, Jingyun Chen - Nov, 2018
#
# Import the cleaned red wine data set and create an image output for 'alcohol'
# feature and an image output for all features.  The image outputs are density plots to 
# two targets
#
# Usage: Rscript src/eda.R data/cleaned_winequality-red.csv results/figures

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
  
  # print out mean of variable of interest
  
  plot1 <- ggplot(data, aes(x = factor(x = quality_old), alcohol)) +
    geom_violin(fill = "#f8766d", alpha = 0.5) +
    geom_jitter(width = 0.4, alpha = 0.5, size = 0.75) +
    labs(x = "Quality",
         y = "Alcohol (%)",
         subtitle = "A") +
    theme_bw()
  
  plot2 <- ggplot(data, aes(x = factor(x = quality), alcohol)) +
    geom_violin(fill = "#f8766d", alpha = 0.5) +
    geom_jitter(width = 0.4, alpha = 0.5, size = 1) +
    labs(x = "Quality (re-encoded)",
         y = "Alcohol (%)",
         subtitle = "B") +
    theme_bw()
  
  plot1_2 <- gridExtra::grid.arrange(plot1, plot2, nrow=1)
  
  data2 <- data %>%
    gather(key = "characteristic", value = "value", -quality)
  
  plot3 <- ggplot(data2, aes(x = value)) +
    geom_density(aes(group = factor(quality), fill = factor(quality)), alpha = 0.5) +
    facet_wrap(~characteristic, scales = "free") +
    labs(fill = "Quality") +
    theme_bw() +
    theme(axis.title.x = element_blank())
  
  # print(head(test))
  ggsave(paste0(output_dir, '/eda_data_balance.png'), plot1_2, width = 11)
  ggsave(paste0(output_dir, '/eda_all_vars.png'), plot2)
  
}

# call main function
main()