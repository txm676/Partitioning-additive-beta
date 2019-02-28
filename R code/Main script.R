
source("//Source_code.R") #load in the source code file

#load in the datafiles as a list (called "incidence_matrices.R")
#the loaded object is a list of length 254, where each element is a 
#incidence (presence-absence matrix), where rows are sites and
#species are columns
load()

##run main function for all datasets
resAll <- get_beta(ldf, rn = c(fileNames, fileNames2), cor_method = "kendall")
resM <- resAll[[1]] 
resC <- resAll[[2]] %>% round(2) ##correlation results

##need to log-transform the partition variables for presentation
resM[, c(1:4)] <- apply(resM[, c(1:4)], 2, function(x) log(x + 0.1))

#correlation text
t1 <- "Kendall’s tau = -0.11"
t2 <- "Kendall’s tau = 0.43"
t3 <- "Kendall’s tau = 0.56"


##Make Figure 2 in the papers
g1 <- ggplot(data=resM,aes(x=resM$BNes,y=resM$NODF_Overall))+ geom_point() +
  xlab(expression("Log("*beta[Nestedness]*")")) + ylab("NODF") + theme_bw()+ggtitle("a)")+
  annotate("text", label = t1, x = 4.5, y = 6.5, size = 5, colour = "black") +
  theme(axis.title = element_text(size = 14), axis.text = element_text(size =12), 
        plot.title = element_text(size = 16)) 

g1b <- ggplot(data=resM,aes(x=resM$BRpl,y=resM$BSIM))+ geom_point()+
  xlab(expression("Log("*beta[Replacement]*")")) +ylab(expression(""*beta[Sim]*""))+ 
  theme_bw() +ggtitle("b)") +
  annotate("text", label = t2, x = 4.5, y = 0.03, size = 5, colour = "black")+
  theme(axis.title = element_text(size = 14), axis.text = element_text(size =12), 
        plot.title = element_text(size = 16))

g2 <- ggplot(data=resM,aes(x=resM$BSJ,y=BSor))+ geom_point()+
  xlab(expression(""*beta[Stan]*"")) +ylab(expression(""*beta[Sor]*""))+ 
  theme_bw()+ggtitle("c)") +
  annotate("text", label = t3, x = 0.8, y = 0.35, size = 5, colour = "black")+
  theme(axis.title = element_text(size = 14), axis.text = element_text(size =12), 
        plot.title = element_text(size = 16))


jpeg("empirical_analyses.jpeg", width = 13, height = 39, units = "cm", res = 600)
grid.arrange(g1,g1b, g2, ncol = 1)

dev.off()

###PAIR PLOTS OF ALL VARIABLES (Fig S1)#################
resM2 <- select(resM, BTotal, BNes, BRpl, BMult, BSor, BSIM, BNesBaselga,
                NODF_Overall, BSJ)

colnames(resM2) <- c(expression(""*beta[Total]*""), expression(""*beta[Nestedness]*""),
                     expression(""*beta[Replacement]*""), expression(""*beta[Mult]*""),
                     expression(""*beta[Sor]*""), expression(""*beta[Sim]*""),
                     expression(""*beta[Sne]*""), expression("NODF"),
                     expression(""*beta[Stan]*""))

##see the ReadMe file on the GitHub repo for a note about ggpairs and calculating Kendall correlations
g5 <- GGally::ggpairs(resM2, labeller = label_parsed, axisLabels="none", 
                      upper = list("cor")) +theme_bw() + theme(strip.text = element_text(size = 14))

jpeg("all_cor_plot.jpeg", units = "cm", res = 300, width = 25, height = 25)
g5
dev.off()


