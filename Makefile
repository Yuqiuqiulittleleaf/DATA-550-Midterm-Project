.NOTPARALLEL:

Midterm_Project_Report.html: midterm_report.Rmd code/02_render_report.R
	Rscript code/table/00_clean_data.R
	Rscript code/table/01_make_tables.R

.PHONY: clean
clean:
	rm -f output/*.rds && rm -f Midterm_Project_Report.html