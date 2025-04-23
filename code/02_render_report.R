here::i_am("code/02_render_report.R")

library(rmarkdown)
# rendering a report in production mode
render("midterm_report.Rmd", output_file = "Midterm_Project_Report.html")