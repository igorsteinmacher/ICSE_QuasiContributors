library(RJSONIO)
library(jsonlite)
library(httr)

#go-redis/redis
#NEED TO RUN TO EACH PROJECT UNDER projectsWithMetrics

setwd("/Users/igorwiese/Dropbox/QuasiCasual/projectsWithMetrics")
projectUnMergedPR<-read.csv2("redis.csv", fill = T, sep=";", header=F)

#connecting using oauth_app
myapi = oauth_app("github","YOUR CREDENTIALS", secret="YOUR CREDENTIALS")
github_token = oauth2.0_token(oauth_endpoints("github"),myapi)
gtoken <- config(token = github_token)

nRowsDf <- nrow(projectUnMergedPR)

for(index in 1:nRowsDf){
  
  data<-projectUnMergedPR[index,]
  user_ID<-data$V1
  count<-data$V2
  j<-0
  V<-3
  
  while (j < count) {
    
    #getting JSON from github
    link=paste("https://api.github.com/repos/antirez/redis/pulls/",data[,V],sep="")
    request <- GET(link,gtoken)
    json_file <- content(request)
    PR <- fromJSON(toJSON(json_file))
    
    #metrics collect from JSON
    changed_files<-PR$changed_files
    additions<-PR$additions
    deletions<-PR$deletions
    commits<-PR$commits
    review_comments<-PR$review_comments
    comments<-PR$comments
  
    df = data.frame(user_ID,data[,V],comments,review_comments,commits,changed_files,additions,deletions)
    print(df)
    
    #writting the results into CSV
    write.table(df, file = "redisMetrics.csv", sep = ";", append = TRUE, col.names=FALSE)
    
    V<-V+1
    j<-j+1
  } 
  print(index)  
}







