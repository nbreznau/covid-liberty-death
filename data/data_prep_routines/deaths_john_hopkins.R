# Import data from Johns Hopkings Covid-Tracker
# Reformat and take weekly rolling averages
# Key variable deaths with an 18-day lag

pacman::p_load("tidyverse", "countrycode")

time_series_deaths <- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"))
time_series_deaths_US <- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"))
time_series_cases <- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"))

time_series_deaths$var <- "deaths"
time_series_cases$var <- "cases"
time_series_deaths <- rbind(time_series_deaths, time_series_cases)

time_series_deaths_province <- time_series_deaths %>%
  subset(`Country/Region` %in% c("Australia","Canada","China")) %>%
  mutate(iso3c = countrycode(`Country/Region`, "country.name", "iso3c")) %>%
  select(-c(`Province/State`,Lat,Long)) %>%
  group_by(iso3c,var) %>%
  summarise_at(vars(`1/22/20`:`6/3/21`), sum, na.rm = T)

# this is actually not necessary, they have a full "US" row in the global data
# but in future analyses it would be ideal to model each state separately
time_series_deaths_usa <- time_series_deaths_US %>%
  select(Province_State, Country_Region, `1/22/20`:`6/3/21`) %>%
  summarise_at(vars(`1/22/20`:`6/3/21`), sum, na.rm = T) %>%
  mutate(iso3c = "USA")

time_series_deaths_a <- time_series_deaths %>%
  subset(!(`Country/Region` %in% c("Australia","Canada","China"))) %>%
  subset(!(`Province/State` %in% c("Faroe Islands","Greenland","French Guiana","French Polynesia",
                                   "Guadeloupe","Martinique","Mayotte","New Caledonia","Reunion",
                                   "Saint Barthelemy","Saint Pierre and Miquelon","St Martin","Wallis and Futuna",
                                   "Aruba","Bonaire, Sint Eustatius and Saba","Curacao","Sint Maarten",
                                   "Anguilla","Bermuda","British Virgin Islands","Cayman Islands",
                                   "Channel Islands","Falkland Islands (Malvinas)","Gibraltar",
                                   "Isle of Man","Montserrat","Saint Helena, Ascension and Tristan da Cunha",
                                   "Turks and Caicos Islands",""))) %>%
  mutate(iso3c = countrycode(`Country/Region`, "country.name", "iso3c"),
         iso3c = ifelse(`Country/Region` == "Micronesia", "FSM", 
                        ifelse(`Country/Region` == "Kosovo", "XXK", 
                               ifelse(`Country/Region` == "Cuba", "CUB",iso3c)))
         ) %>%
  select(-c(`Province/State`,`Country/Region`,
            Lat,Long)) %>%
  subset(!is.na(iso3c))
  
deaths_wide <- as.data.frame(time_series_deaths_a) %>%
  rbind(time_series_deaths_province) %>%
  #rbind(time_series_deaths_usa) %>%
  select(iso3c, var, everything())

# re-split
cases_wide <- subset(deaths_wide, var == "cases")
deaths_wide <- subset(deaths_wide, var == "deaths")

deaths_long <- reshape(deaths_wide, 
        direction = "long",
        v.names = "deaths",
        varying = 3:501,
        idvar = "iso3c",
        timevar = "day",
        times = seq(as.Date("2020-01-22"), as.Date("2021-06-03"), by="days")) %>%
  select(-var)

cases_long <- reshape(cases_wide, 
                       direction = "long",
                       v.names = "cases",
                       varying = 3:501,
                       idvar = "iso3c",
                       timevar = "day",
                       times = seq(as.Date("2020-01-22"), as.Date("2021-06-03"), by="days")) %>%
  select(-var)

deaths_long <- left_join(deaths_long, cases_long, by = c("iso3c","day"))

# There are corrections in the time-series that are negative and need to be fixed for analytical purposes

row.names(deaths_long) <- NULL

