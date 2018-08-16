### Function Definitions ###

#####################################
### year and month classifications ##
#####################################

water_year <- function(date) {
  ifelse(month(date) < 10, year(date), year(date)+1)}

water_month <-function(date) {
  ifelse(month(date) < 10, month(date)+3, month(date)-9)}

fx2_month <-function(date) {
  ifelse(month(date) < 9, month(date)+4, month(date)-8)}

febjanwy <- function(date) {  
  ifelse(month(date) > 1, year(date), year(date)-1)}

marfebwy <- function(date){    #typical cvp contract year
  ifelse(month(date) > 2, year(date), year(date)-1)}

jandecwy <- function(date){  year(date)} 

fx2sepaugwy<- function(date) {
  ifelse(month(date) > 8, year(date), year(date)-1)}

sepaugwy <- function(date) {
  ifelse(month(date) < 9, year(date), year(date)+1)}

cfs_taf <- function(cfs,tstep) {cfs*1.98347*days_in_month(tstep)/1000}
taf_cfs <- function(taf,tstep) {taf*1000/(1.98347*days_in_month(tstep))}


#################################
#################################
#####   data.frame create   #####
#################################
#################################

create_df <-function(df_csv){
  df <- df_csv %>% filter(Variable %in% dvs) %>%  transmute(scen = as.factor(scen), tstep = Date_Time,
        wy = water_year(tstep), fjwy = febjanwy(tstep), mfwy = marfebwy(tstep), jdwy = year(tstep),
        wm = water_month(tstep), m = month(tstep), tstep,  dv = Variable, kind = Kind, 
        rawunit = Units, rawval = Value, mon = month.abb[m]  ,
        taf = ifelse(rawunit == "cfs", cfs_taf(rawval,tstep), ifelse(rawunit == "taf", rawval, NA)),
        cfs = ifelse(rawunit == "taf", taf_cfs(rawval,tstep), ifelse(rawunit == "cfs", rawval, NA)), 
        yearmon = as.yearmon(tstep), tstep = ymd(tstep)) %>% filter(wy >= 1922) #ignore any pre-Oct-'21 data
  
     wyt <- read_csv("wyt.csv") %>% mutate(tstep = mdy(tstep)) #makes sure date reads in as date
     scwyt_txt <- data.frame("scwyt" = c(1,2,3,4,5), "scwytt"=c("wt", "an", "bn", "dr", "cr"))
     sjwyt_txt <- data.frame("sjwyt" = c(1,2,3,4,5), "sjwytt"=c("wt", "an", "bn", "dr", "cr"))
  
  df <- df %>% inner_join(wyt) %>% inner_join(scwyt_txt) %>% inner_join(sjwyt_txt) %>%
    mutate(scwyt_scwytt = paste0(scwyt, "_", scwytt), sjwyt_sjwytt = paste0(sjwyt, "_", sjwytt))  %>%
    mutate(scwyt = as.integer(scwyt), sjwyt = as.integer(sjwyt)) 
  
  df <- df %>%  mutate(nxtscwyt = lead(scwyt,5)) %>% 
    mutate(nxtscwytt = ifelse(nxtscwyt == 1, "wt", ifelse(nxtscwyt == 2, "an", ifelse(nxtscwyt == 3, "bn", ifelse(nxtscwyt == 4, "dr", 
    ifelse(nxtscwyt ==5, "cr", NA))))))  %>% mutate(scwyt2 = paste0(nxtscwyt, "_", nxtscwytt))
  
  varcode <- read_csv("varcodes.csv")
  df <- df %>% left_join(varcode) 

  df <- df %>% mutate(dv_name = ifelse(is.na(dv_name), dv, dv_name))
  
  lastwyt <- df %>% filter(scen == "baseline", yearmon == "Apr 2003") %>% select(scwyt2) 
  lastwyt <- lastwyt[1,]
  df <- df %>% mutate(scwyt2 = ifelse(scwyt2 == "NA_NA", lastwyt, scwyt2 )) 
  
}


create_df_diff <-function(df){
  baseline_df <- df %>% filter(scen == "baseline") %>% mutate(id = row_number())

  df_diff <- df %>% select(scen, taf, cfs, rawval) %>% group_by(scen) %>% mutate(id = row_number()) %>% 
    left_join(baseline_df, by = "id", suffix = c("_scen", "_bl")) %>%  ungroup() %>%
    mutate(taf = taf_scen - taf_bl, cfs = cfs_scen - cfs_bl, rawval = rawval_scen - rawval_bl, scen = paste0(scen_scen," - bl")) %>%
    select(-scen_scen, -scen_bl) %>%
    filter(scen != "baseline - bl")
  
  
   wyt <- read_csv("wyt.csv") %>% mutate(tstep = mdy(tstep)) #makes sure date reads in as date
   scwyt_txt <- data.frame("scwyt" = c(1,2,3,4,5), "scwytt"=c("wt", "an", "bn", "dr", "cr"))
   sjwyt_txt <- data.frame("sjwyt" = c(1,2,3,4,5), "sjwytt"=c("wt", "an", "bn", "dr", "cr"))
  
  df_diff  <- df_diff %>% inner_join(wyt) %>% inner_join(scwyt_txt) %>% inner_join(sjwyt_txt) %>%
    mutate(scwyt_scwytt = paste0(scwyt, "_", scwytt), sjwyt_sjwytt = paste0(sjwyt, "_", sjwytt)) %>%
    mutate(scwyt = as.integer(scwyt), sjwyt = as.integer(sjwyt)) 
  
  df_diff <- df_diff %>%  mutate(nxtscwyt = lead(scwyt,5)) %>%
    mutate(nxtscwytt = ifelse(nxtscwyt == 1, "wt", ifelse(nxtscwyt == 2, "an", ifelse(nxtscwyt == 3, "bn", ifelse(nxtscwyt == 4, "dr", 
                       ifelse(nxtscwyt ==5, "cr", NA))))))  %>% mutate(scwyt2 = paste0(nxtscwyt, "_", nxtscwytt))
  
  lastwyt_d <- df_diff %>% filter(yearmon == "Apr 2003") %>% select(scwyt2) #no baseline in df_diff, start w/df
  lastwyt_d <- lastwyt_d[1,]
  df_diff <- df_diff %>% mutate(scwyt2 = ifelse(scwyt2 == "NA_NA", lastwyt_d, scwyt2 ))
  

}

################################
## add spec. scen data frame ###  #adds fall x2 attributes for fall to spring (set below at five (5) month period of interest
################################  #IDs wy change, ie from this year type to that & other related fields


create_fallx2_df <- function(df) {
  df_fallx2 <- df %>% mutate(fx2spagwy = fx2sepaugwy(tstep), spagwy = sepaugwy(tstep)) %>% filter(spagwy>1922, spagwy<2003) %>%
    mutate(nxtscwyt = lead(scwyt,5)) %>%
    mutate(nxtscwytt = ifelse(nxtscwyt == 1, "wt", ifelse(nxtscwyt == 2, "an", ifelse(nxtscwyt == 3, "bn", ifelse(nxtscwyt == 4, "dr", 
    ifelse(nxtscwyt ==5, "cr", NA)))))) %>%
    mutate(fx2yt = ifelse(m == 9  & scwyt == 1, "wt", ifelse(m == 9 & scwyt == 2, "an", NA))) %>%
    group_by(grp = cumsum(!is.na(fx2yt))) %>% mutate(fx2yt = replace(fx2yt, 2:pmin(9,n()), fx2yt[1])) %>% ungroup %>% select(-grp) %>%
    mutate(fx2ytn = ifelse(fx2yt == "wt", 1, ifelse(fx2yt == "an", "2", NA))) %>%
    mutate(facet = ifelse(fx2ytn >0, paste0(fx2yt, fx2spagwy, "_", nxtscwytt, spagwy), NA))%>%
    mutate(facet2 = ifelse(fx2ytn >0, paste0(fx2ytn, "_",  nxtscwyt,"_", fx2spagwy, "_", spagwy), NA)) 
  df_fallx2
}

########################################################################
## reordering functions for ranking within facets ######################
########################################################################

reorder_within <- function(x, by, within, fun = mean, sep = "___", ...) {
  new_x <- paste(x, within, sep = sep)
  stats::reorder(new_x, by, FUN = fun)
}

scale_x_reordered <- function(..., sep = "___") {
  reg <- paste0(sep, ".+$")
  ggplot2::scale_x_discrete(labels = function(x) gsub(reg, "", x), ...)
}

scale_y_reordered <- function(..., sep = "___") {
  reg <- paste0(sep, ".+$")
  ggplot2::scale_y_discrete(labels = function(x) gsub(reg, "", x), ...)
}

###################
### Misc. functions
###################


addxtoy_csv <- function(csv, dvx, dvy) {  #overwrites y - addxtoy_asz, other derived timeseries operators coming soon - for df data.frame though, not df_csv
 
  assignxasy <- csv %>% filter(Variable == paste(dvx)) %>%
                        mutate(Variable = paste(dvy)) 

  setDT(csv)
  setDT(assignxasy)
  ##add y2 to y1 by matching 
  csv[assignxasy, Value := Value + i.Value, on=.(Date_Time, Variable, scen)]
  
}


#################################
#################################
###  Data Summarizing Funs # ####  #makes tables not plots. plot functions are below these.
#################################
#################################

## Ann Avgs
mn_ann_perav_taf<- function(df) {
mnanntaf_perav <- df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  round(12*mean(taf),0)) %>%
  spread(dv, mnanntaf_perav)
 print(mnanntaf_perav)
}  

mn_ann_eomstor_taf <- function(df) {
mnanntaf_eomstor <- df %>% filter(kind == "storage") %>% group_by(dv, scen) %>% summarize(mnanntaf_eomstor =  round(mean(taf), 0)) %>% 
  spread(dv, mnanntaf_eomstor)
  print(mnanntaf_eomstor)
}

md_ann_perav_taf <- function(df) {
mdannwytaf_perav <-  df %>% filter(!kind == "storage") %>% group_by(dv, scen, wy) %>% summarize(sumperavtaf = sum(taf)) %>%
summarize(mdannwytaf_perav = round(median(sumperavtaf),0)) %>% spread(dv,mdannwytaf_perav )
print(mdannwytaf_perav)
}

mn_ann_perav_native <- function(df) {
  mn_ann_perav_native <- df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnannnat_perav =  round(12*mean(rawval),0)) %>%
    spread(dv, mnannnat_perav)
  print(mn_ann_perav_native)
}  

md_ann_perav_native <- function(df) {
  md_ann_perav_native <-  df %>% filter(!kind == "storage") %>% group_by(dv, scen, wy) %>% summarize(sumperavnat = sum(rawval)) %>%
    summarize(mdannwynat_perav = round(median(sumperavnat),0)) %>% spread(dv,mdannwynat_perav )
  print(md_ann_perav_native)
}

## End of May, Sept
eo_may_stor_taf <- function(df) {
  eo_may_stor <- df %>% filter(kind == "storage", m== 5) %>% group_by(dv, scen) %>% summarize(eo_may_stor =  round(mean(taf), 0)) %>%
  spread(dv, eo_may_stor )
  print(eo_may_stor)
}

eo_sep_stor_taf <- function(df) {
  eo_sep_stor <- df %>% filter(kind == "storage", m== 9) %>% group_by(dv, scen) %>% summarize(eo_sep_stor =  round(mean(taf), 0)) %>%
  spread(dv, eo_sep_stor )
  print(eo_sep_stor)
}

## Max, Min monthly
max_mon_native <- function(df) {
  maxmonrawval <- df  %>% group_by(dv, scen) %>% summarize(maxmonval=  round(max(rawval), 0)) %>% spread(dv, maxmonval)
  print(maxmonrawval)
}

min_mon_native <- function(df) {
  maxmonrawval <- df  %>% group_by(dv, scen) %>% summarize(minmonval =  round(min(rawval), 0)) %>% spread(dv, minmonval)
  print(maxmonrawval)
}

## WYT means

mn_ann_scwyt_perav_taf <- function(df) {
  mnanntaf_perav_wyt <- df %>% filter(!kind == "storage", fjwy>1921, fjwy<2003) %>% group_by(dv, scen, scwyt_scwytt) %>%
  summarize(mnanntaf_perav_wyt =  round(12*mean(taf),0)) %>% spread(scwyt_scwytt, mnanntaf_perav_wyt)
  print(mnanntaf_perav_wyt)
} 

mn_ann_perav_sjwyt_taf <- function(df) {
  mnanntaf_perav_wyt <- df %>% filter(!kind == "storage", fjwy>1921, fjwy<2003) %>% group_by(dv, scen, sjwyt_sjwytt) %>%
  summarize(mnanntaf_perav_wyt =  round(12*mean(taf),0)) %>% spread(sjwyt_sjwytt, mnanntaf_perav_wyt)
  print(mnanntaf_perav_wyt)
} 

## ID timesteps under/over a value

showtstepsallscensunder <- function(df, limit) {  #for single DV only!
  findDVtstepsunder <- df %>% group_by(tstep) %>% 
    filter(all(rawval < limit)) %>% ungroup() %>% transmute(tstep, scen, rawval) %>%  spread(tstep, rawval)
  print(findDVtstepsunder)
}

showtstepsallscensover <- function(df, limit) {   #for single DV only!
  findDVtstepsunder <- df %>% group_by(tstep) %>% 
    filter(all(rawval > limit)) %>% ungroup() %>% transmute(tstep, scen, rawval) %>%  spread(tstep, rawval)
  print(findDVtstepsunder)
}

## all timesteps in period of record (984 for CSII)

mn984_taf <- function(df) {
 mn984 <- df %>% group_by(dv,scen) %>% summarize(mean984 = mean(taf)) %>% spread(dv,mean984)
 print(mn984)
}

sum984_taf <- function(df) {
  sum984 <- df %>% group_by(dv,scen) %>% summarize(sum984 = sum(taf)) %>% spread(dv,sum984)
  print(sum984)
}


#######################################
#######################################
########  plotting functions   ########  # general order top to bottom is basic bar plots, timeseries line plots, exceedance lines and bars, 
#######################################  # tiles/ridges timeseries, bell-shape pdf functions. "_d" suffix denotes a plot of differences.
#######################################


##### annual stats ######

## Ann Avgs
# plot bars of mean annual period average ("flow") in taf  # doesn't allow storage dvs
pb_mn_ann_perav_taf <- function(df) {
df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  12*mean(taf))  %>%
ggplot(aes(x = scen, y = mnanntaf_perav, fill = scen, label = round(mnanntaf_perav, 0))) + geom_bar(position = "dodge",stat = "identity") + 
     theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
     ylab("taf") + geom_text(color = "dark blue", angle = 90, hjust = 1) + 
    facet_grid(~dv) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    #theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
    scale_y_continuous(sec.axis = dup_axis(name = NULL) )+
    scale_fill_manual(values=df_cols) +
    ggtitle("mean annual (82 yrs)")
  } 

