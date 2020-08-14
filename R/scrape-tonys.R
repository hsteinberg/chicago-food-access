#source general code
source("R/general.R")

#start firefox session
start_server()

#go to site
rD$navigate("https://www.tonysfreshmarket.com/my-store/store-locator")

Name = get_text_class(".fp-store-title") %>%
  gsub("\\\n.*$", "", .)
Address = get_text_class(".fp-store-address") %>%
  gsub("\\\n", ", ", .)
Phone = get_text_class(".fp-store-phone")
Hours = get_text_class(".fp-panel-store-hours")

tonys = tibble(Name, Address, Phone) %>%
  mutate(Fax = gsub("^.*Fax: ", "", Phone),
         Fax = ifelse(grepl("Fax", Phone), Fax, ""),
         Phone = gsub("\\\nFax.*$", "", Phone),
         Hours = Hours,
         Name = paste("Tony's", Name)
         )

#write to file
write_csv(tonys, paste0("data/tonys/", Sys.Date(), "-tonys.csv"), na = "")

#stop server
stop_server()