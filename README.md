# DATA550 Midterm Project

------------------------------------------------------------------------

# Collaborative description

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

# Implement description for Coders

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

# Implement description for Leader

The leader should display all the works from coders in "midterm_report.Rmd", and
use make command to generate all needed data/tables/plots, and render the html
report correctly. 

The leader should fetch code from coders' repositories and make sure these code
work locally, and merge all the pull requests.

# Instructions for users

## How to Download the data
If you want to clone this project to your local computer, you may first check
your installation of git lfs, because the origin data file is over 100MB.
After successfully cloning the project, the following code would be helpful to 
recover the dataset.
```bash
brew install git-lfs
git lfs install
git lfs pull
```

---
## How to generate the report

The following command should synchronize the project environment,
and generate the report. If you meet any problem, please see the next section.
```bash
make
```

---
## How to synchronize the environment

To synchronize the project environment, use:
```bash
make install
```
This command has been tested on a Mac computer, so it should work and the environment
will be built very quickly.

However, if you receive any errors that corresponds to the package "Matrix",
please try the following command:
```bash
brew install gcc
which gfortran
```

The second command will return the correct path to your Fortran compiler. Please 
copy it and use it to replace /opt/homebrew/bin/gfortran in the configuration.
```bash
cat <<EOF > ~/.R/Makevars
FC = /opt/homebrew/bin/gfortran
F77 = /opt/homebrew/bin/gfortran
FLIBS = -L/opt/homebrew/opt/gcc/lib/gcc/\$(/opt/homebrew/bin/gfortran -dumpversion | cut -d. -f1) -lgfortran -lquadmath -lm
EOF
```

Then, try to rerun make install.

If it's still not working, which might happen sometimes, please directly run the 
following command in your console and terminal.
I strongly recommend you run as administrator at this point.
```console
renv::restore()
```
```bash
make Midterm_Project_Report.html
```


There is an alternative dataset provided in data/cdc_data2021_no_january.csv,
which can be used to test the reproducibility. Generating ways see code/03_alternative_data.R.

