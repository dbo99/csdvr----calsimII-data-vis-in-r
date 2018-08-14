setwd(here()) 

  dvs <- c("del_cvp_psc_n", "del_cvp_pmi_n", "del_cvp_pag_n", "del_cvp_prf_n","del_cvp_pex_s", "del_cvp_pmi_s", "del_cvp_pag_s", "del_cvp_prf_s")
  source("df_create.r")
  
  
  
  df_diff$dv <- df_diff$dv_name
  
  # orders dv_names here
  df$dv <- factor(df$dv, levels = c("Trinity (CVP)", "Shasta (CVP)", "Folsom (CVP)", "CVP San Luis", "Oroville (SWP)", "SWP San Luis"  ,  "Delta Outflow", "CVP Total",
                                              "CVP NOD", "CVP SOD", "SWP Total", "SWP NOD", "SWP SOD", "NOD CVP Settlement",
                                              "NOD CVP M&I", "NOD CVP Ag. Service", "NOD CVP Refuge",
                                              "SOD CVP Exchange","SOD CVP M&I", "SOD CVP Ag. Service", "SOD CVP Refuge"))
  df_diff$dv <- factor(df_diff$dv, levels = c("Trinity (CVP)", "Shasta (CVP)", "Folsom (CVP)", "CVP San Luis", "Oroville (SWP)", "SWP San Luis","Delta Outflow", "CVP Total",
                                              "CVP NOD", "CVP SOD", "SWP Total","SWP NOD", "SWP SOD", "NOD CVP Settlement",
                                              "NOD CVP M&I", "NOD CVP Ag. Service", "NOD CVP Refuge",
                                              "SOD CVP Exchange","SOD CVP M&I", "SOD CVP Ag. Service", "SOD CVP Refuge"))
  
  
  
  
  
  z <- 
    #choose label style or ranked; labels good for few scenarios, maybe too busy for many scenarios
    
    #pb_mn_ann_perav_taf_d(df_diff) + 
    #pb_mn_ann_perav_taf_d_hlab(df_diff) +
     pb_mn_ann_perav_taf_d_nolab_rank(df_diff) + 
    
    ggtitle("CVP Delivery Subgroups, \nMean Annual Delivery Volume, Difference from Baseline")+
    theme(plot.margin=grid::unit(c(0.5,0.5,0.5,0.5), "mm")) +
    theme(strip.text.x = element_text(size = 8)) + 
    #scale_x_discrete(label=abbreviate) + if low enough numbers of scens, activate to turn on scen labels, turn '#switch' rows' below off
    theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) + #theme(legend.position="none") +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + #switch
    theme(strip.text.x = element_text(angle = 90, vjust = 0))
z
setwd(here("plots", "delivplot_cvpgrp_diffs"))
ggsave( "deliv_cvpsubgroupdiffs.jpg", dpi = 300, width = 13, height = 8, units = "in") 
z <- ggplotly(z)
htmlwidgets::saveWidget(as_widget(z), "deliv_cvpsubgroupdiffs.html")
setwd(here("plotexportscripts"))
rm(list = ls()[grep("^z", ls())]) #beware removes variables beginning with z