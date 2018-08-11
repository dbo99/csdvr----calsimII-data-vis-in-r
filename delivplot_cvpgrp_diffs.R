
  dvs <- c("del_cvp_psc_n", "del_cvp_pmi_n", "del_cvp_pag_n", "del_cvp_prf_n","del_cvp_pex_s", "del_cvp_pmi_s", "del_cvp_pag_s", "del_cvp_prf_s")
  df <- create_df(df_csv) 
  df_diff <- create_df_diff(df)
  setwd("..")
  source("scenfacts.r")
  p <- 
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
p
setwd("./plots")
ggsave( "deliv_cvpsubgroupdiffs.jpg", dpi = 300, width = 13, height = 8, units = "in") 
p <- ggplotly(p)
htmlwidgets::saveWidget(as_widget(p), "deliv_cvpsubgroupdiffs.html")
setwd('..')
setwd("./plotexportscripts")
