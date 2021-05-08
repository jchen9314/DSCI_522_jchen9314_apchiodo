## Red Wine Quality Predictor

[Try it on Heroku](https://prod-quality-predictor.herokuapp.com/)

![](https://media.giphy.com/media/3oKIP5bAoKJFJNOkgM/giphy.gif)

[source](https://media.giphy.com/media/3oKIP5bAoKJFJNOkgM/giphy.gif)

Collaborators: Jingyun Chen ([jchen9314](https://github.com/jchen9314)) & Anthony Chiodo ([apchiodo](https://github.com/apchiod))

### Project summary

Have you ever attended a dinner party and felt completely clueless when the conversation topic abruptly shifts to the quality of the wine paired with your meal? If so, then you are not alone. Often, the arbitrary labeling of a given wine (i.e. “good” or “bad”) appears to be subject to an everyday consumers palette. However, given the complexity of the wine industry and the degree of professionalism associated with it (wine experts, sommeliers), there clearly must be some characteristics that serve as strong predictors for what ultimately is defined as a quality wine.

The objective of this project is to find out which physiochemical characteristics of wine are the most important predictors of wine quality.

Exploratory data analysis revealed that the distribution of the data across the target categories (wine quality, as a rating between 1 and 10) was fairly unbalanced. Thus, we re-encoded the data such that target cartegories less than or equal to 5 were classified as 0 (or “low quality"), and targets greater than 5 were classified as 1 (or "high quality").

In order to address this now binary classification problem, we applied a decision tree algorithm to our data set. We separated features from their targets and split them into a train and test sets by 80:20. Through 5-fold cross-validation, we were able to select the best `max_depth` as a hyperparameter for our model. We then trained our model on the train set and predicted our target on the test set. 

In building our model, we were also able to tease out the most important features. According to our results are alcohol, sulphates and total sulfur dioxide are the three most important features.

### Data set

In this project, we used a red wine quality data set sourced from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/wine+quality). It contains 1599 red variants of the Portuguese Vinho Verde wine.

The table below shows the description of 11 physiochemical characteristics used as numeric features to predict wine quality, which is a categorical variable. Descriptions provided by [Kaggles version of this dataset](https://www.kaggle.com/uciml/red-wine-quality-cortez-et-al-2009).

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

You can reproduce our analysis using either Docker or Make with the following steps:

__Docker__

1. Install Docker

    - [Install Docker for Mac](https://docs.docker.com/v17.12/docker-for-mac/install/)
    - [Install Docker for Windows](https://docs.docker.com/v17.12/docker-for-windows/install/)
    - [Install Docker for Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/) 

2. Run the following code in Terminal to download the Docker image:

```
docker pull jc2592/dsci_522_jchen9314_apchiodo
```

3. Clone this repo from [here](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo), and using the command line, navigate to the root of this project.

4. Type the following code in Terminal to run the analysis and generate a report with a dependency diagram:

```
docker run --rm -v <ABSOLUTE_PATH_OF_REPO_ON_YOUR_COMPUTER>:/home/red_wine_quality_prediction jc2592/dsci_522_jchen9314_apchiodo make -C '/home/red_wine_quality_prediction' all
```

5. Type the following code in Terminal to clean up the analysis:

```
docker run --rm -v <ABSOLUTE_PATH_OF_REPO_ON_YOUR_COMPUTER>:/home/red_wine_quality_prediction jc2592/dsci_522_jchen9314_apchiodo make -C '/home/red_wine_quality_prediction' clean
```

__Make__

1. Install Make

    - Install Make for Mac: type `xcode-select --install` in Terminal
    - [Install Make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm)
    - Install Make for Ubuntu: type `sudo apt-get install build-essential` in Terminal

2. Ensure all dependecies are installed (See Dependencies section)

3. Clone this repo from [here](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo), and using the command line, navigate to the root of this project.

4. Run [Makefile](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/blob/master/Makefile) by typing the following code in Terminal:

```
# removes unnecessary files to start the analysis from scratch
make clean

# runs all scripts to generate the report without the dependency diagram
# Note: It will throw an error if you type `make all` with Make.
make all_local
```

The Makefile creates an entire data analysis pipeline for our red wine quality prediction project by executing the following scripts one by one:

```
# step 1. run 01_wine_data_clean.R script: clean data set
Rscript src/01_wine_data_clean.R https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv_winequality-red.csv

# step 2. run 02_wine_data_viz.R script: wine data visualization
Rscript src/02_wine_data_viz.R data/cleaned_winequality-red.csv results/figures

# step 3. run 03_wine_quality_pred.py script: wine quality prediction and save results
python src/03_wine_quality_pred.py data/cleaned_winequality-red.csv results/

# step 4. run 04_plot_tree_model.py script: cross-validation score and decision tree model visualization
python src/04_plot_tree_model.py results/ results/figures/

# step 5. knit the final report
Rscript -e "rmarkdown::render('doc/wine_quality_analysis_report.Rmd')"

# step 6. generate a dependency diagram 
# Note: The diagram will be generated using Docker. If you only use Make to run the analysis, please omit this step.
makefile2graph > Makefile.dot
dot -Tpng Makefile.dot -o Makefile.png
```

The following is the description, expected input and output files of each script we used in this project.

1. [01\_wine\_data\_clean.R](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/blob/master/src/01_wine_data_clean.R)

    This script imports the raw red wine data set and re-encodes the 'quality' variable to only have two targets(1: "high quality" if the value of quality is greater than 5; otherwise 0: "low quality")

    Input:
    
    - Raw data set: https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/
    
    Output: 
        
    - Cleaned data set: data/cleaned_winequality-red.csv

2. [02\_wine\_data\_viz.R](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/blob/master/src/02_wine_data_viz.R)

    This script imports the cleaned red wine data set and creates a violin plot for the 'alcohol' feature with original classes and with re-encoded classes.

    Input: 
       
    - Cleaned data set: data/cleaned_winequality-red.csv

    Output:
       
    - A violin plot showing distribution of data on original targets and on re-encoded targets ("low quality", "high quality"; alcohol chosen as arbitrary feature for visualization): eda_data_balance.png

3. [03\_wine\_quality\_pred.py](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/blob/master/src/03_wine_quality_pred.py)

    This script takes cleaned red wine quality data set, splits the data set into a train(80%) and a test(20%) set, and fits the train set into a decision tree model and calculates the prediction accuracy on the test set. Also, it performs a 5-fold cross-validation to find the best hyper-parameter and presents the importance of each feature used in this model.

    Input: 
       
    - Cleaned data set: data/cleaned_winequality-red.csv
       
    Outputs:
       
    - Cross-validation score: results/cross_validation_scores.csv
    - Decision tree model: results/winequality_pred_model.pkl
    - Prediction results: results/pred_summary_table.csv
    - Features' importance: results/feature_importance.csv

4. [04\_plot\_tree\_model.py](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/blob/master/src/04_plot_tree_model.py)

    This script takes a decision tree model and a cross-validation score .csv file as inputs and converts them into a tree model graph and a cross-validation score plot, respectively.

    Inputs: 
    
    - Decision tree model: results/winequality_pred_model.pkl
    - Cross-validation score: results/cross_validation_scores.csv

    Outputs:
      
    - Tree model graph: results/figures/tree_model.png
    - Cross-validation score plot: results/figures/cv_score.png

The following is a dependency diagram of the Makefile generated with Docker.

![](Makefile.png)

### Dependencies

- R & R libraries:

	- `R 3.5.1`
	- `rmarkdown 1.10`
	- `knitr 1.20`
	- `tidyverse 1.2.1`
	- `dplyr 0.7.6`
	- `readr 1.1.1`
	- `stringr 1.3.1`
	- `gridExra 2.3`

- Python & Python libraries:
 
    - `Python 3.6.5`
	- `numpy 1.14.3`
	- `pandas 0.23.0`
	- `sklearn 0.19.1`
	- `graphviz 0.10.1`
	- `matplotplib 2.2.2`

### Report
The analysis report can be found [here](https://github.com/jchen9314/DSCI_522_jchen9314_apchiodo/blob/master/doc/wine_quality_analysis_report.md).

### Deploy on Heroku

In this project, I deploy app/ to Heroku using git-subtrees.

- Heroku Setup

```
npm install -g heroku
heroku login
heroku git:remote -a <WEB APPLICATION NAME>
```

- Add Procfile
Before we deploy the app to Heroku, we need to tell Heroku how to run various pieces of our app. That is function of Procfile. Type the following line in Procfile:

```
web gunicorn app:app
```

- Using git-subtree to deploy the app
```
git subtree push --prefix path/to/subdirectory heroku master
```
In this case, path/to/subdirectory would be app/


### Release versions

- [V1.0](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/tree/v1.0)

- [V2.0](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/tree/v2.0)

- [V3.0](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/tree/v3.0)

- [V4.0](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/tree/v4.0)
