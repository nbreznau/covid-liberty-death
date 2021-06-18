pacman::p_load("tidyverse","countrycode")

load(here::here("data/data_prep_routines","swiid8_3.rda"))

swiid_summary <- swiid_summary %>%
  subset(year > 2014) %>%
  mutate(iso3c = countrycode(country, "country.name","iso3c")) %>%
  select(iso3c, gini_disp, gini_mkt, gini_disp_se, gini_mkt_se) %>%
  group_by(iso3c) %>%
  summarise_all(mean, na.rm = T)

write.csv(swiid_summary, here::here("data","gini_solt.csv"), row.names = F)