pb_mn_ann_perav_taf_rank <- function(df) {
  df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  12*mean(taf))  %>%
    ggplot(aes(x = reorder_within(scen, -mnanntaf_perav, dv), y = mnanntaf_perav, fill = scen, label = round(mnanntaf_perav, 0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf") + geom_text(color = "dark blue", angle = 90, hjust = 1) + 
    scale_x_reordered() +
    facet_wrap(~dv, nrow = 1, scales = "free_x") +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    #theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
    scale_y_continuous(sec.axis = dup_axis(name = NULL) )+
    scale_fill_manual(values=df_cols) +
    ggtitle("mean annual (82 yrs)")
}


pb_mn_ann_perav_taf_hlab <- function(df) {
  df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  12*mean(taf))  %>%
    ggplot(aes(x = scen, y = mnanntaf_perav, fill = scen, label = round(mnanntaf_perav, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf") + geom_text(color = "dark blue", angle = 0, vjust = 0.5) + 
    facet_grid(~dv) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    #theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
    scale_y_continuous(sec.axis = dup_axis(name = NULL) )+
    ggtitle("mean annual (82 yrs)") + scale_fill_manual(values=df_cols)
} 

pb_mn_ann_perav_taf_nolab <- function(df) {
  df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  12*mean(taf))  %>%
    ggplot(aes(x = scen, y = mnanntaf_perav, fill = scen, label = round(mnanntaf_perav, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf") + 
    facet_grid(~dv) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    #theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
    scale_y_continuous(sec.axis = dup_axis(name = NULL) )+
    ggtitle("mean annual (82 yrs)") + scale_fill_manual(values=df_cols)
}

pb_mn_ann_perav_taf_nolab_rank <- function(df) {
  df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  12*mean(taf))  %>%
    ggplot(aes(x = reorder_within(scen, -mnanntaf_perav, dv), y = mnanntaf_perav, fill = scen, label = round(mnanntaf_perav, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf") + 
    scale_x_reordered() +
    facet_wrap(~dv, nrow = 1, scales = "free_x") +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    #theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
    scale_y_continuous(sec.axis = dup_axis(name = NULL) )+
    scale_fill_manual(values = df_cols)+
    ggtitle("mean annual (82 yrs)")
}



#plot bars mean annual eom stor  #rarely tells much
pb_mn_ann_eomstor_taf <- function(df) {
df %>% filter(kind == "storage") %>% group_by(dv, scen) %>% summarize(mnanntaf_eomstor =  mean(taf)) %>%
    ggplot(aes(x = scen, y = mnanntaf_eomstor,   fill = scen, label = round(mnanntaf_eomstor, 0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("mean annual eom taf") + geom_text(color = "dark blue", angle = 90) + facet_grid(~dv)  +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("mean annual storage (82 yrs)") + scale_fill_manual(values=df_cols)
}

#plot bars median annual
pb_md_ann_perav_taf <- function(df) {
df %>% filter(!kind == "storage") %>% group_by(dv, scen, wy) %>% summarize(sumperavtaf = sum(taf)) %>%
  summarize(mdannwytaf_perav = median(sumperavtaf)) %>% 
  ggplot(aes(x = scen, y = mdannwytaf_perav, fill = scen, label = round(mdannwytaf_perav, 0))) + geom_bar(position = "dodge",stat = "identity") + 
  theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+
    ylab("median annual") + geom_text(color = "dark blue", angle = 90) + facet_grid(~dv) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("median annual (82 yrs)") + scale_fill_manual(values=df_cols)
}


### WYT Avgs ###

# sac water year type
pb_mn_scwyt_perav_taf <- function(df) {
  df %>% filter(!kind == "storage", fjwy>1921, fjwy<2003) %>% group_by(dv, scen, scwyt_scwytt) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
  ggplot(aes(x = scwyt_scwytt, y = mnanntaf_perav_wyt, fill = scwyt_scwytt, label = round(mnanntaf_perav_wyt,0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf") + 
    geom_text(color = "dark blue", angle = 90) +
    ggtitle("81 feb-jan totals") +
    facet_grid(dv~scen) +
    theme(axis.title.x=element_blank()) + 
    scale_fill_manual(values=wyt_cols, name = "sac wyt") + 
    theme(strip.text.y = element_text(angle = 0))+ 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) 
} 

pb_mn_scwyt_perav_taf_nolab <- function(df) {
  df %>% filter(!kind == "storage", fjwy>1921, fjwy<2003) %>% group_by(dv, scen, scwyt_scwytt) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
    ggplot(aes(x = scwyt_scwytt, y = mnanntaf_perav_wyt, fill = scwyt_scwytt, label = round(mnanntaf_perav_wyt,0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf") + 
    ggtitle("81 feb-jan totals") +
    facet_grid(dv~scen) +
    scale_fill_manual(values=wyt_cols, name = "sac wyt") + theme(axis.title.x=element_blank()) + 
    theme(strip.text.y = element_text(angle = 0)) + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) 
} 

#san joaquin water year type
pb_mn_sjwyt_perav_taf <- function(df) {
  df %>% filter(!kind == "storage", fjwy>1921, fjwy<2003) %>% group_by(dv, scen, sjwyt_sjwytt) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
    ggplot(aes(x = sjwyt_sjwytt, y = mnanntaf_perav_wyt, fill = sjwyt_sjwytt, label = round(mnanntaf_perav_wyt,0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("mean sj wyt per avg taf") + geom_text(color = "dark blue", angle = 90) +facet_grid(dv~scen) +ggtitle("81 feb-jan totals")+
    scale_fill_discrete(name = "sj wyt") + theme(axis.title.x=element_blank()) + 
    scale_fill_manual(values=wyt_cols, name = "sj wyt") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) 
} 

pb_mn_scwyt2_perav_taf <- function(df) {  #coerces feb-jan water years to regular water years
  df %>% filter(!kind == "storage") %>% mutate(scwyt2 = as.character(scwyt2)) %>% group_by(dv, scen, scwyt2) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
    ggplot(aes(x = scwyt2, y = mnanntaf_perav_wyt, fill = scwyt2, label = round(mnanntaf_perav_wyt,0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf") + 
    #geom_text(color = "dark blue", angle = 90) +
    facet_grid(dv~scen) +ggtitle("mean annual vol. by sac 8RI wyt adj (82 yrs)") +
    scale_fill_discrete(name = "sac wyt") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    scale_y_continuous(expand = c(0.01,0.01)) + 
    scale_fill_manual(values=wyt_cols, name = "sac wyt")
}
#### month specific ####

pb_mn_eomay_stor_taf <- function(df) {
  df %>% filter(kind == "storage", m == 5) %>% group_by(dv, scen) %>% summarize(eo_sep_stor =  round(mean(taf), 0)) %>% 
    ggplot(aes(x = scen, y = eo_sep_stor , fill = scen, label = round(eo_sep_stor, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+
    ylab("eo may avg taf") + geom_text(color = "dark blue", angle = 90) + facet_grid(~dv) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("mean eo may storage (82 yrs)") + scale_fill_manual(values=df_cols) 
}
pb_mn_eosep_stor_taf <- function(df) {
  df %>% filter(kind == "storage", m == 9) %>% group_by(dv, scen) %>% summarize(eo_may_stor =  round(mean(taf), 0)) %>% 
    ggplot(aes(x = scen, y = eo_may_stor,  fill = scen, label = round(eo_may_stor, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+
    ylab("eo sept avg taf") + geom_text(color = "dark blue", angle = 90)  + facet_grid(~dv)+
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("mean eo sept. storage (82 yrs)") + scale_fill_manual(values=df_cols)
}


######
### Difference 
######

pb_mn_ann_perav_taf_d <- function(df) {
df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  12*mean(taf))  %>%
    ggplot(aes(x = scen, y = mnanntaf_perav, fill = scen, label = round(mnanntaf_perav, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf [difference]")  + geom_text(color = "dark blue", angle = 90, hjust = 1)+
    facet_grid(~dv) + 
    scale_y_continuous(sec.axis = dup_axis(name = NULL) )+
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("mean annual difference (82 yrs)") + scale_fill_manual(values=df_diff_cols)
} 



pb_mn_ann_perav_taf_d_rank <- function(df) {
  df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  12*mean(taf))  %>%
    ggplot(aes(x = reorder_within(scen, -mnanntaf_perav, dv), y = mnanntaf_perav, fill = scen, label = round(mnanntaf_perav, 0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf") + geom_text(color = "dark blue", angle = 90, hjust = 1) + 
    scale_x_reordered() +
    facet_wrap(~dv, nrow = 1, scales = "free_x") +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    #theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
    scale_y_continuous(sec.axis = dup_axis(name = NULL) )+
    scale_fill_manual(values=df_cols) +
    ggtitle("mean annual difference (82 yrs)")
}

pb_mn_ann_perav_taf_d_hlab <- function(df) {
  df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  12*mean(taf))  %>%
    ggplot(aes(x = scen, y = mnanntaf_perav, fill = scen, label = round(mnanntaf_perav, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf [difference]")  + geom_text(color = "dark blue", angle = 0, vjust = 0.5)+
    facet_grid(~dv) + 
    scale_y_continuous(sec.axis = dup_axis(name = NULL) )+
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("mean annual difference (82 yrs)") + scale_fill_manual(values=df_diff_cols)
} 


pb_mn_ann_perav_taf_d_nolab <- function(df) {
  df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  12*mean(taf))  %>%
    ggplot(aes(x = scen, y = mnanntaf_perav, fill = scen, label = round(mnanntaf_perav, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf [difference]")  + 
    facet_grid(~dv) + 
    scale_y_continuous(sec.axis = dup_axis(name = NULL) )+
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("mean annual difference (82 yrs)") + scale_fill_manual(values=df_diff_cols)
} 

pb_mn_ann_perav_taf_d_nolab_rank <- function(df) {
  df %>% filter(!kind == "storage") %>% group_by(dv, scen) %>%  summarize(mnanntaf_perav =  12*mean(taf))  %>%
    ggplot(aes(x = reorder_within(scen, -mnanntaf_perav, dv), y = mnanntaf_perav, fill = scen, label = round(mnanntaf_perav, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf [difference]") + 
    scale_x_reordered() +
    facet_wrap(~dv, nrow = 1, scales = "free_x") +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    #theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
    scale_y_continuous(sec.axis = dup_axis(name = NULL) )+
    ggtitle("mean annual difference (82 yrs)") + scale_fill_manual(values=df_diff_cols)
}

pb_mn_ann_eomstor_taf_d <- function(df) {
df %>% filter(kind == "storage") %>% group_by(dv, scen) %>% summarize(mnanntaf_eomstor =  mean(taf)) %>%
    ggplot(aes(x = scen, y = mnanntaf_eomstor, fill = scen, label = round(mnanntaf_eomstor, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("mean annual eom taf [difference]") + geom_text(color = "dark blue", angle = 90)+ facet_grid(~dv) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("mean ann. storage difference (82 yrs)") + scale_fill_manual(values=df_diff_cols)
}

pb_md_ann_perav_taf_d <- function(df) {
df %>% filter(!kind == "storage") %>% group_by(dv, scen, wy) %>% summarize(sumperavtaf = sum(taf)) %>%
    summarize(mdannwytaf_perav = median(sumperavtaf)) %>% 
    ggplot(aes(x = scen, y = mdannwytaf_perav, fill = scen, label = round(mdannwytaf_perav, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf [difference]") + geom_text(color = "dark blue", angle = 90)+ facet_grid(~dv) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("median annual difference (82 yrs)") + scale_fill_manual(values=df_diff_cols)
}

pb_mn_scwyt_perav_taf_d <- function(df) {
  df %>% filter(!kind == "storage", fjwy>1921, fjwy<2003) %>% group_by(dv, scen, scwyt_scwytt) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
    ggplot(aes(x = scwyt_scwytt, y = mnanntaf_perav_wyt, fill = scwyt_scwytt, label = round(mnanntaf_perav_wyt,0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf [difference]") + 
    geom_text(color = "dark blue", angle = 90) +
    facet_grid(dv~scen) +
    #facet_grid(scen~dv) +
    ggtitle("mean sac wyt annual difference (82 yrs)") +
    scale_fill_discrete(name = "sac wyt")   +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    scale_fill_manual(values=wyt_cols) + 
    theme(strip.text.y = element_text(angle = 0)) 
} 

pb_mn_scwyt_perav_taf_d_nolab <- function(df) {
  df %>% filter(!kind == "storage", fjwy>1921, fjwy<2003) %>% group_by(dv, scen, scwyt_scwytt) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
    ggplot(aes(x = scwyt_scwytt, y = mnanntaf_perav_wyt, fill = scwyt_scwytt, label = round(mnanntaf_perav_wyt,0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf [difference]") + 
    #geom_text(color = "dark blue", angle = 90) +
    facet_grid(dv~scen) +
    #facet_grid(scen~dv) +
    ggtitle("mean sac wyt annual difference (82 yrs)") +
    scale_fill_manual(values=wyt_cols, name = "sac wyt")   +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    theme(strip.text.y = element_text(angle = 0)) 
} 

pb_mn_scwyt_perav_taf_d_hlab <- function(df) {
  df %>% filter(!kind == "storage", fjwy>1921, fjwy<2003) %>% group_by(dv, scen, scwyt_scwytt) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
    ggplot(aes(x = scwyt_scwytt, y = mnanntaf_perav_wyt, fill = scwyt_scwytt, label = round(mnanntaf_perav_wyt,0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf [difference]") + 
    geom_text(color = "dark blue", angle = 0, vjust = 1) +
    facet_grid(dv~scen) +
    #facet_grid(scen~dv) +
    ggtitle("mean sac wyt annual difference (82 yrs)") + 
    scale_fill_manual(values=wyt_cols, name = "sac wyt")   +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    theme(strip.text.y = element_text(angle = 0)) 
} 


pb_mn_sjwyt_perav_taf_d <- function(df) {
  df %>% filter(!kind == "storage", fjwy>1921, fjwy<2003) %>% group_by(dv, scen, sjwyt_sjwytt) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
    ggplot(aes(x = sjwyt_sjwytt, y = mnanntaf_perav_wyt, fill = sjwyt_sjwytt, label = round(mnanntaf_perav_wyt,0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf [difference]") + geom_text(color = "dark blue", angle = 90) +facet_grid(dv~scen) +
    ggtitle("mean sj wyt difference (82 yrs)")+ 
    scale_fill_manual(values=wyt_cols, name = "sj wyt")  +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    theme(strip.text.y = element_text(angle = 0)) 
} 

pb_mn_scwyt2_perav_taf_d <- function(df) {
  df %>% filter(!kind == "storage") %>% mutate(scwyt2 = as.character(scwyt2)) %>% group_by(dv, scen, scwyt2) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
    ggplot(aes(x = scwyt2, y = mnanntaf_perav_wyt, fill = scwyt2, label = round(mnanntaf_perav_wyt,0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf [difference]") + 
    #geom_text(color = "dark blue", angle = 90) +
    facet_grid(dv~scen) +ggtitle(paste0(df$dv[1]), " mean annual difference by sac. 8RI wyt (82 yrs)") + 
    scale_fill_manual(values=wyt_cols, name = "sac wyt") + theme(axis.title.x=element_blank()) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    scale_y_continuous(expand = c(0.01,0.01)) + 
    theme(strip.text.y = element_text(angle = 0)) 
}


#### month specific difference ####

pb_eosep_stor_taf_d <- function(df) {
   df %>% filter(kind == "storage", m== 9) %>% group_by(dv, scen) %>% summarize(eo_sep_stor =  round(mean(taf), 0)) %>% 
    ggplot(aes(x = scen, y = eo_sep_stor , fill = scen, label = round(eo_sep_stor, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+
    ylab("eo sep avg taf [difference]") + geom_text(color = "dark blue", angle = 90) + facet_grid(~dv) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +ggtitle("mean eo september storage, difference (82 yrs)") +
    scale_fill_manual(values=df_diff_cols)
}

pb_eomay_stor_taf_d <- function(df) {
   df %>% filter(kind == "storage", m== 5) %>% group_by(dv, scen) %>% summarize(eo_may_stor =  round(mean(taf), 0)) %>% 
    ggplot(aes(x = scen, y = eo_may_stor,  fill = scen, label = round(eo_may_stor, 0))) + geom_bar(position = "dodge",stat = "identity") + 
    theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+
    ylab("eo may avg taf [difference]") + geom_text(color = "dark blue", angle = 90) + facet_grid(~dv)+
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +ggtitle("mean eo may storage, difference (82 yrs)")+
    scale_fill_manual(values=df_diff_cols)
}

#######################
#######################
###### timeseries #####
#######################
#######################

p_mon_ts_taf <- function(df, yrmin, yrmax) {
df %>% filter(rawunit != "km") %>% ggplot(aes(x = yearmon, y = taf, color = scen, linetype = dv, label = round(taf, 0)))+geom_line()+
    scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01))+
    labs(x= "month", y = "taf -- monthly") + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))+
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) + scale_color_manual(values = df_cols) + 
    ggtitle("monthly taf")
}

p_mon_ts_may_taf <- function(df, yrmin, yrmax) {
  df %>% filter(rawunit != "km", m == 5) %>% ggplot(aes(x = yearmon, y = taf, color = scen, linetype = dv, label = round(taf, 0)))+geom_line()+
    scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01))+
    labs(x= "month", y = "taf -- just mays") + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))+
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+  scale_color_manual(values = df_cols) + 
    ggtitle("mays, taf")
}

p_mon_ts_sep_taf <- function(df, yrmin, yrmax) {
  df %>% filter(rawunit != "km", m == 9) %>% ggplot(aes(x = yearmon, y = taf, color = scen, linetype = dv, label = round(taf, 0)))+geom_line()+
    scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01))+
    labs(x= "month", y = "taf -- just septs") + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))+
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_cols) + 
    ggtitle("septembers, taf")
}

p_mon_ts_taf_maysseps_taf <- function(df, yrmin, yrmax) {
  df %>% filter(rawunit != "km", m == 5 | m==9) %>% ggplot(aes(x = yearmon, y = taf, color = scen, linetype = dv, label = round(taf, 0), shape =dv))+geom_line()+
    scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01))+
    labs(x= "month", y = "taf -- just Mays & Septs") + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))+
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_cols) + 
    ggtitle("mays and septembers, taf")
}

p_mon_ts_cfs    <- function(df, yrmin, yrmax) {
df %>% filter(kind != "storage",rawunit != "km") %>% ggplot(aes(x = yearmon, y = cfs, color = scen, linetype = dv, label = round(cfs, 0)))+geom_line() +
   scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01)) +
   labs(x= "month", y = "monthly average cfs")+ theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2)))+
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_cols) + 
    ggtitle("monthly cfs")
}
p_mon_ts_native    <- function(df, yrmin, yrmax) {
df  %>% #filter(!(kind %in% c("storage", "flow_delivery", "flow_channel")))
    ggplot(aes(x = yearmon, y = rawval, color = scen, linetype = dv, label = round(rawval, 0)))+
    geom_line() + scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01)) +
    labs(x= "month", y = "monthly (unassigned unit)") + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+
    ggtitle("monthly, other unit") + scale_color_manual(values = df_cols) 
}

p_ann_ts_sum_taf <- function(df, yrmin, yrmax) {
df %>% filter(!kind == "storage") %>% group_by(scen, dv, wy) %>% summarize(wytafsum =  sum(taf)) %>% 
    ggplot(aes(x = wy, y = wytafsum, color = scen, linetype = dv, label = round(wytafsum, 0))) + geom_line() + 
    scale_x_continuous(limits = c(yrmin, yrmax), expand = c(0.01, 0.01))+ labs(x = "water year", y = "taf -- water year sum")+
    theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2)))+ theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+
    ggtitle("water year sums, taf")  + scale_color_manual(values = df_cols) 
}

p_annmean_ts_mn_taf <- function(df, yrmin, yrmax) {
  df %>% filter(rawunit == "cfs"|rawunit == "taf") %>% group_by(scen, dv, wy) %>% summarize(wytafmean =  mean(taf)) %>% 
    ggplot(aes(x = wy, y = wytafmean, color = scen, linetype = dv, label = round(wytafmean, 0))) + geom_line() + 
    scale_x_continuous(limits = c(yrmin, yrmax), expand = c(0.01, 0.01))+
    labs(x = "water year", y = "taf -- water year mean (82 yrs)")+ theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+
    ggtitle("water year means, taf") + scale_color_manual(values = df_cols) 
} 
p_ann_ts_sum_native <- function(df, yrmin, yrmax) {
df  %>% #filter(!(kind %in% c("storage", "flow_delivery", "flow_channel")))  
     group_by(scen, dv, wy) %>%
    summarize(annmean =  mean(rawval)) %>% ggplot(aes(x = wy, y = annmean, color = scen, linetype = dv, label = round(annmean, 0))) + geom_line() + 
    scale_x_continuous(limits = c(yrmin, yrmax), expand = c(0.01, 0.01))+ labs(x = "water year",
    y = "mean water year annual (unassigned unit)") + theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_cols) +
    ggtitle("water year [other units], taf")
}

################
## diff ########
################

## mon ##
p_mon_ts_taf_d <- function(df, yrmin, yrmax) {
  df %>% filter(rawunit != "km") %>% ggplot(aes(x = yearmon, y = taf, color = scen, linetype = dv, label = round(taf, 0))) + geom_line()+
    scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01))+
    labs(x= "month", y = "taf -- monthly [difference]")+ theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_diff_cols) +
    ggtitle("monthly difference, taf")
} 

p_mon_ts2_taf_d <- function(df, yrmin, yrmax) {
  df %>% filter(rawunit != "km") %>% ggplot(aes(x = yearmon, y = taf, color = scen, linetype = dv, label = round(taf, 0))) + geom_line()+
    scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01))+
    labs(x= "month", y = "taf -- monthly [difference]")+ theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_diff_cols) + facet_wrap(~dv, nrow = 1)+
    ggtitle("monthly difference, taf")
}

p_mon_ts3_taf_d <- function(df, yrmin, yrmax) {
  df %>% filter(rawunit != "km") %>% ggplot(aes(x = yearmon, y = taf, color = scen, linetype = dv, label = round(taf, 0))) + geom_line()+
    scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01))+
    labs(x= "month", y = "taf -- monthly [difference]")+ theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_diff_cols) + facet_wrap(~scen, nrow = 1)+
    ggtitle("monthly difference, taf")
}


p_mon_ts_cfs_d    <- function(df, yrmin, yrmax) {
  df %>% filter(kind != "storage",rawunit != "km") %>% ggplot(aes(x = yearmon, y = cfs, color = scen, linetype = dv, label = round(cfs, 0)))+geom_line() +
    scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01)) +
    labs(x= "month", y = "monthly average cfs [difference]")+ theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+scale_color_manual(values = df_diff_cols) +
    ggtitle("monthly difference, cfs")
} 

p_mon_ts_native_d    <- function(df, yrmin, yrmax) {
  df  %>% #filter(!(kind %in% c("storage", "flow_delivery", "flow_channel")))  %>% 
    ggplot(aes(x = yearmon, y = rawval,
               color = scen, linetype = dv, label = round(rawval, 0)))+geom_line() + scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01)) +
    labs(x= "month", y = "monthly average (unassigned unit) [difference]")+ theme_gray()+ guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_diff_cols) +
    ggtitle("monthly difference, [other units]")
} 

p_mon_ts2_native_d    <- function(df, yrmin, yrmax) {
  df  %>% #filter(!(kind %in% c("storage", "flow_delivery", "flow_channel")))  %>% 
    ggplot(aes(x = yearmon, y = rawval,
               color = scen, linetype = dv, label = round(rawval, 0)))+geom_line() + scale_x_continuous(limits = c(yrmin, yrmax), labels = yearmon, expand = c(0.01, 0.01)) +
    labs(x= "month", y = "monthly average (unassigned unit) [difference]")+ theme_gray()+ guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_diff_cols) + facet_wrap(~dv, ncol = 1, scales = "free") + 
    ggtitle("monthly difference, [other units]")
} 

p_ann_ts_sum_taf_d <- function(df, yrmin, yrmax) {
  df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, wy) %>% summarize(wytafsum =  sum(taf)) %>% 
    ggplot(aes(x = wy, y = wytafsum, color = scen, linetype = dv, label = round(wytafsum, 0))) + geom_line() + 
    scale_x_continuous(limits = c(yrmin, yrmax), expand = c(0.01, 0.01))+
    labs(x = "water year", y = "taf -- water year sum [difference]") + theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_diff_cols) +
    ggtitle("water year difference, taf")
} 

pb_ann_ts_sum_taf_d <- function(df, yrmin, yrmax) {
  df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, wy) %>% summarize(wytafsum =  sum(taf)) %>% 
    ggplot(aes(x = wy, y = wytafsum, fill = scen, label = round(wytafsum, 0))) + geom_bar(stat = "identity") + 
    scale_x_continuous(limits = c(yrmin, yrmax), expand = c(0.01, 0.01))+
    labs(x = "water year", y = "taf [difference]") + theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_diff_cols) +
    ggtitle("water year difference, taf")
}



p_ann_ts_mn_taf_d <- function(df, yrmin, yrmax) {
  df %>% filter(rawunit == "cfs"|rawunit == "taf") %>% group_by(scen, dv, wy) %>% summarize(wytafmean =  mean(taf)) %>% 
    ggplot(aes(x = wy, y = wytafmean, color = scen, linetype = dv, label = round(wytafmean, 0))) + geom_line() + 
    scale_x_continuous(limits = c(yrmin, yrmax), expand = c(0.01, 0.01))+
    labs(x = "water year", y = "taf -- water year mean [difference]")+ theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ scale_color_manual(values = df_diff_cols) +
    ggtitle("water year mean, differences, taf")
} 


######################################
#### Tiles and Rasters Timeseries ####
######################################

### Rasters ###

## raster timeseries ##

 ## monthly

prast_mon_ts_taf <- function(df) {

df1 <- df %>% group_by(wy, scen, dv) %>% summarize(anntafsum = sum(taf)) %>% mutate(wyscen = paste0(wy,scen))
df2 <- inner_join(df, df1)
ggplot(df2, aes(x=wy, y = -wm,  fill = taf))+#, color = ScenWYTSJR_txt))# +
  geom_raster()+ theme_black3() + 
  scale_y_continuous(expand = c(0.04, 0.04),
                     breaks = c(-1, -2,-3,-4,-5,-6,-7,-8,-9,-10, -11, -12) , 
                     #labels = c( "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr","May","Jun","Jul","Aug", "Sep"))+
                     labels = c( "O", "N", "D", "J", "F", "M", "A","M","J","J","A", "S"))+
  scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                     labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                     expand = c(0.01, 0.01))+
  scale_fill_viridis( name = "TAF/Mon") + 
  theme(strip.text.y = element_text(angle = 0))+
  facet_grid(scen~dv)  + theme(legend.key.width = unit(0.5, "in"), legend.key.height = unit(1, "in")) +
  labs(x ="CalSim Water Year (Q5e hydrology)", y = NULL) + ggtitle("monthly taf") 
}

## annual

 ## annual sum
prast_ann_ts_sum_taf <- function(df) {
  df %>% group_by(wy, scen, dv) %>% summarize(anntafsum = sum(taf))   %>% mutate(wyscen = paste0(wy,scen)) %>%
  ggplot(aes(x=wy, y = 1,  fill = anntafsum))  +
    geom_raster() + 
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_viridis( name = "TAF/WY") + theme_black3() + 
    facet_grid(scen~dv) + theme(axis.text.y=element_blank(), axis.ticks.y=element_blank()) + labs(y = NULL) +
    theme(legend.key.width = unit(0.5, "in"), legend.key.height = unit(1, "in")) +
    theme(strip.text.y = element_text(angle = 0)) +labs(x = "CalSim Water Year") +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) + ggtitle("water year sums, taf") #+
    #scale_x_continuous(sec.axis = dup_axis(name = NULL))
}

## annual mon mean
prast_ann_ts_mn_taf <- function(df) {
  df %>% group_by(wy, scen, dv) %>% summarize(annmontafmean = mean(taf)) %>% mutate(wyscen = paste0(wy,scen)) %>%
  ggplot(aes(x=wy, y = 1,  fill = annmontafmean))  +
    geom_raster() + 
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_viridis( name = "TAF/WY") + theme_black3() + 
    facet_grid(scen~dv) + theme(axis.text.y=element_blank(), axis.ticks.y=element_blank()) + labs(y = NULL) +
    theme(strip.text.y = element_text(angle = 0)) +labs(x = "CalSim Water Year") +
    theme(legend.key.width = unit(0.5, "in"), legend.key.height = unit(1, "in")) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) + ggtitle("annual monthly mean, taf")#+
    #scale_x_continuous(sec.axis = dup_axis(name = NULL))  
}

## diff


prast_mon_ts_taf_d <- function(df) {
  
  df1 <- df %>% group_by(wy, scen, dv) %>% summarize(anntafsum = sum(taf)) %>% mutate(wyscen = paste0(wy,scen))
  df2 <- inner_join(df, df1)
  ggplot(df2, aes(x=wy, y = -wm,  fill = taf))+#, color = ScenWYTSJR_txt))# +
    geom_raster()+ theme_black3() + 
    scale_y_continuous(expand = c(0.04, 0.04),
                       breaks = c(-1, -2,-3,-4,-5,-6,-7,-8,-9,-10, -11, -12) , 
                       #labels = c( "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr","May","Jun","Jul","Aug", "Sep"))+
                       labels = c( "O", "N", "D", "J", "F", "M", "A","M","J","J","A", "S"))+
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_gradient2( name = "TAFdiff/Mon") + 
    theme(strip.text.y = element_text(angle = 0))+
    facet_grid(scen~dv)  + theme(legend.key.width = unit(0.5, "in"), legend.key.height = unit(1, "in")) +
    theme(legend.key.width = unit(0.5, "in"), legend.key.height = unit(1, "in")) +
    labs(x ="CalSim Water Year (Q5e hydrology)", y = NULL) + ggtitle("monthly taf [difference]") 
}

prast_ann_ts_sum_taf_d <- function(df) {
  df %>% group_by(wy, scen, dv) %>% summarize(anntafsum = sum(taf))   %>% mutate(wyscen = paste0(wy,scen)) %>%
    ggplot(aes(x=wy, y = 1,  fill = anntafsum))  +
    geom_raster() + 
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_gradient2( name = "TAFdiff/WY") + theme_black3() + 
    facet_grid(scen~dv) + theme(axis.text.y=element_blank(), axis.ticks.y=element_blank()) + labs(y = NULL) +
    theme(strip.text.y = element_text(angle = 0)) +labs(x = "CalSim Water Year") +
    theme(legend.key.width = unit(0.5, "in"), legend.key.height = unit(1, "in")) +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) + ggtitle("water year sums, taf [difference from baseline]") #+
    #scale_x_continuous(sec.axis = dup_axis(name = NULL))
}

## annual mon mean
prast_ann_ts_mn_taf_d <- function(df) {
  df %>% group_by(wy, scen, dv) %>% summarize(annmontafmean = mean(taf)) %>% mutate(wyscen = paste0(wy,scen)) %>%
    ggplot(aes(x=wy, y = 1,  fill = annmontafmean))  +
    geom_raster() + 
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_gradient2( name = "TAFdiff/WY") + theme_black3() + 
    facet_grid(scen~dv) + theme(axis.text.y=element_blank(), axis.ticks.y=element_blank()) + labs(y = NULL) +
    theme(legend.key.width = unit(0.5, "in"), legend.key.height = unit(1, "in")) +
    theme(strip.text.y = element_text(angle = 0)) +labs(x = "CalSim Water Year") +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) + ggtitle("annual monthly mean, taf [difference from baseline]")
    #scale_x_continuous(sec.axis = dup_axis(name = NULL))
}


## tile timeseries ##  adds ability to outline raster fill with another attribute, color = outline
###

####
ptile_mon_ts_taf <- function(df) {
  
  df1 <- df %>% group_by(wy, scen, dv) %>% summarize(anntafsum = sum(taf)) %>% mutate(wyscen = paste0(wy,scen))
  df2 <- inner_join(df, df1)
  ggplot(df2, aes(x=wy, y = -wm,  fill = taf, color = scwyt_scwytt))+
    geom_tile()+ theme_black3() + 
    scale_y_continuous(expand = c(0.04, 0.04),
                       breaks = c(-1, -2,-3,-4,-5,-6,-7,-8,-9,-10, -11, -12) , 
                       #labels = c( "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr","May","Jun","Jul","Aug", "Sep"))+
                       labels = c( "O", "N", "D", "J", "F", "M", "A","M","J","J","A", "S"))+
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_viridis( name = "TAF/Mon") + 
    theme(strip.text.y = element_text(angle = 0))+
    facet_grid(scen~dv)  + theme(legend.key.width = unit(0.5, "in"), legend.key.height = unit(1, "in")) +
    labs(x ="CalSim Water Year (Q5e hydrology)", y = NULL) + ggtitle("monthly taf") 
}

## annual

## annual sum
ptile_ann_ts_sum_taf <- function(df) {
  df %>% group_by(wy, scen, dv) %>% summarize(anntafsum = sum(taf))   %>% mutate(wyscen = paste0(wy,scen)) %>%
    ggplot(aes(x=wy, y = 1,  fill = anntafsum))  +
    geom_tile() + 
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_gradient2( name = "TAF/WY") + theme_black3() + 
    facet_grid(scen~dv) + theme(axis.text.y=element_blank(), axis.ticks.y=element_blank()) + labs(y = NULL) +
    theme(strip.text.y = element_text(angle = 0)) +labs(x = "CalSim Water Year") +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) + ggtitle("water year sums, taf") #+
    #scale_x_continuous(sec.axis = dup_axis(name = NULL))
}

## annual mon mean
ptile_ann_mean_ts_mn_taf <- function(df) {
  df %>% group_by(wy, scen, dv) %>% summarize(anntafmean = mean(taf)) %>% mutate(wyscen = paste0(wy,scen)) %>%
    ggplot(aes(x=wy, y = 1,  fill = anntafmean))  +
    geom_tile() + 
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_viridis( name = "TAF/WY") + theme_black3() + 
    facet_grid(scen~dv) + theme(axis.text.y=element_blank(), axis.ticks.y=element_blank()) + labs(y = NULL) +
    theme(strip.text.y = element_text(angle = 0)) +labs(x = "CalSim Water Year") +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) + ggtitle("annual monthly mean, taf")#+
    #scale_x_continuous(sec.axis = dup_axis(name = NULL))  
}

## diff

## mon
ptile_mon_ts_taf_d <- function(df) {

  ggplot(df, aes(x=wy, y = -wm,  fill = taf))+
    geom_tile()+ theme_black3() + 
    scale_y_continuous(expand = c(0.04, 0.04),
                       breaks = c(-1, -2,-3,-4,-5,-6,-7,-8,-9,-10, -11, -12) , 
                       #labels = c( "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr","May","Jun","Jul","Aug", "Sep"))+
                       labels = c( "O", "N", "D", "J", "F", "M", "A","M","J","J","A", "S"))+
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_gradient2( name = "TAFdiff/Mon") + 
    theme(strip.text.y = element_text(angle = 0))+
    facet_grid(scen~dv)  + theme(legend.key.width = unit(0.5, "in"), legend.key.height = unit(1, "in")) +
    labs(x ="CalSim Water Year (Q5e hydrology)", y = NULL) + ggtitle("monthly taf [difference]") 
}


## ann
ptile_ann_ts_sum_taf_d <- function(df) {

  df %>% group_by(wy, scen, dv) %>% summarize(anntafsum = sum(taf))   %>% mutate(wyscen = paste0(wy,scen)) %>%
    ggplot(aes(x=wy, y = 1,  fill = anntafsum))  +
    geom_tile() + 
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_gradient2( name = "TAFdiff/WY") + theme_black3() + 
    facet_grid(scen~dv) + theme(axis.text.y=element_blank(), axis.ticks.y=element_blank()) + labs(y = NULL) +
    theme(strip.text.y = element_text(angle = 0)) +labs(x = "CalSim Water Year") +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) + ggtitle("water year sums, taf [difference from baseline]") #+
    #scale_x_continuous(sec.axis = dup_axis(name = NULL))
}


## annual mon mean
ptile_ann_ts_mn_taf_d <- function(df) {
  df %>% group_by(wy, scen, dv) %>% summarize(anntafmean = mean(taf)) %>% mutate(wyscen = paste0(wy,scen)) %>%
    ggplot(aes(x=wy, y = 1,  fill = anntafmean))  +
    geom_tile() + 
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    scale_fill_gradient2( name = "TAFdiff/WY") + theme_black3() + 
    facet_grid(scen~dv) + theme(axis.text.y=element_blank(), axis.ticks.y=element_blank()) + labs(y = NULL) +
    theme(strip.text.y = element_text(angle = 0)) +labs(x = "CalSim Water Year") +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) + ggtitle("annual monthly mean, taf [difference from baseline]")#+
    #scale_x_continuous(sec.axis = dup_axis(name = NULL))
}

ptilewyt_mon_ts_taf <- function(df) {
  
  df <- df %>% filter(scen == "baseline")
  
  ggplot(df, aes(x=wy, y = -wm, fill = scwyt))+
    geom_tile()+ theme_black3() + 
    scale_y_continuous(expand = c(0.04, 0.04),
                       breaks = c(-1, -2,-3,-4,-5,-6,-7,-8,-9,-10, -11, -12) , 
                       #labels = c( "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr","May","Jun","Jul","Aug", "Sep"))+
                       labels = c( "O", "N", "D", "J", "F", "M", "A","M","J","J","A", "S"))+
    scale_x_continuous(breaks = c(1922, 1930, 1940,1950, 1960, 1970, 1980, 1990, 2003),
                       labels = c("'22", "'30", "'40","'50", "'60", "'70", "'80", "'90", "'03"), sec.axis = dup_axis(name = NULL),
                       expand = c(0.01, 0.01))+
    #scale_fill_gradient( name = "TAF/Mon") + 
    theme(strip.text.y = element_text(angle = 0))+
    facet_grid(scen~dv)  + theme(legend.key.width = unit(0.5, "in"), legend.key.height = unit(1, "in")) +
    labs(x ="CalSim Water Year (Q5e hydrology)", y = NULL) + ggtitle("monthly taf") 
}

################################
#######  exceedance ############
################################

p_mon_excd_taf <- function(df) {
df %>% filter(rawunit != "km")%>% group_by(scen, dv) %>% arrange(dv, desc(taf)) %>% mutate(taf_dv_rank = row_number(),
         excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = taf, color = scen,
          linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf -- monthly")+theme_gray() +
           guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
           scale_color_manual(values = df_cols) +
          ggtitle("984 months (taf)")
}

p_mon_excd2_taf <- function(df) { #remove linetype = scen
  df %>% filter(rawunit != "km")%>% group_by(scen, dv) %>% arrange(dv, desc(taf)) %>% mutate(taf_dv_rank = row_number(),
        excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = taf, color = scen, linetype = scen)) + geom_line() + labs(x = "probability of exceedance", y = "taf -- monthly")+theme_gray() +
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
      ggtitle("984 months (taf)") + facet_grid(~dv) + scale_color_manual(values = df_cols)
}

p_mon_excd_cfs <- function(df) {
df %>% filter(kind != "storage", rawunit != "km") %>% group_by(scen, dv) %>% arrange(dv, desc(cfs)) %>% mutate(cfs_dv_rank = row_number(),
        excdxaxis = cfs_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = cfs, color = scen,
        linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "monthly average cfs") + theme_gray() +   
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +ggtitle("984 months (cfs)") +
    scale_color_manual(values = df_cols)
}

p_mon_excd2_cfs <- function(df) {
  df %>% filter(kind != "storage", rawunit != "km") %>% group_by(scen, dv) %>% arrange(dv, desc(cfs)) %>% mutate(cfs_dv_rank = row_number(),
        excdxaxis = cfs_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = cfs, color = scen)) + geom_line() + labs(x = "probability of exceedance", y = "monthly average cfs") + theme_gray() +   
        guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("984 months (cfs)") + facet_grid(~dv) + scale_color_manual(values = df_cols)
}


p_mon_excd_native <- function(df) {
df  %>% #filter(!(kind %in% c("storage", "flow_delivery", "flow_channel"))) %>% 
    group_by(scen, dv) %>% arrange(dv, desc(rawval)) %>% 
    mutate(oth_dv_rank = row_number(), excdxaxis = oth_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = rawval, color = scen,
    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "monthly (unassigned)")  + theme_gray() +  
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("984 months (other units)") + scale_color_manual(values = df_cols)
}

p_mon_excd2_native <- function(df) {
  df  %>% #filter(!(kind %in% c("storage", "flow_delivery", "flow_channel"))) %>% 
    group_by(scen, dv) %>% arrange(dv, desc(rawval)) %>% 
    mutate(oth_dv_rank = row_number(), excdxaxis = oth_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = rawval, color = scen)) + 
    geom_line() + labs(x = "probability of exceedance", y = "monthly (unassigned)")  + theme_gray() + facet_grid(~dv) +
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("984 months (other units)") + scale_color_manual(values = df_cols)
}

