# pairwiseAdonis
This is an R wrapper function for multilevel pairwise comparison using adonis (~Permanova) from package 'vegan'.
			The function returns adjusted p-values using p.adjust().

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

Martinez Arbizu, P. (2017). pairwiseAdonis: Pairwise multilevel comparison using adonis. R package version 0.0.1.
