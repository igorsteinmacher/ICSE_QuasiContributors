library(RJSONIO)
library(jsonlite)
library(httr)
library(stringi)
library(chron) 
require(reshape2)

setwd("/Users/igorwiese/Dropbox/QuasiCasual/")

#connecting using oauth_app
myapi = oauth_app("github","YOUR CREDENTIALS", secret="YOUR CREDENTIALS")
github_token = oauth2.0_token(oauth_endpoints("github"),myapi)
gtoken <- config(token = github_token)

summaryRQ1<-read.csv2("summaryRq1FrequencyByUser.csv", sep=";", header=TRUE)
for(index in 1:length(summaryRQ1$user)) {
  link = paste("https://api.github.com/users/",summaryRQ1$user[index],sep="")
  request = GET(link,gtoken)
  json_file = content(request)
  email = if (is.null(json_file$email)) {0} else {json_file$email}
  print(index)
  df = data.frame(summaryRQ1$user[index],email,summaryRQ1$Project[index])
  
  write.table(df, file = "email_userByProject.csv", sep = ";", append = TRUE, row.names = FALSE, col.names = FALSE)
  #CSV Format: githubID,email,projectName
}

#### Merging emails and PR by user 

setwd("/Users/igorwiese/Dropbox/QuasiCasual/")

summarEmails<-read.csv2("email_userByProject.csv", sep=";", header=FALSE)
emailValido=summarEmails[which(summarEmails$V2!=0),]
write.table(emailValido, file = "CarasComEmailValido.csv", sep = ";", row.names = FALSE)

summarEmails<-read.csv2("PeopleWithValidEmail.csv", sep=";", header=TRUE)


project_name = c("angular-js","bitcoin","bootstrap","caffe","d3","django","docker","flask","jenkins","joomla","jquery","laravel",
                 "mongo","opencv","rails","react","redis","scikit-learn","spring-framework","tensorflow","kubernetes")

setwd("/Users/igorwiese/Dropbox/QuasiCasual/projectsWithMetrics/")

for(index in 1:length(project_name)){
  project<-read.csv2(paste0(project_name[index],".csv",sep=""), sep=";", header=FALSE)
  emails_by_project = summarEmails[which(summarEmails$project==project_name[index]),]
  x = merge(emails_by_project, project, "V1")
  write.table(assign(paste0("df",project_name[index], sep=""),x), file = "email_userByProjectWithPR.csv", sep = ";", append = TRUE, row.names = FALSE, col.names = FALSE)
}

### summary emails 
setwd("/Users/igorwiese/Dropbox/QuasiCasual/")
summarEmailsbyPR<-read.csv2("email_userByProjectWithPR.csv", sep=";", header=TRUE)
#CSV Format: user;email;project;total_PR;PR1;PR2;PR3;PR4;PR5;PR6;PR7;PR8;PR9;PR10;PR11;PR12;PR13;PR14;PR15;PR16;PR17;PR18;PR19;PR20;PR21;PR22;PR23;PR24;;;;;;

project_name = c("angular-js","bitcoin","bootstrap","caffe","d3","django","docker","flask","jenkins","joomla","jquery","laravel",
                 "mongo","opencv","rails","react","redis","scikit-learn","spring-framework","tensorflow","kubernetes")


for(index in 1:length(project_name)){
  emailValido=summarEmailsbyPR[which(summarEmailsbyPR$project==project_name[index]),] 
  total_User = nrow(emailValido)
  total_PR = sum(emailValido$total_PR)
  df = data.frame(project_name[index],total_User,total_PR)
  write.table(df, file = "Summary_EmailsByProjectWithPR.csv", sep = ";", append = TRUE, row.names = FALSE, col.names = FALSE)
}

