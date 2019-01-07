#'@title Pairwise multilevel comparison using adonis accepting strata
#'
#'@description This is a wrapper function for multilevel pairwise comparison
#' using adonis2() from package 'vegan'. The function accepts interactions between factors and strata.
#'
#'@param x Model formula. The LHS is either community matrix or dissimilarity matrix (eg. from vegdist or dist).
#' See ?adonis2() for details. The RHS are factor(s) that must be column name(s) of a data frame specified with argument data.
#' 
#'@param data The data frame of independent variables having as column names the factors specified in formula.
#'
#'@param strata String. The name of the column with factors to be used as strata.  
#'
#'@param (...) Any other parameter passed to adonis2 
#'
#'@return List. The parent call, the anova table of the full model and for each unique pairwise combination of factors the anova table.
#'
#'@author Pedro Martinez Arbizu 
#'
#'@examples
#' data(iris)
#' pw <- pairwise.adonis2(iris[,1:4]~Species,data=iris)
#' summary(pw)
#'
#'# For strata, extract factors into a new data.frame
#' fac <- data.frame(Species=iris$Species,
#'		Season = rep( c('winter','summer'),75))
#'
#' pw <- pairwise.adonis2(dist(iris[,1:4])~Species/Season,data=fac,strata='Season')
#' summary(pw)
#'
#'# Note: do not define strata indexing a column e.g. strata = iris[,5]. This will raise an error.
#'# Use the name of the column as string as example above.
#'
#' data(dune)
#' data(dune.env) 
#' 
## default test by terms <- example from adonis2
#' pw <- pairwise.adonis2(dune ~ Management*A1, data = dune.env)
#' summary(pw)
#'
#'@export pairwise.adonis2 summary.pwadonis2
#'@importFrom utils combn
#'@importFrom vegan adonis vegdist
#'@seealso \code{\link{adonis2}}

pairwise.adonis2 <- function(x, data, strata = NULL, ... ) {

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

#calculate full model
	#calculate adonis 
	if(is.null(strata)){
	ad.full <- adonis2(x,data=data, ... )
	}else{ad.full <- adonis2(x,data=data, strata = data[,strata], ... )}

	
# data.frame for results of pairwise comparison	
	res.pw <- data.frame()

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
	
	res.pw <- rbind(res.pw,
					data.frame(
					pairs=rep(paste(co[1,elem],co[2,elem],sep='_vs_'),length(ad[,1]))
					,ad[1:4])
					)
	}

#remove NAs
	#res.pw[is.na(res.pw)] <- " "
	res.pw[3:5] <- round(res.pw[3:5],4)
	
	#significance symbols
	sig = c(rep('',length(res.pw[,1])))
	sig[res.pw[5] <= 0.1] <-'.'
	sig[res.pw[5] <= 0.05] <-'*'
	sig[res.pw[5] <= 0.01] <-'**'
	sig[res.pw[5] <= 0.001] <-'***'
	res.pw <- cbind(res.pw,sig)
	# round values
	res.pw[3:5] <- round(res.pw[3:5],4)
	colnames(res.pw) <- c('pairs', 'Df', 'SumOfSqs','F','Pr(>F)','')
	
	res <- list(full.model=ad.full, pairwise = res.pw)
	
class(res) <- c("pwadonis2", "list")
return(res)
} 

### Method summary
summary.pwadonis2 = function(object, ...) {
    cat("Pairwise Adonis2:\n")
    cat("\n")
	cat("Results of full model:\n")
    print(object$full.model, ...)
	cat('---------------------------------------------------------------')
	cat("\n")
	cat("\n")
	cat("Results of pairwise comparison:\n")
	cat("\n")
	pw <- object$pairwise
	pw[is.na(pw)] <- ''
	le <- as.numeric(table(pw$pairs)[1])
	pa <- unique(pw$pairs)
	rn <- rownames(pw)[1:le]
	from <- seq(1,nrow(pw),le)
	to  <- from+le-1
	for(elem in 1:length(from)){
	cat(as.character(pa[elem]))
	cat("\n")
	red.pw <- pw[from[elem]:to[elem],-1]
	rownames(red.pw) <- rn
	print(red.pw)
	cat('---')
	cat("\n")
	cat("\n")
	}
	cat("Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1\n")
    cat("\n")
    cat('---------------------------------------------------------------')
	cat("\n")
    }
## end of method summary