p_ann_wysum_excd_taf <- function(df) {
df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, wy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = wytafsum, color = scen,
    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf")+
    theme_gray() +  
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("82 water year totals") + scale_color_manual(values = df_cols)
}

p_ann_wysum_excd2_taf <- function(df) {
  df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, wy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = wytafsum, color = scen)) + 
    geom_line() + labs(x = "probability of exceedance", y = "taf")+
    theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + facet_wrap(~dv,nrow = 1, scales = "free") +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +ggtitle("82 water year totals") + scale_color_manual(values = df_cols)
}

p_ann_wysum_excd3_taf <- function(df) {
  df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, wy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(),
      excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = wytafsum, color = scen)) + 
    geom_line() + labs(x = "probability of exceedance", y = "taf")+
    theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + facet_wrap(~dv, ncol =1, scales = "free") +
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +ggtitle("82 water year totals") + scale_color_manual(values = df_cols)
}



p_ann_fjwysum_excd_taf <- function(df) {
df %>% filter(rawunit == "cfs", fjwy > 1921, fjwy < 2003) %>% group_by(scen, dv, fjwy) %>% summarize(fjwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(fjwytafsum)) %>% mutate(taf_dv_rank = row_number(),
   excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = fjwytafsum, color = scen,
    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf")+
    theme_gray() +  
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("81 feb-jan totals") + scale_color_manual(values = df_cols)
}

p_ann_fjwysum_excd2_taf <- function(df) {
  df %>% filter(rawunit == "cfs", fjwy > 1921, fjwy < 2003) %>% group_by(scen, dv, fjwy) %>% summarize(fjwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(fjwytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = fjwytafsum, color = scen)) + geom_line() + 
    labs(x = "probability of exceedance", y = "taf")+
    theme_gray() +  guides(colour = guide_legend(override.aes = list(size=2))) + facet_wrap(~dv) + 
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +ggtitle("81 feb-jan totals") + scale_color_manual(values = df_cols)
}

p_ann_mfwysum_excd_taf <- function(df) {
df %>% filter(rawunit == "cfs", mfwy > 1921, mfwy < 2003) %>% group_by(scen, dv, mfwy) %>% summarize(mfwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(mfwytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = mfwytafsum, color = scen,
    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf")+
    theme_gray() +  
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("81 mar-feb totals") + scale_color_manual(values = df_cols)
}

p_ann_mfwysum_excd2_taf <- function(df) {
  df %>% filter(rawunit == "cfs", mfwy > 1921, mfwy < 2003) %>% group_by(scen, dv, mfwy) %>% summarize(mfwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(mfwytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = mfwytafsum, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "taf ")+
    theme_gray() +  guides(colour = guide_legend(override.aes = list(size=2))) + facet_wrap(~dv) +  
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +ggtitle("81 mar-feb totals") + scale_color_manual(values = df_cols)
}

p_ann_jdwysum_excd_taf <- function(df) {
  df %>% filter(rawunit == "cfs", jdwy > 1921, jdwy < 2003) %>% group_by(scen, dv, mfwy) %>% summarize(jdwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(jdwytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = jdwytafsum, color = scen,
                                                                                                                    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf")+
    theme_gray() +  
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("81 jan-dec totals") + scale_color_manual(values = df_cols)
}

p_ann_jdwysum_excd2_taf <- function(df) {
  df %>% filter(rawunit == "cfs", jdwy > 1921, jdwy < 2003) %>% group_by(scen, dv, mfwy) %>% summarize(jdwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(jdwytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = jdwytafsum, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "taf")+
    theme_gray() +  guides(colour = guide_legend(override.aes = list(size=2))) + facet_wrap(~dv) +  
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +ggtitle("81 jan-dec totals") + scale_color_manual(values = df_cols)
}

p_ann_wymn_excd_taf <- function(df) {
df %>% filter(rawunit == "taf" | rawunit == "cfs" ) %>% group_by(scen, dv, wy) %>% summarize(wytafmean =  mean(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafmean)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = wytafmean, color = scen,
    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf -- water year mean (82 yrs)")+
    theme_gray()+ 
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("82 water year means") + scale_color_manual(values = df_cols)
}

p_ann_wymn_excd2_taf <- function(df) {
  df %>% filter(rawunit == "taf" | rawunit == "cfs" ) %>% group_by(scen, dv, wy) %>% summarize(wytafmean =  mean(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafmean)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = wytafmean, color = scen)) + 
    geom_line() + labs(x = "probability of exceedance", y = "taf -- water year mean (82 yrs)")+
    theme_gray()+ guides(colour = guide_legend(override.aes = list(size=2))) + facet_grid(~dv) +  
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +ggtitle("82 water year means") + scale_color_manual(values = df_cols)
}


############
## diff ####
############


p_mon_excd_taf_d <- function(df) {
df %>% filter(rawunit != "km") %>% group_by(scen, dv) %>% arrange(dv, desc(taf)) %>% mutate(taf_dv_rank = row_number(),
      excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = taf, color = scen,
      linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf -- monthly [difference]")+
      theme_gray()+ 
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("984 months, difference") + scale_color_manual(values = df_diff_cols)
}

p_mon_excd2_taf_d <- function(df) {
  df %>% filter(rawunit != "km") %>% group_by(scen, dv) %>% arrange(dv, desc(taf)) %>% mutate(taf_dv_rank = row_number(),
  excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = taf, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "taf -- monthly [difference]")+
    theme_gray()+guides(colour = guide_legend(override.aes = list(size=2))) + facet_grid(~dv) +  
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +ggtitle("984 months, difference") + scale_color_manual(values = df_diff_cols)
}


p_mon_excd_cfs_d <- function(df) {
df %>% filter(kind != "storage", rawunit != "km") %>% group_by(scen, dv) %>% arrange(dv, desc(cfs)) %>% mutate(cfs_dv_rank = row_number(),
     excdxaxis = cfs_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = cfs, color = scen,
    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "monthly average cfs [difference]")+
    theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("984 months, difference") + scale_color_manual(values = df_diff_cols)
}

p_mon_excd2_cfs_d <- function(df) {
  df %>% filter(kind != "storage", rawunit != "km") %>% group_by(scen, dv) %>% arrange(dv, desc(cfs)) %>% mutate(cfs_dv_rank = row_number(),
         excdxaxis = cfs_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = cfs, color = scen)) + geom_line() +
         labs(x = "probability of exceedance", y = "monthly average cfs [difference]")  + facet_grid(~dv) + 
         theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
         ggtitle("984 months, difference") + scale_color_manual(values = df_diff_cols)
}

p_ann_wysum_excd_taf_d <- function(df)  {
df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, wy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = wytafsum, color = scen,
    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf -- water year sum (82 yrs) [difference]")+
    theme_gray()+ guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("82 oct-sep totals, difference")+ scale_color_manual(values = df_diff_cols)
}

p_ann_wysum_excd2_taf_d <- function(df)  {
  df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, wy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = wytafsum, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "taf [difference]")+
    theme_gray()+ guides(colour = guide_legend(override.aes = list(size=2))) + facet_grid(~dv) +  
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("82 oct-sep totals, difference") + scale_color_manual(values = df_diff_cols)
}

p_ann_fjwysum_excd_taf_d <- function(df) {
df %>% filter(rawunit == "cfs", fjwy > 1921, fjwy < 2003) %>% group_by(scen, dv, fjwy) %>% summarize(fjwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(fjwytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = fjwytafsum, color = scen,
    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf -- feb - jan year sum (81 yrs) [difference]")+
    theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("81 feb-jan totals, difference") + scale_color_manual(values = df_diff_cols)
}

p_ann_fjwysum_excd2_taf_d <- function(df) {
  df %>% filter(rawunit == "cfs", fjwy > 1921, fjwy < 2003) %>% group_by(scen, dv, fjwy) %>% summarize(fjwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(fjwytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = fjwytafsum, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "taf -- feb - jan year sum (81 yrs) [difference]") + facet_grid(~dv) + 
    theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("81 feb-jan totals, difference") + scale_color_manual(values = df_diff_cols)
}


p_ann_mfwysum_excd_taf_d <- function(df) {
df %>% filter(rawunit == "cfs", mfwy > 1921, mfwy < 2003) %>% group_by(scen, dv, mfwy) %>% summarize(mfwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(mfwytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = mfwytafsum, color = scen, 
    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf -- mar - feb year sum (81 yrs) [difference]")+
    theme_gray()  +  guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("81 mar-feb totals, difference") + scale_color_manual(values = df_diff_cols)
}

p_ann_mfwysum_excd2_taf_d <- function(df) {
  df %>% filter(rawunit == "cfs", mfwy > 1921, mfwy < 2003) %>% group_by(scen, dv, mfwy) %>% summarize(mfwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(mfwytafsum)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = mfwytafsum, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "taf -- mar - feb year sum (81 yrs) [difference]") + facet_grid(~dv) + 
    theme_gray()  +  guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("81 mar-feb totals, difference") + scale_color_manual(values = df_diff_cols)
}

p_ann_jdwysum_excd_taf_d <- function(df) {
  df %>% filter(rawunit == "cfs", jdwy > 1921, jdwy < 2003) %>% group_by(scen, dv, mfwy) %>% summarize(jdwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(jdwytafsum)) %>% mutate(taf_dv_rank = row_number(),
      excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = jdwytafsum, color = scen,
                    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf [difference]")+
    theme_gray() +  
    guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("81 jan-dec totals") + scale_color_manual(values = df_diff_cols)
}

p_ann_jdwysum_excd2_taf_d <- function(df) {
  df %>% filter(rawunit == "cfs", jdwy > 1921, jdwy < 2003) %>% group_by(scen, dv, mfwy) %>% summarize(jdwytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(jdwytafsum)) %>% mutate(taf_dv_rank = row_number(),
                                                                    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = jdwytafsum, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "taf [difference]")+
    theme_gray() +  guides(colour = guide_legend(override.aes = list(size=2))) + facet_grid(~dv) +  
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +ggtitle("81 jan-dec totals") + scale_color_manual(values = df_diff_cols)
}
p_ann_wymn_excd_taf_d <- function(df) {
df %>% filter(rawunit == "cfs"| rawunit == "taf") %>% group_by(scen, dv, wy) %>% summarize(wytafmean =  mean(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafmean)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = wytafmean, color = scen, 
    linetype = dv)) + geom_line() + labs(x = "probability of exceedance", y = "taf -- water year mean (82 yrs) [difference]")+
    theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("82 water year means, difference")
}

p_ann_wymn_excd2_taf_d <- function(df) {
  df %>% filter(rawunit == "cfs"| rawunit == "taf") %>% group_by(scen, dv, wy) %>% summarize(wytafmean =  mean(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafmean)) %>% mutate(taf_dv_rank = row_number(),
    excdxaxis = taf_dv_rank/(n()+1)) %>% ggplot(aes(x = excdxaxis, y = wytafmean, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "taf -- water year mean (82 yrs) [difference]")+
    theme_gray()  + guides(colour = guide_legend(override.aes = list(size=2))) + facet_grid(~dv) +  
    theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("82 water year means, difference")
}


###################################################
### plot exceedance by wyt, line plot grid ########
###################################################

## Sac WYT taf - dvs together
p_ann_fjwysum_scwyt_excd_taf <- function(df)  {
df_0 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy) %>% summarize(wytafsum =  sum(taf)) %>%
        group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1), 
                                                                 scwyt_scwytt = "all") 

df_1_5 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>% summarize(wytafsum =  sum(taf)) %>%
          group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1))

df_0_5 <- rbind(df_0, df_1_5) %>%  ggplot(aes(x = excdxaxis, y = wytafsum, color = scen,
                                              linetype = dv)) + geom_line() + geom_point(size =0.5) +labs(x = "probability of exceedance", y = "taf -- feb - jan water year sum") +
  facet_wrap(~scwyt_scwytt, ncol = 3) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
  ggtitle("sac wyt sums (81 yrs)")
df_0_5 +  theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + 
  scale_color_manual(values=df_cols) 
}

## Sac WYT taf - dvs apart
p_ann_fjwysum_scwyt_excd2_taf <- function(df)  {
  df_0 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1), 
                                                                  scwyt_scwytt = "all") 
  
  df_1_5 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1))
  
  df_0_5 <- rbind(df_0, df_1_5) %>%  ggplot(aes(x = excdxaxis, y = wytafsum, color = scen)) + geom_line() + geom_point(size =0.5) +labs(x = "probability of exceedance", y = "taf -- feb - jan water year sum") +
    facet_grid(dv~scwyt_scwytt) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("sac wyt sums (81 yrs)")
  df_0_5 +  theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + 
    scale_color_manual(values=df_cols) 
}

p_ann_fjwysum_scwyt_excd_taf <- function(df)  {
  df_0 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1), 
                                                                  scwyt_scwytt = "all") 
  
  df_1_5 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1))
  
  df_0_5 <- rbind(df_0, df_1_5) %>%  ggplot(aes(x = excdxaxis, y = wytafsum, color = scen,
                                                linetype = dv)) + geom_line() + geom_point(size =0.5) +labs(x = "probability of exceedance", y = "taf -- feb - jan water year sum") +
    facet_wrap(~scwyt_scwytt, ncol = 3) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("sac wyt sums (81 yrs)")
  df_0_5 +  theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + 
    scale_color_manual(values=df_cols) 
}

