#source general code
source("R/general.R")

#start firefox session
start_server()

#go to Sams club website
rD$navigate("https://www.samsclub.com/locator")

#search chicago
enter_text("#inputbox2", "60601")
click(".sc-location-search-box-button > button:nth-child(1)")

Name = rD$findElements(using = "css", ".sc-club-card-club-name") %>%
  sapply(function(x){x$getElementText()[[1]]})
Number = rD$findElements(using = "css", ".sc-club-card-club-number") %>%
  sapply(function(x){x$getElementText()[[1]]})
Address = rD$findElements(using = "css", ".sc-club-card-club-address") %>%
  sapply(function(x){x$getElementText()[[1]]})
Phone = rD$findElements(using = "css", ".sc-phone-link") %>%
  sapply(function(x){x$getElementText()[[1]]})

sams = bind_cols(Name, Number, Address, Phone) %>%
  set_colnames(c("Name", "Store Number", "Address", "Phone")) %>%
  mutate(Address = gsub("\\\n", ", ", Address)) %>%
  filter(grepl(" IL ", Address))

write_csv(sams, paste0("data/sams-club/", Sys.Date(), "-sams-club.csv"))

stop_server()
