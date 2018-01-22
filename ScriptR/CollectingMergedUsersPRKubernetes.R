library(RJSONIO)
library(jsonlite)
library(httr)
library(stringi)
library(chron) 
require(reshape2)

setwd("/Users/igorwiese/Dropbox/QuasiCasual/Accepted_PRs")

repo = "d3"
projectName = "d3"

#"docker","docker" - running
#"kubernetes","kubernetes" - DONE
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


#connecting using oauth_app
myapi = oauth_app("github","fa6c0d9b6b607c839d59", secret="cd30d422fbeaa59f3e73d632d0ffb3fe2dd68e9f")
github_token = oauth2.0_token(oauth_endpoints("github"),myapi)
gtoken <- config(token = github_token)

i = 2656
Total_PR =3200
while (i <= Total_PR) {
Sys.sleep(1)
link = paste("https://api.github.com/repos/",repo,"/",projectName,"/pulls/",i,sep="")
request = GET(link,gtoken)
json_file = content(request)

if (validate(toJSON(json_file)) == TRUE) {
  PR = fromJSON(toJSON(json_file))

  if (is.null(PR$message) && PR$state == "closed" && PR$merged == TRUE) {
    PR_ID = PR$number
    
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
    
    df=data.frame(PR$user$login,total_PR_User,PR_ID,comments,review_comments,commits,changed_files,additions,deletions,daysToClose,size_of_DescriptionTitlePR,size_of_DescriptionBodyPR,medianReplyMessages,distinct_users_comments,Total_size_of_DescriptionCommentsPR,Median_size_of_DescriptionCommentsPR)
    write.table(df, file = paste(repo,"_",projectName,"StatisticsByPR.csv",sep=""), sep = ";", append = TRUE, col.names=FALSE, row.names = FALSE)

    print(PR_ID)
  }
}
i = i + 1

}