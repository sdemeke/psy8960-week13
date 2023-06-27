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
dbGetQuery(con, 
           "SELECT city, COUNT(employee_id) AS no_mgrs 
           FROM datascience_8960_table 
           WHERE manager_hire = 'N' 
           GROUP BY city ;")


# Display the average and standard deviation of number of years of employment 
#split by performance level (bottom, middle, and top).
dbGetQuery(con, 
           "SELECT performance_group, ROUND(AVG(yrs_employed),2) AS avg_yrs, ROUND(STDDEV_SAMP(yrs_employed),3) AS sd_yrs 
           FROM datascience_8960_table 
           GROUP BY performance_group;"
)


#For this final step, I followed information in provided guide about over clauses and using WITH(). Within the WITH statement,
#I select the city, ID, test score column and assign a new test_rank variable that labels each ID with a value denoting relative rank
#on test_score. The over clause here determines that the RANK() be in descending order of test score within each city. Finally, an additional
#ORDER BY statement outside of the over clause sorts the rows by alphabetical order of location.
#Finally, outside of WITH(), I call on the temporary viewset and select the two desired column and display only those individuals
#with rank up to 3.

dbGetQuery(con,
           "WITH added_test_rank AS (
           SELECT	city, employee_id, test_score, RANK() OVER(PARTITION BY city ORDER BY test_score DESC) AS test_rank 
           FROM datascience_8960_table 
           ORDER BY city)
          
           SELECT city, employee_id 
           FROM added_test_rank
           WHERE test_rank <= 3;"
)
