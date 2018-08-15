setwd(here()) 
## Annual ##
# Delta Outflow ## 

{dvs <- c("c406")
  source("df_create.r")


pb_mn_scwyt2_perav_taf(df) + ggtitle("Total Delta Outflow \n by Sacramento Water Year Type Means (82 water years)")+
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
setwd(here("plots", "july2018plots"))
ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 

setwd(here())
}

{dvs <- c("c406")
  source("df_create.r")
  
  
  pb_mn_scwyt2_perav_taf_d(df_diff) + ggtitle("Total Delta Outflow \n by Sacramento Water Year Type, Mean Differences From Baseline (82 water years)")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bars_diffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}


  
# total cvp delivery ## 

{dvs <- c("del_cvp_total_n", "del_cvp_total_s")
   
  source("df_create.r")
  
  
  pb_mn_ann_perav_taf(df)  + ggtitle("Mean Annual CVP Delivery, NOD (left) & SOD (right) (82 years)") + 
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_meanannperavbars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

{dvs <- c("del_cvp_total_n", "del_cvp_total_s")
   
  source("df_create.r")
  
  
  pb_mn_ann_perav_taf_d(df_diff)  + ggtitle("Mean Annual CVP Delivery NOD & SOD, Difference from Baseline (82 years)")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_meanannperavbars_diff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

# total cvp nod delivery ## 

{dvs <- c("del_cvp_total_n")
 
source("df_create.r")


pb_mn_scwyt2_perav_taf(df) + ggtitle("Total CVP NOD Delivery \n by Sacramento Water Year Type Means (82 water years)")+
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
setwd(here("plots", "july2018plots"))
ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 

setwd(here())
}

{dvs <- c("del_cvp_total_n")
   
  source("df_create.r")
  
  
  pb_mn_scwyt2_perav_taf_d(df_diff) + ggtitle("Total CVP NOD Delivery, Mean Differences From Baseline \n by Sacramento Water Year Type (82 water years)")
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "july2018plots"))
 ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bar_diffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
 
 setwd(here())
}

# total cvp sod delivery ## 

