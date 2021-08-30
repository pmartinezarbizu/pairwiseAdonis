# pairwiseAdonis
# version 0.4 includes 2 functions
pairwise.adonis

pairwise.adonis2

# pairwise.adonis
This is a wrapper function for multilevel pairwise comparison using adonis2 (~Permanova) from package 'vegan'. The function returns adjusted p-values using p.adjust(). It does not accept interaction between factors neither strata.

# pairwise.adonis2
This function accepts strata

NOTE: This is still a developing version -- Please validate your results.
I would appreciate feed back.

update 28 April 2020:
Function now adapts the permutation matrix for each combination of factors before applying adonis.
The p-value when using strata (block) looks correct now. Check syntax in example below.

This function accepts a model formula like in adonis from vegan. You can use interactions between factors and define strata to constrain permutations. For pairwise comparison a list of unique pairwise combination of factors is produced. Then for each pair, following objects are reduced accordingly to include only the subset of cases belonging to the pair:

- the left hand side of the formula (dissimilarity matrix or community matrix)

- the right hand side of the formula (factors)

- the strata if used.

The reduced data are passed to adonis and the summary of the anova table for each pair is saved in a list, together with the anova table of the full model and the original 'parent call'.

update 30.08.21
Both functions now use adonis2 instead of adonis. This will solve some problems when loading Desctools. The functions should now work with Phyloseq objects.

Thanks to @lkoest12 for raising this and @JFMSilva for the solution 
https://github.com/joey711/phyloseq/issues/1457#issuecomment-880093708


_________________________________________________________________________________________________

## INSTALLATION
### For linux

Note: I have experience myself an Error when installing from github.

Error converted from warning ... (https://github.com/r-lib/remotes/issues/403)
To avoid this, load devtools and type first in your R session:

```Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS"=TRUE)```

.... follow below

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

# For strata (blocks), following example of Jari Oksanen in adonis2. 
dat <- expand.grid(rep=gl(2,1), NO3=factor(c(0,10,30)),field=gl(3,1) )
Agropyron <- with(dat, as.numeric(field) + as.numeric(NO3)+2) +rnorm(18)/2
Schizachyrium <- with(dat, as.numeric(field) - as.numeric(NO3)+2) +rnorm(18)/2
Y <- data.frame(Agropyron, Schizachyrium)

pairwise.adonis2(Y ~ NO3/field, data = dat, strata = 'field')
```

for more examples see also
```?pairwise.adonis()```
```?pairwise.adonis2()```
_____________________________________________
## Citation

Martinez Arbizu, P. (2020). pairwiseAdonis: Pairwise multilevel comparison using adonis. R package version 0.4
