# Shamem
data analysis for project Shamem

# ana_001.m
This script reads and cleans the data in the csv files provided by the shamem framework

path_in  = "raw_data"<br />
path_out = "data_ana001"

# ana_002.m
This script averages experiment data per subcategory and saves result as a table.
Output files serve as input data for the ANOVAs and chi-squared test in SPSS

path_in  = "data_ana001"<br />
path_out = "data_ana002"

# ana_003.m
This script averages over each type (criminal, spy, neutral) 

path_in  = "data_ana002"<br />
path_out = "data_ana003"


# plot_results.m
This script plots the mean values of measured variables for encoding, retrieval and secret job task
