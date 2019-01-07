#'@title Pairwise multilevel comparison using adonis accepting strata
#'
#'@description This is a wrapper function for multilevel pairwise comparison
#' using adonis() from package 'vegan'. The function accepts interactions between factors and strata.
#'
#'@param x Model formula. The LHS is either community matrix or dissimilarity matrix (eg. from vegdist or dist).
#' See ?adonis() for details. The RHS are factor(s) that nmust be column name(s) of a data frame specified with argument data.
#' 
#'@param data The data frame of independent variables having as column names the factors specified in formula.
#'
#'@param strata String. The name of the column with factors to be used as strata.  
#'
#'@param (...) Any other parameter passed to adonis 
#'
#'@return List. The parent call, the anova table of the full model and for each unique pairwise combination of factors the anova table.
#'
#'@author Pedro Martinez Arbizu 
#'
#'@examples
#' data(iris)
#' pairwise.adonis2(iris[,1:4]~Species,data=iris)
#'
#'# For strata, extract factors into a new data.frame
#' fac <- data.frame(Species=iris$Species,
#'		Season = rep( c('winter','summer'),75))
#'
#' pairwise.adonis2(dist(iris[,1:4])~Species/Season,data=fac,strata='Season')
#' 
#'# Note: do not define strata indexing a column e.g. strata = iris[,5]. This will raise an error.
#'# Use the name of the column as string as example above.
#'
#'@export pairwise.adonis2
#'@importFrom utils combn
#'@importFrom vegan adonis vegdist


pairwise.adonis2 <- function(x, data, strata = NULL, ... ) {

#describe parent call function 
ststri <- ifelse(is.null(strata),'Null',strata)
fostri <- as.character(x)
#list to store results

#copy model formula
   x1 <- x
# extract left hand side of formula
  lhs <- x1[[2]]
# extract factors on right hand side of formula 
  rhs <- x1[[3]]
# create model.frame matrix  
  x1[[2]] <- NULL   
  rhs.frame <- model.frame(x1, data, drop.unused.levels = TRUE) 

# create unique pairwise combination of factors 
  co <- combn(unique(as.character(rhs.frame[,1])),2)

# create names vector   
  nameres <- c('parent_call','full_model')
  for (elem in 1:ncol(co)){
  nameres <- c(nameres,paste(co[1,elem],co[2,elem],sep='_vs_'))
  }
#create results list  
  res <- vector(mode="list", length=length(nameres))
  names(res) <- nameres

#add parent call to res 
	res['parent_call'] <- list(paste(fostri[2],fostri[1],fostri[3],', strata =',ststri))

#calculate full model
	#calculate adonis 
	if(is.null(strata)){
	ad <- adonis2(x,data=data, ... )
	}else{ad <- adonis2(x,data=data, strata = data[,strata], ... )}
	
#add full model to res 
	res['full_model'] <- ad[1]

  
#start iteration trough pairwise combination of factors  
	for(elem in 1:ncol(co)){

#reduce model elements  
	if(inherits(eval(lhs),'dist')){	
	    xred <- as.dist(as.matrix(eval(lhs))[rhs.frame[,1] %in% c(co[1,elem],co[2,elem]),
		rhs.frame[,1] %in% c(co[1,elem],co[2,elem])])
	}else{
	xred <- eval(lhs)[rhs.frame[,1] %in% c(co[1,elem],co[2,elem]),]
	}
	
	mdat1 <-  data[rhs.frame[,1] %in% c(co[1,elem],co[2,elem]),] 

# redefine formula
	if(length(rhs) == 1){
		xnew <- as.formula(paste('xred',as.character(rhs),sep='~'))	
		}else{
		xnew <- as.formula(paste('xred' , 
					paste(rhs[-1],collapse= as.character(rhs[1])),
					sep='~'))}
					
#pass new formula to adonis
	if(is.null(strata)){
	ad <- adonis2(xnew,data=mdat1, ... )
	}else{ad <- adonis2(xnew,data=mdat1,strata= mdat1[,strata], ... )}
	
	res[nameres[elem+2]] <- ad[1]
	}
 
class(res) <- c("pwadstrata", "list")
return(res)
} 