## SJ WYT taf - dvs together
p_ann_fjwysum_sjwyt_excd_taf <- function(df) {
df_0 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy) %>% summarize(wytafsum =  sum(taf)) %>%
        group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1), sjwyt_sjwytt = "all")

df_1_5 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, sjwyt_sjwytt) %>% summarize(wytafsum =  sum(taf)) %>%
         group_by(scen, dv, sjwyt_sjwytt) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1))

df_0_5 <- rbind(df_0, df_1_5) %>%  ggplot(aes(x = excdxaxis, y = wytafsum, color = scen,
                                              linetype = dv)) + geom_line() + geom_point(size =0.5) +labs(x = "probability of exceedance", y = "taf -- feb - jan water year sum") +
          facet_wrap(~sjwyt_sjwytt, ncol = 3) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
          ggtitle("sjr wyt sums (81 yrs)")
df_0_5 + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm"))+ 
  scale_color_manual(values=df_cols) 
}

## SJ WYT taf - dvs apart
p_ann_fjwysum_sjwyt_excd2_taf <- function(df) {
  df_0 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1), sjwyt_sjwytt = "all")
  
  df_1_5 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, sjwyt_sjwytt) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv, sjwyt_sjwytt) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1))
  
  df_0_5 <- rbind(df_0, df_1_5) %>%  ggplot(aes(x = excdxaxis, y = wytafsum, color = scen)) + geom_line() + geom_point(size =0.5) +labs(x = "probability of exceedance", y = "taf -- feb - jan water year sum") +
    facet_grid(dv~sjwyt_sjwytt) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("sjr wyt sums (81 yrs)")
  df_0_5 + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) + 
    scale_color_manual(values=df_cols) 
}


