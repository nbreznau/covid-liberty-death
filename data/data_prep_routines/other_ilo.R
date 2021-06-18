pacman::p_load("tidyverse", "countrycode", "readxl")

# from ILO data (accessed 08-May-2021)
# https://ilostat.ilo.org/data/
# 1. Working hours lost due to the COVID-19 crisis -- ILO modelled estimates (%) | Annual

hours_lost <- read_xlsx(here::here("data/data_prep_routines","HOW_2LSS_NOC_RT_A_EN.xlsx"), range = "A6:D382")

hours_lost <- hours_lost %>%
  mutate(iso3c = countrycode(`Reference area`, "country.name", "iso3c"),
         hours_lost = Value) %>%
  subset(!is.na(iso3c), select = c(iso3c, hours_lost))

write.csv(hours_lost, here::here("data","hours_lost_ilo.csv"), row.names = F)
