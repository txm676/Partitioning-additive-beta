
source("//Source_code.R") #load in the source code file

#load in the datafiles as a list (called "incidence_matrices.R")
#the loaded object is a list of length 254, where each element is a 
#incidence (presence-absence matrix), where rows are sites and
#species are columns
load()

#create results matrix
resM <- matrix(nrow = length(ldf), ncol = 18)
rownames(resM) <- c(fileNames, fileNames2)
colnames(resM) <-   c("BTotal", "BNes", "BRpl", 
                      "BMult", "BSor", "BSIM", "BNesBaselga", "NODF_Overall", 
                      "NODF_Rows", "NODF_Cols", "BSA", "BSJ", "Bjac", "JacSim",
                      "JacNes", "CarvTot", "CarvRplc", "CarvRich")

#run the main function across all datasets
for (i in 1:length(ldf)){
  resM[i] <- betD(ldf[[i]])
}

resM <- as.data.frame(resM)

#add column with island category
resM$Type <- c(rep("True", length(ldf1)), rep("Habitat", length(ldf2)))

##Kendall correlation
cor.test(resM$BNes, resM$BNesBaselga, method = "kendall")
cor.test(resM$BNes, resM$NODF_Overall, method = "kendall")
cor.test(resM$BRpl, resM$BSor, method = "kendall")
cor.test(resM$BRpl, resM$BSIM, method = "kendall")

cor.test(resM$BSJ, resM$BSor, method = "kendall")#this is the standardised metric we use in the paper


##need to log-transform the partition variables for presentation
resM[, c(1:4, 6)] <- apply(resM[, c(1:4, 6)], 2, function(x) log(x + 0.1))

#correlation text
t1 <- "Kendall’s tau = -0.11"
t2 <- "Kendall’s tau = 0.43"
t3 <- "Kendall’s tau = 0.59"

g1 <- ggplot(data=resM,aes(x=resM$BNes,y=resM$NODF_Overall))+ geom_point() +
  xlab(expression("Log("*beta[Nestedness]*")")) + ylab("NODF") + theme_bw()+ggtitle("a)")+
  annotate("text", label = t1, x = 4.5, y = 6.5, size = 5, colour = "black") +
  theme(axis.title = element_text(size = 14), axis.text = element_text(size =12), 
        plot.title = element_text(size = 16)) 

g1b <- ggplot(data=resM,aes(x=resM$BRpl,y=resM$BSIM))+ geom_point()+
  xlab(expression("Log("*beta[Replacement]*")")) +ylab(expression("Log("*beta[Sim]*")"))+ 
  theme_bw() +ggtitle("b)") +
  annotate("text", label = t2, x = 4.5, y = 0.03, size = 5, colour = "black")+
  theme(axis.title = element_text(size = 14), axis.text = element_text(size =12), 
        plot.title = element_text(size = 16))

g2 <- ggplot(data=resM,aes(x=resM$BSJ,y=BSor))+ geom_point()+
  xlab(expression("Log("*beta[Stan]*")")) +ylab(expression("Log("*beta[Sor]*")"))+ 
  theme_bw()+ggtitle("c)") +
  annotate("text", label = t3, x = 0.8, y = 0.35, size = 5, colour = "black")+
  theme(axis.title = element_text(size = 14), axis.text = element_text(size =12), 
        plot.title = element_text(size = 16))


jpeg("empirical_analyses.jpeg", width = 13, height = 39, units = "cm", res = 600)
grid.arrange(g1,g1b, g2, ncol = 1)

dev.off()