###########
## diff ###
###########
## Sac WYT taf - dvs together
p_ann_fjwysum_scwyt_excd_taf_d <- function(df) {
  df_0 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1), 
                                                                  scwyt_scwytt = "all")
  
  df_1_5 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(),
                                                                                excdxaxis = taf_dv_rank/(n()+1))
  
  df_0_5 <- rbind(df_0, df_1_5) %>%  ggplot(aes(x = excdxaxis, y = wytafsum, color = scen, linetype = dv)) + geom_line() + geom_point(size =0.5) +
    labs(x = "probability of exceedance", y = "taf -- feb - jan water year sum [difference]") +
    facet_wrap(~scwyt_scwytt, ncol = 3) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("sac wyt sums, difference (81 yrs)")
  df_0_5  + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + 
    scale_color_manual(values=df_diff_cols) 
}



## Sac WYT taf - dvs apart
p_ann_fjwysum_scwyt_excd2_taf_d <- function(df) {
  df_0 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1), 
                                                                  scwyt_scwytt = "all")
  
  df_1_5 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(),
                                                                                excdxaxis = taf_dv_rank/(n()+1))
  
  df_0_5 <- rbind(df_0, df_1_5) %>%  ggplot(aes(x = excdxaxis, y = wytafsum, color = scen, linetype = dv)) + geom_line() + geom_point(size =0.5) +
    labs(x = "probability of exceedance", y = "taf -- feb - jan water year sum [difference]") +
    facet_grid(dv~scwyt_scwytt) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("sac wyt sums, difference (81 yrs)")
  df_0_5  + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) +   
    scale_color_manual(values=df_diff_cols) 
}


## SJ WYT taf - dvs together
p_ann_fjwysum_sjwyt_excd_taf_d <- function(df) {
df_0 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy) %>% summarize(wytafsum =  sum(taf)) %>%
        group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1), sjwyt_sjwytt = "all")

df_1_5 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, sjwyt_sjwytt) %>% summarize(wytafsum =  sum(taf)) %>%
          group_by(scen, dv, sjwyt_sjwytt) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1))

df_0_5 <- rbind(df_0, df_1_5) %>%  ggplot(aes(x = excdxaxis, y = wytafsum, color = scen,
          linetype = dv)) + geom_line() + geom_point(size =0.5) +labs(x = "probability of exceedance", y = "taf -- feb - jan water year sum [difference]") +
          facet_wrap(~sjwyt_sjwytt, ncol = 3) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
          ggtitle("sj wyt sums, difference (81 yrs)")
df_0_5 + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +   
  scale_color_manual(values=df_diff_cols) 
}

## SJ WYT taf - dvs apart
p_ann_fjwysum_sjwyt_excd2_taf_d <- function(df) {
  df_0 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1), sjwyt_sjwytt = "all")
  
  df_1_5 <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, sjwyt_sjwytt) %>% summarize(wytafsum =  sum(taf)) %>%
    group_by(scen, dv, sjwyt_sjwytt) %>% arrange(dv, desc(wytafsum)) %>% mutate(taf_dv_rank = row_number(), excdxaxis = taf_dv_rank/(n()+1))
  
  df_0_5 <- rbind(df_0, df_1_5) %>%  ggplot(aes(x = excdxaxis, y = wytafsum, color = scen)) + geom_line() + geom_point(size =0.5) +labs(x = "probability of exceedance", y = "taf -- feb - jan water year sum [difference]") +
    facet_grid(dv~sjwyt_sjwytt) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
      ggtitle("sj wyt sums, difference (81 yrs)")
  df_0_5 + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +   
    scale_color_manual(values=df_diff_cols) 
}

###################################################
### stack sequential bars by wyt            #######
###################################################

## bar sums ##

pb_ann_fjwysum_scwyt_taf <- function(df) {
  df_bars <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>%
    summarize(fjwytafsum =  sum(taf)) %>%
    group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(fjwytafsum)) %>%
    mutate(taf_dv_rank = row_number()) %>% group_by(scen, dv, scwyt_scwytt) %>% arrange(scwyt_scwytt, desc(fjwytafsum)) %>%
    group_by(scen,dv) %>% mutate(x = row_number())
  df_bars_mns <- df_bars %>% group_by(scen, dv, scwyt_scwytt) %>% summarize(mean = mean(fjwytafsum))
  df_bars_mn <- df_bars %>% group_by(scen, dv) %>% summarize(mean = mean(fjwytafsum))
  
ggplot(df_bars, aes(x, fjwytafsum, fill = scwyt_scwytt, label = fjwy))  +geom_bar(stat = "identity", position = "dodge") +
  facet_grid(dv~scen) + scale_fill_discrete(name = "sac wyt") + labs(x = "CalSim Feb-Jan Yrs") + theme_gray() +
  scale_y_continuous(sec.axis = dup_axis(name = NULL)) + labs(y = "feb - jan wy sum (taf)") + geom_hline(data = df_bars_mns, mapping = aes(yintercept = mean, color = scwyt_scwytt), show.legend = FALSE) +
  geom_hline(data = df_bars_mn, mapping = aes(yintercept = mean, linetype = "Overall Ann. Average"), color = "dark blue") +
  scale_linetype_manual(name = " ", values = c(2, 2))+ggtitle("sac wyt sums and means") + 
  scale_fill_manual(values=wyt_cols, name = "sac wyt") +
  scale_color_manual(values=wyt_cols, name = "sac wyt") 
}

pb_ann_fjwysum_sjwyt_taf <- function(df) {
  df_bars <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, sjwyt_sjwytt) %>%
    summarize(fjwytafsum =  sum(taf)) %>%
    group_by(scen, dv, sjwyt_sjwytt) %>% arrange(dv, desc(fjwytafsum)) %>%
    mutate(taf_dv_rank = row_number()) %>% group_by(scen, dv, sjwyt_sjwytt) %>% arrange(sjwyt_sjwytt, desc(fjwytafsum)) %>%
    group_by(scen,dv) %>% mutate(x = row_number())
  df_bars_mns <- df_bars %>% group_by(scen, dv, sjwyt_sjwytt) %>% summarize(mean = mean(fjwytafsum))
  df_bars_mn <- df_bars %>% group_by(scen, dv) %>% summarize(mean = mean(fjwytafsum))
  
  ggplot(df_bars, aes(x, fjwytafsum, fill = sjwyt_sjwytt, label = fjwy))  +geom_bar(stat = "identity", position = "dodge") +
    facet_grid(dv~scen) + scale_fill_discrete(name = "sj wyt") + labs(x = "CalSim Feb-Jan Yrs") + theme_gray() +
    scale_y_continuous(sec.axis = dup_axis(name = NULL)) + labs(y = "feb - jan wy sum (taf)") +
    geom_hline(data = df_bars_mns, mapping = aes(yintercept = mean, color = sjwyt_sjwytt), show.legend = FALSE) +
    geom_hline(data = df_bars_mn, mapping = aes(yintercept = mean, linetype = "Overall Ann. Average"), color = "dark blue") +
    scale_linetype_manual(name = " ", values = c(2, 2)) +ggtitle("sj wyt sums and means") + 
    scale_fill_manual(values=wyt_cols, name = "sac wyt") +
    scale_color_manual(values=wyt_cols, name = "sac wyt") 
}

## storage ## 

pb_eomay_stor_scwyt_taf <- function(df) {
  df_bars <- df %>% filter(kind == "storage", fjwy>1921, fjwy<2003, wm == 8) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>%
    summarize(eomay_stor =  taf) %>%
    group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(eomay_stor)) %>%
    mutate(taf_dv_rank = row_number()) %>% group_by(scen, dv, scwyt_scwytt) %>% arrange(scwyt_scwytt, desc(eomay_stor)) %>%
    group_by(scen,dv) %>% mutate(x = row_number())
  df_bars_mns <- df_bars %>% group_by(scen, dv, scwyt_scwytt) %>% summarize(mean = mean(eomay_stor))
  df_bars_mn <- df_bars %>% group_by(scen, dv) %>% summarize(mean = mean(eomay_stor))
  
  ggplot(df_bars, aes(x, eomay_stor, fill = scwyt_scwytt, label = fjwy))  +geom_bar(stat = "identity", position = "dodge") +
    facet_grid(dv~scen) + scale_fill_discrete(name = "sac wyt") + labs(x = "CalSim Feb-Jan Yrs") + theme_gray() +
    scale_y_continuous(sec.axis = dup_axis()) + labs(y = "end of may storage (taf)") +
    geom_hline(data = df_bars_mns, mapping = aes(yintercept = mean, color = scwyt_scwytt), show.legend = FALSE) +
    geom_hline(data = df_bars_mn, mapping = aes(yintercept = mean, linetype = "Overall May Average"), color = "dark blue") +
    scale_linetype_manual(name = " ", values = c(2, 2)) +ggtitle("82 end of may storages") + 
    scale_fill_manual(values=wyt_cols, name = "sac wyt") +
    scale_color_manual(values=wyt_cols, name = "sac wyt") 
}

pb_eosep_stor_scwyt_taf <- function(df) {
  df_bars <- df %>% filter(kind == "storage", fjwy>1921, fjwy<2003, wm == 12) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>%
    summarize(eomay_stor =  taf) %>%
    group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(eomay_stor)) %>%
    mutate(taf_dv_rank = row_number()) %>% group_by(scen, dv, scwyt_scwytt) %>% arrange(scwyt_scwytt, desc(eomay_stor)) %>%
    group_by(scen,dv) %>% mutate(x = row_number())
  df_bars_mns <- df_bars %>% group_by(scen, dv, scwyt_scwytt) %>% summarize(mean = mean(eomay_stor))
  df_bars_mn <- df_bars %>% group_by(scen, dv) %>% summarize(mean = mean(eomay_stor))
  
  ggplot(df_bars, aes(x, eomay_stor, fill = scwyt_scwytt, label = fjwy))  +geom_bar(stat = "identity", position = "dodge") +
    facet_grid(dv~scen) + scale_fill_discrete(name = "sac wyt") + labs(x = "CalSim Feb-Jan Yrs") + theme_gray() +
    scale_y_continuous(sec.axis = dup_axis()) + labs(y = "end of september storage (taf)") +
    geom_hline(data = df_bars_mns, mapping = aes(yintercept = mean, color = scwyt_scwytt), show.legend = FALSE) +
    geom_hline(data = df_bars_mn, mapping = aes(yintercept = mean, linetype = "Overall Sept. Average"), color = "dark blue") +
    scale_linetype_manual(name = " ", values = c(2, 2)) +ggtitle("82 end of september storages")+ 
    scale_fill_manual(values=wyt_cols, name = "sac wyt") +
    scale_color_manual(values=wyt_cols, name = "sac wyt") 
}

pb_eoaug_stor_scwyt_taf <- function(df) {
  df_bars <- df %>% filter(kind == "storage", fjwy>1921, fjwy<2003, wm == 11) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>%
    summarize(eomay_stor =  taf) %>%
    group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(eomay_stor)) %>%
    mutate(taf_dv_rank = row_number()) %>% group_by(scen, dv, scwyt_scwytt) %>% arrange(scwyt_scwytt, desc(eomay_stor)) %>%
    group_by(scen,dv) %>% mutate(x = row_number())
  df_bars_mns <- df_bars %>% group_by(scen, dv, scwyt_scwytt) %>% summarize(mean = mean(eomay_stor))
  df_bars_mn <- df_bars %>% group_by(scen, dv) %>% summarize(mean = mean(eomay_stor))
  
  ggplot(df_bars, aes(x, eomay_stor, fill = scwyt_scwytt, label = fjwy))  +geom_bar(stat = "identity", position = "dodge") +
    facet_grid(dv~scen) + scale_fill_discrete(name = "sac wyt") + labs(x = "CalSim Feb-Jan Yrs") + theme_gray() +
    scale_y_continuous(sec.axis = dup_axis()) + labs(y = "end of august storage (taf)") +
    geom_hline(data = df_bars_mns, mapping = aes(yintercept = mean, color = scwyt_scwytt), show.legend = FALSE) +
    geom_hline(data = df_bars_mn, mapping = aes(yintercept = mean, linetype = "Overall Aug. Average"), color = "dark blue") +
    scale_linetype_manual(name = " ", values = c(2, 2)) +ggtitle("82 end of august storages")+ 
    scale_fill_manual(values=wyt_cols, name = "sac wyt") +
    scale_color_manual(values=wyt_cols, name = "sac wyt") 
}


