setwd("/Users/igorwiese/Dropbox/QuasiCasual/projectsWithMetrics/Metrics/Validated")

raw_data <- sort(list.files(pattern = "csv"))

for (i in seq_along(raw_data)) {
  
  name_project = raw_data[i]
  #name_project = raw_data[2]
  name_project = gsub("\\.csv","",name_project)
  
  
  data_metrics<-read.csv2(paste(name_project,".csv",sep=""), sep=";", header=T)
  
  total_PR_WithoutCommitMerged = length(which(data_metrics$Did_CommitMerge==FALSE))
  total_PR_CommitMerged = length(which(data_metrics$Did_CommitMerge==TRUE))  
  
  data_metrics = data_metrics[which(data_metrics$Did_CommitMerge==FALSE),]
  
  median_Comments = median(data_metrics$comments)
  median_CommentsReview = median(data_metrics$coments_review)
  median_Commits = median(data_metrics$commit)
  median_Add_lines = median(data_metrics$add_lines)
  median_Delete_lines = median(data_metrics$delete_lines)
  median_Changed_files = median(data_metrics$changed_files)
  
  df = data.frame(name_project,median_Comments,median_CommentsReview,median_Commits,median_Add_lines,median_Delete_lines,median_Changed_files)
  colnames(df) <- c("Project", "Mdn Comments", "Mdn Review Comments","Mdn Commits", "Mdn Added lines", "Mdn Added lines", "Mdn Changed Files")
  
  setwd("/Users/igorwiese/Dropbox/QuasiCasual/")
  write.table(df, file = "summaryUnmergedMeasures.csv", sep = ";", append = TRUE, row.names = FALSE, col.names=!file.exists("summaryUnmergedMeasures.csv"))
  
}


