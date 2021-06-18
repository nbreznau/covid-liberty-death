pacman::p_load("tidyverse")


# Esteban Ortiz-Ospina and Max Roser (2016) - "Government Spending". Published online at OurWorldInData.org. Retrieved from: 'https://ourworldindata.org/government-spending' [Online Resource]

socx_owd <- read_csv(here::here("data/data_prep_routines","historical-gov-spending-gdp.csv"))

colnames(socx_owd) <- c("c","iso3c","year","socx_owd")

socx_owd <- socx_owd %>%
  subset(year > 2009) %>%
  group_by(iso3c) %>%
  summarise_all(mean, na.rm = T) %>%
  select(iso3c, socx_owd)

write.csv(socx_owd, here::here("data","socx_owd.csv"), row.names = F)
