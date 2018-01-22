library(effsize)

project_name = c("angular-js","bitcoin","bootstrap","caffe","d3","django","docker","flask","jenkins","joomla","jquery","laravel",
                 "mongo","opencv","rails","react","redis","scikit-learn","spring-framework","tensorflow","kubernetes")

for(i in 1:length(project_name)){
  
  setwd("/Users/igorwiese/Dropbox/QuasiCasual/Accepted_PRs")
  mergedPR<-read.csv2(paste(project_name[i],"StatisticsByPR.csv", sep=""), sep=";", header=FALSE)
  
  setwd("/Users/igorwiese/Dropbox/QuasiCasual/projectsWithMetrics/Metrics/Validated/")
  unmergedPR<-read.csv2(paste(project_name[i],"Metrics.csv", sep=""), sep=";", header=TRUE)
  
  name_project = project_name[i]
  
  #filtering those with unmergedPRs
  unmergedPR = unmergedPR[which(unmergedPR$Did_CommitMerge==FALSE),]
  
  comments_wilcoxon = wilcox.test(mergedPR$V4, unmergedPR$comments)
  comments_effect = res = cliff.delta(mergedPR$V4, unmergedPR$comments,return.dm=TRUE)
  comments_wilcoxon$p.value
  comments_effect$estimate
  comments_effect$magnitude
  
  comments_review_wilcoxon = wilcox.test(mergedPR$V5, unmergedPR$coments_review)
  comments_review_effect = cliff.delta(mergedPR$V5, unmergedPR$coments_review, return.dm=TRUE)
  comments_review_wilcoxon$p.value
  comments_review_effect$estimate
  comments_review_effect$magnitude
  
  commit_wilcoxon = wilcox.test(mergedPR$V6, unmergedPR$commit)
  commit_effect = res = cliff.delta(mergedPR$V6, unmergedPR$commit,return.dm=TRUE)
  commit_wilcoxon$p.value
  commit_effect$estimate
  commit_effect$magnitude
  
  changed_files_wilcoxon = wilcox.test(mergedPR$V7, unmergedPR$changed_files)
  changed_files_effect = res = cliff.delta(mergedPR$V7, unmergedPR$changed_files,return.dm=TRUE)
  changed_files_wilcoxon$p.value
  changed_files_effect$estimate
  changed_files_effect$magnitude
  
  add_lines_wilcoxon = wilcox.test(mergedPR$V8, unmergedPR$add_lines)
  add_lines_effect = res = cliff.delta(mergedPR$V8, unmergedPR$add_lines,return.dm=TRUE)
  add_lines_wilcoxon$p.value
  add_lines_effect$estimate
  add_lines_effect$magnitude
  
  delete_lines_wilcoxon = wilcox.test(mergedPR$V9, unmergedPR$delete_lines)
  delete_lines_effect = res = cliff.delta(mergedPR$V9, unmergedPR$delete_lines,return.dm=TRUE)
  delete_lines_wilcoxon$p.value
  delete_lines_effect$estimate
  delete_lines_effect$magnitude
  
  #df = data.frame(name_project,comments_wilcoxon$p.value,comments_effect$estimate,comments_effect$magnitude,comments_review_wilcoxon$p.value,comments_review_effect$estimate,comments_review_effect$magnitude,commit_wilcoxon$p.value,commit_effect$estimate,commit_effect$magnitude,changed_files_wilcoxon$p.value,changed_files_effect$estimate,changed_files_effect$magnitude,add_lines_wilcoxon$p.value,add_lines_effect$estimate,add_lines_effect$magnitude,delete_lines_wilcoxon$p.value,delete_lines_effect$estimate,delete_lines_effect$magnitude)
  #colnames(df) <- c("Project", "Comments PValue", "Comments Cliffs","Comments Magnitude","Comments_Review PValue", "Comments_Review Cliffs","Comments_Review Magnitude","Commits PValue", "Commits Cliffs","Commits Magnitude","changed_files PValue", "changed_files Cliffs","changed_files Magnitude","add_lines PValue","add_lines Cliffs","add_lines Magnitude","delete_lines PValue","delete_lines Cliffs","delete_lines Magnitude")

  df2 = data.frame(name_project,round(mean(mergedPR$V4),2), round(mean(unmergedPR$comments),2), round(mean(mergedPR$V5),2), round(mean(unmergedPR$coments_review),2), round(mean(mergedPR$V6),2), round(mean(unmergedPR$commit),2), round(mean(mergedPR$V7),2), round(mean(unmergedPR$changed_files),2), round(mean(mergedPR$V8),2), round(mean(unmergedPR$add_lines),2), round(mean(mergedPR$V9),2), round(mean(unmergedPR$delete_lines),2))
  colnames(df2) <- c("Project", "Comments Merged", "Comments unMerged","Comments Review Merged","Comments Review unMerged", "Commits Merged","Commits UnMerged","ChangedFiles Merged", "ChangedFiles UnMerged","AddedLines Merged","AddedLines UnMerged", "DeletedLines Merged","DeletedLines UnMerged")
 
  #setwd("/Users/igorwiese/Dropbox/QuasiCasual/")
  write.table(df, file = "EffectSizeMeasuresBKP.csv", sep = ";", append = TRUE, row.names = FALSE, col.names=!file.exists("EffectSizeMeasures.csv"))
  write.table(df2, file = "MetricsByProject.csv", sep = ";", append = TRUE, row.names = FALSE, col.names=!file.exists("MetricsByProject.csv"))
}  

#library(beanplot)
#beanplot(MetricsbyProjects ~ PR_Type, names=c("PR Types"), ll = 0.04, data = Violin_Merged, main = "", ylab = "# of Users", side = "both",  border = NA, col = list("black", c("grey", "white")))
#legend(cex = 0.9, "bottomleft", fill = c("black", "grey"), legend = c("no merged", "Unmerged"))

