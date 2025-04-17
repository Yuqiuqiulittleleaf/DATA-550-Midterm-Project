.NOTPARALLEL:

install:
	Rscript -e 'renv::restore()'

Midterm_Project_Report.html: midterm_report.Rmd code/02_render_report.R
	Rscript code/table/00_clean_data.R
	Rscript code/table/01_make_tables.R
	Rscript code/figure/00_clean_data.R
	Rscript code/figure/01_boxplot.R
	Rscript code/figure/02_dotplot.R

.PHONY: clean
clean:
	rm -f data/*.rds output/figure/*.png && rm -f Midterm_Project_Report.html