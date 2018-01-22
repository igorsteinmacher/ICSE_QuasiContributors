#project_name = "kubernetes"
#angular-js,bitcoin,bootstrap,caffe,d3,django,docker,flask,jenkins,joomla,jquery,laravel,mongo,opencv
#rails,react,redis,scikit-learn,spring-framework,tensorflow,kubernetes

project_name = c("angular-js","bitcoin","bootstrap","caffe","d3","django","docker","flask","jenkins","joomla","jquery","laravel",
                 "mongo","opencv","rails","react","redis","scikit-learn","spring-framework","tensorflow","kubernetes")
for(index in 1:length(project_name)){
  nome<-project_name[index]
  
  setwd("Users/igorwiese/Dropbox/QuasiCasual/AcceptedCommits")
  temCommitUnico<-read.csv2(paste(nome,"_unicos.csv", sep=""), sep=";", header=F)

  setwd("Users/igorwiese/Dropbox/QuasiCasual/AcceptedCommits/old")
  temCommitUnico2<-read.csv2(paste(project_name[index],"_temCommit_unico.csv", sep=""), sep=";", header=F)

  temCommit<-rbind(temCommitUnico, temCommitUnico2)

  setwd("Users/igorwiese/Dropbox/QuasiCasual/projectsWithMetrics/Metrics")
  metrics<-read.csv2(paste(project_name[index],"Metrics.csv", sep=""), sep=";", header=TRUE)

  nRowsDf <- nrow(metrics)

  for(i in 1:nRowsDf){
    Did_CommitMerge = metrics$user %in% temCommit$V1
  }
  metrics = cbind(metrics,Did_CommitMerge)

  print(length(which(Did_CommitMerge==TRUE)))
  setwd("Users/igorwiese/Dropbox/QuasiCasual/projectsWithMetrics/Metrics/Validated")
  write.table(metrics, file = paste(project_name[index],"Metrics.csv", sep=""), sep = ";", row.names=FALSE, col.names=TRUE)

}