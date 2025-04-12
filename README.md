# DATA550 Midterm Project

------------------------------------------------------------------------

## Collaborative description

The leader is responsible for:

Setting the project organization structure;

Maintaining the project's config file and report parameters;

Creating and maintaining the GitHub repository for the midterm project;

Handling all merging and testing of code from team members;

Creating a report that includes all elements output from team members.

The coders are responsible for:

Summarizing tables and plots;

Submitting several pull requests to merge code into the central repository;

Documenting code and output.

## Implement description for Coders

Coders should fork and clone this repository.

Coders should store their R code to "code/code_for_plot" and "code/code_for_table". 

Code for each part should be kept in a single R file.

Code files named "00_*.R" should generate correspond rds data files by cleaning or 
filtering the "data/cdc.csv" file, and save them to "data/data_for_plot" and 
"data/data_for_table".

Code files named "01_*.R" should make tables or plots using the rds data files
and save them to "output" (For tables, there will be no need for output.)

Code files named "02_*.R" might contain additional elements that the coders would 
like to include.

PS: Coders can use different names for files as long as they are recognizable, 
and are encourage to store code for different tables or plots in seperate files.

## Implement description for Leader

The leader should display all the works from coders in "midterm_report.Rmd", and
use make command to generate all needed data/tables/plots, and render the html
report correctly. 

The leader should fetch code from coders' repositories and make sure these code
work locally, and merge all the pull requests.

## Instructions

Anyone who clone this project, should first check their installation of git lfs,
for the data used here is over 100MB. If not, try code:
brew install git-lfs
git lfs install
git lfs pull

To synchronize the project environment, use:
make install
