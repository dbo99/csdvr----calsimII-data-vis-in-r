#Created on Aug 16 10:25:37 2018

#@author: dbo
#



library(here)
library(dplyr)

setwd(here("csv"))
# current WRIMS column IDs are
## ID | Timsestep | Units | Date_Time | Variable | Kind | Value ##

# list CalSim dv .csv file name and name scenarios on each line
# use any number (32 scenarios is max tried - formatting challenges there - use no label functions)
# note column "ID" vs "id" - older WRIMS outputs "ID", newer"id" 
# for Shasta raise scenarios, add `addxtoy_newy_csv()` at end of line

# loop not used as calsim scenarios are unique and commonly need individual processing for comparison

#csv#  <- read_csv ("filename.csv"   )  %>% mutate(scen = "nickname") %>% select(-id, -Timestep)

# run to print file names below for easy pasting here
#list.files(path = here("csv"), pattern = NULL, all.files = FALSE, full.names = FALSE, recursive = FALSE, ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)


## project xscens 
#csv1  <- read_csv ("agencx_x_baseline.csv"   )  %>% mutate(scen = "x_baseline") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv2 <- read_csv ("agencyx_scenario1.csv"   )  %>% mutate(scen = "x_scen1") %>%    select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv3  <- read_csv ("agencyx_scenario2.csv"   )  %>% mutate(scen = "x_scen2") %>%    select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv4  <- read_csv ("agencyx_scenario3.csv"   )  %>% mutate(scen = "x_cen2) %>%     select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 



## project xscens 
#csv5  <- read_csv ("agencx_x_baseline.csv")  %>% mutate(scen = "y_baseline")%>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv6  <- read_csv ("agency_scenario1.csv" )  %>% mutate(scen = "y_scen1") %>%   select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv7 <- read_csv ("agency_scenario2.csv"   )%>% mutate(scen = "y_scen2") %>%   select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv8 <- read_csv ("agency_scenario2a.csv"   %>% mutate(scen = "y_scen2a") %>%  select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv9 <- read_csv ("agency_scenario3.csv" )  %>% mutate(scen = "y_scen3") %>%   select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv10 <- read_csv ("agency_scenario4.csv"   )%>% mutate(scen = "y_scen4") %>%   select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv11 <- read_csv ("agency_scenario5.csv"   )%>% mutate(scen = "y_scen5") %>%   select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 


df_csv <- mget(ls(pattern="^csv.*")) %>% bind_rows() # recognizes above new csv# data.frames and combines into one

rm(list = ls()[grep("^csv", ls())])  #releases single csvs from memory - deletes everything starting with `csv`!)
setwd(here())

# if just appending to df_csv to an already big list, can avoid re-reading in all with:

#df_csv_toadd <- read_csv("scenariofilename.csv") %>% mutate(scen = "newscenname") %>% select(-ID, -Timestep)
#df_csv <- rbind(df_csv, df_csv_toadd)


# ignore possible occassional error: "Error in names(frame) <- `*vtmp*` : names() applied to a non-vector"

