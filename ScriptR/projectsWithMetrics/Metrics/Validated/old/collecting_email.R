library(RJSONIO)
library(jsonlite)
library(httr)
library(stringi)
library(chron) 
require(reshape2)

setwd("/Users/igorwiese/Dropbox/QuasiCasual/")

#connecting using oauth_app
myapi = oauth_app("github","fa6c0d9b6b607c839d59", secret="cd30d422fbeaa59f3e73d632d0ffb3fe2dd68e9f")
github_token = oauth2.0_token(oauth_endpoints("github"),myapi)
gtoken <- config(token = github_token)

summaryRQ1<-read.csv2("summaryRq1FrequencyByUser.csv", sep=";", header=TRUE)
summaryRQ1$user[1]

for(index in 1:length(project_name)) {
  
  link = paste("https://api.github.com/users/",summaryRQ1$user[index],sep="")
  request = GET(link,gtoken)
  json_file = content(request)
  email = if (is.null(json_file$email)) {0} else {json_file$email}
  df = data.frame(summaryRQ1$user[index],email,summaryRQ1$Project[index])
  write.table(df, file = "email_userByProject.csv", sep = ";", append = TRUE, row.names = FALSE, col.names = FALSE)
  
}