###########
## diff ###
###########

## bars sums ##

pb_ann_fjwysum_scwyt_taf_d <- function(df) {
  df_bars <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>%
    summarize(fjwytafsum =  sum(taf)) %>%
    group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(fjwytafsum)) %>%
    mutate(taf_dv_rank = row_number()) %>% group_by(scen, dv, scwyt_scwytt) %>% arrange(scwyt_scwytt, desc(fjwytafsum)) %>%
    group_by(scen,dv) %>% mutate(x = row_number())
  df_bars_mns <- df_bars %>% group_by(scen, dv, scwyt_scwytt) %>% summarize(mean = mean(fjwytafsum))
  df_bars_mn <- df_bars %>% group_by(scen, dv) %>% summarize(mean = mean(fjwytafsum))
  
  ggplot(df_bars, aes(x, fjwytafsum, fill = scwyt_scwytt, label = fjwy))  +geom_bar(stat = "identity", position = "dodge") +
    facet_grid(dv~scen) + scale_fill_discrete(name = "sac wyt") + labs(x = "CalSim Feb-Jan Yrs") + theme_gray() +
    scale_y_continuous(sec.axis = dup_axis()) + labs(y = "feb - jan wy sum (taf) [difference]") +
    geom_hline(data = df_bars_mns, mapping = aes(yintercept = mean, color = scwyt_scwytt), show.legend = FALSE) +
    geom_hline(data = df_bars_mn, mapping = aes(yintercept = mean, linetype = "Overall Avg. Ann. Diff"), color = "dark blue") +
    scale_linetype_manual(name = " ", values = c(2, 2)) +ggtitle("sac wyt sums and means, difference")+ 
    scale_fill_manual(values=wyt_cols, name = "sac wyt") +
    scale_color_manual(values=wyt_cols, name = "sac wyt") 
} 

pb_ann_fjwysum_sjwyt_taf_d <- function(df) {
  df_bars <- df %>% filter(rawunit == "cfs", fjwy>1921, fjwy<2003) %>% group_by(scen, dv, fjwy, sjwyt_sjwytt) %>%
    summarize(fjwytafsum =  sum(taf)) %>%
    group_by(scen, dv, sjwyt_sjwytt) %>% arrange(dv, desc(fjwytafsum)) %>%
    mutate(taf_dv_rank = row_number()) %>% group_by(scen, dv, sjwyt_sjwytt) %>% arrange(sjwyt_sjwytt, desc(fjwytafsum)) %>%
    group_by(scen,dv) %>% mutate(x = row_number())
  df_bars_mns <- df_bars %>% group_by(scen, dv, sjwyt_sjwytt) %>% summarize(mean = mean(fjwytafsum))
  df_bars_mn <- df_bars %>% group_by(scen, dv) %>% summarize(mean = mean(fjwytafsum))
  
  ggplot(df_bars, aes(x, fjwytafsum, fill = sjwyt_sjwytt, label = fjwy))  +geom_bar(stat = "identity", position = "dodge") +
    facet_grid(dv~scen) + scale_fill_discrete(name = "sj wyt") + labs(x = "CalSim Feb-Jan Yrs") + theme_gray() +
    scale_y_continuous(sec.axis = dup_axis()) + labs(y = "feb - jan wy sum (taf) [difference]") +
    geom_hline(data = df_bars_mns, mapping = aes(yintercept = mean, color = sjwyt_sjwytt), show.legend = FALSE) +
    geom_hline(data = df_bars_mn, mapping = aes(yintercept = mean, linetype = "Overall Avg. Ann. Diff."), color = "dark blue") +
    scale_linetype_manual(name = " ", values = c(2, 2)) +ggtitle("sj wyt sums means, difference")+ 
    scale_fill_manual(values=wyt_cols, name = "sac wyt") +
    scale_color_manual(values=wyt_cols, name = "sac wyt") 
    
  }

## storage ##

pb_eomay_stor_scwyt_taf_d <- function(df) {
  df_bars <- df %>% filter(kind == "storage", fjwy>1921, fjwy<2003, wm == 8) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>%
    summarize(eomay_stor =  taf) %>%
    group_by(scen, dv, scwyt_scwytt) %>% arrange(dv, desc(eomay_stor)) %>%
    mutate(taf_dv_rank = row_number()) %>% group_by(scen, dv, scwyt_scwytt) %>% arrange(scwyt_scwytt, desc(eomay_stor)) %>%
    group_by(scen,dv) %>% mutate(x = row_number())
  df_bars_mns <- df_bars %>% group_by(scen, dv, scwyt_scwytt) %>% summarize(mean = mean(eomay_stor))
  df_bars_mn <- df_bars %>% group_by(scen, dv) %>% summarize(mean = mean(eomay_stor))
  
  ggplot(df_bars, aes(x, eomay_stor, fill = scwyt_scwytt, label = fjwy))  +geom_bar(stat = "identity", position = "dodge") +
    facet_grid(dv~scen) + scale_fill_discrete(name = "sac wyt") + labs(x = "CalSim Feb-Jan Yrs") + theme_gray() +
    scale_y_continuous(sec.axis = dup_axis()) + labs(y = "end of may storage (taf) [difference]") +
    geom_hline(data = df_bars_mns, mapping = aes(yintercept = mean, color = scwyt_scwytt), show.legend = FALSE) +
    geom_hline(data = df_bars_mn, mapping = aes(yintercept = mean, linetype = "Overall May Avg. Diff."), color = "dark blue") +
    scale_linetype_manual(name = " ", values = c(2, 2)) +ggtitle("82 end of may storages, difference")+ 
    scale_fill_manual(values=wyt_cols, name = "sac wyt") +
    scale_color_manual(values=wyt_cols, name = "sac wyt") 
}

pb_eosep_stor_scwyt_taf_d <- function(df) {
  df_bars <- df %>% filter(kind == "storage", fjwy>1921, fjwy<2003, wm == 12) %>% group_by(scen, dv, dv_name, fjwy, scwyt_scwytt) %>%
    summarize(eomay_stor =  taf) %>%
    group_by(scen, dv, dv_name, scwyt_scwytt) %>% arrange(dv, desc(eomay_stor)) %>%
    mutate(taf_dv_rank = row_number()) %>% group_by(scen, dv, dv_name, scwyt_scwytt) %>% arrange(scwyt_scwytt, desc(eomay_stor)) %>%
    group_by(scen,dv) %>% mutate(x = row_number())
  df_bars_mns <- df_bars %>% group_by(scen, dv, dv_name, scwyt_scwytt) %>% summarize(mean = mean(eomay_stor))
  df_bars_mn <- df_bars %>% group_by(scen, dv, dv_name) %>% summarize(mean = mean(eomay_stor))
  
  ggplot(df_bars, aes(x, eomay_stor, fill = scwyt_scwytt, label = fjwy))  +geom_bar(stat = "identity", position = "dodge") +
    facet_grid(dv_name~scen) + scale_fill_discrete(name = "sac wyt") + labs(x = "CalSim Feb-Jan Yrs") + theme_gray() +
    scale_y_continuous(sec.axis = dup_axis()) + labs(y = "end of september storage (taf) [difference]") +
    geom_hline(data = df_bars_mns, mapping = aes(yintercept = mean, color = scwyt_scwytt), show.legend = FALSE) +
    geom_hline(data = df_bars_mn, mapping = aes(yintercept = mean, linetype = "Overall Sept. Avg. Diff"), color = "dark blue") +
    scale_linetype_manual(name = " ", values = c(2, 2)) +ggtitle("82 end of sept. storages, difference") + 
    scale_fill_manual(values=wyt_cols, name = "sac wyt") +
    scale_color_manual(values=wyt_cols, name = "sac wyt") + 
    theme(strip.text.y = element_text(angle = 0))
    
}

###################################################
### plot exceedance by month, line plot grid ########
###################################################

## taf ## 

## Month facets - dvs apart
 # facet grid
p_monfacetg_excd_taf <- function(df) {

p <- df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, mon)  %>% 
    arrange(dv, desc(taf)) %>% mutate(taf_dv_rank = row_number(),excdxaxis = taf_dv_rank/(n()+1)) %>% 
    ggplot(aes(x = excdxaxis, y = taf, color = scen)) + geom_line() + 
    labs(x = "probability of exceedance", y = "taf") +
    facet_grid(dv~mon) +scale_x_continuous(breaks = c(0.50), sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("monthly exceedance by month") + 
   scale_color_manual(values=df_cols) + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2))) 
  
p   
}

p_monfacetg_excd_taf_d <- function(df) {
  
  p <- df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, mon)  %>% 
    arrange(dv, desc(taf)) %>% mutate(taf_dv_rank = row_number(),excdxaxis = taf_dv_rank/(n()+1)) %>% 
    ggplot(aes(x = excdxaxis, y = taf, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "taf [difference]") +
    facet_grid(dv~mon) +scale_x_continuous(breaks = c(0.50), sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("monthly exceedance by month, difference from baseline") +
   
    scale_color_manual(values=df_diff_cols) + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))
  p   
}

# facet wrap
p_monfacetw_excd_taf <- function(df) {
  
  p <- df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, mon)  %>% 
    arrange(dv, desc(taf)) %>% mutate(taf_dv_rank = row_number(),excdxaxis = taf_dv_rank/(n()+1)) %>% 
    ggplot(aes(x = excdxaxis, y = taf, color = scen)) + geom_line() + 
    labs(x = "probability of exceedance", y = "taf") +
    facet_wrap(~mon, ncol =3) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("monthly exceedance by month") + 
    scale_color_manual(values=df_cols) + theme_gray() + guides(colour = guide_legend(override.aes = list(size=2)))
  p   
}

p_monfacetw_excd_taf_d <- function(df) {
  
  p <- df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, mon)  %>% 
    arrange(dv, desc(taf)) %>% mutate(taf_dv_rank = row_number(),excdxaxis = taf_dv_rank/(n()+1)) %>% 
    ggplot(aes(x = excdxaxis, y = taf, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "taf [difference]") +
    facet_wrap(~mon, ncol = 3) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("monthly exceedance by month, difference from baseline") + 
    scale_color_manual(values=df_diff_cols) + theme_gray() + 
    guides(colour = guide_legend(override.aes = list(size=2)))
  p   
}

## cfs ## 
p_monfacetg_excd_cfs <- function(df) {
  
  p <- df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, mon)  %>% 
    arrange(dv, desc(cfs)) %>% mutate(cfs_dv_rank = row_number(),excdxaxis = cfs_dv_rank/(n()+1)) %>% 
    ggplot(aes(x = excdxaxis, y = cfs, color = scen)) + geom_line() + 
    labs(x = "probability of exceedance", y = "monthly average cfs") +
    facet_grid(dv~mon) +scale_x_continuous(breaks = c(0.50), sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("monthly exceedance by month") + theme_gray()  + 
    scale_color_manual(values=df_cols)+ 
    guides(colour = guide_legend(override.aes = list(size=2))) 
  
  p   
}

p_monfacetg_excd_cfs_d <- function(df) {
  
  p <- df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, mon)  %>% 
    arrange(dv, desc(cfs)) %>% mutate(cfs_dv_rank = row_number(),excdxaxis = cfs_dv_rank/(n()+1)) %>% 
    ggplot(aes(x = excdxaxis, y = cfs, color = scen)) + geom_line() +
  labs(x = "probability of exceedance", y = "monthly average cfs [difference]") +
    facet_grid(dv~mon) +scale_x_continuous(breaks = c(0.50), sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("monthly exceedance by month, difference from baseline") + 
    scale_color_manual(values=df_diff_cols) +theme_gray() + 
    guides(colour = guide_legend(override.aes = list(size=2)))
  p   
}

# facet wrap
p_monfacetw_excd_cfs <- function(df) {
  
  p <- df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, mon)  %>% 
    arrange(dv, desc(cfs)) %>% mutate(cfs_dv_rank = row_number(),excdxaxis = cfs_dv_rank/(n()+1)) %>% 
    ggplot(aes(x = excdxaxis, y = cfs, color = scen)) + geom_line() + 
    labs(x = "probability of exceedance", y = "monthly average cfs") +
    facet_wrap(~mon, ncol =3) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("monthly exceedance by month") + theme_gray() + 
    scale_color_manual(values=df_cols) + guides(colour = guide_legend(override.aes = list(size=2)))
  p   
}

p_monfacetw_excd_cfs_d <- function(df) {
  
  p <- df %>% filter(rawunit == "cfs") %>% group_by(scen, dv, mon)  %>% 
    arrange(dv, desc(cfs)) %>% mutate(cfs_dv_rank = row_number(),excdxaxis = cfs_dv_rank/(n()+1)) %>% 
    ggplot(aes(x = excdxaxis, y = cfs, color = scen)) + geom_line() +
    labs(x = "probability of exceedance", y = "monthly average cfs [difference]") +
    facet_wrap(~mon, ncol = 3) +scale_x_continuous(sec.axis = dup_axis(name = NULL))+scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("monthly exceedance by month, difference from baseline") + theme_gray() +
    scale_color_manual(values=df_diff_cols) + 
    guides(colour = guide_legend(override.aes = list(size=2)))
  p   
}

################################
#######  non-stor taf ridges  ##  #for one dv only!
################################

# plot ridges pr
pr_ts_taf <- function(df, yrmin, yrmax, scalingfactor) { #plots monthly output on y, colors by annual total
df <-df  %>% group_by(scen, wy) %>% mutate(wy_taf = sum(taf))  
sc <- (max(df$taf) / min(df$taf) * scalingfactor) # usually needs to be very low, say 0.00005 for c9
minh <- min(df$taf)
yrmaxtitle <- yrmax-1
ggplot(df, aes(wm, wy, height = taf, group=as.factor(wy), fill = wy_taf))+
  geom_ridgeline( stat = "identity", show.legend = T, scale = sc, alpha = 0.8,
                  min_height = minh) + 
  facet_grid(~scen) +
  scale_fill_viridis() + theme_gray() +
  scale_x_continuous(expand = c(0.02, 0.02),
                     breaks = c(1,2,3,4,5,6,7,8,9,10,11,12),
                     labels = c("O", "N", "D", "J", "F", "M", "A","M","J","J","A","S"),
                     sec.axis = dup_axis()) +
  scale_y_continuous(expand = c(0.02, 0.02),
                     limits  =c(yrmin,yrmax), 
                     breaks = seq(from = 1922, to = 2002, by = 2),
                     labels = seq(from = 1922, to = 2002, by = 2),
                     sec.axis = dup_axis())  +
  theme(axis.title.x = element_blank(), axis.title.y = element_blank())+
  ggtitle(paste0(df$dv[1],"  ", yrmin, " - ", yrmaxtitle))
}



pr_ts_taf_d <- function(df, yrmin, yrmax, scalingfactor) { #plots monthly output on y, colors by annual total
  df_diff <- df_diff %>% group_by(scen, wy, dv) %>% mutate(anntaf_diff = sum(taf)) 
  sc <- (max(df_diff$taf) / min(df_diff$taf) * scalingfactor) # usually needs to be very low, say 0.00005 for c9
  
  minh <- max(df_diff$taf)
  yrmaxtitle <- yrmax-1
  yrmintitle <- yrmin+1
  ggplot(df_diff, aes(wm, wy, height = -taf, group=as.factor(wy), fill = anntaf_diff))+
    geom_ridgeline( stat = "identity", show.legend = T, scale = sc, alpha = 0.8, min_height = -minh) + 
    facet_grid(~scen) +
    scale_fill_gradient2() + theme_gray() +
    scale_x_continuous(expand = c(0.02, 0.02),
                       breaks = c(1,2,3,4,5,6,7,8,9,10,11,12),
                       labels = c("O", "N", "D", "J", "F", "M", "A","M","J","J","A","S"),
                       sec.axis = dup_axis()) +
    scale_y_continuous(expand = c(0.02, 0.02),
                       limits  =c(yrmin,yrmax), 
                       breaks = seq(from = 1922, to = 2002, by = 2),
                       labels = seq(from = 1922, to = 2002, by = 2),
                       sec.axis = dup_axis())  +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
    ggtitle(paste0(df_diff$dv[1], " [difference]", yrmintitle, " - ", yrmaxtitle))
}

