# Makefile
# Authors: Jingyun Chen, Anthony Chiodo
# Date: November 30, 2018
# Purpose: This script creates an entire data analysis pipeline for our red wine quality prediction project


#####################################
# Run all scripts
#####################################

# run make all using `Make` only, which won't generate a dependency diagram 
all_local: doc/wine_quality_analysis_report.md
	rm -f Rplots.pdf doc/wine_quality_analysis_report.html results/figures/tree_model

# run make all using `Docker`, which will generate a dependency diagram 
all: doc/wine_quality_analysis_report.md Makefile.png
	rm -f Rplots.pdf doc/wine_quality_analysis_report.html results/figures/tree_model Makefile.dot


#####################################
# Run Scripts
#####################################

DATASET = https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv
MODEL = results/cross_validation_scores.csv results/winequality_pred_model.joblib
PREDICTIONS = results/pred_summary_table.csv results/feature_importance.csv
RESULTS = results/figures/tree_model.png results/figures/cv_score.png

# step 1. run 01_wine_data_clean.R script: clean data set
WinesDB.db: src/01_wine_data_clean.R
	Rscript src/01_wine_data_clean.R $(DATASET) WinesDB.db

# step 2. run 02_wine_data_viz.R script: wine data visualization
results/figures/eda_data_balance.png: src/02_wine_data_viz.R WinesDB.db
	Rscript $^ results/figures

# step 3. run 03_wine_quality_pred.py script: wine quality prediction and save results
$(PREDICTIONS) $(MODEL): src/03_wine_quality_pred.py WinesDB.db
	python3 $^ results/

# step 4. run 04_plot_tree_model.py script: cross-validation score and decision tree model visualization
$(RESULTS): src/04_plot_tree_model.py $(MODEL)
	python3 src/04_plot_tree_model.py results/ results/figures/

# step 5. knit the final report
doc/wine_quality_analysis_report.md: doc/wine_quality_analysis_report.Rmd \
									 results/figures/eda_data_balance.png \
									 results/figures/tree_model.png \
									 results/figures/cv_score.png \
									 $(PREDICTIONS)
	Rscript -e "rmarkdown::render('doc/wine_quality_analysis_report.Rmd')"

# step 6. generate dependency diagram (Note: The diagram will not be generated using Make)
Makefile.png: Makefile
	makefile2graph > Makefile.dot
	dot -Tpng Makefile.dot -o Makefile.png


#####################################
# Remove all files
#####################################

clean:
	rm -f results/figures/*.png
	rm -f results/*.csv
	rm -f doc/wine_quality_analysis_report.md
	rm -f results/winequality_pred_model.joblib
	rm -f Makefile.png
