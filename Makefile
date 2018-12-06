# Makefile
# Authors: Jingyun Chen, Anthony Chiodo
# Date: November 30, 2018
# Purpose: This script creates an entire data analysis pipeline for our red wine quality prediction project


#####################################
# Run all scripts
#####################################

all: doc/wine_quality_analysis_report.md
	rm -f Rplots.pdf doc/wine_quality_analysis_report.html results/figures/tree_model


#####################################
# Run Scripts
#####################################

# step 1. run 01_wine_data_clean.R script: clean data set
data/cleaned_winequality-red.csv: data/winequality-red.csv src/01_wine_data_clean.R
	Rscript src/01_wine_data_clean.R data/winequality-red.csv data/cleaned_winequality-red.csv

# step 2. run 02_wine_data_viz.R script: wine data visualization
results/figures/eda_data_balance.png results/figures/eda_all_vars.png: data/cleaned_winequality-red.csv src/02_wine_data_viz.R
	Rscript src/02_wine_data_viz.R data/cleaned_winequality-red.csv results/figures

# step 3. run 03_wine_quality_pred.py script: wine quality prediction and save results
results/cross_validation_scores.csv results/pred_summary_table.csv results/winequality_pred_model.pkl results/feature_importance.csv: data/cleaned_winequality-red.csv src/03_wine_quality_pred.py
	python src/03_wine_quality_pred.py data/cleaned_winequality-red.csv results/

# step 4. run 04_plot_tree_model.py script: cross-validation score and decision tree model visualization
results/figures/tree_model.png results/figures/cv_score.png: results/winequality_pred_model.pkl results/cross_validation_scores.csv src/04_plot_tree_model.py
	python src/04_plot_tree_model.py results/ results/figures/

# step 5. knit the final report
doc/wine_quality_analysis_report.md: doc/wine_quality_analysis_report.Rmd results/figures/eda_data_balance.png results/figures/tree_model.png results/figures/cv_score.png
	Rscript -e "rmarkdown::render('doc/wine_quality_analysis_report.Rmd')"


#####################################
# Remove all files
#####################################

clean:
	rm -f data/cleaned_winequality-red.csv
	rm -f results/figures/eda_data_balance.png results/figures/eda_all_vars.png
	rm -f results/figures/tree_model.png results/figures/cv_score.png
	rm -f doc/wine_quality_analysis_report.md
	rm -f results/cross_validation_scores.csv results/pred_summary_table.csv results/feature_importance.csv results/winequality_pred_model.pkl
