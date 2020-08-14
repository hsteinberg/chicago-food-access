#source general code
source("R/general.R")

#start firefox session
start_server()

#go to site
rD$navigate("https://www.petesfresh.com/stores")

Name = get_text_class(".views-field-title") %>%
  setdiff("")
Address = get_text_class(".location") %>%
  setdiff("") %>%
  gsub("\\\n", ", ", .)

petes = tibble(Name, Address)

#write to file
write_csv(petes, paste0("data/petes/", Sys.Date(), "-petes.csv"), na = "")

#stop server
stop_server()