##################
## eom ridges diff ###
##################

pr_ts_eomstormean_taf <- function(df, yrmin, yrmax, scalingfactor) { #plots monthly output on y, colors by annual total
  df <-df  %>% group_by(scen, wy) %>% mutate(meaneomtaf = mean(taf))  
  sc <- (max(df$taf) / min(df$taf) * scalingfactor) # usually needs to be very low, say 0.00005 for c9
  yrmaxtitle <- yrmax-1
  ggplot(df, aes(wm, wy, height = taf, group=as.factor(wy), fill = meaneomtaf))+
    geom_ridgeline( stat = "identity", show.legend = T, scale = sc, alpha = 0.8 ) + 
    facet_grid(~scen) +
    scale_fill_viridis() + theme_gray() +
    scale_x_continuous(expand = c(0.02, 0.02),
                       breaks = c(1,2,3,4,5,6,7,8,9,10,11,12),
                       labels = c("O", "N", "D", "J", "F", "M", "A","M","J","J","A","S"),
                       sec.axis = dup_axis()) +
    scale_y_continuous(expand = c(0.02, 0.02),
                       limits  =c(yrmin,yrmax), 
                       breaks = seq(from = 1922, to = 2002, by = 2),
                       labels = seq(from = 1922, to = 2002, by = 2),
                       sec.axis = dup_axis())  +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank())+
    ggtitle(paste0(df$dv[1],"  ", yrmin, " - ", yrmaxtitle))
}





pr_ts_eomstormean_taf_d <- function(df, yrmin, yrmax, scalingfactor) { #plots monthly output on y, colors by annual total
  df_diff <- df_diff  %>% mutate(abstaf = abs(taf)) %>% group_by(scen, wy) %>% mutate(mnabseomtaf_d = mean(abstaf)) 
  sc <- (max(df_diff$taf) / min(df_diff$taf) * scalingfactor) # usually needs to be very low, say 0.00005 for c9
  mh <- max(df_diff$taf)
  yrmaxtitle <- yrmax-1
  yrmintitle <- yrmin+1
  ggplot(df_diff, aes(wm, wy, height = -taf, group=as.factor(wy), fill = mnabseomtaf_d))+
    geom_ridgeline( stat = "identity", show.legend = T, scale = sc, alpha = 0.8, min_height = -mh) + 
    facet_grid(~scen) +
    scale_fill_gradient2()  + theme_gray() +
    scale_x_continuous(expand = c(0.05, 0.05),
                       breaks = c(1,2,3,4,5,6,7,8,9,10,11,12),
                       labels = c("O", "N", "D", "J", "F", "M", "A","M","J","J","A","S"),
                       sec.axis = dup_axis()) +
    scale_y_continuous(expand = c(0.02, 0.02),
                       limits  =c(yrmin,yrmax), 
                       breaks = seq(from = 1922, to = 2002, by = 2),
                       labels = seq(from = 1922, to = 2002, by = 2),
                       sec.axis = dup_axis())  +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
    ggtitle(paste0(df_diff$dv[1], " [difference]", yrmintitle, " - ", yrmaxtitle))
}

#########################
## Plot Box plot
#########################

## Monthly ## use for one dv only, otherwise too cluttered
#plot box plot pbp
pbp_mon_taf <- function(df) {
  
  df %>% group_by(wm, scen, dv)%>% mutate(scen_wm_dv= paste0(scen, "_", wm, "_", dv)) %>%
    ggplot(aes(x = wm, y = taf, color = scen, group = scen_wm_dv)) + geom_boxplot(outlier.alpha = 0.5)+
    scale_x_continuous(expand = c(0.01, 0.01),limits = c(0.5,12.5), breaks = c(1:12),
                       labels = c('O', 'N', 'D', 'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S'),sec.axis = dup_axis(name = NULL) ) +
    labs(y = "taf", x  = NULL) + facet_grid(~dv) +
    scale_y_continuous(sec.axis = dup_axis(name = NULL))+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +ggtitle("monthly distribution (984 months)")+ 
    scale_color_manual(values=df_cols)
}

## Monthly by Sac WYT ##

pbp_mon_scwyt_taf <- function(df) {  #use for one dv only, otherwise too cluttered

df %>% group_by(wm, scen, dv)%>% mutate(scen_wm_dv= paste0(scen, "_", wm, "_", dv)) %>%
ggplot(aes(x = wm, y = taf, color = scen, group = scen_wm_dv)) + geom_boxplot(outlier.alpha = 0.5)+
   scale_x_continuous(expand = c(0.01, 0.01),limits = c(0.5,12.5), breaks = c(1:12),
  labels = c('O', 'N', 'D', 'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S'),sec.axis = dup_axis(name = NULL) )+
    labs(y = "taf") + 
    facet_grid(dv~ scwyt_scwytt  )+ theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("monthly distribution by sac wyt") + 
    scale_color_manual(values=df_cols)
}


## Monthly Difference ##

pbp_mon_taf_d <- function(df) {
  
  df %>% group_by(wm, scen, dv)%>% mutate(scen_wm_dv= paste0(scen, "_", wm, "_", dv)) %>%
    ggplot(aes(x = wm, y = taf, color = scen, group = scen_wm_dv)) + geom_boxplot(outlier.alpha = 0.5)+
    scale_x_continuous(expand = c(0.01, 0.01),limits = c(0.5,12.5), breaks = c(1:12),
                       labels = c('O', 'N', 'D', 'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S'),sec.axis = dup_axis(name = NULL) ) +
    labs(y = "taf [difference]", x  = NULL) + facet_grid(~dv) + 
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    scale_y_continuous(sec.axis = dup_axis(name = NULL)) +
    ggtitle("monthly distribution (984 months), difference") + 
    scale_color_manual(values=df_diff_cols)
}

## Monthly difference by Sac WYT ##

pbp_mon_scwyt_taf_d <- function(df) {  #use for one dv only, otherwise too cluttered
  
  df %>% group_by(wm, scen, dv)%>% mutate(scen_wm_dv= paste0(scen, "_", wm, "_", dv)) %>%
    ggplot(aes(x = wm, y = taf, color = scen, group = scen_wm_dv)) + geom_boxplot(outlier.alpha = 0.5)+
    scale_x_continuous(expand = c(0.01, 0.01),limits = c(0.5,12.5), breaks = c(1:12),
                       labels = c('O', 'N', 'D', 'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S'),sec.axis = dup_axis(name = NULL) )+
    labs(y = "taf [difference]") + 
    facet_grid(dv~ scwyt_scwytt  )+ theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ggtitle("monthly distribution by sac wyt, difference from baseline") + 
    scale_color_manual(values=df_diff_cols)
}


## Annual ##  


pbp_ann_perav_wysum_taf <- function(df) {
  
  df %>% filter(kind != "storage") %>% group_by(scen, dv, wy) %>% summarize(wytafsum =  sum(taf)) %>%
    ggplot(aes(x = scen, y = wytafsum, color = scen, group = scen)) + geom_boxplot() +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(~dv)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "taf") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("82 water year totals") + stat_summary(fun.y=mean, geom="point", shape=18, color= "dark blue") + 
    stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", color = "dark blue", angle = 0,
                 vjust = 1.25) + 
    scale_color_manual(values=df_cols)
}

pbp_ann_perav_fjwysum_taf <- function(df) {
  
  df %>% filter(kind != "storage", fjwy > 1921, fjwy < 2003) %>% group_by(scen, dv, fjwy) %>%
    summarize(fjwytafsum =  sum(taf))  %>%
    ggplot(aes(x = scen, y = fjwytafsum, color = scen, group = scen)) + geom_boxplot() +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(~dv)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "feb-jan water year total (taf)") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    ggtitle("81 feb-jan water year totals") + stat_summary(fun.y=mean, geom="point", shape=18, color= "red") + 
    stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", color = "red", angle = 90,
                 hjust = -0.5) + 
    scale_color_manual(values=df_cols)
}

pbp_ann_perav_mfwysum_taf <- function(df) {
  
  df %>% filter(kind != "storage", mfwy > 1921, mfwy < 2003) %>% group_by(scen, dv, mfwy) %>%
    summarize(mfwytafsum =  sum(taf))  %>%
    ggplot(aes(x = scen, y = mfwytafsum, color = scen, group = scen)) + geom_boxplot() +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(~dv)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "mar-feb water year total (taf)") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    ggtitle("81 mar-feb water year totals")+ stat_summary(fun.y=mean, geom="point", shape=18, color= "red") + 
    stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", color = "red", angle = 90,
                 hjust = -0.5) + 
    scale_color_manual(values=df_cols)
}

pbp_ann_perav_fjwysum_scwyt_taf <- function(df) {
  
  df %>% filter(kind != "storage", fjwy > 1921, fjwy < 2003) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>%
    summarize(fjwytafsum =  sum(taf))  %>%
    ggplot(aes(x = scen, y = fjwytafsum, color = scen, group = scen)) + geom_boxplot() +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(dv~scwyt_scwytt)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "feb-jan water year total (taf)") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    ggtitle("81 feb-jan water year totals b ysac wyt")+ stat_summary(fun.y=mean, geom="point", shape=18, color= "red") + 
    stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", color = "red", angle = 90,
                 hjust = -0.5) + 
    scale_color_manual(values=df_cols)
}

## Diffs ##

pbp_ann_perav_wysum_taf_d <- function(df) {
  
  df %>% filter(kind != "storage") %>% group_by(scen, dv, wy) %>% summarize(wytafsum =  sum(taf)) %>%
    ggplot(aes(x = scen, y = wytafsum, color = scen, group = scen)) + geom_boxplot() +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(~dv)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "taf [difference]") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    ggtitle("82 water year totals, difference from baseline")+ stat_summary(fun.y=mean, geom="point", 
    shape=18, color= "dark blue") + stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", 
    color = "dark blue", angle = 0,  vjust = 1.25) + 
    scale_color_manual(values=df_diff_cols)
}

pbp_ann_perav_fjwysum_taf_d <- function(df) {
  
  df %>% filter(kind != "storage", fjwy > 1921, fjwy < 2003) %>% group_by(scen, dv, fjwy) %>%
    summarize(fjwytafsum =  sum(taf))  %>%
    ggplot(aes(x = scen, y = fjwytafsum, color = scen, group = scen)) + geom_boxplot() +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(~dv)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "feb-jan water year total (taf) [difference]") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    ggtitle("81 feb-jan water year totals, difference from baseline") + stat_summary(fun.y=mean,
    geom="point", shape=18, color= "red") + 
    stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", color = "red",angle = 90,
                 hjust = -0.5) + 
    scale_color_manual(values=df_diff_cols)
}

pbp_ann_perav_mfwysum_taf_d <- function(df) {
  
  df %>% filter(kind != "storage", mfwy > 1921, mfwy < 2003) %>% group_by(scen, dv, mfwy) %>%
    summarize(mfwytafsum =  sum(taf))  %>%
    ggplot(aes(x = scen, y = mfwytafsum, color = scen, group = scen)) + geom_boxplot() +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(~dv)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "mar-feb water year total (taf) [difference]") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    ggtitle("81 mar-feb water year totals, difference from baseline")+ stat_summary(fun.y=mean,
    geom="point", shape=18, color= "red") + 
    stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", color = "red",angle = 90,
                 hjust = -0.5) + 
    scale_color_manual(values=df_diff_cols)
}

pbp_ann_perav_fjwysum_scwyt_taf_d <- function(df) {
  
  df %>% filter(kind != "storage", fjwy > 1921, fjwy < 2003) %>% group_by(scen, dv, fjwy, scwyt_scwytt) %>%
    summarize(fjwytafsum =  sum(taf))  %>%
    ggplot(aes(x = scen, y = fjwytafsum, color = scen, group = scen)) + geom_boxplot() +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(dv~scwyt_scwytt)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "feb-jan water year total (taf) [difference]") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    ggtitle("81 feb-jan water year totals by sac wyt, difference from baseline")+ stat_summary(fun.y=mean,
    geom="point", shape=18, color= "red")  + 
    scale_color_manual(values=df_diff_cols)
}

#########################
## Plot dot plots
#########################

#plot dot plot pdp
pdp_ann_perav_wysum_taf <- function(df, binwidth, dotsize) {
  
  df %>% filter(kind != "storage", wy > 1921, wy < 2004) %>% group_by(scen, dv, wy) %>%
    summarize(wytafsum =  sum(taf))  %>%
    ggplot(aes(x = scen, y = wytafsum, color = scen, group = scen)) +
    geom_boxplot() +
    geom_dotplot(binaxis = "y",  stackdir = "center", binwidth = binwidth, dotsize = dotsize) +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(~dv)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "taf") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    ggtitle("82 water year totals") + stat_summary(fun.y=mean, geom="point", shape=18,
                                                               size=4, color= "dark blue") +
    stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=4, color = "dark blue",
                 vjust = -0.5)  + 
    scale_color_manual(values=df_cols)
}

pdp_ann_perav_mfwysum_taf <- function(df, binwidth, dotsize) {
  
  df %>% filter(kind != "storage", mfwy > 1921, mfwy < 2003) %>% group_by(scen, dv, mfwy) %>%
    summarize(mfwytafsum =  sum(taf))  %>%
    ggplot(aes(x = scen, y = mfwytafsum, color = scen, group = scen)) +
    geom_boxplot() +
    geom_dotplot(binaxis = "y",  stackdir = "center", binwidth = binwidth, dotsize = dotsize) +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(~dv)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "mar-feb water year total (taf)") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    ggtitle("81 mar-feb water year totals") + stat_summary(fun.y=mean, geom="point", shape=18,
    size=4, color= "red") +
    stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=4, color = "red",
                 vjust = -0.5) + 
    scale_color_manual(values=df_cols)
}
## diff ##

pdp_ann_perav_wysum_taf_d <- function(df, binwidth, dotsize) {
  
  df %>% filter(kind != "storage", wy > 1921, wy < 2004) %>% group_by(scen, dv, wy) %>%
    summarize(wytafsum =  sum(taf))  %>%
    ggplot(aes(x = scen, y = wytafsum, color = scen, group = scen)) +
    geom_boxplot() +
    geom_dotplot(binaxis = "y",  stackdir = "center", binwidth = binwidth, dotsize = dotsize) +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(~dv)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "taf [difference]") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    ggtitle("82 water years totals, difference from baseline") + stat_summary(fun.y=mean, geom="point", shape=18,
                                                             size=4, color= "red") +
    stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=4, color = "red",
                 vjust = -0.5) + 
    scale_color_manual(values=df_diff_cols)
}

pdp_ann_perav_mfwysum_taf_d <- function(df, binwidth, dotsize) {
  
  df %>% filter(kind != "storage", mfwy > 1921, mfwy < 2003) %>% group_by(scen, dv, mfwy) %>%
    summarize(mfwytafsum =  sum(taf))  %>%
    ggplot(aes(x = scen, y = mfwytafsum, color = scen, group = scen)) +
    geom_boxplot() +
    geom_dotplot(binaxis = "y",  stackdir = "center", binwidth = binwidth, dotsize = dotsize) +
    scale_y_continuous(sec.axis = dup_axis(name = NULL) ) + facet_grid(~dv)+
    theme_gray() + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    labs(y = "mar-feb water year total (taf) [difference]") + 
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) + 
    ggtitle("81 mar-feb water year totals, difference from baseline") + stat_summary(fun.y=mean, geom="point", shape=18,
                                                               size=4, color= "red") +
    stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=4, color = "red",
                 vjust = -0.5)  + 
    scale_color_manual(values=df_diff_cols)
}

#########################
## Plot density ridges
#########################

pdr_ann_perav_wysum_taf <- function(df) {
  df_mn <- df %>% group_by(dv,scen) %>% summarize(annmean = 12*mean(taf))
  df_md <- df %>% group_by(dv,scen,wy) %>% summarize(wysumtaf = sum(taf)) %>% group_by(scen, dv) %>% summarize(median = median(wysumtaf)) 
df %>% filter(kind != "storage") %>% group_by(scen, dv, wy) %>% summarize(wytafsum = sum(taf)) %>%
ggplot(aes(x=wytafsum, y=scen, color=dv, point_color=dv, fill=dv)) +
  geom_density_ridges(geom = "density_ridges_gradient", calc_ecdf = TRUE, jittered_points=TRUE, scale = .95, rel_min_height = .01,
                      point_shape = "|", point_size = 3, size = 0.25, quantile_lines = TRUE, quantiles = 4,
                      position = position_points_jitter(height = 0), alpha = 0.5) +
  scale_y_discrete(expand = c(.01, 0))  +
  scale_x_continuous(expand = c(0, 0), name = "water year total (taf)", sec.axis = dup_axis(name = NULL)) +
  theme_ridges(center = TRUE) + ggtitle("82 water year totals") + theme_gray() +
  #geom_point(data = df_md, mapping = aes(x = median, y = scen, color = dv), shape = 124, size = 10) +
  #geom_text(data = df_md, mapping = aes(x = median, y = scen, label = round(median,0)), color = "black") +
  geom_point(data = df_mn, mapping = aes(x = annmean, y = scen, fill = dv), color = "black", shape = 21) 
}

