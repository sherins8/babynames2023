setwd("data/source")
library(tidyverse)
statefiles <- list.files("namesbystate", full.names = TRUE)

statesdf<- map_df(statefiles, read_csv, col_names = FALSE)

natfilepaths <- list.files("names", full.names = TRUE)

nationaldf<-    map_df(natfilepaths,
                       function(x) {
                         read_csv(x, col_names = c("name","sex","babies")) %>%
                           mutate(year = as.numeric(
                             str_sub(x, nchar(x[1])-7,nchar(x[1])-4))
                           )
                       }
)



names(statesdf)<- c("state","sex","year","name", "babies")

missing_names <-
  statesdf %>%
  group_by(name, sex, year) %>%
  summarize(babies = sum(babies)) %>%
  right_join(nationaldf, by=c("name","sex","year"), suffix=c("_state","_nat"))


a<- missing_names %>% filter(is.na(babies_state))
b<- missing_names %>% filter(year>=1986, is.na(babies_state))