deaths_long <- deaths_long %>%
  group_by(iso3c) %>%
  arrange(day) %>%
  mutate(deaths = ifelse(iso3c == "KGZ" & day > "2020-08-20", deaths + 443, deaths),
         deaths = ifelse(iso3c == "ESP" & day > "2020-05-24", deaths + 1918, deaths),
         deaths = ifelse(iso3c == "ESP" & day > "2020-08-11", deaths + 2, deaths),
         deaths = ifelse(iso3c == "SWE" & day > "2020-04-03", deaths + 232, deaths),
         deaths = ifelse(iso3c == "SWE" & day > "2020-08-06", deaths + 3, deaths),
         deaths = ifelse(iso3c == "SWE" & day >= "2020-09-01", deaths + 8, deaths),
         deaths = ifelse(iso3c == "SWE" & day > "2020-10-06", deaths + 3, deaths),
         deaths = ifelse(iso3c == "SWE" & day > "2020-10-27", deaths + 6, deaths),
         deaths = ifelse(iso3c == "FRA" & day > "2020-05-18", deaths + 217, deaths),
         deaths = ifelse(iso3c == "FRA" & day > "2020-05-23", deaths + 82, deaths),
         deaths = ifelse(iso3c == "FRA" & day > "2020-11-03", deaths + 38, deaths),
         deaths = ifelse(iso3c == "FRA" & day > "2020-09-03", deaths + 22, deaths),
         deaths = ifelse(iso3c == "FRA" & day > "2020-10-24", deaths + 21, deaths),
         deaths = ifelse(iso3c == "FRA" & day > "2020-07-20", deaths + 14, deaths),
         deaths = ifelse(iso3c == "FRA" & day > "2021-04-02", deaths + 6, deaths),
         deaths = ifelse(iso3c == "FRA" & day > "2021-02-03", deaths + 4, deaths),
         deaths = ifelse(iso3c == "BEL" & day > "2020-08-25", deaths + 117, deaths),
         deaths = ifelse(iso3c == "CHE" & day > "2020-10-20", deaths + 106, deaths),
         deaths = ifelse(iso3c == "CHE" & day > "2021-04-24", deaths + 24, deaths),
         deaths = ifelse(iso3c == "MOZ" & day > "2021-01-25", deaths + 34, deaths),
         deaths = ifelse(iso3c == "COG" & day > "2020-09-09", deaths + 31, deaths),
         deaths = ifelse(iso3c == "DEU" & day > "2020-04-10", deaths + 31, deaths),
         deaths = ifelse(iso3c == "DEU" & day > "2020-07-05", deaths + 1, deaths),
         deaths = ifelse(iso3c == "ITA" & day > "2020-06-23", deaths + 31, deaths),
         deaths = ifelse(iso3c == "NLD" & day > "2020-07-26", deaths + 18, deaths),
         deaths = ifelse(iso3c == "NLD" & day > "2020-08-10", deaths + 16, deaths),
         deaths = ifelse(iso3c == "BIH" & day > "2020-12-27", deaths + 11, deaths),
         deaths = ifelse(iso3c == "CYP" & day > "2020-11-07", deaths + 7, deaths),
         deaths = ifelse(iso3c == "CYP" & day > "2020-04-04", deaths + 2, deaths),
         deaths = ifelse(iso3c == "DNK" & day > "2020-05-11", deaths + 6, deaths),
         deaths = ifelse(iso3c == "EST" & day > "2020-08-01", deaths + 6, deaths),
         deaths = ifelse(iso3c == "VEN" & day >= "2020-05-01", deaths + 6, deaths),
         deaths = ifelse(iso3c == "IRL" & day > "2020-07-07", deaths + 4, deaths),
         deaths = ifelse(iso3c == "IRL" & day > "2020-10-01", deaths + 5, deaths),
         deaths = ifelse(iso3c == "IRL" & day > "2020-12-07", deaths + 2, deaths),
         deaths = ifelse(iso3c == "IRL" & day > "2021-05-06", deaths + 3, deaths),
         deaths = ifelse(iso3c == "IRL" & day > "2020-05-24", deaths + 2, deaths),
         deaths = ifelse(iso3c == "IRL" & day >= "2020-06-01", deaths + 2, deaths),
         deaths = ifelse(iso3c == "IRL" & day > "2020-07-29", deaths + 1, deaths),
         deaths = ifelse(iso3c == "ISL" & day > "2020-03-15", deaths + 5, deaths),
         deaths = ifelse(iso3c == "ISL" & day > "2020-03-19", deaths + 1, deaths),
         deaths = ifelse(iso3c == "ISR" & day > "2021-03-29", deaths + 4, deaths),
         deaths = ifelse(iso3c == "AGO" & day > "2020-10-07", deaths + 3, deaths),
         deaths = ifelse(iso3c == "CZE" & day > "2020-07-03", deaths + 2, deaths),
         deaths = ifelse(iso3c == "CZE" & day > "2020-07-04", deaths + 3, deaths),
         deaths = ifelse(iso3c == "CZE" & day > "2020-08-03", deaths + 3, deaths),
         deaths = ifelse(iso3c == "CZE" & day > "2020-06-10", deaths + 2, deaths),
         deaths = ifelse(iso3c == "CZE" & day > "2020-05-17", deaths + 1, deaths),
         deaths = ifelse(iso3c == "CZE" & day > "2020-06-12", deaths + 1, deaths),
         deaths = ifelse(iso3c == "CZE" & day > "2020-06-27", deaths + 1, deaths),
         deaths = ifelse(iso3c == "CZE" & day > "2020-08-06", deaths + 1, deaths),
         deaths = ifelse(iso3c == "GTM" & day > "2021-03-13", deaths + 3, deaths),
         deaths = ifelse(iso3c == "LBY" & day > "2020-07-29", deaths + 3, deaths),
         deaths = ifelse(iso3c == "MCO" & day > "2020-09-01", deaths + 3, deaths),
         deaths = ifelse(iso3c == "SRB" & day > "2020-03-25", deaths + 3, deaths),
         deaths = ifelse(iso3c == "FIN" & day >= "2020-06-01", deaths + 2, deaths),
         deaths = ifelse(iso3c == "FIN" & day > "2020-10-22", deaths + 2, deaths),
         deaths = ifelse(iso3c == "FIN" & day > "2020-04-05", deaths + 1, deaths),
         deaths = ifelse(iso3c == "FIN" & day > "2020-07-14", deaths + 1, deaths),
         deaths = ifelse(iso3c == "FIN" & day > "2020-09-29", deaths + 1, deaths),
         deaths = ifelse(iso3c == "LUX" & day > "2020-04-13", deaths + 2, deaths),
         deaths = ifelse(iso3c == "MLT" & day > "2020-11-02", deaths + 2, deaths),
         deaths = ifelse(iso3c == "NLD" & day > "2020-07-13", deaths + 2, deaths),
         deaths = ifelse(iso3c == "NLD" & day > "2020-07-17", deaths + 2, deaths),
         deaths = ifelse(iso3c == "NLD" & day > "2020-07-09", deaths + 1, deaths),
         deaths = ifelse(iso3c == "PHL" & day > "2020-03-18", deaths + 2, deaths),
         deaths = ifelse(iso3c == "AUS" & day >= "2020-06-01", deaths + 1, deaths),
         deaths = ifelse(iso3c == "AUT" & day > "2020-07-20", deaths + 1, deaths),
         deaths = ifelse(iso3c == "AUT" & day > "2020-10-10", deaths + 1, deaths),
         deaths = ifelse(iso3c == "BLZ" & day > "2021-03-03", deaths + 1, deaths),
         deaths = ifelse(iso3c == "CUB" & day > "2020-08-13", deaths + 1, deaths),
         deaths = ifelse(iso3c == "HTI" & day > "2020-04-23", deaths + 1, deaths),
         deaths = ifelse(iso3c == "HTI" & day > "2021-03-12", deaths + 1, deaths),
         deaths = ifelse(iso3c == "HTI" & day > "2021-03-29", deaths + 1, deaths),
         deaths = ifelse(iso3c == "HTI" & day > "2021-04-12", deaths + 1, deaths),
         deaths = ifelse(iso3c == "HTI" & day > "2021-04-16", deaths + 1, deaths),
         deaths = ifelse(iso3c == "IND" & day > "2020-03-20", deaths + 1, deaths),
         deaths = ifelse(iso3c == "JPN" & day > "2020-06-05", deaths + 1, deaths),
         deaths = ifelse(iso3c == "KAZ" & day > "2020-04-03", deaths + 1, deaths),
         deaths = ifelse(iso3c == "MMR" & day > "2021-02-17", deaths + 1, deaths),
         deaths = ifelse(iso3c == "NGA" & day > "2020-11-07", deaths + 1, deaths),
         deaths = ifelse(iso3c == "PNG" & day > "2020-07-21", deaths + 1, deaths),
         deaths = ifelse(iso3c == "SOM" & day > "2020-09-03", deaths + 1, deaths),
         deaths = ifelse(iso3c == "SVK" & day > "2020-03-21", deaths + 1, deaths),
         deaths = ifelse(iso3c == "TJK" & day > "2020-12-12", deaths + 1, deaths),
         deaths = ifelse(iso3c == "VNM" & day > "2020-08-18", deaths + 1, deaths))
                         
#                            

write.csv(deaths_long, file = here::here("data","deaths_long.csv"), row.names = F)
