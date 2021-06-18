# Freedom House 
# Freedom rankings (0-100)
# Use to interpolate polity2

# Freedom House, 2021. Freedom in the World Index (FIW). Accessed 09-May-21. https://freedomhouse.org/report/freedom-world

pacman::p_load("tidyverse","countrycode","readxl")

fiw <- read_xlsx(here::here("data/data_prep_routines","Aggregate_Category_and_Subcategory_Scores_FIW_2003-2021.xlsx"), sheet = "FIW06-21")

fiw <- fiw %>%
  mutate(iso3c = countrycode(`Country/Territory`, "country.name", "iso3c"),
         fiw = Total,
         iso3c = ifelse(`Country/Territory` == "Serbia and Montenegro", "SRB",
                        ifelse(`Country/Territory` == "Micronesia", "FSM", iso3c))) %>%
  subset(Edition == 2019 & !is.na(iso3c), select = c(iso3c, fiw))

# covert to -10/9 scale to match polity2

fiw <- fiw %>%
  mutate(fiw = round(((fiw/10)*1.9)-9,0))

write.csv(fiw, here::here("data", "fiw.csv"), row.names = F)
