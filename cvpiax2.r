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

{dvs <- c("x2_prv")
  
  source("df_create.r")
  df_diff <- df_diff %>%  mutate(rawval = lead(rawval,1)) %>% mutate(dv = "x2_prv(adj)")
  
  pb_mn_ann_perav_km_d_rank(df_diff) + ggtitle("X2 position (x2_prv(adj)), difference from baseline (984 months; Q5e hydrology)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "cvpiax2"))
  ggsave(paste0(paste(dvs,collapse="&"), "_meanannualkmdiffbars.jpg"), dpi = 300, width = 17, height = 11, units = "in") 
  
  setwd(here())
}







####### Keep as last row below to access next possible script ##############
setwd(here("plotexportscripts"))
