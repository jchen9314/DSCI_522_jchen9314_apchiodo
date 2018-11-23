#! /usr/bin/env Rscript 
# plot_result.R
# Anthony Chiodo, Jingyun Chen - Nov, 2018
#
# This script imports a feature importance table and a cross validation performance table 
# from a .csv files and outputs a figures that shows all the features' importance and 
# a figure that shows the trend of cross validation score as increasing the depth of tree. 
# This script takes the path to the input file and path to the output figure file
#
# Dependencies: tidyverse
#
# Usage: 
# Rscript src/plot_results.R results results/figures


# load libraries
library(tidyverse)

# read in command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_dir <- args[1]
output_dir <- args[2]

main <- function(){
  # read in data
  feature_importance <- read_csv(paste0(input_dir, "/feature_importance.csv"))
  cv_scores <- read_csv(paste0(input_dir, "/cross_validation_scores.csv"))
  # plot the feature importance
  plot_feature_importance <- feature_importance %>% ggplot(aes(x = feature_importance, 
                                    y = reorder(feature,feature_importance)))+
    geom_point() + 
    labs(x = "Feature Importance", y = "Feature") +
    scale_x_continuous(breaks = c(0.05,0.1,0.15,0.2,0.25,0.3) ) + 
    theme_bw()
  # plot cross validation scores
  plot_cv_scores <- cv_scores %>% ggplot(aes(x = tree_depth, y = cv_performance))+
    geom_point() + 
    geom_line() + 
    labs(x = "Tree Depth", y = "Cross Validation Score") +
    theme_bw()
  
  # save plots
  ggsave(paste0(output_dir, "/figure_importance.png"), plot_feature_importance, width = 4, height = 3, dpi = 300)
  ggsave(paste0(output_dir, "/cv_score.png"), plot_cv_scores, width = 4, height = 3, dpi = 300)
  }

# call main function
main()