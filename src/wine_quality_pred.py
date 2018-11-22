#!/usr/bin/env python 
# wine_quality_predicton.py
# Jingyun Chen, Nov 22, 2018
#
# This script import cleaned dataset from a .csv files and output the cross validation performance on train set
# as a .csv file and the prediciton summary table as a .csv file. 
# This script takes the path to the input file, and two paths/filenames 
# where to write the file to and what to call it.
#
# Dependencies: argparse, pandas, numpy, sklearn
#
# Usage: python src/wine_quality_pred.py data/cleaned_winequality-red.csv results/cross_validation_scores.csv results/pred_summary_table.csv


# import libraries
import argparse
import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score

# read in command line arguments
parser = argparse.ArgumentParser()
parser.add_argument('input_file_path')
parser.add_argument('output_file_path1')
parser.add_argument('output_file_path2')
args = parser.parse_args()

def main():
    
    wine_quality = pd.read_csv(args.input_file_path)
    X = wine_quality.drop("quality", axis = 1)
    y = wine_quality["quality"]

    #  split your data into train:validation sets by 80:20
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 1234)
    
    # pick up the best hyper-parameter using 5 folds cross validation
    cv_performance = []
    for depth in range(1,26):
        model = DecisionTreeClassifier(max_depth = depth)
        score = cross_val_score(model, X_train, y_train, cv = 5)
        cv_score = score.mean()
        cv_performance.append(cv_score)
    write_cv_score(cv_performance)
    train_acc = max(cv_performance)
    best_depth = cv_performance.index(train_acc) + 1
    
    # prediction on test data
    model = DecisionTreeClassifier(max_depth = best_depth)
    model.fit(X_train, y_train)
    test_acc = model.score(X_test, y_test)
    
    # create summary table of the result
    summary_lst = ["red_wine_quality_data", "decision_tree", best_depth, round(train_acc,2), round(test_acc, 2)]
    df = pd.DataFrame(summary_lst, index = ["dataset", "classifier", "best_depth", "train_accuracy", "test_accuracy"])
    df = df.T
    df.to_csv(args.output_file_path2)

    
# dataset, classifier, train_accuracy, test_accuracy
def write_cv_score(cv_scores_lst):
    depth_lst = [x for x in range(1,26)]
    depth_performance = [depth_lst, cv_scores_lst]
    df = pd.DataFrame(depth_performance, index = ["tree_depth", "cv_performance"])
    df = df.T
    df.to_csv(args.output_file_path1)
    
# call main function
if __name__ == "__main__":
    main()