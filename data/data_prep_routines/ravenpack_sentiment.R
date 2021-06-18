pacman::p_load("jsonlite","tidyverse","countrycode")

df <- read_csv(here::here("data","deaths_long.csv"))
iso2c <- unique(df$iso3c)
iso2c <- countrycode(iso2c, "iso3c", "iso2c")
iso2c <- sort(iso2c)
iso2c <- iso2c[!iso2c %in% c("FM","KM","LS","MH","SB","ST","VU","WS","KI")] #countries not included in their list

# loop through json graph data from their site
for (i in iso2c){
url <- paste0("https://coronavirus.ravenpack.com/data/1.4/country/",i,"/sent.json")
dfs <- jsonlite::fromJSON(url)
adf <- as.data.frame(dfs[["results"]])
adf$iso2c <- paste0(i)
assign(paste0("sentiment_",i), adf)
}


sent <- ls(pattern = "sentiment_")

sentiment <- rbind(sentiment_AD,sentiment_AE,sentiment_AF,sentiment_AG,sentiment_AL,
 sentiment_AM,sentiment_AO,sentiment_AR,sentiment_AT,sentiment_AU,
 sentiment_AZ,sentiment_BA,sentiment_BB,sentiment_BD,sentiment_BE,
 sentiment_BF,sentiment_BG,sentiment_BH,sentiment_BI,sentiment_BJ,
 sentiment_BN,sentiment_BO,sentiment_BR,sentiment_BS,sentiment_BT,
 sentiment_BW,sentiment_BY,sentiment_BZ,sentiment_CA,sentiment_CD,
 sentiment_CF,sentiment_CG,sentiment_CH,sentiment_CI,sentiment_CL,
 sentiment_CM,sentiment_CN,sentiment_CO,sentiment_CR,sentiment_CU,
 sentiment_CV,sentiment_CY,sentiment_CZ,sentiment_DE,sentiment_DJ,
 sentiment_DK,sentiment_DM,sentiment_DO,sentiment_DZ,sentiment_EC,
 sentiment_EE,sentiment_EG,sentiment_ER,sentiment_ES,sentiment_ET,
 sentiment_FI,sentiment_FJ,sentiment_FR,sentiment_GA,sentiment_GB,
 sentiment_GD,sentiment_GE,sentiment_GH,sentiment_GM,sentiment_GN,
 sentiment_GQ,sentiment_GR,sentiment_GT,sentiment_GW,sentiment_GY,
 sentiment_HN,sentiment_HR,sentiment_HT,sentiment_HU,sentiment_ID,
 sentiment_IE,sentiment_IL,sentiment_IN,sentiment_IQ,sentiment_IR,
 sentiment_IS,sentiment_IT,sentiment_JM,sentiment_JO,sentiment_JP,
 sentiment_KE,sentiment_KG,sentiment_KH,sentiment_KN,sentiment_KR,
 sentiment_KW,sentiment_KZ,sentiment_LA,sentiment_LB,sentiment_LC,
 sentiment_LI,sentiment_LK,sentiment_LR,sentiment_LT,sentiment_LU,
 sentiment_LV,sentiment_LY,sentiment_MA,sentiment_MC,sentiment_MD,
 sentiment_ME,sentiment_MG,sentiment_MK,sentiment_ML,sentiment_MM,
 sentiment_MN,sentiment_MR,sentiment_MT,sentiment_MU,sentiment_MV,
 sentiment_MW,sentiment_MX,sentiment_MY,sentiment_MZ,sentiment_NA,
 sentiment_NE,sentiment_NG,sentiment_NI,sentiment_NL,sentiment_NO,
 sentiment_NP,sentiment_NZ,sentiment_OM,sentiment_PA,sentiment_PE,
 sentiment_PG,sentiment_PH,sentiment_PK,sentiment_PL,sentiment_PS,
 sentiment_PT,sentiment_PY,sentiment_QA,sentiment_RO,sentiment_RS,
 sentiment_RU,sentiment_RW,sentiment_SA,sentiment_SC,sentiment_SD,
 sentiment_SE,sentiment_SG,sentiment_SI,sentiment_SK,sentiment_SL,
 sentiment_SM,sentiment_SN,sentiment_SO,sentiment_SR,sentiment_SS,
 sentiment_SV,sentiment_SY,sentiment_SZ,sentiment_TD,sentiment_TG,
 sentiment_TH,sentiment_TJ,sentiment_TL,sentiment_TN,sentiment_TR,
 sentiment_TT,sentiment_TW,sentiment_TZ,sentiment_UA,sentiment_UG,
 sentiment_US,sentiment_UY,sentiment_UZ,sentiment_VA,sentiment_VC,
 sentiment_VE,sentiment_VN,sentiment_YE,sentiment_ZA,sentiment_ZM,
 sentiment_ZW)

sentiment <- sentiment %>%
   mutate(iso3c = countrycode(iso2c, "iso2c","iso3c"),
          day = format(as.POSIXct(ts, format = "%Y-%m-%d %H:%M:%S"), format = "%Y-%m-%d")) %>%
   select(iso3c, day, sent)

write.csv(sentiment, here::here("data","sentiment_rp.csv"), row.names = F)
 