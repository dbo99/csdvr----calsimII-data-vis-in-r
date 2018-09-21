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

## project x scens
csv0  <- read_csv ("0_FO_04012018_b2fix.csv") %>% mutate(scen = "baseline")           %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) #use 10-30 not 10-31 (24 hr date-time)

csv1  <- read_csv ("FullObs_MayThruAugDailyX2_Roe.csv"   )  %>% mutate(scen = "5678_dyRoe") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
csv2  <- read_csv ("FullObs_MayThruAugDailyX2_Chp.csv"   )  %>% mutate(scen = "5678_dyChp") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
csv3  <- read_csv ("FullObs_MayThruAugDailyX2_Cnf.csv"   )  %>% mutate(scen = "5678_dyCnf") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
csv4  <- read_csv ("FullObs_MayJuneRoe_JulAugChp.csv"   )  %>% mutate(scen = "56_dyRoe_78dyChp") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
csv5  <- read_csv ("FullObs_MayJuneChp_JulAugCnf.csv"   )  %>% mutate(scen = "56_dyChp_78dyCnf") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
csv6  <- read_csv ("FullObs_MayJuneRoe_JulAugCnf.csv"   )  %>% mutate(scen = "56_dyRoe_78dyCnf") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 



#csv23  <- read_csv ("DCR17_MayThruAugDailyX2Roe_v2.csv"   )  %>% mutate(scen = "MayAugDailyX2Roe") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 

df_csv <- mget(ls(pattern="^csv.*")) %>% bind_rows() # recognizes above new csv# data.frames and combines into one

rm(list = ls()[grep("^csv", ls())])  #releases single csvs from memory - deletes everything starting with `csv`!)
setwd(here())

# if just appending to df_csv to an already big list, can avoid re-reading in all with:

#df_csv_toadd <- read_csv("scenariofilename.csv") %>% mutate(scen = "newscenname") %>% select(-ID, -Timestep)
#df_csv <- rbind(df_csv, df_csv_toadd)


# ignore possible occassional error: "Error in names(frame) <- `*vtmp*` : names() applied to a non-vector"

