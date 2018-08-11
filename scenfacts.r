## specify legend order (in certain order desired top to bottom or to match trends)


                                        
df$scen <- factor(df$scen, levels = c(
  
  "baseline"  ,
  "2_SHA_TF"  ,            
 "3_SHA_SL_TF_NDD"  ,              
 #"4_SHA_TF_NDD"   ,            
 #"5_SHA_SL_NDD" ))          
 "6_SL_NDD"   ,          
 #"7_SL_TF_NDD"   ,         
 #"8_SHA_NDD"   ,        
 #"9_SHA_SL"     ,       
 #"10_TF_NDD"     ,      
 #"11_SL_TF"  ,     
 #"12_SHA_SL_TF",
 "OMRAct1OnlyMin2k"))
 #"OMRAct1OnlyMin5k"
 #))
          
scendiffnames <- levels((df$scen))                             
scendiffnames <- scendiffnames[scendiffnames != "baseline"]; 
scendiffnames <- paste(scendiffnames, " - bl", sep="")

df_diff$scen <- factor(df_diff$scen, levels = c(paste0(scendiffnames)))


numnonbaselinescens <- length(unique(df_diff$scen))+1
df_diff_cols <- scales::hue_pal()(numnonbaselinescens)
black <- c("gray45") #gray55 
df_cols <- c(black, df_diff_cols)



df$dv_name <- factor(df$dv_name, levels = c("Trinity (CVP)", "Shasta (CVP)", "Folsom (CVP)", "CVP San Luis", "Oroville (SWP)", "SWP San Luis"  ,  "Delta Outflow", "CVP Total",
                                            "CVP NOD", "CVP SOD", "SWP Total", "SWP NOD", "SWP SOD", "NOD CVP Settlement",
                                            "NOD CVP M&I", "NOD CVP Ag. Service", "NOD CVP Refuge",
                                            "SOD CVP Exchange","SOD CVP M&I", "SOD CVP Ag. Service", "SOD CVP Refuge"))
df_diff$dv_name <- factor(df_diff$dv_name, levels = c("Trinity (CVP)", "Shasta (CVP)", "Folsom (CVP)", "CVP San Luis", "Oroville (SWP)", "SWP San Luis","Delta Outflow", "CVP Total",
                                            "CVP NOD", "CVP SOD", "SWP Total","SWP NOD", "SWP SOD", "NOD CVP Settlement",
                                            "NOD CVP M&I", "NOD CVP Ag. Service", "NOD CVP Refuge",
                                            "SOD CVP Exchange","SOD CVP M&I", "SOD CVP Ag. Service", "SOD CVP Refuge"))

df$mon <- factor(df$mon, levels = c("Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep"))
df_diff$mon <- factor(df_diff$mon, levels = c("Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep"))
