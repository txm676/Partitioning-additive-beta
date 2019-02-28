# Partitioning-additive-beta
Data and code accompanying the paper: Can additive beta-diversity be reliably partitioned into nestedness and turnover components? (In Review)

The R scripts can be used to run the analyses in the paper. The data are available in the data folder and comprise the 254 island incidence (presence-absence) matrices used in the paper. Here, rows are sites and columns are species. The matrices are available as csv files (in the zip file) or as an R object (matrices stored in a list called 'ldf').

The script makes use of the ggpairs function from the GGally R package. However, we were unable to get this function to compute Kendall's correlation (it seems to only calculate Pearson's, at least at this time). We forked the GGally package and edited the function to do this. Thus, to directly reproduce Fig.S1 in the appendix of the paper it is necessary to download the forked version of GGally from my GitHub. 
