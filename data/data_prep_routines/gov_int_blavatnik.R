# Blavatnik Oxford Government Intervention Data

pacman::p_load("tidyverse")

gov_int <- read_csv(url("https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv"))

gov_int <- gov_int %>%
  mutate(iso3c = CountryCode,
         Date = as.character(Date),
         day = as.Date(Date, format = "%Y%m%d"))

gov_int <- gov_int %>%
  mutate(C1_school_closing = `C1_School closing`,
         C2_work_closing = `C2_Workplace closing`,
         C3_cancel_pub_events = `C3_Cancel public events`,
         C4_gather_restrict = `C4_Restrictions on gatherings`,
         C5_pub_trans_closed = `C5_Close public transport`,
         C6_stay_home = `C6_Stay at home requirements`,
         C7_restrict_intern_moves = `C7_Restrictions on internal movement`,
         C8_restrict_intl_travel = `C8_International travel controls`,
         H1_public_info_campaigns = `H1_Public information campaigns`,
         H2_testing_policy = `H2_Testing policy`,
         H3_contact_tracing = `H3_Contact tracing`,
         H4_emergency_health_invest = `H4_Emergency investment in healthcare`,
         H5_vaccine_invest = `H5_Investment in vaccines`,
         H6_mask_req = `H6_Facial Coverings`,
         H7_vaccine_policy = `H7_Vaccination policy`,
         H8_elderly_protection = `H8_Protection of elderly people`) 

gov_int <- gov_int %>%
  select(iso3c, day, StringencyIndex, GovernmentResponseIndex, ContainmentHealthIndex, 
         EconomicSupportIndex, C1_school_closing:H8_elderly_protection)

# Brazil is repeated several times, remove duplicated

gov_inta <- subset(gov_int, duplicated(gov_int) == FALSE)

# Still doesn't fix it, Brazil has different scores for the same days

gov_inta <- gov_inta %>%
  group_by(iso3c,day) %>%
  summarise_all(mean, na.rm = T)

write.csv(gov_inta, here::here("data","gov_int_blavatnik.csv"), row.names = F)
