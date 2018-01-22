library(lubridate)
setwd("/Users/igorwiese/Dropbox/QuasiCasual/")

tabela1 = read.csv2("dataTable", sep=";", header=TRUE)

elapsed_months <- function(end_date, start_date) {
  ed <- as.POSIXlt(end_date)
  sd <- as.POSIXlt(start_date)
  12 * (ed$year - sd$year) + (ed$mon - sd$mon)
}

age <- function(dob, age.day = today(), units = "years", floor = TRUE) {
  calc.age = interval(dob, age.day) / duration(num = 1, units = units)
  if (floor) return(as.integer(floor(calc.age)))
  return(calc.age)
}

dates = as.character(tabela1$Activity)
datesPR = as.character(tabela1$Fist_PR)

dates = as.Date(dates, format="%d/%m/%y")
datesPR = as.Date(datesPR, format="%d/%m/%y")

elapsed_months(Sys.time(), datesPR[21])
elapsed_months(Sys.time(), dates[21])
difftime(Sys.time(),dates[21],units="year")
age(dates[1], units = "years")

summary(tabela1$MonthstoNow)
summary(tabela1$Years)
summary(tabela1$Months_PR)
summary(tabela1$avg_PR_Month)


