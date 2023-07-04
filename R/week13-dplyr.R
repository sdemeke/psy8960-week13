#Script Settings and Resources
#I blocked out steps to connect with MySQL and call the database because I have already saved table as week13.csv in data folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
# library(RMariaDB)
# library(keyring)
# 
# con <- dbConnect(MariaDB(), 
#                  host = 'mysql-prod5.oit.umn.edu', 
#                  username = 'demek004', 
#                  password = key_get("latis-mysql","demek004"), 
#                  port = 3306,
#                  ssl.ca = '../mysql_hotel_umn_20220728_interm.cer')




#Data Import and Cleaning

#After setting up MySQL Workbench and configuring the connection to my personal user/pass with dbConnect() and keyring, I used 
#workbench to test a query to display all columns from the datascience_8960_table table. This query was successful in 
#workbench so I then used dbGetQuery() to import this table into R, saved it in data, and read in as week13_tbl 


# dbGetQuery(con, "SELECT * FROM cla_tntlab.datascience_8960_table;") %>%
#   write_csv("../data/week13.csv")

week13_tbl <- read_csv("../data/week13.csv")


#Analysis

#First statement just displays number of rows and since there are no NAs, it displays total number of managers 

week13_tbl %>% 
  nrow()

#Second statement adds distinct() select only one row per unique employee id. The displayed count
#is the same as above which means that none of the manager ids were duplicated  

week13_tbl %>% 
  distinct(employee_id) %>% 
  nrow()
  

#Third chunk filters those not hired originally as mangers based on Y/N manager_hire variable. I then used
#group_by to split by city location and summarise() to count the length of the employee_id vector in each group

week13_tbl %>% 
  filter(manager_hire == 'N') %>% 
  group_by(city) %>% 
  summarise(no_mgrs = n())

#To display the average and standard deviation of number of years of employment, I used group_by() first to split by
#performance group and then summarise() to calculate both summary statistics within each group

week13_tbl %>% 
  group_by(performance_group) %>% 
  summarise(avg_yrs = mean(yrs_employed, na.rm = T),
            sd_yrs = sd(yrs_employed, na.rm = T))


#To display top 3 scoring (include ties) managers by location, I first grouped the tbl by location then 
#used filter() and dense_rank() to first rank the rows by descending test score (dense_rank does not skip
#gaps when ranking) then filter for the top 3 scorers. Next, arrange reorders by city and the descending test
#score within each group. Finally, select() retains only the desired variables with all the ordering retained
#and print(n=24) sets display to the full output instead of just the top rows.

week13_tbl %>% 
  group_by(city) %>% 
  filter(
    dense_rank(desc(test_score)) <= 3
    ) %>% 
  arrange(city, desc(test_score), .by_group = T) %>% 
  select(city, employee_id) %>% 
  print(n=24) 