pdr_ann_perav_mfwysum_taf <- function(df) {
  df_mn <- df %>% filter(mfwy > 1921, mfwy < 2003) %>% group_by(dv,scen) %>% summarize(annmean = 12*mean(taf))
  df_md <- df %>% filter(mfwy > 1921, mfwy < 2003) %>% group_by(dv,scen,mfwy) %>% summarize(wysumtaf = sum(taf)) %>% group_by(scen, dv) %>% summarize(median = median(wysumtaf))
  df %>% filter(kind != "storage", mfwy > 1921, mfwy < 2003) %>% group_by(scen, dv, mfwy) %>%
    summarize(mfwytafsum = sum(taf)) %>%
    ggplot(aes(x=mfwytafsum, y=scen, color=dv, point_color=dv, fill=dv)) +
    geom_density_ridges(geom = "density_ridges_gradient", calc_ecdf = TRUE, jittered_points=TRUE, scale = .95, rel_min_height = .01,
                        point_shape = "|", point_size = 3, size = 0.25,  quantile_lines = TRUE, quantiles = 4,
                        position = position_points_jitter(height = 0), alpha = 0.5) +
    scale_y_discrete(expand = c(.01, 0)) +
    scale_x_continuous(expand = c(0, 0), name = "mar-feb water year total (taf)", sec.axis = dup_axis(name = NULL)) +
    theme_ridges(center = TRUE)   + theme_gray() + 
    ggtitle("81 mar-feb water year totals")+
    geom_point(data = df_mn, mapping = aes(x = annmean, y = scen, fill = dv), color = "black", shape = 21) 
}


pdr2_ann_perav_wysum_taf <- function(df) {
  df_mn <- df %>% group_by(dv,scen) %>% summarize(annmean = 12*mean(taf))
  df_md <- df %>% group_by(dv,scen,wy) %>% summarize(wysumtaf = sum(taf)) %>% group_by(scen, dv) %>% summarize(median = median(wysumtaf)) 
  df %>% filter(kind != "storage") %>% group_by(scen, dv, wy) %>% summarize(wytafsum = sum(taf)) %>%
    ggplot(aes(x=wytafsum, y=scen, color=scen,  fill=scen), point_color="gray") +
    geom_density_ridges(geom = "density_ridges_gradient", calc_ecdf = TRUE, jittered_points=TRUE, scale = .95, rel_min_height = .01,
    point_shape = "|", point_size = 3, size = 0.25, quantile_lines = TRUE, quantiles = 4,
    position = position_points_jitter(height = 0), alpha = 0.5) +
    scale_y_discrete(expand = c(.01, 0))  + labs(y = NULL)+
    scale_x_continuous(expand = c(0, 0), name = "water year total (taf)", sec.axis = dup_axis(name = NULL)) +
    theme_ridges(center = TRUE) + ggtitle("82 water year totals")  +
    geom_point(data = df_mn, mapping = aes(x = annmean, y = scen, fill = scen), color = "black", shape = 21, size = 2) +
    geom_text(data = df_md, mapping = aes(x = median, y = scen, fill = scen, label = round(median,0)), color = "red", shape = 21, size = 6) +
    facet_wrap(~dv)
}
## diff ##

pdr_ann_perav_wysum_taf_d <- function(df) {
  df_mn <- df %>% group_by(dv,scen) %>% summarize(annmean = 12*mean(taf))
  df_md <- df %>% group_by(dv,scen,wy) %>% summarize(wysumtaf = sum(taf)) %>% group_by(scen, dv) %>% summarize(median = median(wysumtaf))
  df %>% filter(kind != "storage") %>% group_by(scen, dv, wy) %>% summarize(wytafsum = sum(taf)) %>%
    ggplot(aes(x=wytafsum, y=scen, color=dv, point_color=dv, fill=dv)) +
    geom_density_ridges(geom = "density_ridges_gradient", calc_ecdf = TRUE, jittered_points=TRUE, scale = .95, rel_min_height = .01,
                        point_shape = "|", point_size = 3, size = 0.25, quantile_lines = TRUE, quantiles = 4,
                        position = position_points_jitter(height = 0), alpha = 0.5) +
    scale_y_discrete(expand = c(.01, 0)) +
    scale_x_continuous(expand = c(0, 0), name = "water year total (taf) [difference]", sec.axis = dup_axis(name = NULL)) +
    theme_ridges(center = TRUE) + ggtitle("82 water year totals, difference from baseline") +
    theme_gray() +
    #geom_point(data = df_md, mapping = aes(x = median, y = scen, color = dv), shape = 124, size = 10) +
    geom_point(data = df_mn, mapping = aes(x = annmean, y = scen, fill = dv), color = "black", shape = 21) 
}

pdr2_ann_perav_wysum_taf_d <- function(df) {
  df_mn <- df %>% group_by(dv,scen) %>% summarize(annmean = 12*mean(taf))
  df_md <- df %>% group_by(dv,scen,wy) %>% summarize(wysumtaf = sum(taf)) %>% group_by(scen, dv) %>% summarize(median = median(wysumtaf))
  df %>% filter(kind != "storage") %>% group_by(scen, dv, wy) %>% summarize(wytafsum = sum(taf)) %>%
    ggplot(aes(x=wytafsum, y=scen, color=scen, point_color=scen, fill=scen)) +
    geom_density_ridges(geom = "density_ridges_gradient", calc_ecdf = TRUE, jittered_points=TRUE, scale = .95, rel_min_height = .01,
                        point_shape = "|", point_size = 3, size = 0.25, quantile_lines = TRUE, quantiles = 4,
                        position = position_points_jitter(height = 0), alpha = 0.5) +
    scale_y_discrete(expand = c(.01, 0)) +
    scale_x_continuous(expand = c(0, 0), name = "water year total (taf) [difference]", sec.axis = dup_axis(name = NULL)) +
    theme_ridges(center = TRUE) + ggtitle("82 water year totals, difference from baseline") +
    theme_gray() + facet_grid(~dv) + 
    #geom_point(data = df_md, mapping = aes(x = median, y = scen, color = scen), shape = 124, size = 10) +
    geom_point(data = df_mn, mapping = aes(x = annmean, y = scen, fill = scen), color = "black", shape = 21) 
}

pdr_ann_perav_mfwysum_taf_d <- function(df) {
  df_mn <- df %>% filter(mfwy > 1921, mfwy < 2003) %>% group_by(dv,scen) %>% summarize(annmean = 12*mean(taf))
  df_md <- df %>% filter(mfwy > 1921, mfwy < 2003) %>% group_by(dv,scen,mfwy) %>% summarize(wysumtaf = sum(taf)) %>% group_by(scen, dv) %>% summarize(median = median(wysumtaf))
  df %>% filter(kind != "storage", mfwy > 1921, mfwy < 2003) %>% group_by(scen, dv, mfwy) %>%
    summarize(mfwytafsum = sum(taf)) %>%
    ggplot(aes(x=mfwytafsum, y=scen, color=dv, point_color=dv, fill=dv)) +
    geom_density_ridges(geom = "density_ridges_gradient", calc_ecdf = TRUE, jittered_points=TRUE, scale = .95, rel_min_height = .01,
    point_shape = "|", point_size = 3, size = 0.25, quantile_lines = TRUE, quantiles = 4,
    position = position_points_jitter(height = 0), alpha = 0.5) +
    scale_y_discrete(expand = c(.01, 0)) +
    scale_x_continuous(expand = c(0, 0), name = "mar-feb water year total (taf) [difference]", sec.axis = dup_axis(name = NULL)) +
    theme_ridges(center = TRUE)  + theme_gray() +  
    ggtitle("81 mar-feb water year totals, difference from baseline")+
    geom_point(data = df_mn, mapping = aes(x = annmean, y = scen, fill = dv), color = "black", shape = 21) 
}

#######################################################################################
########## Plot themes, rarely used, varieties of theme_black allow black background,
########## good for viridis & color blind 
#######################################################################################

theme_black = function(base_size = 12, base_family = "") 
  
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
  
  theme(
    # Specify axis options
    axis.line = element_blank(),  
    axis.text.x = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
    axis.text.y = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
    axis.ticks = element_line(color = "white", size  =  0.2),  
    axis.title.x = element_text(size = base_size, color = "white", margin = margin(0, 10, 0, 0)),  
    axis.title.y = element_text(size = base_size, color = "white", angle = 90, margin = margin(0, 10, 0, 0)),  
    axis.ticks.length = unit(0.3, "lines"),   
    # Specify legend options
    legend.background = element_rect(color = NA, fill = "black"),  
    legend.key = element_rect(color = "white",  fill = "black"),  
    legend.key.size = unit(1.2, "lines"),  
    legend.key.height = NULL,  
    legend.key.width = NULL,      
    legend.text = element_text(size = base_size*0.8, color = "white"),  
    legend.title = element_text(size = base_size*0.8, face = "bold", hjust = 0, color = "white"),  
    legend.position = "right",  
    legend.text.align = NULL,  
    legend.title.align = NULL,  
    legend.direction = "vertical",  
    legend.box = NULL, 
    # Specify panel options
    panel.background = element_rect(fill = "black", color  =  NA),  
    panel.border = element_rect(fill = NA, color = "white"),  
    panel.grid.major = element_blank(),#element_line(color = "grey35"),  
    panel.grid.minor = element_blank(),#element_line(color = "grey20"),  
    panel.margin = unit(0.5, "lines"),   
    # Specify facetting options
    strip.background = element_rect(fill = "grey30", color = "grey10"),  
    strip.text.x = element_text(size = base_size*0.8, color = "white"),  
    strip.text.y = element_text(size = base_size*0.8, color = "white",angle = -90),  
    # Specify plot options
    plot.background = element_rect(color = "black", fill = "black"),  
    plot.title = element_text(size = base_size*1.2, color = "white"),  
    plot.margin = unit(rep(1, 4), "lines")
    
  )


theme_black2 = function(base_size = 12, base_family = "") 
  
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
  
  theme(
    # Specify axis options
    axis.line = element_blank(),  
    axis.text.x = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
    axis.text.y = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
    axis.ticks = element_line(color = "white", size  =  0.2),  
    axis.title.x = element_text(size = base_size, color = "white", margin = margin(0, 10, 0, 0)),  
    axis.title.y = element_text(size = base_size, color = "white", angle = 90, margin = margin(0, 10, 0, 0)),  
    axis.ticks.length = unit(0.3, "lines"),   
    # Specify legend options
    legend.background = element_rect(color = NA, fill = "black"),  
    legend.key = element_rect(color = "white",  fill = "black"),  
    legend.key.size = unit(1.2, "lines"),  
    legend.key.height = NULL,  
    legend.key.width = NULL,      
    legend.text = element_text(size = base_size*0.8, color = "white"),  
    legend.title = element_text(size = base_size*0.8, face = "bold", hjust = 0, color = "white"),  
    legend.position = "right",  
    legend.text.align = NULL,  
    legend.title.align = NULL,  
    legend.direction = "vertical",  
    legend.box = NULL, 
    # Specify panel options
    panel.background = element_rect(fill = "black", color  =  NA),  
    panel.border = element_rect(fill = NA, color = "white"),  
    panel.grid.major = element_line(color = "grey35"),  
    panel.grid.minor = element_line(color = "grey35"),  #origgrey20
    panel.margin = unit(0.5, "lines"),   
    # Specify facetting options
    strip.background = element_rect(fill = "grey35", color = "grey10"),  
    #orig grey 30
    strip.text.x = element_text(size = base_size*0.8, color = "white"),  
    strip.text.y = element_text(size = base_size*0.8, color = "white",angle = -90),  
    # Specify plot options
    plot.background = element_rect(color = "black", fill = "black"),  
    plot.title = element_text(size = base_size*1.2, color = "white"),  
    plot.margin = unit(rep(1, 4), "lines")
    
  )

theme_allblack = function(base_size = 12, base_family = "") 
  
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
  
  theme(
    # Specify axis options
    axis.line = element_blank(),  
    axis.text.x = element_text(size = base_size*0.8, color = "black", lineheight = 0.9),  
    axis.text.y = element_text(size = base_size*0.8, color = "black", lineheight = 0.9),  
    axis.ticks = element_line(color = "black", size  =  0.2),  
    axis.title.x = element_text(size = base_size, color = "black", margin = margin(0, 10, 0, 0)),  
    axis.title.y = element_text(size = base_size, color = "black", angle = 90, margin = margin(0, 10, 0, 0)),  
    axis.ticks.length = unit(0.3, "lines"),   
    # Specify legend options
    legend.background = element_rect(color = NA, fill = "black"),  
    legend.key = element_rect(color = "black",  fill = "black"),  
    legend.key.size = unit(1.2, "lines"),  
    legend.key.height = NULL,  
    legend.key.width = NULL,      
    legend.text = element_text(size = base_size*0.8, color = "black"),  
    legend.title = element_text(size = base_size*0.8, face = "bold", hjust = 0, color = "black"),  
    legend.position = "right",  
    legend.text.align = NULL,  
    legend.title.align = NULL,  
    legend.direction = "vertical",  
    legend.box = NULL, 
    # Specify panel options
    panel.background = element_rect(fill = "black", color  =  NA),  
    panel.border = element_rect(fill = NA, color = "black"),  
    panel.grid.major = element_line(color = "black"),  
    panel.grid.minor = element_line(color = "black"),  #origgrey20
    panel.margin = unit(0.5, "lines"),   
    # Specify facetting options
    strip.background = element_rect(fill = "black", color = "black"),  
    #orig grey 30
    strip.text.x = element_text(size = base_size*0.8, color = "black"),  
    strip.text.y = element_text(size = base_size*0.8, color = "black",angle = -90),  
    # Specify plot options
    plot.background = element_rect(color = "black", fill = "black"),  
    plot.title = element_text(size = base_size*1.2, color = "black"),  
    plot.margin = unit(rep(1, 4), "lines")
    
  )

theme_black3 = function(base_size = 12, base_family = "") 
  
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
  
  theme(
    # Specify axis options
    axis.line = element_blank(),  
    axis.text.x = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
    axis.text.y = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
    axis.ticks = element_line(color = "white", size  =  0.2),  
    axis.title.x = element_text(size = base_size, color = "white", margin = margin(0, 10, 0, 0)),  
    axis.title.y = element_text(size = base_size, color = "white", angle = 90, margin = margin(0, 10, 0, 0)),  
    axis.ticks.length = unit(0.3, "lines"),   
    # Specify legend options
    legend.background = element_rect(color = NA, fill = NA),  
    legend.key = element_rect(color = "white",  fill = "black"),  
    legend.key.size = unit(1.2, "lines"),  
    legend.key.height = NULL,  
    legend.key.width = NULL,      
    legend.text = element_text(size = base_size*0.8, color = "white"),  
    legend.title = element_text(size = base_size*0.8, face = "bold", hjust = 0, color = "white"),  
    legend.position = "right",  
    legend.text.align = NULL,  
    legend.title.align = NULL,  
    legend.direction = "vertical",  
    legend.box = NULL, 
    # Specify panel options
    panel.background = element_rect(fill = "black", color  =  NA),  
    panel.border = element_rect(fill = NA, color = "white"),  
    panel.grid.major = element_line(color = "grey35"),  
    panel.grid.minor = element_line(color = "grey35"),  #origgrey20
    panel.margin = unit(0.5, "lines"),   
    # Specify facetting options
    strip.background = element_rect(fill = "grey35", color = "grey10"),  
    #orig grey 30
    strip.text.x = element_text(size = base_size*0.8, color = "white"),  
    strip.text.y = element_text(size = base_size*0.8, color = "white",angle = -90),  
    # Specify plot options
    plot.background = element_rect(color = "black", fill = "black"),  
    plot.title = element_text(size = base_size*1.2, color = "white"),  
    plot.margin = unit(rep(1, 4), "lines")
    
  )


## USBR draft - D. O'Connor 2018 ##
