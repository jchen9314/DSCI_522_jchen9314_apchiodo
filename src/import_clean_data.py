#!/usr/bin/env python 
# import_clean_data.py
# Jingyun Chen, Nov 19, 2018
#
# This script import dataset from a .csv files and output the cleaned data. 
# This script takes the path to the input file, and a path/filename 
# where to write the file to and what to call it.
#
# Dependencies: argparse, pandas, numpy
#
# Usage: python import_clean_data.py ../data/winequality-red.csv ../data/redwinequality_cleaned.csv

# import libraries
import argparse
import pandas as pd
import numpy as np

# read in command line arguments
parser = argparse.ArgumentParser()
parser.add_argument('input_file_path')
parser.add_argument('output_file_path')
args = parser.parse_args()

def main():
    # read data
    wine_qual = pd.read_csv(args.input_file_path)
    # cut wine as good and bad by giving bins for the quality
    wine_qual['quality'] = pd.cut(wine_qual["quality"], 
                                  bins = (3, 5, 8), 
                                  labels = ["bad", "good"])
    wine_qual.to_csv(args.output_file_path)
    

# call main function
if __name__ == "__main__":
    main()