library(dplyr)
library(betapart)
library(ggplot2)
library(gridExtra)
library(vegan)
library(BAT)

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
  betAJ <- betA / ((1 - (1/N)) * gam) #jaccard
  betAS <- betA / ((N - 1) * alp) #sorensen
  
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
  BD <- unlist(betapart::beta.multi(dat3, index.family="sorensen")) #first is turn, 2nd is nest, 3rd is overall
  BDJ <- unlist(betapart::beta.multi(dat3, index.family="jaccard")) #first is turn, 2nd is nest, 3rd is overall
  
  #use Carvalho method
  BCAR <-  unlist(BAT::beta.multi(dat3)[,1])#first is total, second replacement, third richness
  
  #get NODF
  ND <- unlist(vegan::nestednodf(dat3)$statistic) #first is by cols, second by rows, third is overall
  
  ov_res <- round(c("BTotal" = res[1], "BNes" = res[2], "BRpl" = res[3],
                    "BMult" = BW, "BSor" = BD[3], "BSIM" = BD[1], "BNes[Baselga]" = BD[2], "NODF_Overall" = ND[3], 
                    "NODF_Rows" = ND[2], "NODF_Cols" = ND[1], "BSA" = betAS, "BSJ" = betAJ, "Bjac" = BDJ[3], "JacSim" = BDJ[1],
                    "JacNes" = BDJ[2], "CarvTot" = BCAR[1], "CarvRplc" = BCAR[2], "CarvRich" = BCAR[3]), 2)
  return(ov_res)
}#eo function

