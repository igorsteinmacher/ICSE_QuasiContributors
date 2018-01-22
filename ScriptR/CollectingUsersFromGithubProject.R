library(RJSONIO)
library(jsonlite)
library(httr)
library(stringi)

setwd("Users/igorwiese/Dropbox/QuasiCasual")

#NEED TO RUN FOR EACH PROJECT
projectName <- "jquery"

#connecting using oauth_app
myapi = oauth_app("github","YOUR CREDENTIALS", secret="YOUR CREDENTIALS")
github_token = oauth2.0_token(oauth_endpoints("github"),myapi)
gtoken <- config(token = github_token)


###### Getting the list of TOP 100 Contributors by project ####
link = paste("https://api.github.com/search/issues?page=1&per_page=100&q=is:merged+is:pr+is:closed+repo:jquery/jquery")
request = GET(link,gtoken)
json_file = content(request)
All_PR_Closed_Merged <- fromJSON(toJSON(json_file))
number_of_pages = round(All_PR_Closed_Merged$total_count / 100)
x = 1

while (x <= number_of_pages) {
  link = paste("https://api.github.com/search/issues?page=",x,"&per_page=100&q=is:merged+is:pr+is:closed+repo:jquery/jquery",sep="")
  request = GET(link,gtoken)
  json_file = content(request)
  All_PR_Closed_Merged <- fromJSON(toJSON(json_file))
  if (x == 1) {
    List_of_PR = All_PR_Closed_Merged$items[6]
  } else {
    List_of_PR = rbind(List_of_PR,All_PR_Closed_Merged$items[6])
  }
  x = x+1
}

Total_contributors = 

#### generating the list of Users that worked on Merged Pull Request
i=1
df = NULL
while (i <= Total_PR) {
  PR_ID <- stri_extract_all_regex(List_of_PR[i,], "[0-9]+")
  link=paste("https://api.github.com/repos/jquery/jquery/pulls/",PR_ID,sep="")
  request <- GET(link,gtoken)
  json_file <- content(request)
  PR <- fromJSON(toJSON(json_file))
  total_PR_User = 1
  df = rbind(df,data.frame(PR$user$login,total_PR_User))
  i = i + 1
}

Pull_request_Total_By_user = aggregate(total_PR_User ~ PR.user.login, data=df ,FUN=sum)

#### Finding the list of Merged and Closed PR by User
x<-1
Total_users = nrow(Pull_request_Total_By_user)
while (x <= Total_users) {
  total_pages = if (Pull_request_Total_By_user$total_PR_User[x] <= 100) { 1 } else {round(Pull_request_Total_By_user$total_PR_User[x] / 100)}
  y = 1
  while (y <= total_pages) {
    Sys.sleep(100)
    link=paste("https://api.github.com/search/issues?page=",y,"&per_page=999&q=is:merged+is:pr+is:closed+repo:jquery/jquery+author:",Pull_request_Total_By_user$PR.user.login[x],sep="")
    request <- GET(link,gtoken)
    json_file <- content(request)
    PR_by_user <- fromJSON(toJSON(json_file))
    List_PR_by_user <- PR_by_user$items[6]
    y = y + 1
  }
  print(Pull_request_Total_By_user$PR.user.login[x])
  df_PR = data.frame(Pull_request_Total_By_user$PR.user.login[x],List_PR_by_user)
  df_PR <- lapply(df_PR,as.character)
  write.table(df_PR, file = paste(projectName,"UserPR.csv",sep=""), sep = ";", append = TRUE, col.names=FALSE)
  
  x = x + 1
}


######### - Stats from Pull Request ####

nRowsPR_By_Users <- nrow(List_PR_by_user)

for(index in 1:nRowsPR_By_Users){
  
  data<-nRowsPR_By_Users[index,]
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
  
    #df = data.frame(user_ID,data[,V],comments,review_comments,commits,changed_files,additions,deletions)
    #print(df)
    
    #writting the results into CSV
    #write.table(df, file = "redisMetrics.csv", sep = ";", append = TRUE, col.names=FALSE)
    
    V<-V+1
    j<-j+1
  } 
  print(index)  
}




#Commits
#https://api.github.com/repos/jquery/jquery/commits?author=jeresig?page=1
#https://api.github.com/repos/rails/rails/commits/master?author=rafaelfranca
#parametros:
#merge:true

#Contributors + Stats
#https://api.github.com/repos/jquery/jquery/contributors?page=1&per_page=100
#https://api.github.com/repos/jquery/jquery/stats/contributors?page=1&per_page=100

#List Pull from user
#https://api.github.com/search/issues?q=is:merged+is:pr+is:closed+repo:jquery/jquery+author:mgol

#Get a specific Pull Request
#https://api.github.com/repos/antirez/redis/pulls/1000



