# Jingyun Chen, Anthony Chiodo - Nov, 2018


all: doc/wine_quality_analysis_report.md
	rm -f Rplots.pdf doc/wine_quality_analysis_report.html

data/cleaned_winequality-red.csv: data/winequality-red.csv src/clean_data.R
	Rscript src/clean_data.R data/winequality-red.csv data/cleaned_winequality-red.csv

results/figures/eda_data_balance.png results/figures/eda_all_vars.png: data/cleaned_winequality-red.csv src/eda.R
	Rscript src/eda.R data/cleaned_winequality-red.csv results/figures

results/cross_validation_scores.csv results/pred_summary_table.csv results/feature_importance.csv: data/cleaned_winequality-red.csv src/wine_quality_pred.py
	python src/wine_quality_pred.py data/cleaned_winequality-red.csv results/

results/figures/feature_importance.png results/figures/cv_score.png: results/feature_importance.csv results/cross_validation_scores.csv src/plot_results.R
	Rscript src/plot_results.R results results/figures

doc/wine_quality_analysis_report.md: doc/wine_quality_analysis_report.Rmd results/figures/eda_data_balance.png results/figures/eda_all_vars.png results/figures/feature_importance.png results/figures/cv_score.png
	Rscript -e "rmarkdown::render('doc/wine_quality_analysis_report.Rmd')"


clean:
	rm -f data/cleaned_winequality-red.csv
	rm -f results/figures/eda_data_balance.png results/figures/eda_all_vars.png results/figures/feature_importance.png results/figures/cv_score.png
	rm -f doc/wine_quality_analysis_report.md
	rm -f results/cross_validation_scores.csv results/pred_summary_table.csv results/feature_importance.csv