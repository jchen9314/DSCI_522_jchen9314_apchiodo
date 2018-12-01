## Red Wine Quality Predictor

![](https://media.giphy.com/media/3oKIP5bAoKJFJNOkgM/giphy.gif)

[source](https://media.giphy.com/media/3oKIP5bAoKJFJNOkgM/giphy.gif)

Collaborators: Jingyun Chen ([jchen9314](https://github.com/jchen9314)) & Anthony Chiodo ([apchiodo](https://github.com/apchiod))

### Project summary

Have you ever attended a dinner party and felt completely clueless when the conversation topic abruptly shifts to the quality of the wine paired with your meal? If so, then you are not alone. Often, the arbitrary labeling of a given wine (i.e. “good” or “bad”) appears to be subject to an everyday consumers palette. And this is OK. 

However, given the complexity of the wine industry and the degree of professionalism associated with it (wine experts, sommeliers), there clearly must be some characteristics that serve as strong predictors for what ultimately is defined as a quality wine.

The objective of this project is to find out which physiochemical characteristics of wine are the most important predictors of wine quality.

In this project, we used red wine quality data set from Kaggle. It contains 1599 red variants of the Portuguese Vinho Verde wine. A table shows the description of 11 physiochemical characteristics of wine in detail can be found in Dataset section. Besides, the categorical target variable, which is wine quality, is ranked between 0 and 10. 

Exploratory data analysis revealed that the distribution of the data across the targets was fairly unbalanced. Thus, we re-encoded the data such that targets less than or equal to 5 were classified as 0 (or “poor” quality), and targets greater than 5 were classified as 1 (or “good” quality) so that the data became more evenly balanced between classes.

In order to address this binary classification problem, we applied decision tree algorithm to our data set. We separated features from the target and splitted them into train and test set by 80:20. We performed 5-fold cross-validation to choose the best `max_depth` of our model. We then trained our model on train set and predicted our target on the test set. 

After performing cross-validation, the best `max_depth` we chose is 4 and our classification accuracy on the test set is about 0.712. Also, the three most important features according to our results are alcohol, sulphates and total sulfur dioxide.

In order to increase the accuracy of our model, we might explore the use of other hyperparameters and might use other machine learning models such as random forest.

In order to improve the generalization ability of our model, we could collect more similar data on different types of wine in the future.

### Data set
Data source is [here](https://www.kaggle.com/uciml/red-wine-quality-cortez-et-al-2009). 

The table below shows the description of 11 physiochemical characteristics used as numeric features to predict wine quality, which is a categorical variable. Descriptions provided by [UCI Machine Learning](https://www.kaggle.com/uciml/red-wine-quality-cortez-et-al-2009).

| Feature              | Description                                                                                                                                                                                     |
| :------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Fixed acidity        | Most acids involved with wine or fixed or non-volatile (do not evaporate readily)                                                                                                                |
| Volatile acidity     | The amount of acetic acid in wine, which at too high of levels can lead to an unpleasant, vinegar taste                                                                                         |
| Citric acid          | Found in small quantities, citric acid can add ‘freshness’ and flavor to wines                                                                                                                  |
| Residual sugar       | The amount of sugar remaining after fermentation stops, it’s rare to find wines with less than 1 gram/liter and wines with greater than 45 grams/liter are considered sweet                     |
| Chlorides            | The amount of salt in the wine                                                                                                                                                                  |
| Free sulfur dioxide  | The free form of SO2 exists in equilibrium between molecular SO2 (as a dissolved gas) and bisulfite ion; it prevents microbial growth and the oxidation of wine                                 |
| Total sulfur dioxide | Amount of free and bound forms of S02; in low concentrations, SO2 is mostly undetectable in wine, but at free SO2 concentrations over 50 ppm, SO2 becomes evident in the nose and taste of wine |
| Density              | The density of water is close to that of water depending on the percent alcohol and sugar content                                                                                               |
| pH                   | Describes how acidic or basic a wine is on a scale from 0 (very acidic) to 14 (very basic); most wines are between 3-4 on the pH scale                                                          |
| Sulphates            | A wine additive which can contribute to sulfur dioxide gas (S02) levels, which acts as an antimicrobial and antioxidant                                                                          |
| Alcohol              | The percent alcohol content of the wine                                                                                                                                                         |

### Usage

You can reproduce our analysis with the following steps:

1. Clone this repo, and using the command line, navigate to the root of this project.

2. Run Makefile by typing following code in the terminal:

```
# Removes unnecessary files to start the analysis from scratch
make clean

# Runs all scripts to generate the report
make all
```
The Makefile creates an entire data analysis pipeline for our red wine quality prediction project by executing the following scripts one by one:

```
# step 1. run 01_wine_data_clean.R script: clean data set
Rscript src/01_wine_data_clean.R data/winequality-red.csv data/cleaned_winequality-red.csv

# step 2. run 02_wine_data_viz.R script: wine data visualization
Rscript src/02_wine_data_viz.R data/cleaned_winequality-red.csv results/figures

# step 3. run 03_wine_quality_pred.py script: wine quality prediction and save results
python src/03_wine_quality_pred.py data/cleaned_winequality-red.csv results/

# step 4 run 04_plot_tree_model.py script: cross-validation score and decision tree model visualization
python src/04_plot_tree_model.py results/ results/figures/

# step 5. knit the final report
Rscript -e "rmarkdown::render('doc/wine_quality_analysis_report.Rmd')"
```

The following is the description, expected input and output files of each script we used in this project.

1. 01\_wine\_data\_clean.R

    This script import the raw red wine data set and re-encodes the 'quality' variable to only have two targets(1: "high quality" if the value of quality is greater than 5; otherwise 0: "low quality")

    Input:
    
    - Raw data set: data/winequality-red.csv
    
    Output: 
        
    - Cleaned data set: data/cleaned_winequality-red.csv

2. 02\_wine\_data\_viz.R

    This script imports the cleaned red wine data set and create a violin plot for the 'alcohol' feature with original classes and with re-encoded classes. Also it creates a facetted density plot to compare the distribution of re-encoded classes across all features.

    Input: 
       
    - Clean data set: data/cleaned_winequality-red.csv

    Outputs:
       
    - A violin plot showing distribution of data on original targets and on re-encoded targets ("low quality", "high quality"; alcohol chosen as arbitrary feature for visualization): eda_data_balance.png
    - An density plot showing distribution of on re-encoded targets across all features("low quality", "high quality"): eda_all_vars_density.png

3. 03_wine_quality_pred.py

    This script takes cleaned red wine quality data set, splits the data set into train(80%) and test(20%), and fits into a decision tree model and predict accuracy on test set. Also, it performs a 5-fold cross-validation to find the best hyper-parameter and presents importance of each feature used in this model.

    Input: 
       
    - Clean data set: data/cleaned_winequality-red.csv
       
    Outputs:
       
    - Cross-validation score: results/cross_validation_scores.csv
    - Decision tree model: results/winequality_pred_model.pkl
    - Prediction results: results/pred_summary_table.csv
    - Features' importance: results/feature_importance.csv

4. 04_plot_tree_model.py

    This script takes a decision tree model and a cross-validation score .csv file as inputs and converts them into a tree model graph and a cross-validation score plot, respectively.

    Inputs: 
    
    - Decision tree model: results/winequality_pred_model.pkl
    - Cross-validation score: results/cross_validation_scores.csv

    Outputs:
      
    - Tree model graph: results/figures/tree_model.png
    - Cross-validation score plot: results/figures/cv_score.png


### Dependencies

- R & R libraries:

	- `R 3.5.1`
	- `rmarkdown 1.10`
	- `knitr 1.20`
	- `dplyr 0.7.6`
	- `tidyverse 1.2.1`
	- `readr 1.1.1`

- Python & Python libraries:
 
    - `Python 3.6.5`
	- `argparse 1.1`
	- `numpy 1.14.3`
	- `pandas 0.23.0`
	- `sklearn 0.19.1`
	- `pickle 4.0`
	- `graphviz 0.10.1`
	- `matplotplib 2.2.2`

### Report
The analysis report can be found [here](https://github.com/jchen9314/DSCI_522_jchen9314_apchiodo/blob/master/doc/wine_quality_analysis_report.md).

### Release versions

- [V1.0](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/tree/v1.0)

- [V2.0](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/tree/v2.0)

- [V3.0](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/tree/v3.0)
