# COVIDiSTRESS data, worked up in
# Breznau, Nate. 2021. “The Welfare State and Risk Perceptions: The Novel Coronavirus Pandemic and Public Concern in 70 Countries.” European Societies 23(sup1): S33–46.


pacman::p_load("tidyverse", "countrycode")

load(here::here("data/data_prep_routines","cis.Rdata"))

# Breznau (2021) found that 75 countries had enough cases to produce reliable means, take these cases and use

cis <- cis %>%
  mutate(iso3c = iso,
         day = as.Date(StartDate),
         period = ifelse(date < as.Date('2020-03-31'), 1, ifelse(day < as.Date('2020-04-01'), 2, 
                                                          ifelse(day < as.Date('2020-04-04'), 3, 
                                                          ifelse(day < as.Date('2020-04-07'), 4, 
                                                          ifelse(day < as.Date('2020-04-12'), 5, 
                                                          ifelse(day < as.Date('2020-04-19'), 6, 
                                                          ifelse(day < as.Date('2020-05-05'), 7, 8)
                                                          ))))))
         ) %>%
  rowwise() %>%
  mutate(concern_self = mean(c(Corona_concerns_1,Corona_concerns_2,Corona_concerns_3), na.rm=T),
         concern_society = mean(c(Corona_concerns_4,Corona_concerns_5), na.rm=T)) %>%
  subset(!is.na(iso3c), select = c(iso3c, day, period, concern_self, concern_society))

cis <- cis %>%
  group_by(iso3c, period) %>%
  summarise(concern_self = mean(concern_self, na.rm = T),
            concern_society = mean(concern_society, na.rm = T),
            cis_cases = n())

cis <- cis %>%
  mutate(day = ifelse(period == 1, "2020-03-31",
               ifelse(period == 2, "2020-04-01", 
               ifelse(period == 3, "2020-04-04",
               ifelse(period == 4, "2020-04-07",
               ifelse(period == 5, "2020-04-12",
               ifelse(period == 6, "2020-04-19",
               NA))))))) %>%
  subset(!is.na(day) & cis_cases > 8)

write.csv(cis, here::here("data","cis.csv"), row.names = F)
