library(dplyr)
library(readxl)
library(RMariaDB)
library(emayili)
library(DBI)

email <-  commandArgs(trailingOnly = TRUE)

################################################################################
#KØRES KUN FOR AT WRITE I SQL
################################################################################
føds_martin <- read_xlsx("/home/ubuntu/.ssh/git/bday/f-dselsdag/f-dselsdag/føds_martin.xlsx")
føds_martin$Fødselsdag <- as.Date(føds_martin$Fødselsdag, format = "%Y-%m-%d")

føds_johanne <- read_xlsx("/home/ubuntu/.ssh/git/bday/f-dselsdag/f-dselsdag/fødseldag.xlsx")
føds_johanne$Fødselsdag <- as.Date(føds_johanne$Fødselsdag, format = "%Y-%m-%d")

con <- dbConnect(MariaDB(),
                 host="localhost",
                 db="william",
                 user="root",
                 password="william")

dbWriteTable(con, "mart.bitsch@gmail.com", føds_martin, append = T)
dbWriteTable(con, "jjstokholm@gmail.com", føds_johanne, append = T)

################################################################################
#HENTER FRA SQL
################################################################################


føds <- dbGetQuery(con, paste0("SELECT * FROM fødselsdage_db.`", email, "`;"))

føds_idag <- føds[format(føds$Fødselsdag, "%m-%d") == format(Sys.Date(), "%m-%d"), ]
føds_14_dage <- føds[format(føds$Fødselsdag, "%m-%d") == format(Sys.Date()+14, "%m-%d"), ]


if (nrow(føds_idag) >= 1) {

for(i in 1:nrow(føds_idag)){

smtp <- server( host = "smtp.gmail.com", 
                  port = 465, username = "mart.bitsch@gmail.com", 
                  password = "xovb bvpi gzde xuck",
                  reuse = FALSE)
  

email <- envelope() %>% 
  from("mart.bitsch@gmail.com") %>% 
  to(email) %>% 
  subject("Fødselsdag idag!!") %>% 
  text(paste0(føds_idag[i,2], " har fødselsdag idag"))

smtp(email)


}
}


if (nrow(føds_14_dage) >= 1) {
  
  for(i in 1:nrow(føds_idag)){
    
    smtp <- server( host = "smtp.gmail.com", 
                    port = 465, 
                    username = "mart.bitsch@gmail.com", 
                    password = "xovb bvpi gzde xuck",
                    reuse = FALSE)
    
    
    email <- envelope() %>% 
      from("mart.bitsch@gmail.com") %>% 
      to(email) %>% 
      subject("Fødselsdag om 2 uger") %>% 
      text(paste0(føds_14_dage[i,2], " har fødselsdag om 2 uger"))
    
    smtp(email)
    
    
  }
}

