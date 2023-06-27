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




#Data Import and Cleaning

#After setting up MySQL Workbench and configuring the connection to my personal user/pass with dbConnect() and keyring, I used 
#workbench to test a query to display all columns from the datascience_8960_table table. This query was successful in 
#workbench so I then used dbGetQuery() to import this table into R and assigned it to week13_tbl then saved it to csv in data folder


# week13_tbl <- dbGetQuery(con, "SELECT * FROM cla_tntlab.datascience_8960_table;") %>% 
#   write_csv("../data/week13.csv")

week13_tbl <- read_csv("../data/week13.csv")


#Analysis

#First statement just displays number of rows 

total_number_managers <- week13_tbl %>% 
  nrow() %>%  print()

#Second statement adds distinct() select only one row per unique employee id. The displayed count
#is the same as above which means that none of the manager ids were duplicated over more than one row

total_number_uq_managers <- week13_tbl %>% 
  distinct(employee_id) %>% 
  nrow() %>%  print()
  

#Third statement chunk filters those not hired originally as mangers based on Y/N manager_hire variable. I then used
#group_by to split by city location and summarise() to count the length of the employee_id vector in each group

mgr_by_location <- week13_tbl %>% 
  filter(manager_hire == 'N') %>% 
  group_by(city) %>% 
  summarise(no_mgrs = length(employee_id)) %>% 
  print()


# Display the average and standard deviation of number of years of employment split by performance level (bottom, middle, and top).
# Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3.





