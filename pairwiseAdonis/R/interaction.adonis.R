interaction.adonis <- function(x, factor_A, factor_B,
                               sim.function = "vegdist",
                               sim.method = "bray",
                               p.adjust.m = "none",
                               perm = 999) {
  
  AD.factor_A <- NULL
  for(f in levels(factor_A)) {
    if (inherits(x, "dist")) {
      S1 <- as.matrix(x)
      S1 <- S1[factor_A == f, factor_A == f]
      S1 <- as.dist(S1)
    } else {
      S1 <- x[factor_A == f, ]
    }
    B1 <- factor_B[factor_A == f]
    AD.factor_A[[f]] <- pairwise.adonis(S1, B1, sim.function, sim.method, p.adjust.m, reduce = NULL, perm)
  }
  
  AD.factor_B <- NULL
  for(i in levels(factor_B)) {
    if (inherits(x, "dist")) {
      S1 <- as.matrix(x)
      S1 <- S1[factor_B == i, factor_B == i]
      S1 <- as.dist(S1)
    } else {
      S1 <- x[factor_B == i, ]
    }
    B1 <- factor_A[factor_B == i]
    AD.factor_B[[i]] <- pairwise.adonis(S1, B1, sim.function, sim.method, p.adjust.m, reduce = NULL, perm)
  }
  
  result <- structure(list(AD.factor_A, AD.factor_B),
                      names = c(deparse(substitute(factor_A)), deparse(substitute(factor_B))))
  
  return(result)
}
