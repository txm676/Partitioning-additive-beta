library(dplyr)
library(betapart)
library(ggplot2)
library(gridExtra)
library(vegan)
library(BAT)
library(GGally)

###############################################
#####Main Diversity Partitioning Function##############
################################################

betD <- function(dat){
  gam <- ncol(dat)
  N <- nrow(dat)
  sp <- rowSums(dat)
  
  ##alpha div
  alp <- mean(sp)
  
  ##multiplicative beta
  BW <- gam / alp
  
  ##overall additive beta div
  betA <- gam - alp
  
  #Chao standardisation
  betAJ <- betA / ((1 - (1/N)) * gam) 
  betAS <- betA / ((N - 1) * alp) 
  
  ###nestedness component
  maxS <- max(sp)
  dum <- vapply(sp, function(x) maxS - x, numeric(1))
  bnst <- (sum(dum))/length(sp)
  
  ###check
  che <- maxS - alp
  if(round(che,0)!=round(bnst,0)) stop("All wrong: bnest methods don't match", "\n")
  
  ##replacment component
  brpl <- betA - bnst
  res <- c(round(betA,2),round(bnst,2),round(brpl,2))
  
  ##run beta function in betapart
  BD <- unlist(betapart::beta.multi(dat, index.family="sorensen")) #first is turn, 2nd is nest, 3rd is overall
  BDJ <- unlist(betapart::beta.multi(dat, index.family="jaccard")) #first is turn, 2nd is nest, 3rd is overall
  
  #use Carvalho method
  BCAR <-  unlist(BAT::beta.multi(dat)[,1])#first is total, second replacement, third richness
  
  #get NODF
  ND <- unlist(vegan::nestednodf(dat)$statistic) #first is by cols, second by rows, third is overall
  
  ov_res <- round(c("BTotal" = res[1], "BNes" = res[2], "BRpl" = res[3],
                    "BMult" = BW, "BSor" = BD[3], "BSIM" = BD[1], "BNes[Baselga]" = BD[2], "NODF_Overall" = ND[3], 
                    "NODF_Rows" = ND[2], "NODF_Cols" = ND[1], "BSA" = betAS, "BSJ" = betAJ, "Bjac" = BDJ[3], "JacSim" = BDJ[1],
                    "JacNes" = BDJ[2], "CarvTot" = BCAR[1], "CarvRplc" = BCAR[2], "CarvRich" = BCAR[3]), 2)
  return(ov_res)
}#eo function





##############################################################
#############Function run betD across all datasets#############
#############and return the results and Correlations###########
##############################################################

##returns a list: first element is results matrix with beta values,
##second element is the correlation table (tau and P value)

get_beta <- function(ldf, rn = NULL, cor_method = "kendall"){
  
  resM <- matrix(nrow = length(ldf), ncol = 18)
  
  rownames(resM) <- rn
  
  
  colnames(resM) <-   c("BTotal", "BNes", "BRpl", 
                        "BMult", "BSor", "BSIM", "BNesBaselga", "NODF_Overall", 
                        "NODF_Rows", "NODF_Cols", "BSA", "BSJ", "Bjac", "JacSim",
                        "JacNes", "CarvTot", "CarvRplc", "CarvRich")
  
  for (i in 1:length(ldf)){
    resM[i, 1:18] <- betD(ldf[[i]])
  }
  
  resM <- as.data.frame(resM)
  
  ##look at correlations
  c1 <- cor.test(resM$BNes, resM$BNesBaselga, method = cor_method)
  c2 <- cor.test(resM$BNes, resM$NODF_Overall, method = cor_method)
  c3 <- cor.test(resM$BRpl, resM$BSor, method = cor_method)
  c4 <- cor.test(resM$BRpl, resM$BSIM, method = cor_method)
  c5 <- cor.test(resM$BSJ, resM$BSor, method = cor_method)#this is the standardised one we use in the paper
  cAll <- list(c1, c2, c3, c4, c5)
  
  rv <- vapply(cAll, function(x) c(x$estimate, x$p.value), FUN.VALUE = numeric(2))
  resAll <- list(resM, rv)
  return(resAll)
}
