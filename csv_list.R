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
csv0  <- read_csv ("0_FO_04012018_b2fix.csv")  %>% mutate(scen = "baseline")           %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) #use 10-30 not 10-31 (24 hr date-time)

csv1a  <- read_csv ("0_CWF.csv"   )  %>% mutate(scen =           "CWF(CWF)")            %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )
#csv1b  <- read_csv ("0_NDD.csv"   )  %>% mutate(scen =           "NDD(NDD)")            %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )
#csv1c  <- read_csv ("0_SL.csv"   )  %>% mutate(scen =            "SanLR(SL)")    %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )
#csv1d  <- read_csv ("0_SHA.csv"   )  %>% mutate(scen =           "ShasR(SH)")   %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )  %>% addxtoy_csv("s44", "s4") 
#csv1e  <- read_csv ("0_TF.csv"   )  %>% mutate(scen =            "TF(TF)")       %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )
#
#
#
#csv2  <- read_csv ("2_SHA_TF.csv"   )  %>% mutate(scen =         "2_SH_TF")          %>% select(-ID, -Timestep)%>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )  %>% addxtoy_csv("s44", "s4") 
#
#csv3  <- read_csv ("3_SHA_SL_TF_CWF.csv")  %>% mutate(scen =     "3_SH_SL_TF_CWF")   %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30") %>% addxtoy_csv("s44", "s4")
#csv3a  <- read_csv ("3_SHA_SL_TF_NDD.csv")  %>% mutate(scen =    "3_SH_SL_TF_NDD")   %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30") %>% addxtoy_csv("s44", "s4")
#
#csv4  <- read_csv ("4_SHA_TF_CWF.csv"   )  %>% mutate(scen =     "4_SH_TF_CWF")      %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )%>% addxtoy_csv("s44", "s4")
#csv4a  <- read_csv ("4_SHA_TF_NDD.csv"   )  %>% mutate(scen =    "4_SH_TF_NDD")      %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )%>% addxtoy_csv("s44", "s4")
#
#csv5  <- read_csv ("5_SHA_SL_CWF.csv"   )  %>% mutate(scen =     "5_SH_SL_CWF")      %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )  %>% addxtoy_csv("s44", "s4")
#csv5a  <- read_csv ("5_SHA_SL_NDD.csv"   )  %>% mutate(scen =    "5_SH_SL_NDD")      %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )  %>% addxtoy_csv("s44", "s4")
#
#csv6  <- read_csv ("6_SL_CWF.csv"   )  %>% mutate(scen =         "6_SL_CWF")          %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )  %>% addxtoy_csv("s44", "s4")
#csv6a  <- read_csv ("6_SL_NDD.csv"   )  %>% mutate(scen =        "6_SL_NDD")          %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )  %>% addxtoy_csv("s44", "s4")
#
#csv7  <- read_csv ("7_SL_TF_CWF.csv"   )  %>% mutate(scen =      "7_SL_TF_CWF")       %>% select(-ID, -Timestep)%>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )
#csv7a  <- read_csv ("7_SL_TF_NDD.csv"   )  %>% mutate(scen =     "7_SL_TF_NDD")       %>% select(-ID, -Timestep)%>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )
#
#csv8  <- read_csv ("8_SHA_CWF.csv"   )  %>% mutate(scen =        "8_SH_CWF")         %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) %>% addxtoy_csv("s44", "s4")
#csv8a  <- read_csv ("8_SHA_NDD.csv"   )  %>% mutate(scen =       "8_SH_NDD")         %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) %>% addxtoy_csv("s44", "s4")
#
#csv9  <- read_csv ("9_SHA_SL.csv"   )  %>% mutate(scen =         "9_SH_SL")          %>% select(-ID, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) %>% addxtoy_csv("s44", "s4")
#  
#csv10 <- read_csv ("10_TF_CWF.csv"   )  %>% mutate(scen =        "10_TF_CWF")         %>% select(-ID, -Timestep)%>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )
#csv10a <- read_csv ("10_TF_NDD.csv"   )  %>% mutate(scen =       "10_TF_NDD")         %>% select(-ID, -Timestep)%>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )
#
#csv11 <- read_csv ("11_SL_TF.csv"   )  %>% mutate(scen =         "11_SL_TF")          %>% select(-ID, -Timestep)%>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )
#csv12 <- read_csv ("12_SHA_SL_TF.csv"   )  %>% mutate(scen =     "12_SH_SL_TF")      %>% select(-ID, -Timestep ) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) %>% addxtoy_csv("s44", "s4")


#csv13 <- read_csv ("omr_Act1only_min2k.csv"   )  %>% mutate(scen = "OMRAct1OnlyMin2k") %>% select(-id, -Timestep ) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) %>% addxtoy_csv("s44", "s4")
#csv14 <- read_csv ("omr_Act1only_min5k.csv"   )  %>% mutate(scen = "OMRAct1OnlyMin5k") %>% select(-id, -Timestep ) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) %>% addxtoy_csv("s44", "s4")
#csv15 <- read_csv ("Track2Scen1_DV.csv"   )  %>% mutate(scen = "oldT2Scen1") %>% select(-id, -Timestep )%>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" )  %>% addxtoy_csv("s44", "s4")








## project y scens
#csv16  <- read_csv ("0_FO_04012018_b2fix.csv"   )  %>% mutate(scen = "baseline") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv17  <- read_csv ("omr_Act1only_min2k.csv"   )  %>% mutate(scen = "omr_act1_min2k") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv18  <- read_csv ("omr_Act1only_min2k_11IE.csv"   )  %>% mutate(scen = "omr_act1_min2k_11ie") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv19  <- read_csv ("omr_Act1only_min5k.csv"   )  %>% mutate(scen = "omr_act1_min5k") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv20  <- read_csv ("omr_Act1only_min5k_11IE.csv" )  %>% mutate(scen = "omr_act1_min5k_11ie") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv21  <- read_csv ("omrbyvern.csv"   )  %>% mutate(scen = "omrbyvern") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 
#csv22  <- read_csv ("omrbyvern_11IE.csv"   )  %>% mutate(scen = "omrbyvern_11ie") %>% select(-id, -Timestep) %>% filter(Date_Time >= "1921-10-30", Date_Time <= "2003-9-30" ) 

df_csv <- mget(ls(pattern="^csv.*")) %>% bind_rows() # recognizes above new csv# data.frames and combines into one

rm(list = ls()[grep("^csv", ls())])  #releases single csvs from memory - deletes everything starting with `csv`!)
setwd(here())

# if just appending to df_csv to an already big list, can avoid re-reading in all with:

#df_csv_toadd <- read_csv("scenariofilename.csv") %>% mutate(scen = "newscenname") %>% select(-ID, -Timestep)
#df_csv <- rbind(df_csv, df_csv_toadd)


# ignore possible occassional error: "Error in names(frame) <- `*vtmp*` : names() applied to a non-vector"

