library(tidyverse)
library(magrittr)
library(devtools)
library(RSelenium)

#source functions to make rselenium easier
source_url("https://github.com/hsteinberg/ccdph-functions/blob/master/general-use-rselenium-functions.R?raw=TRUE")

#zip codes spread out through the county since most store locator websites only show a certain number of stores,
#have to search by many zip codes
cook_zipcodes_sample = c(north="60625", west="60804",south="60620",
                         central="60601",northsub="60026",northwestsub="60004",
                         westsub="60546",southsub="60426",southwestsub="60465")