#! /usr/bin/env Rscript 
# plot_feature_importance.R
# Anthony Chiodo, Jingyun Chen - Nov, 2018
#
# This script imports a feature importance table from a .csv files and outputs a figures that 
# show all the features' importance. 
# This script takes the path to the input file and path to the output figure file
#
# Dependencies: tidyverse
#
# Usage: 
# Rscript src/plot_feature_importance.R results/feature_importance.csv results/figures


# load libraries
library(tidyverse)

# read in command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_dir <- args[2]

main <- function(){
  # read in data
  feature_importance <- read_csv(input_file)
  
  # plot the feature importance
  plot <- feature_importance %>% ggplot(aes(x = feature_importance, 
                                    y = reorder(feature,feature_importance)))+
    geom_point() + 
    labs(x = "Feature Importance", y = "Feature") +
    scale_x_continuous(breaks = c(0.05,0.1,0.15,0.2,0.25,0.3) ) + 
    theme_bw()
  # plot
  ggsave(paste0(output_dir, "/figure_importance.png"), plot, width = 4, height = 3, dpi = 300)
}

# call main function
main()
print(1)
