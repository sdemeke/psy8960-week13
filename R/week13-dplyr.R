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


dbGetQuery(con, "SELECT * FROM cla_tntlab.datascience_8960_table;") %>%
  write_csv("../data/week13.csv")

week13_tbl <- read_csv("../data/week13.csv")


#Analysis

#First statement just displays number of rows and since there are no NAs, displays total number of managers 

week13_tbl %>% 
  nrow()

#Second statement adds distinct() select only one row per unique employee id. The displayed count
#is the same as above which means that none of the manager ids were duplicated over more than one row

week13_tbl %>% 
  distinct(employee_id) %>% 
  nrow()
  

#Third statement chunk filters those not hired originally as mangers based on Y/N manager_hire variable. I then used
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


# Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3.
#To display top 3 scoring (with ties) manager by location, I first grouped the df by location then used arrange() to order
#each grouped df by alphabetical order of city and descending test score (the .by_group parameter makes sure this ordering
#is done within each location group). To retain only the top 3 test scores, I used slice_max and retained default with_ties = TRUE so that
#more than 3 rows are returned if there are ties. Finally, select() retains only the desired variables with all the ordering retained.

week13_tbl %>% 
  group_by(city) %>% 
  arrange(city, desc(test_score), .by_group = T) %>% 
  slice_max(test_score, n = 3, with_ties = T) %>% 
  select(city, employee_id) 


