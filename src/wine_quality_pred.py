#!/usr/bin/env python 
# wine_quality_predicton.py
# Jingyun Chen, Nov 22, 2018
#
# This script imports cleaned dataset from a .csv files and outputs either an cross validation performance on train set
# as a .csv file, or a prediciton summary table as a .csv file, or a feature importance table as a .csv file(by default). 
# This script takes the path to the input file, the path where to write the file, 
# and also an option that specify what type of table a user wants to create.
#
# Dependencies: argparse, pandas, numpy, sklearn
#
# Usage: 
# python src/wine_quality_pred.py data/cleaned_winequality-red.csv results/ --option=cv
# python src/wine_quality_pred.py data/cleaned_winequality-red.csv results/ --option=acc
# python src/wine_quality_pred.py data/cleaned_winequality-red.csv results/


# import libraries
import argparse
import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score

# read in command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("input_file_path")
parser.add_argument("output_file_path")
parser.add_argument("--option")
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
        model = DecisionTreeClassifier(max_depth = depth, random_state = 1234)
        score = cross_val_score(model, X_train, y_train, cv = 5)
        cv_score = score.mean()
        cv_performance.append(cv_score)
    train_acc = max(cv_performance)
    best_depth = cv_performance.index(train_acc) + 1
    print(best_depth)
    
    # prediction on test data
    model = DecisionTreeClassifier(max_depth = best_depth, random_state = 1234)
    model.fit(X_train, y_train)
    test_acc = model.score(X_test, y_test)

    if args.option == "cv":
        write_cv_score(cv_performance)
    elif args.option == "acc":
        # create summary table of the result
        summary_lst = ["red_wine_quality_data", "decision_tree", best_depth, round(train_acc,2), round(test_acc, 2)]
        create_acc_table(summary_lst)
    else:
        # create feature importance table
        create_feature_importance(X_test.columns, model)


def write_cv_score(cv_scores_lst):
    depth_lst = [x for x in range(1,26)]
    depth_performance = [depth_lst, cv_scores_lst]
    df = pd.DataFrame(depth_performance, index = ["tree_depth", "cv_performance"])
    df = df.T
    df.to_csv(args.output_file_path + "cross_validation_scores.csv")
    
def create_acc_table(summary_lst):
    df = pd.DataFrame(summary_lst, index = ["dataset", "classifier", "best_depth", "train_accuracy", "test_accuracy"])
    df = df.T
    df.to_csv(args.output_file_path + "pred_summary_table.csv")
    
def create_feature_importance(columns, model):
    feature_lst = list(model.feature_importances_)
    feature_scores = [list(columns), feature_lst]
    df = pd.DataFrame(feature_scores, index = ["feature", "feature_importance"])
    df = df.T
    df = df.sort_values(by = "feature_importance", axis = 0, ascending = False)
    df = df.reset_index().drop("index", axis= 1)
    df.to_csv(args.output_file_path + "feature_importance.csv")

# call main function
if __name__ == "__main__":
    main()