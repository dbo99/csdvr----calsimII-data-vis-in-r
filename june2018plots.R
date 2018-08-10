

### Ann sum ###
dvs <- c( "c406", "del_cvp_total_n", "del_cvp_total_s", "del_swp_tot_n", "del_swp_tot_s")
df <- create_df(df_csv) 
df_diff <- create_df_diff(df)
setwd("..")
source("scenfacts.r")
pb_mn_ann_perav_taf(df) + ggtitle("Mean Annual Delta Outflow and Project Delivery, 82 CalSim years (Q5E)") +
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
setwd("./plots")
ggsave(paste0(paste(dvs,collapse="&"), "_Outflow&DelivBars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
setwd('..')
setwd("./plotexportscripts")



### Ann sum ###
dvs <- c( "c406", "del_cvp_total_n", "del_cvp_total_s", "del_swp_tot_n", "del_swp_tot_s")
  df <- create_df(df_csv) 
  df_diff <- create_df_diff(df)
  setwd("..")
  source("scenfacts.r")
  pb_mn_ann_perav_taf_d(df_diff) + ggtitle("Mean Annual Delta Outflow and Project Delivery, Difference from Baseline\n82 CalSim years (Q5E)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd("./plots")
  ggsave(paste0(paste(dvs,collapse="&"), "_Outflow&DelivBarDiffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  setwd('..')
  setwd("./plotexportscripts")


### Ann sum ###
dvs <- c( "c406", "del_cvp_total_n", "del_cvp_total_s", "del_swp_tot_n", "del_swp_tot_s")
  df <- create_df(df_csv) 
  df_diff <- create_df_diff(df)
  setwd("..")
  source("scenfacts.r")
pb_mn_scwyt_perav_taf(df) + ggtitle("Mean Annual Delta Outflow and Project Delivery Totals\n by Sac WYT, 82 CalSim years (Q5E)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) + theme(strip.text.y = element_text(angle = 0))
setwd("./plots")
  ggsave(paste0(paste(dvs,collapse="&"), "_Outflow&Deliv_scwyt_Bars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  setwd('..')
  setwd("./plotexportscripts")


dvs <- c( "c406", "del_cvp_total_n", "del_cvp_total_s", "del_swp_tot_n", "del_swp_tot_s")
  df <- create_df(df_csv) 
  df_diff <- create_df_diff(df)
  setwd("..")
  source("scenfacts.r")
  pb_mn_scwyt_perav_taf_d(df_diff) + ggtitle("Mean Annual Delta Outflow and Project Delivery Totals\n by Sac WYT,Difference from Baseline, 82 CalSim years (Q5E)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) + theme(strip.text.y = element_text(angle = 0))
  setwd("./plots")
  ggsave(paste0(paste(dvs,collapse="&"), "_Outflow&Deliv_Scwyt_BarDiffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  setwd('..')
  setwd("./plotexportscripts")
  


dvs <- c( "c406", "del_cvp_total_n", "del_cvp_total_s", "del_swp_tot_n", "del_swp_tot_s")
  df <- create_df(df_csv) 
  df_diff <- create_df_diff(df)
  setwd("..")
  source("scenfacts.r")
  pb_mn_scwyt_perav_taf(df) + ggtitle("Mean Annual Delta Outflow and Project Delivery Totals\n by Sac WYT, 82 CalSim years (Q5E)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) + theme(strip.text.y = element_text(angle = 0))
  setwd("./plots")
  ggsave(paste0(paste(dvs,collapse="&"), "_Outflow&Deliv_scwyt_Bars_r.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  setwd('..')
  setwd("./plotexportscripts")


dvs <- c( "c406", "del_cvp_total_n", "del_cvp_total_s", "del_swp_tot_n", "del_swp_tot_s")
  df <- create_df(df_csv) 
  df_diff <- create_df_diff(df)
  setwd("..")
  source("scenfacts.r")
  pb_mn_scwyt_perav_taf_d(df_diff) + ggtitle("Mean Annual Delta Outflow and Project Delivery Totals\n by Sac WYT,Difference from Baseline, 82 CalSim years (Q5E)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) + theme(strip.text.y = element_text(angle = 0))
  setwd("./plots")
  ggsave(paste0(paste(dvs,collapse="&"), "_Outflow&Deliv_Scwyt_BarDiffs_r.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  setwd('..')
  setwd("./plotexportscripts")


### Ann sum ###
dvs <- c( "del_cvp_total_n", "del_cvp_total_s", "del_swp_tot_n", "del_swp_tot_s")
  df <- create_df(df_csv) 
  df_diff <- create_df_diff(df)
  setwd("..")
  source("scenfacts.r")
  pb_mn_scwyt_perav_taf(df) + ggtitle("Mean Annual Delta Outflow and Project Delivery Totals\n by Sac WYT, 82 CalSim years (Q5E)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) + theme(strip.text.y = element_text(angle = 0))
  setwd("./plots")
  ggsave(paste0(paste(dvs,collapse="&"), "_Deliv_scwyt_Bars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  setwd('..')
  setwd("./plotexportscripts")


dvs <- c( "del_cvp_total_n", "del_cvp_total_s", "del_swp_tot_n", "del_swp_tot_s")
  df <- create_df(df_csv) 
  df_diff <- create_df_diff(df)
  setwd("..")
  source("scenfacts.r")
  pb_mn_scwyt_perav_taf_d(df_diff) + ggtitle("Mean Annual Delta Outflow and Project Delivery Totals\n by Sac WYT,Difference from Baseline, 82 CalSim years (Q5E)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) + theme(strip.text.y = element_text(angle = 0))
  setwd("./plots")
  ggsave(paste0(paste(dvs,collapse="&"), "_Deliv_Scwyt_BarDiffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  setwd('..')
  setwd("./plotexportscripts")






### Ann sum ###
dvs <- c("del_swp_tot_s", "del_swp_tot_n")
df <- create_df(df_csv) 
df_diff <- create_df_diff(df)
setwd("..")
source("scenfacts.r")
pdr_ann_perav_wysum_taf(df) + ggtitle("Annual Total NOD & SOD SWP Delivery, 82 CalSim years") +
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) + labs(y = NULL) 
  #scale_color_manual(values=df_cols) + scale_fill_manual(values=df_cols) 
#scale_fill_cyclical(breaks = c("del_swp_tot_n", "del_swp_tot_s"),
#                    labels = c(`del_swp_tot_n` = "SWP NOD", `del_swp_tot_s` = "SWP SOD"),
#                    values = c("#ff0000", "#0000ff", "#ff8080", "#8080ff"),
#                    name = "Option", guide = "legend") 
setwd("./plots")
ggsave(paste0(paste(dvs,collapse="&"), "_annsumdenridge.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
setwd('..')
setwd("./plotexportscripts")

### Ann sum ###
dvs <- c("del_cvp_total_s", "del_cvp_total_n")
  df <- create_df(df_csv) 
  df_diff <- create_df_diff(df)
  setwd("..")
  source("scenfacts.r")
  pdr_ann_perav_wysum_taf(df) + ggtitle("Annual Total NOD & SOD CVP Delivery, 82 CalSim years") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ labs(y = NULL)#+ 
  #scale_color_manual(values=df_cols) + scale_fill_manual(values=df_cols) 
  setwd("./plots")
  ggsave(paste0(paste(dvs,collapse="&"), "_annsumdenridge.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 


setwd('..')
setwd("./plotexportscripts")