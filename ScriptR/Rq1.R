library(plyr)

setwd("/Users/igorwiese/Dropbox/QuasiCasual")

project_name = c("angular-js","bitcoin","bootstrap","caffe","d3","django","docker","flask","jenkins","joomla","jquery","laravel",
                 "mongo","opencv","rails","react","redis","scikit-learn","spring-framework","tensorflow","kubernetes")


for(index in 1:length(project_name)){
  
  metrics<-read.csv2(paste(project_name[index],"Metrics.csv", sep=""), sep=";", header=TRUE)
  
  data_metrics = metrics[which(metrics$Did_CommitMerge==FALSE),]
  results = count(data_metrics, "user")
  
  results = cbind(results,project_name[index])
  results = as.data.frame(results)
  
  write.table(results, file = "summaryRq1FrequencyByUser.csv", sep = ";", append = TRUE, col.names = FALSE, row.names = FALSE)
  
}

summaryRQ1<-read.csv2("summaryRq1FrequencyByUser.csv", sep=";", header=FALSE)

project_name = c("angular-js","bitcoin","bootstrap","caffe","d3","django","docker","flask","jenkins","joomla","jquery","laravel",
                 "mongo","opencv","rails","react","redis","scikit-learn","spring-framework","tensorflow","kubernetes")

for(index in 1:length(project_name)){
  
  project=summaryRQ1[which(summaryRQ1$V3==project_name[index]),]
  distinct_users = length(unique(project$V1))
  df = data.frame(project_name[index],distinct_users)
  write.table(df, file = "summaryRq1FrequencyByProject.csv", sep = ";", append = TRUE, row.names = FALSE)
  
}



