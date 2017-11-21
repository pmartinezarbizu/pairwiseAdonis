#'@title Pairwise multilevel comparison using adonis
#'
#'@description This is a wrapper function for multilevel pairwise comparison
#' using adonis() from package 'vegan'. The function returns adjusted p-values using p.adjust().
#'
#'@param x Data frame (the community table).
#'
#'@param factors Vector (a column or vector with the levels to be compared pairwise).
#'
#'@param sim.function Function used to calculate the similarity matrix,
#' one of 'daisy' or 'vegdist' default is 'vegdist'.
#'
#'@param sim.method Similarity method from daisy or vegdist, default is 'bray'. 
#'
#'@param p.adjust.m The p.value correction method, one of the methods supported by p.adjust(),
#' default is 'bonferroni'.
#'
#'#'@param reduce String. Restrict comparison to pairs including these factors. If more than one factor, separate by pipes like  reduce = 'setosa|versicolor'
#'
#'@return Table with the pairwise factors, F-values, R^2, p.value and adjusted p.value.
#'
#'@author Pedro Martinez Arbizu
#'
#'@examples
#' data(iris)
#' pairwise.adonis(iris[,1:4],iris$Species)
#'
#'#similarity euclidean from vegdist and holm correction
#' pairwise.adonis(x=iris[,1:4],factors=iris$Species,sim.function='vegdist',
#' sim.method='euclidian',p.adjust.m='holm')
#'
#'#similarity manhattan from daisy and bonferroni correction
#' pairwise.adonis(x=iris[,1:4],factors=iris$Species,sim.function='daisy',
#' sim.method='manhattan',p.adjust.m='bonferroni')
#'@export pairwise.adonis
#'@importFrom stats p.adjust
#'@importFrom utils combn
#'@importFrom vegan adonis vegdist
#'@importFrom cluster daisy



pairwise.adonis <- function(x,factors, sim.function = 'vegdist', sim.method = 'bray', p.adjust.m ='bonferroni',reduce=NULL)
{

co <- combn(unique(as.character(factors)),2)
pairs <- c()
F.Model <- c()
R2 <- c()
p.value <- c()


for(elem in 1:ncol(co)){
if(sim.function == 'daisy'){
x1 = daisy(x[factors %in% c(co[1,elem],co[2,elem]),],metric=sim.method)
} else{x1 = vegdist(x[factors %in% c(co[1,elem],co[2,elem]),],method=sim.method)}

ad <- adonis(x1 ~ factors[factors %in% c(co[1,elem],co[2,elem])] );
pairs <- c(pairs,paste(co[1,elem],'vs',co[2,elem]));
F.Model <- c(F.Model,ad$aov.tab[1,4]);
R2 <- c(R2,ad$aov.tab[1,5]);
p.value <- c(p.value,ad$aov.tab[1,6])
}
p.adjusted <- p.adjust(p.value,method=p.adjust.m)

sig = c(rep('',length(p.adjusted)))
sig[p.adjusted <= 0.05] <-'.'
sig[p.adjusted <= 0.01] <-'*'
sig[p.adjusted <= 0.001] <-'**'
sig[p.adjusted <= 0.0001] <-'***'
pairw.res <- data.frame(pairs,F.Model,R2,p.value,p.adjusted,sig)

if(!is.null(reduce)){
pairw.res <- subset (pairw.res, grepl(reduce,pairs))
pairw.res$p.adjusted <- p.adjust(pairw.res$p.value,method=p.adjust.m)

sig = c(rep('',length(pairw.res$p.adjusted)))
sig[pairw.res$p.adjusted <= 0.05] <-'.'
sig[pairw.res$p.adjusted <= 0.01] <-'*'
sig[pairw.res$p.adjusted <= 0.001] <-'**'
sig[pairw.res$p.adjusted <= 0.0001] <-'***'
pairw.res <- data.frame(pairw.res[,1:5],sig)
}
class(pairw.res) <- c("pwadonis", "data.frame")
return(pairw.res)
} 


### Method summary
summary.pwadonis = function(object, ...) {
    cat("Result of pairwise.adonis:\n")
    cat("\n")
    print(object, ...)
    cat("\n")
	cat("Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1\n")
    }
## end of method summary



