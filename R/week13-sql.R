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

dbExecute(con, "USE cla_tntlab")

# 
# Display the total number of managers.
dbGetQuery(con," SELECT COUNT(employee_id) AS total_number_managers FROM datascience_8960_table;")

# Display the total number of unique managers (i.e., unique by id number).
dbGetQuery(con, "SELECT COUNT(DISTINCT employee_id) AS total_number_uq_managers FROM datascience_8960_table;")

# Display a summary of the number of managers split by location,
# but only include those who were not originally hired as managers.
dbGetQuery(con, "SELECT city, COUNT(employee_id) AS no_mgrs FROM datascience_8960_table WHERE manager_hire = 'N' GROUP BY city ;")

# Display the average and standard deviation of number of years of employment 
  #split by performance level (bottom, middle, and top).


# Display the location and ID numbers of the top 3 managers from each location, 
  #in alphabetical order by location and then descending order of test score. 
  #If there are ties, include everyone reaching rank 3. You’ll probably need this guideLinks to an external site..





