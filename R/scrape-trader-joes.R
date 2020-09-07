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

source("R/general.R")
stop_server()
start_server()

#Arlington Heights location:
rD$navigate("https://locations.traderjoes.com/il/arlington-heights/")
AH= get_text_class("address-left")
Arlington= AH %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName", "Address1", "Address2","Phone"))%>%
  mutate(Address = paste(Address1, Address2))%>% 
  select(StoreName, Address, Phone)


#CHicago locations
rD$navigate("https://locations.traderjoes.com/il/chicago/")
C= get_text_class("address-left")
Chicago= C %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName", "Address1", "Address2","Phone"))%>%
  mutate(Address = paste(Address1, Address2))%>% 
  select(StoreName, Address, Phone)

#Evanston locations
rD$navigate("https://locations.traderjoes.com/il/evanston/")
evanston= get_text_class("address-left")
Evanston= evanston %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName", "Address1", "Address2","Phone"))%>%
  mutate(Address = paste(Address1, Address2))%>% 
  select(StoreName, Address, Phone)

#Glenview Locations
rD$navigate("https://locations.traderjoes.com/il/glenview/")
GL= get_text_class("address-left")
Glenview= GL %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName", "Address1", "Address2","Phone"))%>%
  mutate(Address = paste(Address1, Address2))%>% 
  select(StoreName, Address, Phone)

#LaGrange locations
rD$navigate("https://locations.traderjoes.com/il/la-grange/")
LG= get_text_class("address-left")
LaGrange= LG %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName", "Address1", "Address2","Phone"))%>%
  mutate(Address = paste(Address1, Address2))%>% 
  select(StoreName, Address, Phone)

#Northbrook Location
rD$navigate("https://locations.traderjoes.com/il/northbrook/")
NB= get_text_class("address-left")
Northbrook= NB %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName", "Address1", "Address2","Phone"))%>%
  mutate(Address = paste(Address1, Address2))%>% 
  select(StoreName, Address, Phone)

#Oak Park Locations
rD$navigate("https://locations.traderjoes.com/il/oak-park/")
OP= get_text_class("address-left")
OakPark= OP %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName", "Address1", "Address2","Phone"))%>%
  mutate(Address = paste(Address1, Address2))%>% 
  select(StoreName, Address, Phone)

#Orland Park Locations
rD$navigate("https://locations.traderjoes.com/il/orland-park/")
Orp= get_text_class("address-left")
OrlandPark= Orp %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName", "Address1", "Address2","Phone"))%>%
  mutate(Address = paste(Address1, Address2))%>% 
  select(StoreName, Address, Phone)

#Park Ridge Locations
rD$navigate("https://locations.traderjoes.com/il/park-ridge/")
parkridge= get_text_class("address-left")
park_ridge= parkridge %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName", "Address1", "Address2","Phone"))%>%
  mutate(Address = paste(Address1, Address2))%>% 
  select(StoreName, Address, Phone)

#Schaumburg locations:
rD$navigate("https://locations.traderjoes.com/il/schaumburg/")
S= get_text_class("address-left")
Schaumburg= S %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName", "Address1", "Address2","Phone"))%>%
  mutate(Address = paste(Address1, Address2))%>% 
  select(StoreName, Address, Phone)

#combine datasets
CookTJ= rbind(Arlington, Chicago, Evanston, Glenview, LaGrange, Northbrook, OakPark, OrlandPark, park_ridge, Schaumburg)

#write to csv file
write_csv(CookTJ, paste0("data/traderjoes/", Sys.Date(), "-traderjoes.csv"), na = "")
