library(RJSONIO)
library(jsonlite)
library(httr)
library(stringi)
library(chron) 
require(reshape2)

setwd("/Users/igorwiese/Dropbox/QuasiCasual/")

repo = "d3"
projectName = "d3"

#"kubernetes","kubernetes" - running
#"django","django" - DONE
#"joomla","joomla-cms"  - DONE
#"opencv','opencv" - DONE
#"scikit-learn","scikit-learn" - DONE
#jquery jquery - DONE
#"angular" "angular.js" - DONE
#"twbs","bootstrap" - DONE
#"bitcoin",'bitcoin" - DONE
#"rails','rails" - DONE
#"mongodb","mongo" - DONE
#"d3","d3" - DONE
#"laravel","laravel"  DONE
#"BVLC","caffe" - DONE
#"pallets","flask" - DONE
#"antirez","redis"  - DONE
#"tensorflow","tensorflow" - DONE
#"jenkinsci","jenkins" - DONE
#"spring-projects","spring-framework" - DONE
#"facebook','react" - Done

#"docker","docker"


#connecting using oauth_app
myapi = oauth_app("github","YOUR CREDENTIALS", secret="YOUR CREDENTIALS")
github_token = oauth2.0_token(oauth_endpoints("github"),myapi)
gtoken <- config(token = github_token)

link = paste("https://api.github.com/search/issues?page=1&per_page=100&q=is:merged+is:pr+is:closed+repo:",repo,"/",projectName,sep="")
#readlines <- readLines(link, warn = FALSE)
parse <- fromJSON(link)
request = GET(link,gtoken)
json_file = content(request)
All_PR_Closed_Merged = fromJSON(sprintf("[%s]", toJSON(json_file)))
#All_PR_Closed_Merged <- fromJSON(toJSON(readlines))

number_of_pages = round(as.numeric(All_PR_Closed_Merged$total_count) / 100)
x = 1

while (x <= number_of_pages) {
  if (x != 6) {  ## Para o Kubernets pra funcionar tive que colocar x != 6 | Para o docker...
    link = paste("https://api.github.com/search/issues?page=",x,"&per_page=100&q=is:merged+is:pr+is:closed+repo:",repo,"/",projectName,sep="")
    request = GET(link,gtoken)
    json_file = content(request)
  
    All_PR_Closed_Merged <- fromJSON(toJSON(json_file))
  
    if (x == 1) {
      List_of_PR = All_PR_Closed_Merged$items[6]
    } else {
      List_of_PR = rbind(List_of_PR,All_PR_Closed_Merged$items[6])
    }
  }
  x= x + 1
  print(x)
}

Total_PR <- length(List_of_PR$html_url)

#### generating the list of Users that worked on Merged Pull Request
i=1
while (i <= Total_PR) {
  Sys.sleep(8)
  PR_ID <- stri_extract_all_regex(List_of_PR$html_url[i], "[0-9]+")
  if (PR_ID != 42913) { ## 
    link=paste("https://api.github.com/repos/",repo,"/",projectName,"/pulls/",PR_ID,sep="")
    request <- GET(link,gtoken)
    json_file <- content(request)
    PR <- fromJSON(toJSON(json_file))
  
    link2=paste("https://api.github.com/repos/",repo,"/",projectName,"/issues/",PR_ID,"/comments",sep="")
    request2 <- GET(link2,gtoken)
    json_file2 <- content(request2)
    PRComments <- fromJSON(toJSON(json_file2))
  
    #Generic metrics
    total_PR_User = 1
    changed_files = PR$changed_files
    additions = PR$additions
    deletions = PR$deletions
    commits = PR$commits
    review_comments = PR$review_comments
    comments = PR$comments
    size_of_DescriptionTitlePR = as.numeric(stri_count(PR$title,regex="\\S+"))
    title = PR$title
    size_of_DescriptionBodyPR = as.numeric(stri_count(PR$body,regex="\\S+"))
    if (length(size_of_DescriptionBodyPR) == 0) {size_of_DescriptionBodyPR = 0}
    if (length(size_of_DescriptionTitlePR) == 0) {size_of_DescriptionTitlePR = 0}
    daysToClose = as.numeric(difftime( as.Date(PR$closed_at),as.Date(PR$created_at)))
  
    medianReplyMessages = if (comments == 0) {NA} else { as.numeric(median(diff(as.Date.character(PRComments$updated_at)))) }
    distinct_users_comments = if (comments == 0) {NA} else { length(unique(PRComments$user$login)) }
    assignee = PR$assignee$login
    Total_size_of_DescriptionCommentsPR = if (comments == 0) {NA} else { sum(stri_count(PRComments$body,regex="\\S+")) }
    Median_size_of_DescriptionCommentsPR = if (comments == 0) {NA} else { median(stri_count(PRComments$body,regex="\\S+")) }

#  df$id <- rownames(df) 
#  melt(df)
  
  #df=data.frame(PR$user$login,total_PR_User,PR_ID,comments,review_comments,commits,changed_files,additions,deletions)
    df=data.frame(PR$user$login,total_PR_User,PR_ID,comments,review_comments,commits,changed_files,additions,deletions,daysToClose,size_of_DescriptionTitlePR,size_of_DescriptionBodyPR,medianReplyMessages,distinct_users_comments,Total_size_of_DescriptionCommentsPR,Median_size_of_DescriptionCommentsPR)
    write.table(df, file = paste(repo,"_",projectName,"StatisticsByPR.csv",sep=""), sep = ";", append = TRUE, col.names=FALSE, row.names = FALSE)
  }
  i = i + 1
  print(i)
}

ListUserPR = read.csv2(paste(repo,"_",projectName,"StatisticsByPR.csv",sep=""), fill = T, sep=";", header=F)
Pull_request_Total_By_user = aggregate(ListUserPR$V2 ~ ListUserPR$V1, data=ListUserPR ,FUN=sum)
colnames(Pull_request_Total_By_user) <- c("user","totalPR")
write.table(Pull_request_Total_By_user, file = paste(repo,"_",projectName,"SummaryTotalPR_ByUser.csv",sep=""), sep = ";", row.names = FALSE)

#### Finding the list of Merged and Closed PR by User
x<-1
Total_users = nrow(Pull_request_Total_By_user)
while (x <= Total_users) {
  total_pages = if (Pull_request_Total_By_user$totalPR[x] <= 100) { 1 } else {round(Pull_request_Total_By_user$totalPR[x] / 100)}
  y = 1
  while (y <= total_pages) {
    Sys.sleep(15)
    link=paste("https://api.github.com/search/issues?page=",y,"&per_page=999&q=is:merged+is:pr+is:closed+repo:",repo,"/",projectName,"+author:",Pull_request_Total_By_user$user[x],sep="")
    request <- GET(link,gtoken)
    json_file <- content(request)
    PR_by_user <- fromJSON(toJSON(json_file))
    List_PR_by_user <- PR_by_user$items[6]
    y = y + 1
  }
  
  df_PR = data.frame(Pull_request_Total_By_user$user[x],List_PR_by_user)
  df_PR <- lapply(df_PR,as.character)
  write.table(df_PR, file = paste(repo,"_",projectName,"UserPR.csv",sep=""), sep = ";", append = TRUE, col.names=FALSE)
  
  x = x + 1
}


######### - Stats from Pull Request ####




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



