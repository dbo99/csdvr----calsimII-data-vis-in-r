#Created on Aug 16 10:45:17 2018

## specify legend order (in certain order desired top to bottom or to match trends)

# run below to print scenarios to console for cutting and pasting
#unique(df_csv$scen)
                                        
#df$scen <- factor(df$scen, levels = c(
 
# project x scenarios
#   proj x 
#  "x_baseline"  ,
#  "x_scen1  ,            
#   x_scen2             
#   x_scen2a  
#   x_scen3 ))
  
  
  
# project y scenarios
 #"y_baseline"  ,
#  "y_scen1  ,              
#  "y_scen1  ,       
#  "y_scen1  ,          
#  "y_scen1  ,     
#  "y_scen1  ))

##############################
##### leave below ############
##############################

df$scwyt_scwytt <- factor(df$scwyt_scwytt, levels = c("1_wt", "2_an", "3_bn", "4_dr", "5_cr"))

scendiffnames <- levels((df$scen))                             
scendiffnames <- scendiffnames[scendiffnames != "baseline"]; 
scendiffnames <- paste(scendiffnames, " - bl", sep ="")

#df_diff$scen <- factor(df_diff$scen, levels = c(paste0(scendiffnames)))


numnonbaselinescens <- length(unique(df_diff$scen))+1
df_diff_cols <- scales::hue_pal()(numnonbaselinescens)
black <- c("gray45") #gray55 
df_cols <- c(black, df_diff_cols)




#wyt_cols <- c("#3333CC", "#6666CC", "#FFCCCC", "#CC9999", "#996666")
wyt_cols <- c("#0571b0", "#92c5de", "#fddbc7", "#f4a582", "#ca0020")


# this groups some cvp and swp totals
#df$dv_name <- factor(df$dv_name, levels = c("Trinity (CVP)", "Shasta (CVP)", "Folsom (CVP)", "CVP San Luis", "Oroville (SWP)", "SWP San Luis"  ,  "Delta Outflow", "CVP Total",
#                                            "CVP NOD", "CVP SOD", "SWP Total", "SWP NOD", "SWP SOD", "NOD CVP Settlement",
#                                            "NOD CVP M&I", "NOD CVP Ag. Service", "NOD CVP Refuge",
#                                            "SOD CVP Exchange","SOD CVP M&I", "SOD CVP Ag. Service", "SOD CVP Refuge"))
#df_diff$dv_name <- factor(df_diff$dv_name, levels = c("Trinity (CVP)", "Shasta (CVP)", "Folsom (CVP)", "CVP San Luis", "Oroville (SWP)", "SWP San Luis","Delta Outflow", "CVP Total",
#                                            "CVP NOD", "CVP SOD", "SWP Total","SWP NOD", "SWP SOD", "NOD CVP Settlement",
#                                            "NOD CVP M&I", "NOD CVP Ag. Service", "NOD CVP Refuge",
#                                            "SOD CVP Exchange","SOD CVP M&I", "SOD CVP Ag. Service", "SOD CVP Refuge"))

df_diff$scwyt_scwytt <- factor(df_diff$scwyt_scwytt, levels = c("1_wt", "2_an", "3_bn", "4_dr", "5_cr"))


df$mon <- factor(df$mon, levels = c("Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep"))
df_diff$mon <- factor(df_diff$mon, levels = c("Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep"))

#df$dv <- factor(df$dv, levels = c("s1","s4", "s8", "s11"))
#df_diff$dv <- factor(df_diff$dv, levels = c("s1","s4", "s8", "s11"))