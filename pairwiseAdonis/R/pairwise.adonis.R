#'@title Pairwise multilevel comparison using adonis
#'
#'@description Use this function for multilevel pairwise comparison using adonis (~Permanova) from package 'vegan',
#'			the function returns adjusted p-values using p.adjust().
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
#'@return Table with the pairwise factors, F-values, R^2, p.value and adjusted p.value.
#'
#'@author Pedro Martinez Arbizu
#'
#'@examples
#' data(iris)
#' pairwise.adonis(iris[,1:4],iris$Species)
#'
#'#similarity euclidean from vegdist and holm correction
#' pairwise.adonis(x=iris[,1:4],factors=iris$Species,sim.function='vegdist',sim.method='euclidian',p.adjust.m='holm')
#'
#'#similarity manhattan from daisy and bonferroni correction
#' pairwise.adonis(x=iris[,1:4],factors=iris$Species,sim.function='daisy',sim.method='manhattan',p.adjust.m='bonferroni')
#'@export pairwise.adonis

pairwise.adonis <- function(x,factors, sim.function = 'vegdist', sim.method = 'bray', p.adjust.m ='bonferroni')
{
require(vegan)

co = combn(unique(as.character(factors)),2)
pairs = c()
F.Model =c()
R2 = c()
p.value = c()


for(elem in 1:ncol(co)){
if(sim.function == 'daisy'){
require(cluster); x1 = daisy(x[factors %in% c(co[1,elem],co[2,elem]),],metric=sim.method)
} else{x1 = vegdist(x[factors %in% c(co[1,elem],co[2,elem]),],method=sim.method)}

ad = adonis(x1 ~ factors[factors %in% c(co[1,elem],co[2,elem])] );
pairs = c(pairs,paste(co[1,elem],'vs',co[2,elem]));
F.Model =c(F.Model,ad$aov.tab[1,4]);
R2 = c(R2,ad$aov.tab[1,5]);
p.value = c(p.value,ad$aov.tab[1,6])
}
p.adjusted = p.adjust(p.value,method=p.adjust.m)
sig = c(rep('',length(p.adjusted)))
sig[p.adjusted <= 0.05] <-'.'
sig[p.adjusted <= 0.01] <-'*'
sig[p.adjusted <= 0.001] <-'**'
sig[p.adjusted <= 0.0001] <-'***'

pairw.res = data.frame(pairs,F.Model,R2,p.value,p.adjusted,sig)
print("Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1")
return(pairw.res)

} 


