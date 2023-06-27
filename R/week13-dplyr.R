#Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(RMariaDB)
library(keyring)

con <- dbConnect(MariaDB(), 
                 host = 'mysql-prod5.oit.umn.edu', 
                 username = 'demek004', 
                 password = key_get("latis-mysql","demek004"), 
                 port = 3306,
                 ssl.ca = '../mysql_hotel_umn_20220728_interm.cer')



#dbExecute(con, "USE cla_tntlab")


#Data Import and Cleaning

#After setting up MySQL Workbench and configuring the connection to my personal user/pass with dbConnect() and keyring, I used 
#workbench to test a query to display all columns from the datascience_8960_table table. This query was successful in 
#workbench so I then used dbGetQuery() to import this table into R and assigned it to week13_tbl then saved it to csv in data folder


week13_tbl <- dbGetQuery(con, "SELECT * FROM cla_tntlab.datascience_8960_table;") %>% 
  write_csv("../data/week13.csv")

# Using dplyr and base functions alone, do the following:
# Display the total number of managers. DONE
# Display the total number of unique managers (i.e., unique by id number). DONE
# Display a summary of the number of managers split by location, but only include those who were not originally hired as managers.
# Display the average and standard deviation of number of years of employment split by performance level (bottom, middle, and top).
# Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3.


total_number_managers <- week13_tbl %>% 
  filter(manager_hire == "Y") %>% 
  nrow() %>%  print()

total_number_uq_managers <- week13_tbl %>% 
  filter(manager_hire == "Y") %>% 
  distinct(employee_id) %>% 
  nrow() %>%  print()
  





