## Red Wine Quality Predictor

![](https://media.giphy.com/media/3oKIP5bAoKJFJNOkgM/giphy.gif)

[gif source](https://media.giphy.com/media/3oKIP5bAoKJFJNOkgM/giphy.gif)

### Team members

| Name  | Github username | 
| :------: | :----------: |
| Jingyun Chen | jchen9314 |  
| Anthony Chiodo |apchiodo|

### Dataset

The dataset used for this project is the [Red Wine Quality](https://www.kaggle.com/uciml/red-wine-quality-cortez-et-al-2009) dataset. The data was sourced from [Kaggle](https://www.kaggle.com/datasets), however it originally existed on the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Wine%2BQuality).  It contains information relating to the physiochemical characteristics of red variants of the Portuguese "Vinho Verde" wine.

### Project Summary
To do ...

### Usage

1. Clone this repo, and using the command line, navigate to the root of this project.

2. Run the following commands:

```
Rscript src/clean_data.R data/winequality-red.csv data/cleaned_winequality-red.csv
Rscript src/eda.R data/cleaned_winequality-red.csv results/figures
python src/wine_quality_pred.py data/cleaned_winequality-red.csv results/ --option=cv
python src/wine_quality_pred.py data/cleaned_winequality-red.csv results/ --option=acc
python src/wine_quality_pred.py data/cleaned_winequality-red.csv results/
Rscript src/plot_results.R results results/figures
Rscript -e "rmarkdown::render('doc/wine_quality_analysis_report.Rmd')"
```

### Dependencies

- R & R libraries:

	- rmarkdown
	- knitr
	- kableExtra
	- dplyr
	- tidyverse
	- readr

- Python & Python libraries:

	- argparse
	- numpy
	- pandas
	- sklearn

### Release versions

- [V1.0](https://github.com/UBC-MDS/DSCI_522_jchen9314_apchiodo/releases/tag/v1.0)

- **v2.0:** To do ...
