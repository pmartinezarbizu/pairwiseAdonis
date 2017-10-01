# pairwiseAdonis
Pairwise multilevel comparison using adonis
Use this R function for multilevel pairwise comparison using adonis (~Permanova) from package 'vegan'.
			The function returns adjusted p-values using p.adjust().

_________________________________________________________________________________________________
# INSTALLATION

# For windows
#first install Rtools from here https://cran.r-project.org/bin/windows/Rtools/

#in R install devtools

install.packages('devtools')

#load devtools

library(devtools)

#change to directory where you saved the pairwiseAdonis file, eg here in my Documents folder

setwd("C:/Users/pmartinez/Documents")

#install source

install.packages('pairwiseAdonis_0.0.1.tar.gz', repos = NULL, type="source")

#If this doesnt work:

#open terminal <- type CMD in the start menu

#change to directory where you saved the file

cd C:\Users\pmartinez\Documents

#type:

R CMD INSTALL pairwiseAdonis_0.0.1.tar.gz

#Note that this will install it in the default repository of the default R version

#If you have different R versions installed you can specificy the version by

#specifiying the full path to R.exe to be used, like:

"C:\Program Files\R\R-3.3.1\bin\R.exe" CMD INSTALL pairwiseAdonis_0.0.1.tar.gz

# For linux
#you know what to do :-)

