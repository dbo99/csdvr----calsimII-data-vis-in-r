setwd(here()) 
## Annual ##
# Delta Outflow ## 

{dvs <- c("x2_prv")
  source("df_create.r")

  pbp_mon_x2km(df) + #ggtitle("Total Delta Outflow \n by Sacramento Water Year Type Means (82 water years)")+
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
setwd(here("plots", "cvpiax2"))
ggsave(paste0(paste(dvs,collapse="&"), "_monthlyX2boxplots.jpg"), dpi = 300, width = 17, height = 11, units = "in") 

setwd(here())
}

{dvs <- c("x2_prv")
  source("df_create.r")
  
  pbp_mon_x2km_d(df_diff) + #ggtitle("Total Delta Outflow \n by Sacramento Water Year Type Means (82 water years)")+
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
setwd(here("plots", "cvpiax2"))
ggsave(paste0(paste(dvs,collapse="&"), "_monthlyX2boxplotdiffs.jpg"), dpi = 300, width = 17, height = 11, units = "in") 
  
  setwd(here())
}


#wrap
{dvs <- c("x2_prv")
  
  source("df_create.r")
  df <- df %>%  mutate(rawval = lead(rawval,1)) %>% mutate(dv = "x2_prv(adj)")
  
  p_monfacetw_excd_km(df) + ggtitle("X2 position, 984 months") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "cvpiax2"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcdw.jpg"), dpi = 300, width = 17, height = 11, units = "in") 
  
  setwd(here())
}

{dvs <- c("x2_prv")
  
  source("df_create.r")
  df_diff <- df_diff %>%  mutate(rawval = lead(rawval,1)) %>% mutate(dv = "x2_prv(adj)")
  
  p_monfacetw_excd_km_d(df_diff) + ggtitle("X2 position (x2_prv(adj)), difference from baseline (984 months; Q5e hydrology)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "cvpiax2"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcddiffw.jpg"), dpi = 300, width = 17, height = 11, units = "in") 
  
  setwd(here())
}

#grid
{dvs <- c("x2_prv")
  
  source("df_create.r")
  df <- df %>%  mutate(rawval = lead(rawval,1)) %>% mutate(dv = "x2_prv(adj)")
  
  p_monfacetg_excd_km(df) + ggtitle("X2 position (984 months; Q5e hydrology)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "cvpiax2"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcdg.jpg"), dpi = 300, width = 17, height = 11, units = "in") 
  
  setwd(here())
}

{dvs <- c("x2_prv")
  
  source("df_create.r")
  df_diff <- df_diff %>%  mutate(rawval = lead(rawval,1)) %>% mutate(dv = "x2_prv(adj)")
  
  p_monfacetg_excd_km_d(df_diff) + ggtitle("X2 position (x2_prv(adj)), difference from baseline (984 months; Q5e hydrology)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "cvpiax2"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcddiffg.jpg"), dpi = 300, width = 17, height = 11, units = "in") 
  
  setwd(here())
}

#{dvs <- c("x2_prv")
#  
#  source("df_create.r")
#  
#  
#  pb_mn_ann_perav_km_rank(df) + ggtitle("X2 position (x2_prv(adj)) (984 months; Q5e hydrology)") +
#    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
#  setwd(here("plots", "cvpiax2"))
#  ggsave(paste0(paste(dvs,collapse="&"), "_meankmbars.jpg"), dpi = 300, width = 17, height = 11, units = "in") 
#  
#  setwd(here())
#}
#
#{dvs <- c("x2_prv")
#  
#  source("df_create.r")
# 
#  
#  pb_mn_ann_perav_km_rank_d(df) + ggtitle("X2 position (x2_prv(adj)) difference, (984 months; Q5e hydrology)") +
#    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
#  setwd(here("plots", "cvpiax2"))
#  ggsave(paste0(paste(dvs,collapse="&"), "_meankmbardiffs.jpg"), dpi = 300, width = 17, height = 11, units = "in") 
#  
#  setwd(here())
#}

## together ## 

{dvs <- c("x2_prv")
  
  source("df_create.r")
  
  
 p1 <-  pb_mn_ann_perav_km_rank(df) + ggtitle("mean X2 position (984 months; Q5e hydrology)") 


  
  
  p2 <- pb_mn_ann_perav_km_rank_d(df_diff) + ggtitle("mean X2 position, difference from baseline (984 months; Q5e hydrology)") 
  
  dvs <- c( "del_cvp_total",   "del_cvp_total_n", "del_cvp_total_s", "del_swp_total",  "del_swp_tot_n", "del_swp_tot_s")
  source("df_create.r")
  
  p3 <- pb_mn_ann_perav_taf_d_nolab_rank(df_diff) + ggtitle("mean annual delivery, difference from baseline (82 years; Q5e hydrology)") 
  dvs <- c("d418", "d419")
  source("df_create.r")
  
  p4  <- pb_mn_ann_perav_taf_d_nolab_rank(df_diff) + ggtitle("mean annual Jones(d418)/Banks(d419) pumping, difference from baseline (82 years; Q5e hydrology)") 
         
  
  plot_grid(p1, p2, p3, p4, nrow = 4, rel_heights = c(2,2, 3, 2))
  setwd(here("plots", "cvpiax2"))
  ggsave(paste0(paste(dvs,collapse="&"), "_meankmbars&diffs.jpg"), dpi = 300, width = 17, height = 11, units = "in") 
  
  setwd(here())
}



###
###
####


{dvs <- c("s1", "s4", "s8", "s11")
  source("df_create.r")
  
  pc <- p_mon_excd2_taf(df) +
    theme(legend.position = c(0.9, 0.75)) +  
    theme(plot.margin=grid::unit(c(0.5,0.5,0.5,0.5), "mm")) + scale_colour_manual(values=df_cols )  +
    scale_x_continuous(labels = c(0, 0.25, 0.5, 0.75, 1)) + ggtitle("CVP Reservoirs, End of Month Storage (984 months)")
  pc
  
  
  dvs <- c("s6", "s12")
  source("df_create.r")
  ps <- p_mon_excd2_taf(df) + ggtitle("SWP Reservoirs, End of Month Storage (984 months)") +
    theme(plot.margin=grid::unit(c(0.5,0.5,0.5,0.5), "mm")) + scale_colour_manual(values=df_cols )  +
    scale_x_continuous(labels = c(0, 0.25, 0.5, 0.75, 1)) + theme(legend.position = "none") 
  ps
  p <- plot_grid(pc, ps, nrow = 2, rel_heights = c(1,1)) 
  p
  setwd(here("plots", "cvpiax2"))
  ggsave(paste0(paste(dvs,collapse="&"), "_storagemonthly.jpg"), dpi = 300, width = 17, height = 11, units = "in")
  setwd(here())
}


####### Keep as last row below to access next possible script ##############
setwd(here("plotexportscripts"))
