pacman::p_load("tidyverse")
pacman::p_load("WDI")

wdi <- WDI(indicator = c(
  gdp_cap = "NY.GDP.PCAP.KD",
  unemp_nat = "SL.UEM.TOTL.NE.ZS",
  unemp_ilo = "SL.UEM.TOTL.ZS",
  fertility = "SP.DYN.TFRT.IN",
  fem_labour = "SL.TLF.TOTL.FE.ZS",
  pop = "SP.POP.TOTL",
  pop65 = "SP.POP.65UP.TO.ZS",
  pop_dens = "EN.POP.DNST"
)) %>%
  mutate(iso3c = countrycode::countrycode(iso2c, "iso2c", "iso3c")) %>%
  drop_na(iso3c) %>%
  relocate(iso3c) %>%
  select(-country, -iso2c)

wdi <- wdi %>%
  subset(year > 2009, select = -year) %>%
  group_by(iso3c) %>%
  summarise_all(mean, na.rm = T)

wdi[ wdi == "NaN" ] <- NA

# add Taiwan
wdi2 <- as.data.frame(matrix(nrow = 1, ncol = 9))
wdi2[1,1:9] <- c("TWN", 32000, 3.71, NA, 1.07, 51.4, 23570000, 16, 673)
colnames(wdi2) <- colnames(wdi)
wdi <- rbind(wdi,wdi2)

write.csv(wdi, here::here("data","wdi.csv"), row.names = F)
