setwd("/Users/igorwiese/Dropbox/QuasiCasual")

MetricsbyProjects<-read.csv2("summaryMeasures.csv", sep=";", header=T)
UsersWithClosedIssues<-read.csv2("UsersWithClosedIssues.csv", sep=";", header=T)
Violin_Merged<-read.csv2("ViolioData_no_merged_un_merged.csv", sep=";", header=T)

library(beanplot)
beanplot(MetricsbyProjects ~ PR_Type, names=c("PR Types"), ll = 0.04, data = Violin_Merged, main = "", ylab = "# of Users", side = "both",  border = NA, col = list("black", c("grey", "white")))
legend(cex = 0.9, "bottomleft", fill = c("black", "grey"), legend = c("no merged", "Unmerged"))



