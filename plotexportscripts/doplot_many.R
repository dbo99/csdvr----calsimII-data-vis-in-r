setwd(here()) 



## annual taf bars
{dvs <- c("c406")
source("df_create.r") 



pb_mn_ann_perav_taf(df) + ggtitle("Total Delta Outflow, mean annual average")+
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
  theme(strip.text.x = element_text(size = 8)) 
setwd(here("plots", "doplot_many"))
ggsave(paste0(paste(dvs,collapse="&"), "_meanannavgbars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 

setwd(here()) 
}

## monthly taf  bar diffs
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pb_mn_ann_perav_taf_d(df_diff) + ggtitle("Total Delta Outflow, mean annual average difference from baseline")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_meanannbarsdiffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}





## annual taf stripes
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  prast_ann_ts_sum_taf(df) + ggtitle("Total Delta Outflow \n82 CalSim Water Years")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) + labs(x = "CalSim Water Year (Q5e hydrology)")
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_annsum_stripes.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

## monthly taf 
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  prast_mon_ts_taf(df) + ggtitle("Total Delta Outflow \n984 CalSim Months")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monrast.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

## annual taf diff
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  prast_ann_ts_sum_taf_d(df_diff) + ggtitle("Total Delta Outflow \n82 CalSim Water Years) [Difference from Baseline]")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8))  + labs(x = "CalSim Water Year (Q5e hydrology)")
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_annsumdiff_stripes.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}


## monthly taf diff  - rast
{dvs <- c("c406")
  source("df_create.r")
  
  
  
  prast_mon_ts_taf_d(df_diff) + ggtitle("Total Delta Outflow \n984 CalSim Months [Difference from Baseline]")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) #+ 
  #geom_tile(data = df_diff_scwyt, mapping = aes(x=wy, y=-wm), color = "green", fill = NA )
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monrastdiff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

## monthly taf diff  - tile - wet
{dvs <- c("c406")
  source("df_create.r")
   
  zdf_diff_scwyt_wt <- df_diff %>% filter(scwyt == 1)
 
  
  
  ptile_mon_ts_taf_d(df_diff) + ggtitle("Total Delta Outflow, wet year highlighted (green) \n984 CalSim Months [Difference from Baseline]")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) + 
    geom_tile(data = zdf_diff_scwyt_wt, mapping = aes(x=wy, y=-wm), color = "green", fill = NA )
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "__monrastalldiff_wet.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here()) 
}

## monthly taf diff  - tile - wet and above normal
{dvs <- c("c406")
  source("df_create.r")
   
  zdf_diff_scwyt_wt <- df_diff %>% filter(scwyt == 1)
  
  zdf_diff_scwyt_an <- df_diff %>% filter(scwyt == 2)
  
  
  ptile_mon_ts_taf_d(df_diff) + ggtitle("Total Delta Outflow, Wet (green) and Above Normal (pink) Sac WYT \n984 CalSim Months [Difference from Baseline]")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) + 
    geom_tile(data = zdf_diff_scwyt_wt, mapping = aes(x=wy, y=-wm), color = "green4", fill = NA, show.legend = TRUE )+
    geom_tile(data = zdf_diff_scwyt_an, mapping = aes(x=wy, y=-wm), color = "deeppink", fill = NA )
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "__monrastalldiff_wet&an.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here()) 
}



