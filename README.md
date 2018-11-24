## Red Wine Quality Predictor

![](https://media.giphy.com/media/3oKIP5bAoKJFJNOkgM/giphy.gif)

[gif source](https://media.giphy.com/media/3oKIP5bAoKJFJNOkgM/giphy.gif)

### Team members

| Name  | Github username | 
| :------: | :----------: |
| Jingyun Chen | jchen9314|  
| Anthony Chiodo |apchiodo|

### Project summary

Have you ever attended a dinner party and felt completely clueless when the conversation topic abruptly shifts to the quality of the wine paired with your meal? If so, then you are not alone. Often, the arbitrary labelling of a given wine (i.e. “good” or “bad”) appears to be subject to an everyday consumers palette. And this is OK. 

However, given the complexity of the wine industry and the degree of professionalism associated with it (wine experts, sommeliers), there clearly must be some characteristics that
serve as strong predictors for what ultimately is defined as a quality wine.

The objective of this project is to find out which physiochemical characteristics of wine are the most important predictors of wine quality.

In this project, we use red wine quality dataset from Kaggle. It contains 1599 red variants of the Portuguese Vinho Verde wine. The table below shows the description of 11 physiochemical characteristics of wine in detial. Besides,the target variable, which is wine quality, is ranked between 0 and 10.

In order to address this predictive question, we applied decision tree algorithm to our dataset. We separated features from target and splitted into train and test set by 80:20. We performed 5-fold cross validation to choose the best `max_depth` of our model. We then trained our model on train set and predict our target on test set. 

After performing cross validation, the best `max_depth` we chose is 11 and our classification accuracy on test set is about 0.753. Also, the three most important features according to our results are alcohol, volatile acidity, and sulphates.

In order to increase the accuracy of our model, we might to explore the use of other hyperparameters and might to use other machine learning models such as random forest.

In order to improve the generalization ability of our model, we could collect more similar data on different types of wine in the future.

### Dataset
- Data source: [red wine quality dataset](https://www.kaggle.com/uciml/red-wine-quality-cortez-et-al-2009)
- Data can also be found in the [data folder](https://github.com/jchen9314/DSCI_522_jchen9314_apchiodo/tree/master/data) of this repo.
- Description of each feature

| feature              | description                                                                                                                                                                                     |
| :------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| fixed acidity        | most acids involved with wine or fixed or nonvolatile (do not evaporate readily)                                                                                                                |
| volatile acidity     | the amount of acetic acid in wine, which at too high of levels can lead to an unpleasant, vinegar taste                                                                                         |
| citric acid          | found in small quantities, citric acid can add ‘freshness’ and flavor to wines                                                                                                                  |
| residual sugar       | the amount of sugar remaining after fermentation stops, it’s rare to find wines with less than 1 gram/liter and wines with greater than 45 grams/liter are considered sweet                     |
| chlorides            | the amount of salt in the wine                                                                                                                                                                  |
| free sulfur dioxide  | the free form of SO2 exists in equilibrium between molecular SO2 (as a dissolved gas) and bisulfite ion; it prevents microbial growth and the oxidation of wine                                 |
| total sulfur dioxide | amount of free and bound forms of S02; in low concentrations, SO2 is mostly undetectable in wine, but at free SO2 concentrations over 50 ppm, SO2 becomes evident in the nose and taste of wine |
| density              | the density of water is close to that of water depending on the percent alcohol and sugar content                                                                                               |
| pH                   | describes how acidic or basic a wine is on a scale from 0 (very acidic) to 14 (very basic); most wines are between 3-4 on the pH scale                                                          |
| sulphates            | a wine additive which can contribute to sulfur dioxide gas (S02) levels, wich acts as an antimicrobial and antioxidant                                                                          |
| alcohol              | the percent alcohol content of the wine                                                                                                                                                         |

### Usage

You can reproduce our analysis with the following steps:

1. Clone this repo, and using the command line, navigate to the root of this project.

2. Run the following commands:

```
Rscript src/clean_data.R data/winequality-red.csv data/cleaned_winequality-red.csv
Rscript src/eda.R data/cleaned_winequality-red.csv results/figures
python src/wine_quality_pred.py data/cleaned_winequality-red.csv results/
Rscript src/plot_results.R results results/figures
Rscript -e "rmarkdown::render('doc/wine_quality_analysis_report.Rmd')"
```

### Dependencies

- R & R libraries:

	- `rmarkdown`
	- `knitr`
	- `kableExtra`
	- `dplyr`
	- `tidyverse`
	- `readr`

- Python & Python libraries:

	- `argparse`
	- `numpy`
	- `pandas`
	- `sklearn`

### Report
The analysis report can be found [here](https://github.com/jchen9314/DSCI_522_jchen9314_apchiodo/blob/master/doc/wine_quality_analysis_report.md).

### Release versions

- [V1.0](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/tree/v1.0)

- [V2.0](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/tree/v2.0)