{dvs <- c("del_cvp_total_s")
  
  
  
  pb_mn_scwyt2_perav_taf(df) + ggtitle("Total CVP SOD Delivery\nby Sacramento Water Year Type Means (82 water years)")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

{dvs <- c("del_cvp_total_s")
   
  source("df_create.r")
  
  
  pb_mn_scwyt2_perav_taf_d(df_diff) +
  ggtitle("Total CVP SOD Delivery, Mean Differences From Baseline\nby Sacramento Water Year Type (82 water years)") +
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bar_diffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}


# total swp nod delivery ## 

{dvs <- c("del_swp_tot_n")
   
  
  

  pb_mn_scwyt2_perav_taf(df) + ggtitle("Total SWP NOD Delivery\nby Sacramento Water Year Type Means (82 water years)")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

{dvs <- c("del_swp_tot_n")
   
  source("df_create.r")
  
  
  pb_mn_scwyt2_perav_taf_d(df_diff) + ggtitle("Total SWP NOD Delivery, Mean Differences From Baseline\nby Sacramento Water Year Type(82 water years)")
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
    setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bar_diffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

# total swp sod delivery ## 

{dvs <- c("del_swp_tot_s")
   
  
  
  pb_mn_scwyt2_perav_taf(df) + ggtitle("Total SWP SOD Delivery\nby Sacramento Water Year Type Means (82 water years)")+
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bars.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

{dvs <- c("del_swp_tot_s")
   
  source("df_create.r")
  
  
  pb_mn_scwyt2_perav_taf_d(df_diff) + ggtitle("Total SWP SOD Delivery, Mean Differences From Baseline\nby Sacramento Water Year Type (82 water years)")+
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bar_diffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}


##########################
####### Monthly ##########
##########################

##  total delta outflow ##

#wrap
{dvs <- c("c406")

source("df_create.r")


p_monfacetw_excd_cfs(df) + ggtitle("Total Delta Outflow, 984 months") +
theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
setwd(here("plots", "july2018plots"))
ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcdw.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 

setwd(here())
}

{dvs <- c("c406")
   
  source("df_create.r")
  
  
  p_monfacetw_excd_cfs_d(df_diff) + ggtitle("Total Delta Outflow, 984 months, difference from baseline") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcdw_diff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

#grid
{dvs <- c("c406")
   
  source("df_create.r")
  
  
  p_monfacetg_excd_cfs(df) + ggtitle("Total Delta Outflow, 984 months") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) #+ scale_colour_manual(values=df_cols ) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcdgrid.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

{dvs <- c("c406")
   
  source("df_create.r")
  
  
  p_monfacetg_excd_cfs_d(df_diff) + ggtitle("Total Delta Outflow, 984 months, difference from baseline") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcdgrid_diff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

## OMR ##

{dvs <- c("c408")
   
  source("df_create.r")
  
  
  p_monfacetw_excd_cfs(df) + ggtitle("Old and Middle River, 984 months") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcdwrap.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

{dvs <- c("c408")
   
  source("df_create.r")
  
  

  p_monfacetw_excd_cfs_d(df_diff) + ggtitle("Old and Middle River, 984 months, difference from baseline") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcdwrap_diff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

## grid ##

{dvs <- c("c408")
   
  source("df_create.r")
  
  
  p_monfacetg_excd_cfs(df) + ggtitle("Old and Middle River, 984 months") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcdgrid.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

{dvs <- c("c408")
   
  source("df_create.r")
  
  
  ymin <- min(df$cfs)
  p_monfacetg_excd_cfs_d(df_diff) + ggtitle("Old and Middle River, 984 months,  difference from baseline") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_mongridexcdgrid_diff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

## Storage All ##  

dvs <- c("s1", "s4", "s6", "s8", "s11")
 
source("df_create.r")


p_mon_excd2_taf(df) + ggtitle("Monthly EOM Storage, 984 months") +
theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + facet_grid(~dv_name) +
  scale_x_continuous(labels = c(0, 0.25, 0.5, 0.75, 1))
setwd(here("plots", "july2018plots"))
ggsave(paste0(paste(dvs,collapse="&"), "_storagemonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 

setwd(here())



{dvs <- c("s1")
   
  source("df_create.r")
  
  
  p_mon_excd2_taf(df) + ggtitle("Trinity EOM Storage, 984 months") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_storagemonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
  }

{dvs <- c("s4")
   
  source("df_create.r")
  
  
  p_mon_excd2_taf(df) + ggtitle("Shasta EOM Storage, 984 months") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_storagemonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

{dvs <- c("s6")
   
  source("df_create.r")
  
  
  p_mon_excd2_taf(df) + ggtitle("Oroville EOM Storage, 984 months") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_storagemonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

{dvs <- c("s8")
   
  source("df_create.r")
  
  
  p_mon_excd2_taf(df) + ggtitle("Folsom EOM Storage, 984 months") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_storagemonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

{dvs <- c("s11")
   
  source("df_create.r")
  
  
  p_mon_excd2_taf(df) + ggtitle("CVP San Luis EOM Storage, 984 months") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_storagemonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  
  setwd(here())
}

## eo sept ##

## Trinity ##
{dvs <- c("s1")
 
df <- df %>% filter(wm == 12)
source("df_create.r")


p_mon_excd2_taf(df) + ggtitle("Trinity Storage, end of September (82 Septs)") +
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  
setwd(here("plots", "july2018plots"))
ggsave(paste0(paste(dvs,collapse="&"), "_eoseptmonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")

setwd(here())
}

## Shasta ##
{dvs <- c("s4")
   
  df <- df %>% filter(wm == 12)
  source("df_create.r")
  
  
  p_mon_excd2_taf(df) + ggtitle("Shasta Storage, end of September (82 Septs)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_eoseptmonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

## Oroville ##
{dvs <- c("s6")
   
  df <- df %>% filter(wm == 12)
  source("df_create.r")
  
  
  p_mon_excd2_taf(df) + ggtitle("Oroville Storage, end of September (82 Septs)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_eoseptmonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

## Folsom ##
{dvs <- c("s8")
   
  df <- df %>% filter(wm == 12)
  source("df_create.r")
  
  
  p_mon_excd2_taf(df) + ggtitle("Folsom Storage, end of September (82 Septs)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_eoseptmonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

## CVP San Luis ##
{dvs <- c("s11")
   
  df <- df %>% filter(wm == 11)
  source("df_create.r")
  
  
  p_mon_excd2_taf(df) + ggtitle("CVP San Luis Storage, end of August (82 Augs)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm")) 
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_eoseptmonthly.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}


 ## May Allocation ##

## CVP NOD Ag

{dvs <- c("perdv_cvpag_sys")
   
  df <- df %>% filter(wm == 8)
  source("df_create.r")
  
  
  p_mon_excd2_native(df) + ggtitle("CVP NOD Ag Service Allocation, May (82 Mays)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + labs(y= "percent allocation")
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_MayAlloc.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

## CVP SOD Ag

{dvs <- c("perdv_cvpag_s")
   
  df <- df %>% filter(wm == 8)
  source("df_create.r")
  
  
  p_mon_excd2_native(df) + ggtitle("CVP SOD Ag Service Allocation, May (82 Mays)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + labs(y= "percent allocation")
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_MayAlloc.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

## CVP NOD MI

{dvs <- c("perdv_cvpmi_sys")
   
  df <- df %>% filter(wm == 8)
  source("df_create.r")
  
  
  p_mon_excd2_native(df) + ggtitle("CVP NOD Project M&I, May (82 Mays)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + labs(y= "percent allocation")
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_MayAlloc.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

{dvs <- c("perdv_cvpmi_s")
   
  df <- df %>% filter(wm == 8)
  source("df_create.r")
  
  
  p_mon_excd2_native(df) + ggtitle("CVP SOD Project M&I, May (82 Mays)") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + labs(y= "percent allocation")
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_MayAlloc.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

{
dvs <- c("del_cvp_total_s")
  

  source("df_create.r")
  
  
  p_ann_fjwysum_scwyt_excd_taf(df) + ggtitle("Annual total: CVP SOD") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_2x3excdgrid.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

{
  dvs <- c("del_cvp_total_s", "del_cvp_total_n")
  
  
  source("df_create.r")
  
  
  p_ann_fjwysum_scwyt_excd_taf(df) + ggtitle("Annual totals: CVP NOD & SOD by Sac WYT") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "2x3excdgrid.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

{
  dvs <- c("del_cvp_total_s", "del_cvp_total_n")
  
  
  source("df_create.r")
  
  
  p_ann_fjwysum_scwyt_excd_taf_d(df_diff) + ggtitle("Annual total, CVP NOD & SOD by Sac WYT, difference from baseline") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_2x3excdgriddiff.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

{
  dvs <- c("del_cvp_total_s", "del_cvp_total_n")
  
  
  source("df_create.r")
  df$dv <- df$dv_name
  
  # order dv_names here. varcodes.csv defines these names - need to be in varcodes.csv first
  df$dv <- factor(df$dv, levels = c( "CVP NOD", "CVP SOD"))
  
  
  p_ann_fjwysum_scwyt_excd2_taf(df) + ggtitle("CVP NOD & SOD by Sac WYT") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + 
    theme(strip.text.y = element_text(angle = 0))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_2x3excdgrid_style2.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

{
  dvs <- c("del_cvp_total_s", "del_cvp_total_n")
  
  
  source("df_create.r")
  df_diff$dv <- df_diff$dv_name
  
  # order dv_names here. varcodes.csv defines these names - need to be in varcodes.csv first
  df_diff$dv <- factor(df_diff$dv, levels = c( "CVP NOD", "CVP SOD"))
  
  
  p_ann_fjwysum_scwyt_excd2_taf_d(df_diff)  + ggtitle("CVP NOD & SOD by Sac WYT, difference from baseline") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + 
    theme(strip.text.y = element_text(angle = 0))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_2x3excdgriddiff_style2.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}



{
  dvs <- c("d418", "d419")
  
  
  source("df_create.r")
  df$dv <- df$dv_name
  
  # order dv_names here. varcodes.csv defines these names - need to be in varcodes.csv first
  df$dv <- factor(df$dv, levels = c( "Jones Pumping (CVP)", "Banks Pumping (SWP)"))
  
  
  p_ann_fjwysum_scwyt_excd2_taf(df)  + ggtitle("Annual SOD Exports") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + 
    theme(strip.text.y = element_text(angle = 0))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_2x3excdgrid_style2.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}





{
  dvs <- c("d418", "d419")
  
  
  source("df_create.r")
  df_diff$dv <- df_diff$dv_name
  
  # order dv_names here. varcodes.csv defines these names - need to be in varcodes.csv first
  df_diff$dv <- factor(df_diff$dv, levels = c( "Jones Pumping (CVP)", "Banks Pumping (SWP)"))
  
  
  p_ann_fjwysum_scwyt_excd2_taf_d(df_diff)  + ggtitle("Annual SOD Exports, difference from baseline") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + 
    theme(strip.text.y = element_text(angle = 0))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_2x3excdgriddiff_style2.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

{
  dvs <- c("d418")
  
  
  source("df_create.r")
  df_diff$dv <- df_diff$dv_name
  
  # order dv_names here. varcodes.csv defines these names - need to be in varcodes.csv first
  df_diff$dv <- factor(df_diff$dv, levels = c( "Jones Pumping (CVP)"))
  
  
  pr_ts_taf_d(df_diff, 1921, 2007, 0.005)  + ggtitle("Jones Pumping, difference from baseline") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + 
    theme(strip.text.y = element_text(angle = 0))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_ridgediffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

{dvs <- c("d419")


source("df_create.r")
df_diff$dv <- df_diff$dv_name

# order dv_names here. varcodes.csv defines these names - need to be in varcodes.csv first
df_diff$dv <- factor(df_diff$dv, levels = c( "Banks Pumping (CVP)"))


pr_ts_taf_d(df_diff, 1921, 2007, 0.005)  + ggtitle("Banks Pumping, difference from baseline") +
  theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + 
  theme(strip.text.y = element_text(angle = 0))
setwd(here("plots", "july2018plots"))
ggsave(paste0(paste(dvs,collapse="&"), "_ridgediffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")

setwd(here())
}

{
  dvs <- c("d418")
  
  
  source("df_create.r")
  df_diff$dv <- df_diff$dv_name
  
  # order dv_names here. varcodes.csv defines these names - need to be in varcodes.csv first
  df_diff$dv <- factor(df_diff$dv, levels = c( "Jones Pumping (CVP)"))
  
  
  prast_mon_ts_taf_d(df_diff)  + ggtitle("Jones Pumping, difference from baseline") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + 
    theme(strip.text.y = element_text(angle = 0))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_monrastdiffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}

{
  dvs <- c("d418")
  
  
  source("df_create.r")
  df_diff$dv <- df_diff$dv_name
  
  # order dv_names here. varcodes.csv defines these names - need to be in varcodes.csv first
  df_diff$dv <- factor(df_diff$dv, levels = c( "Jones Pumping (CVP)"))
  
  
  prast_ann_ts_sum_taf_d(df_diff)  + ggtitle("Annual Jones Pumping, difference from baseline") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + 
    theme(strip.text.y = element_text(angle = 0))
  setwd(here("plots", "july2018plots"))
  ggsave(paste0(paste(dvs,collapse="&"), "_annrastdiffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in")
  
  setwd(here())
}





{
  dvs <- c("s1", "s4", "s8", "s11")
  
  
  source("df_create.r")
  df$dv <- df$dv_name
  
  # order dv_names here. varcodes.csv defines these names - need to be in varcodes.csv first
  df$dv <- factor(df$dv, levels = c( "Trinity (CVP)", "Shasta (CVP)", "Folsom (CVP)", "CVP San Luis"))
  
  
  z <- p_mon_ts_taf(df, 1921, 2004)   + ggtitle("NOD & CVP San Luis Storage") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + 
    theme(strip.text.y = element_text(angle = 0))
  setwd(here("plots", "july2018plots"))
  z
  ggsave(paste0(paste(dvs,collapse="&"), "_mon_timeseries_taf.jpg"), dpi = 300, width = 49.99, height = 13, units = "in")
  
 
z

z <- ggplotly(z)
htmlwidgets::saveWidget(as_widget(z), paste0(paste(dvs,collapse="&"), "_mon_timeseries_taf.html"))
setwd(here())
rm(list = ls()[grep("^z", ls())]) #beware removes variables beginning with z

}

{
  dvs <- c("s1", "s4", "s8", "s11")
  
  
  source("df_create.r")
  #df_diff$dv <- df_diff$dv_name
  #
  ## order dv_names here. varcodes.csv defines these names - need to be in varcodes.csv first
  #df_diff$dv <- factor(df_diff$dv, levels = c( "Trinity (CVP)", "Shasta (CVP)", "Folsom (CVP)", "CVP San Luis"))
  
  
  z <- p_mon_ts_taf_d(df_diff, 1921, 2004)   + ggtitle("NOD & CVP San Luis Storage, Difference") +
    theme(plot.margin=grid::unit(c(6,6,6,6), "mm"))  + 
    theme(strip.text.y = element_text(angle = 0))
  setwd(here("plots", "july2018plots"))
  z
  ggsave(paste0(paste(dvs,collapse="&"), "_mon_timeseries_taf_diff.jpg"), dpi = 300, width = 49.99, height = 13, units = "in")
  
  
  z
  
  z <- ggplotly(z)
  htmlwidgets::saveWidget(as_widget(z), paste0(paste(dvs,collapse="&"), "_mon_timeseries_taf_diff.html"))
  setwd(here())
  rm(list = ls()[grep("^z", ls())]) #beware removes variables beginning with z
  
}




####### Last Row below ##############
setwd(here("plotexportscripts"))