## monthly taf diff - wet highlight
{dvs <- c("c406")
 
  source("df_create.r")
  df_diff %<>% filter(scwyt == 1)

  
  
  prast_mon_ts_taf_d(df_diff) + ggtitle("Total Delta Outflow - Wet Sac WYT \n984 CalSim Months [Difference from Baseline]")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monrastdiff_wet.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

## monthly taf diff - an highlight
{dvs <- c("c406")
  source("df_create.r")
  df_diff %<>% filter(scwyt == 2)

  
  
  prast_mon_ts_taf_d(df_diff) + ggtitle("Total Delta Outflow - Above Normal Sac WYT \n984 CalSim Months [Difference from Baseline]")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monrastdiff_an.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

## monthly taf diff - bn highlight
{dvs <- c("c406")
  source("df_create.r")
  df_diff %<>% filter(scwyt == 3)

  
  
  prast_mon_ts_taf_d(df_diff) + ggtitle("Total Delta Outflow - Below Normal Sac WYT \n984 CalSim Months [Difference from Baseline]")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monrastdiff_bn.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}
## monthly taf diff - dry highlight
{dvs <- c("c406")
  source("df_create.r")
  df_diff %<>% filter(scwyt == 4)

  
  
  prast_mon_ts_taf_d(df_diff) + ggtitle("Total Delta Outflow - Dry Sac WYT \n984 CalSim Months [Difference from Baseline]")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monrastdiff_dry.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

## monthly taf diff - cr highlight
{dvs <- c("c406")
  source("df_create.r")
  df_diff %<>% filter(scwyt == 5)

  
  
  prast_mon_ts_taf_d(df_diff) + ggtitle("Total Delta Outflow - Critical Sac WYT \n984 CalSim Months [Difference from Baseline]")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "monrastdiff_crit.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}


### BARS ###

{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pb_mn_scwyt_perav_taf(df) + ggtitle("Total Delta Outflow \n by Sacramento Water Year Type Means")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) +
    theme(strip.text.x = element_text(size = 8)) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pb_mn_scwyt_perav_taf_d(df_diff) + ggtitle("Total Delta Outflow \n by Sacramento Water Year Type, Mean Differences From Baseline")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bars_diffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

### sequential bars ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pb_ann_fjwysum_scwyt_taf(df) + ggtitle("Total Delta Outflow \n by Sacramento Water Year Type")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_seqbars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

### sequential bars ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pb_ann_fjwysum_scwyt_taf_d(df_diff) + ggtitle("Total Delta Outflow \n by Sacramento Water Year Type, Mean Differences from Baseline")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_seqbarsdiff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}


### Excd lines ###

### month exceed wrap ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  p_monfacetw_excd_taf(df) + ggtitle("Total Delta Outflow by Month") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_cols) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monthexcdwrap.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

### month exceed wrap diff ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  p_monfacetw_excd_taf_d(df_diff) + ggtitle("Total Delta Outflow by Month, Difference from Baseline")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_diff_cols) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monthexcdwrapdiff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

### month exceed wrap ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  p_monfacetw_excd_cfs(df) + ggtitle("Total Delta Outflow by Month (cfs)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_cols) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monthexcdwrap_cfs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

### month exceed wrap diff ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  p_monfacetw_excd_cfs_d(df_diff) + ggtitle("Total Delta Outflow by Month, Difference from Baseline (cfs)")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_diff_cols) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monthexcdwrapdiff_cfs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here()) 
}




## Box plots ##

## Ann

### Ann sum ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pdp_ann_perav_wysum_taf(df,1,5) + ggtitle("Annual Total Delta Outflow, 82 CalSim years)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_cols) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_annsumbp.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

### ann sum diff ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pdp_ann_perav_wysum_taf_d(df_diff,1,5) + ggtitle("Annual Total Delta Outflow, 82 CalSim years, Difference from Baseline")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_diff_cols) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_annsumbpdiff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

## Mon
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pbp_mon_taf(df) + ggtitle("Total Delta Outflow by Month") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_cols) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monbp.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

### ann sum diff ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pbp_mon_taf_d(df_diff) + ggtitle("Total Delta Outflow by Month, Difference from Baseline")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_diff_cols) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monbpdiff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

### Ann sum ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pdr2_ann_perav_wysum_taf(df) + ggtitle("Annual Total Delta Outflow, 82 CalSim years)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_cols) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_annsumdenridge.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

### ann sum diff ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pdr2_ann_perav_wysum_taf_d(df_diff) + ggtitle("Annual Total Delta Outflow, 82 CalSim years, Difference from Baseline")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_diff_cols)
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_annsumdenridgediff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}


### Ann sum ###
{dvs <- c("c406")
  source("df_create.r") 
  
  
  
  pr_ts_taf(df, 1921, 2007, 0.000005) + ggtitle("Annual Total Delta Outflow, 82 CalSim years") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_cols) 
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_annsumridges.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here()) 
}

### ann sum diff ###
{dvs <- c("c406")
  source("df_create.r") 

  
  
  pr_ts_taf_d(df_diff, 1921, 2007, 0.0035) + ggtitle("Annual Total Delta Outflow, 82 CalSim years, Difference from Baseline")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))+ 
    scale_color_manual(values=df_diff_cols)
  setwd(here("plots", "doplot_many"))
  ggsave(paste0(paste(dvs,collapse="&"), "_annsumridgediff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  setwd(here()) 
}
  
  rm(list = ls()[grep("^z", ls())])
  setwd(here("plotexportscripts"))