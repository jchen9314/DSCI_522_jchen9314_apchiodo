#! /usr/bin/env python 
# 
# 04_plot_tree_model.py
# 
# Jingyun Chen, Anthony Chiodo - Nov, 2018
#
# Purpose: This script takes a decision tree model and a cross-validation score .csv file as inputs and
#          converts them into a tree model graph and a cross-validation score plot, respectively.
#  
# Input: 
#      - Decision tree model: results/winequality_pred_model.pkl
#      - Cross-validation score: results/cross_validation_scores.csv
#
# Outputs:
#      - Tree model graph: results/figures/tree_model.png
#      - Cross-validation score plot: results/figures/cv_score.png
#
# Dependencies: argparse, pickle, graphviz, sklearn, matplotlib, pandas
#
# Arguments: 
#      - arg1: input_file_path
#      - arg2: output_file_path
#
# Usage: python src/04_plot_tree_model.py results/ results/figures/


# import libraries
import argparse
import pickle
import pandas as pd
import graphviz
from sklearn.tree import export_graphviz
import matplotlib.pyplot as plt

# read in command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("input_file_path")
parser.add_argument("output_file_path")
args = parser.parse_args()

def main():
    # draw cv score plot
    draw_cv_plot(args.input_file_path, args.output_file_path)
    # draw tree model
    with open(args.input_file_path + "winequality_pred_model.pkl", 'rb') as model:
        tree_model = pickle.load(model)
    save_and_show_decision_tree(tree_model)

def save_and_show_decision_tree(model,class_names = ["low quality","high quality"],save_file_prefix = args.output_file_path +"tree_model", **kwargs):
    """
    Save the decision tree model as a png
    """
    feature_cols = ['fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar',
       'chlorides', 'free sulfur dioxide', 'total sulfur dioxide', 'density',
       'pH', 'sulphates', 'alcohol']
    dot_data = export_graphviz(model, out_file = None,
                             feature_names = feature_cols,
                             class_names = class_names,
                             filled = True, rounded = True,
                             special_characters = True, **kwargs)

    graph = graphviz.Source(dot_data, format = "png")
    graph.render(save_file_prefix)
    return graph

def draw_cv_plot(input_path, output_path):
    """
    Save cross-validation plot as a png
    """
    fig, ax = plt.subplots()
    plt.style.use('ggplot')
    df = pd.read_csv(input_path +"cross_validation_scores.csv").drop("Unnamed: 0", axis = 1)
    df.plot.scatter(x = "Tree depth", y = "Cross-validation score", legend = False, ax = ax, color = "grey")
    df.plot.line(x = "Tree depth", y = "Cross-validation score", legend = False, ax = ax, color = "grey")
    plt.xlabel("Tree depth")
    plt.ylabel("Cross-validation score")
    plt.savefig(output_path + "cv_score.png")
    
# call main function
if __name__ == "__main__":
    main()