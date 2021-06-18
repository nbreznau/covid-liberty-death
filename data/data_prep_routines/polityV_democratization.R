pacman::p_load("tidyverse", "countrycode", "readxl")

# http://www.systemicpeace.org/inscrdata.html

democ_pV <- read_xls(here::here("data/data_prep_routines","p5v2018.xls"))

democ_pV <- democ_pV %>%
  subset(year > 2015, select = c(polity2, scode)) %>%
  mutate(polity2 = ifelse(polity2 < -9, NA, polity2),
         iso3c = scode) %>%
  group_by(iso3c) %>%
  summarise_all(mean) %>%
  mutate(polity2 = round(polity2,0),
         polity2 = ifelse(is.na(polity2), -8, polity2)) %>%
  select(-scode)

write.csv(democ_pV, here::here("data","polity2.csv"), row.names = F)
