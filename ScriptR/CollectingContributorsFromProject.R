library(RJSONIO)
library(jsonlite)
library(httr)
library(stringi)

setwd("Users/igorwiese/Dropbox/QuasiCasual")

projectName <- "tensorflow/tensorflow"
#NEED TO RUN ONCE PER PROJECT

#connecting using oauth_app
myapi = oauth_app("github","YOURCREDENTIALS", secret="YOURCREDENTIALS")
github_token = oauth2.0_token(oauth_endpoints("github"),myapi)
gtoken <- config(token = github_token)


###### Getting the list of TOP 100 Contributors by project ####

total_contributors = 962
number_of_pages = round(total_contributors / 100)
x = 1
df = NULL
while (x <= number_of_pages) {
  link = paste0("https://api.github.com/repos/",projectName,"/contributors?per_page=100&page=",x,"")
  request = GET(link,gtoken)
  json_file = content(request)
  All_Contributors <- fromJSON(toJSON(json_file))
  z = length(All_Contributors)
  y = 1
    while (y <= z){
      y = y + 1
      df = rbind(df,data.frame(All_Contributors$login[[y]],All_Contributors$contributions[[y]]))
    }
  x = x+1
}

