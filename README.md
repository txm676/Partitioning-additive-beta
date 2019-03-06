# Partitioning-additive-beta

[![DOI](https://zenodo.org/badge/167363516.svg)](https://zenodo.org/badge/latestdoi/167363516)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Data and code accompanying the paper: Can additive beta-diversity be reliably partitioned into nestedness and turnover components? (In Review)

The R scripts can be used to run the analyses in the paper. The data are available in the data folder and comprise the 254 island incidence (presence-absence) matrices used in the paper. Here, rows are sites and columns are species. The matrices are available as csv files (in the zip file) or as an RData object (matrices stored in a list called 'ldf'). The references of the source papers are provided in a csv file titled "Incidence_matrices.csv". The datasets were sourced from the literature, including source papers and other databases (e.g. the Nestedness calculator). The full database with additional meta-data
will be published shortly.

The script makes use of the ggpairs function from the GGally R package. However, we were unable to get this function to compute Kendall's correlation (it seems to only calculate Pearson's, at least at this time). We forked the GGally package and edited the function to do this. Thus, to directly reproduce Fig.S1 in the appendix of the paper it is necessary to download the forked version of GGally from my GitHub. 

The GitHub repository has been archived on the Zenodo research data repository (DOI: 10.5281/zenodo.2580168).
