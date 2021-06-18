## "Public Opinion, Pandemic Infection and Policymaking: The COVID-19 Story of Liberty and Death"

### Nate Breznau
#### University of Bremen, breznau.nate@gmail.com

*Main command files:*

[01_Data_Prep.Rmd](/code/01_Data_Prep.Rmd) - data cleaning, recoding and merging

[02_Plots_Maps.Rmd](/code/02_Plots_Maps.Rmd) - generating the figures

*The data used in the blog post:*

|Indicator|Source|
|-----|--------|
| COVID-19 Deaths | [Johns Hopkins Tracker](https://github.com/CSSEGISandData/COVID-19) |
| COVID-19 Infections | Author's own calculations (see [01_Data_Prep.Rmd](/code/01_Data_Prep.Rmd)) |
| Government Intervention | [Oxford Blavatnik School of Government](https://www.bsg.ox.ac.uk/research/research-projects/covid-19-government-response-tracker) |
| Media Sentiment | [RavenPack Coronavirus Media Monitor](https://coronavirus.ravenpack.com/) |
| Public Behaviors | Perceptions and Behaviors Survey [Fetzer et al 2020](https://psyarxiv.com/3kfmh/) |

*Notes for Users:*

1. Data preparation is done in a separate folder /data/data_prep_routines, therefore the user does not need to import and clean all of the source data, but can find all of the .R files that were used to do so. Of potential interest is that there are many sources of data not used in this analysis but that might prove useful in other work and that were used for a Keynote that I gave at the Taiwanese Welfare Association's Annual Conference in 2021 ([slides here](https://github.com/nbreznau/covid-story/blob/04Jun/results/Breznau%20Taiwan%20Social%20Welfare%20Association%202021%20Covid%20Risk%20Policy%20Inequality.pptx)). 
2. The RavenPack data were scraped from the Coronavirus Media Monitor's country-specific json files. This is done with the command file ravenpack_sentiment.R and was last updated June 4th, 2021. Users should be aware that if they run this routine again they will get the newest version of the data and this will likely cause errors in executing the construction of the merged data and the figures. For this reason, this routine has been left in /data/data_prep_routines folder.
