pacman::p_load("tidyverse", "countrycode")

# ILO. 2014. “Global Programme Employment Injury Insurance and Protection | GEIP Data.” https://www.ilo.org/wcmsp5/groups/public/---ed_emp/---emp_ent/documents/publication/wcms_573083.pdf.


geip <- read.csv(here::here("data/data_prep_routines","EIIP_2014.csv"), header=T, stringsAsFactors = F)
geip$cow <- countrycode(geip$Country, "country.name","cown")

# fix entities
# Angloa and Djibouti are presumed to be at the lower tail (interpolate = 4)
# Palau assumed to be like the US and Dominican Rep like well off Carib. nation 
geip <- geip %>%
  mutate(lfcov = as.numeric(Coverage_pct_LF),
         lfcov = ifelse(cow==986,85,lfcov),
         lfcov = ifelse(cow==42,80,lfcov),
         lfcov = ifelse(is.na(lfcov),4,lfcov),
         cow_code = ifelse(Country == "Serbia",345,cow),
         iso3c = countrycode(cow_code, "cown", "iso3c")) %>%
  subset(!is.na(lfcov), select = c(iso3c, lfcov))

write.csv(geip, here::here("data","geip_ilo.csv"), row.names = F)
