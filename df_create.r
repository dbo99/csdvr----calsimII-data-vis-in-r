df <- create_df(df_csv)      #creates data.frame
df_diff <- create_df_diff(df)#creates data.frame of differences. preserves original values if needed for math, labels, etc ###
setwd(here())
source("scenfacts.r")      #sets plot's scenario and legend *orders*, plot order can be overriden below with "_rank" suffix##
