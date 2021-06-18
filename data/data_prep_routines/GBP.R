# Fetzer, Thiemo et al. 2020. “Perceptions of an Insufficient Government Response at the Onset of the COVID-19 Pandemic Are Associated with Lower Mental Well-Being.” https://psyarxiv.com/3kfmh/ (May 11, 2021).
# These three items scale in analysis by -> Nguyen, Hung H.V., Nate Breznau, and Lisa Heukamp. 2021. “Locked Down or Locked In? Institutionalized Public Preferences and Pandemic Policy Feedback in 32 Countries.” Social Policy Review.


pacman::p_load("tidyverse", "haven", "countrycode")

betrack <- read_dta(here::here("data/data_prep_routines","GlobalBehaviorsPerceptions_Data_May21_2020.dta"))


betrack <- betrack %>%
  mutate(
    iso3c = countrycode(iso2c, origin = "iso2c", destination = "iso3c"),
    stay = scale(beh_stayhome),
    gather = scale(beh_socgathering),
    distance = scale(beh_distance),
    day = date,
  ) %>%
  select(iso3c, day, stay, gather, distance)

betrack_complete <- betrack[complete.cases(betrack),]

## Create the "behave" variable (from Nguyen et al 2021)

betrack_complete$behave <- round((betrack_complete$stay + 0.776*betrack_complete$gather + 1.083*betrack_complete$distance)/3,2)

betrack_complete <- betrack_complete %>%
  group_by(iso3c,day) %>%
  summarise(behave = mean(behave, na.rm = T),
            gbp_cases = n()) %>%
  arrange(iso3c,day)

betrack_complete <- betrack_complete %>%
  subset(gbp_cases > 7)

write.csv(betrack_complete, here::here("data","gbp.csv"), row.names = F)
