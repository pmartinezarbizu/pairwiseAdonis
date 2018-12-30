# pairwiseAdonis
# version V0.3 include 2 functions
pairwise.adonis

pairwise.adonis2

# pairwise.adonis
This is a wrapper function for multilevel pairwise comparison using adonis (~Permanova) from package 'vegan'.
			The function returns adjusted p-values using p.adjust(). It does not accept interaction between factors neither strata.

# pairwise.adonis2
This function accept a model formula like in adonis from vegan. You can use interaction between factors and also strata. For pairwise comparison,a list of unique pairwise combination of factors is produced, then for each pairwise combination following objects are reduced accordingly to include only cases of the pair:

- the left hand side of the formula (dissimilarity matrix or community matrix)

- the right hand side of the formula (factors)

- the strata if used.

The reduced data are passed to adonis and the summary of the anova table for each pair is saved in a list.


_________________________________________________________________________________________________

## Download

My recommendation is to install directly from github 

You can also download the folder pairwiseAdonis and build from scratch if you experience problems with R versions

## INSTALLATION
### For linux

make sure you have ```devtools``` installed and loaded, for windows also install ```Rtools```

In your R session

```install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")```

That's it

Or...

### For windows
first install Rtools from here https://cran.r-project.org/bin/windows/Rtools/

in R install devtools

```install.packages('devtools')```

load devtools

```library(devtools)```

In your R session

```install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")```

____________________________________
## Usage
```
library(pairwiseAdonis)
data(iris)
pairwise.adonis(iris[,1:4],iris$Species)
```

for more examples see also
```?pairwise.adonis()```
_____________________________________________
## Citation

Martinez Arbizu, P. (2019). pairwiseAdonis: Pairwise multilevel comparison using adonis. R package version 0.3
