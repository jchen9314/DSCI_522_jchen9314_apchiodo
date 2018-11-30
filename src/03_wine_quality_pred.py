#!/usr/bin/env python 
# 
# 03_wine_quality_predicton.py
# 
# Jingyun Chen, Anthony Chiodo - Nov, 2018
#
# Purpose: This script takes cleaned red wine quality data set, splits the data set into train(80%) and test(20%), 
#          and fits into a decision tree model and predict accuracy on test set. 
#          Also, it performs a 5-fold cross-validation to find the best hyper-parameter and presents importance 
#          of each feature used in this model.
#
# Input: 
#      - Clean data set: data/cleaned_winequality-red.csv
#
# Outputs:
#      - Cross-validation score: results/cross_validation_scores.csv
#      - Decision tree model: results/winequality_pred_model.pkl
#      - Prediction results: results/pred_summary_table.csv
#      - Features' importance: results/feature_importance.csv
#
# Dependencies: argparse, pandas, numpy, sklearn, pickle
# 
# Arguments: 
#      - arg1: input_file_path
#      - arg2: output_file_path
#
# Usage: python src/03_wine_quality_pred.py data/cleaned_winequality-red.csv results/


# import libraries
import argparse
import pickle
import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score

# read in command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("input_file_path")
parser.add_argument("output_file_path")
args = parser.parse_args()

def main():
    # read in data
    wine_quality = pd.read_csv(args.input_file_path)
    X = wine_quality.drop(["quality","quality_old"], axis = 1)
    y = wine_quality["quality"]
    #  split your data into train:validation sets by 80:20
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 62)
    # pick up the best max_depth from 1 to 10  using 5 folds cross validation
    cv_performance = []
    for depth in range(1, 11):
        model = DecisionTreeClassifier(max_depth = depth, random_state = 62)
        score = cross_val_score(model, X_train, y_train, cv = 5)
        cv_score = score.mean()
        cv_performance.append(cv_score)
    write_cv_score(cv_performance)
    train_acc = max(cv_performance)
    best_depth = cv_performance.index(train_acc) + 1
    # prediction on test data
    model = DecisionTreeClassifier(max_depth = best_depth, random_state = 62)
    model.fit(X_train, y_train)
    # save model as .pkl file
    with open(args.output_file_path + "winequality_pred_model.pkl", "wb") as file_name:
        pickle.dump(model, file_name)
    # calculate test accuracy
    test_acc = model.score(X_test, y_test)
    # create summary table of the result
    summary_lst = ["Red wine quality data", "Decision tree", best_depth, round(train_acc, 3), round(test_acc, 3)]
    create_acc_table(summary_lst)
    # create feature importance table
    create_feature_importance(X_test.columns, model)

def write_cv_score(cv_scores_lst):
    """
    create a .csv that stores cross validation score for each tree depth
    """
    depth_lst = [x for x in range(1, 11)]
    depth_performance = [depth_lst, cv_scores_lst]
    df = pd.DataFrame(depth_performance, index = ["Tree depth", "Cross-validation score"])
    df = df.T
    df.to_csv(args.output_file_path + "cross_validation_scores.csv")

def create_acc_table(summary_lst):
    """
    create a .csv that stores the accuracy of train and test data
    """
    df = pd.DataFrame(summary_lst, index = ["Data set", "Classifier", "Best depth", "Train accuracy", "Test accuracy"])
    df = df.T
    df.to_csv(args.output_file_path + "pred_summary_table.csv")

def create_feature_importance(columns, model):
    """
    create a .csv that stores the importance of each feature used in the model
    """
    feature_lst = list(model.feature_importances_)
    feature_lst = [round(x, 3) for x in feature_lst]
    feature_scores = [list(columns), feature_lst]
    df = pd.DataFrame(feature_scores, index = ["Feature", "Feature importance"])
    df = df.T
    df = df.sort_values(by = "Feature importance", axis = 0, ascending = False)
    df = df.reset_index().drop("index", axis= 1)
    df.to_csv(args.output_file_path + "feature_importance.csv")

# call main function
if __name__ == "__main__":
    main()