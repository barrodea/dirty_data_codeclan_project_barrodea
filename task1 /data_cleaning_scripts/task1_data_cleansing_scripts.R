
# TASK 1: Decathlon Data Cleansing
# The purpose of this project is to clean the Decathlon Data provided so that it is a tidy state to be able to save and analyse

library(tidyverse)

#read in the raw data about decathlon
library(here)

here::here()

decathlon_data <- read_rds(here("raw_data/decathlon.rds"))

#look at the overview
glimpse(decathlon_data)


# convert row names to a column with values
library(tibble)
decathlon_data_clean <- rownames_to_column(decathlon_data, var = "names")


# clean column names
library(janitor)

decathlon_data_clean <- decathlon_data_clean %>% 
  clean_names() %>% 
  rename("100m" = "x100m", "400m" = "x400m", "110m_hurdle" = "x110m_hurdle", "1500m" = "x1500m")

# convert all names to lowercase
decathlon_data_clean <- decathlon_data_clean %>% 
  mutate(names = tolower(names))

# pivot table to longer format
decathlon_data_long <- decathlon_data_clean %>% 
  pivot_longer(2:11, names_to = "event", values_to = "result")

# check for NAs in the data
decathlon_data_long %>% 
  summarise(across(.fns = ~sum(is.na(.x))))

# check for zeros in the result column
decathlon_data_long %>% 
  filter(result == 0)

# write clean data to csv
write_csv(decathlon_data_long, "clean_data/decathlon_data_long.csv")

