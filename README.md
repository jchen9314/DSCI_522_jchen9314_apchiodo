# DSCI_522_jchen9314_apchiodo

Wine quality

[](https://media.giphy.com/media/zx6Tsme145Eoo/giphy.gif)

# Project Proposal

## Identify data set, question, & plan of action for analysis to answer that question

1. Choose a public data set from the web that you are interested in to carry out a small data analysis. You may also use any data set we have previously worked with in MDS. **Prove to us that you can load the data set into R or Python** (this could be demonstrating by writing a script that downloads the data and saves a snippet of it, for example).

> - [Scripts for loading data](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/tree/master/scripts)
> - load data using R `scripts\import_data.R`
> - load data using python `scripts\import_data.py`

2. With that data set, identify a question you would like to ask from it that could be answered by some simple analysis and visualization (more on this below). State what kind of question it is (it should be one of the 6 types discussed in lecture 1).

> - Which physiochemical characteristics of wine are the strongest predictors of wine quality?
> - Question type: Predictive

3. Make a plan of how you will analyze the data (report an estimate and confidence intervals? hypothesis test? classification with a decision tree?). Choose something you know how to do (report an estimate and confidence intervals, a two-group hypothesis), or will learn how to do in the first week of block 3 (ANOVA, classification with a decision tree).

> **Classification with a decision tree**
> - perform EDA; get familiar with data set
> - split data set into training and test sets
> - separate features of interest from target
> - apply decision tree classifcation to training set using `scikit-learn`
> - evaluate how our model performed on test set
> - tease out physiochemical characteristics most important for classifying a good wine

4. Suggest how you might summarize the data to show this as a table or a number, as well as how you might show this as a visualization.

> - the output of the machine learning excercise will give us feature importance in determining wine quality, which we can show in tabular form
> - To visualize, we can create an ordered bar chart of each feature.

