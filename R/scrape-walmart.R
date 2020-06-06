#source general code
source("R/general.R")

#start firefox session
start_server()

#go to Dollar General website
rD$navigate("https://www.walmart.com/store/finder?location=60601&distance=50")

#get data
names = rD$findElements(using = "css", ".result-element-store-type-and-number")
cities = rD$findElements(using = "css", ".city")
addresses = rD$findElements(using = "css", ".result-element-address")
info = rD$findElements(using = "css", ".store-info-details")

#Check to make sure each store has each element
stop = FALSE
if(!(all.equal(length(cities), length(addresses), length(info), length(names)))){
  warning("Elements not adding up")
  stop = TRUE
}

#get info for each store
if(stop == FALSE){
  walmarts = sapply(1:length(cities), function(i){
    name = names[[i]]$getElementText()[[1]]
    city = cities[[i]]$getElementText()[[1]]
    address = addresses[[i]]$getElementText()[[1]]
    hours = info[[i]]$getElementText()[[1]]
    address = paste0(address, ", ", city)
    closed = hours == "Closed"
    
    out = c("Name" = name, "Address" = address, "Closed" = closed)
    return(out)
  }) %>%
    t() %>%
    as.tibble()
  
  
  write_csv(walmarts, paste0("data/", Sys.Date(), "-walmart.csv"))
  
  
  
}

stop_server()

