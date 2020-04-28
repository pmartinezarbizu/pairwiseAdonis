#'@title Pairwise multilevel comparison using adonis accepting strata
#'
#'@description This is a wrapper function for multilevel pairwise comparison
#' using adonis() from package 'vegan'. The function accepts interaction between factors and strata.
#'
#'@param x Model formula. The LHS is either community matrix or dissimilarity matrix (eg. from vegdist or dist)
#' See adonis() for details. The RHS are factors that nmust be column names of a data.frame specified with argument data.
#' 
#'@param data The data frame of indipendent varibles having as column names the factors specified in formula.
#'
#'@param strata String. The name of the column with factors to be used as strata.  
#'
#'@param (...) Any other parameter passed to adonis 
#'
#'@return List. Elements are the summary returned by adonis for each unique pairwise combination of factors.
#'
#'@author Pedro Martinez Arbizu 
#'
#'@examples
#' data(iris)
#' pairwise.adonis2(iris[,1:4]~Species,data=iris)
#'
#' #For strata (blocks), Jari Oksanen recommends in the help of adonis2 to define the 
#' #permutation matrix outside the adonis2 call
#' #In this example I have adapted the adonis2 example to have 3 factors in NO3
#'
#' dat <- expand.grid(rep=gl(2,1), NO3=factor(c(0,10,30)),field=gl(3,1) )
#' Agropyron <- with(dat, as.numeric(field) + as.numeric(NO3)+2) +rnorm(18)/2
#' Schizachyrium <- with(dat, as.numeric(field) - as.numeric(NO3)+2) +rnorm(18)/2
#' Y <- data.frame(Agropyron, Schizachyrium)
#' perm <- how(nperm = 199)
#' setBlocks(perm) <- with(dat, field)
#' adonis2(Y ~ NO3, data = dat, permutations = perm)
#'
#' # now the pairwise call
#' pairwise.adonis2(Y ~ NO3, data = dat, permutations = perm)
#'
#' # alternatively you can use
#' pairwise.adonis2(Y ~ NO3, data = dat, strata = dat$fields)
#'
#' #this will give same results a doing adonis2 pairwise one by one
#'
#' #for factors '0' and '10'
#' dat2 <- dat[dat$NO3 %in% c('0','10'),]
#' Y2 <- Y[dat$NO3 %in% c('0','10'),]
#' setBlocks(perm) <- with(dat2, field)
#' adonis2(Y2 ~ NO3, data = dat2, permutations = perm)
#' # and so on...
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
  nameres <- c('parent_call')
  for (elem in 1:ncol(co)){
  nameres <- c(nameres,paste(co[1,elem],co[2,elem],sep='_vs_'))
  }
#create results list  
  res <- vector(mode="list", length=length(nameres))
  names(res) <- nameres

#add parent call to res 
res['parent_call'] <- list(paste(fostri[2],fostri[1],fostri[3],', strata =',ststri))

  
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
	ad <- adonis(xnew,data=mdat1, ... )
	}else{ad <- adonis(xnew,data=mdat1,strata= mdat1[,strata], ... )}
	
  res[nameres[elem+1]] <- ad[1]
  }
  #names(res) <- names  
  class(res) <- c("pwadstrata", "list")
  return(res)
} 




