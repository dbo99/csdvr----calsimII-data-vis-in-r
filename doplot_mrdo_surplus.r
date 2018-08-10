

## MRDO WQ ## 

{dvs <- c("d407", "c407_ann")
df <- create_df(df_csv) 
df_diff <- create_df_diff(df)
setwd("..")
source("scenfacts.r")

df <- df  %>% select(tstep, scen, dv, cfs) %>% spread(dv, cfs) %>% mutate(cfs = d407 + c407_ann, dv = "mrdo_wq (d407+c407_ann)", rawunit = "cfs",
                                                                          taf = ifelse(rawunit == "cfs", cfs_taf(cfs,tstep), NA),yearmon = as.yearmon(tstep))

wyt <- read_csv("wyt.csv") %>% mutate(tstep = mdy(tstep)) #makes sure date read in as date
scwyt_txt <- data.frame("scwyt" = c(1,2,3,4,5), "scwytt"=c("wt", "an", "bn", "dr", "cr"))
sjwyt_txt <- data.frame("sjwyt" = c(1,2,3,4,5), "sjwytt"=c("wt", "an", "bn", "dr", "cr"))

df <- df %>% inner_join(wyt) %>% inner_join(scwyt_txt) %>% inner_join(sjwyt_txt) %>%
  mutate(scwyt_scwytt = paste0(scwyt, "_", scwytt), sjwyt_sjwytt = paste0(sjwyt, "_", sjwytt))  %>%
  mutate(scwyt = as.integer(scwyt), sjwyt = as.integer(sjwyt)) 

df <- df %>%  mutate(nxtscwyt = lead(scwyt,5)) %>%
  mutate(nxtscwytt = ifelse(nxtscwyt == 1, "wt", ifelse(nxtscwyt == 2, "an", ifelse(nxtscwyt == 3, "bn", ifelse(nxtscwyt == 4, "dr", 
                                                                                                                ifelse(nxtscwyt ==5, "cr", NA))))))  %>% mutate(scwyt2 = paste0(nxtscwyt, "_", nxtscwytt))

lastwyt <- df %>% filter(scen == "baseline", yearmon == "Apr 2003") %>% select(scwyt2) #%>% paste0(lastwyt[1])
lastwyt <- paste0(lastwyt[1])
df <- df %>% mutate(scwyt2 = ifelse(scwyt2 == "NA_NA", lastwyt, scwyt2 )) 
yrange <- df  %>% group_by(dv, scen, scwyt2) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf))
ymax <- max(yrange$mnanntaf_perav_wyt)
p <- df  %>% group_by(dv, scen, scwyt2) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
  ggplot(aes(x = scwyt2, y = mnanntaf_perav_wyt, fill = scwyt2, label = round(mnanntaf_perav_wyt,0))) +
  geom_bar(position = "dodge",stat = "identity") + 
  theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
  ylab("taf") + 
  #geom_text(color = "dark blue", angle = 90) +
  facet_grid(dv~scen) +
  scale_fill_discrete(name = "sac wyt") + theme(axis.title.x=element_blank()) +
  geom_hline(data = df %>% filter( scen == "baseline") %>% 
               group_by(dv, scwyt2) %>%
               summarize(mean = 12*mean(taf)),
             mapping = aes(yintercept = mean, color = scwyt2), show.legend = FALSE) +
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
  geom_hline(data = df %>% filter( scen == "baseline") %>% group_by(dv, scwyt2) %>% 
               summarize(mean = 12*mean(taf)),
             mapping = aes(yintercept = mean), show.legend = FALSE, linetype = "dashed", color = "black", size = 0.2) +
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
  scale_y_continuous(expand = c(0.01,0.01)) + ggtitle("Annual MRDO_WQ Outflow Volumes (82 water years)\nby Sacramento Water Year Type Means (82 water years)") +
  coord_cartesian(ylim=c(3800, ymax)) 
setwd("./plots")
p
ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bars_diffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
setwd('..')
setwd("./plotexportscripts")
}

## Surplus  ## 

{dvs <- c("c407_cvp", "c407_swp")
  df <- create_df(df_csv) 
  df_diff <- create_df_diff(df)
  setwd("..")
  source("scenfacts.r")
  
  df <- df  %>% select(tstep, scen, dv, cfs) %>% spread(dv, cfs) %>% mutate(cfs = c407_cvp + c407_swp, dv = "CVP & SWP Surplus (c407_cvp + c407_swp)", rawunit = "cfs",
                                                                            taf = ifelse(rawunit == "cfs", cfs_taf(cfs,tstep), NA),yearmon = as.yearmon(tstep))
  
  wyt <- read_csv("wyt.csv") %>% mutate(tstep = mdy(tstep)) #makes sure date read in as date
  scwyt_txt <- data.frame("scwyt" = c(1,2,3,4,5), "scwytt"=c("wt", "an", "bn", "dr", "cr"))
  sjwyt_txt <- data.frame("sjwyt" = c(1,2,3,4,5), "sjwytt"=c("wt", "an", "bn", "dr", "cr"))
  
  df <- df %>% inner_join(wyt) %>% inner_join(scwyt_txt) %>% inner_join(sjwyt_txt) %>%
    mutate(scwyt_scwytt = paste0(scwyt, "_", scwytt), sjwyt_sjwytt = paste0(sjwyt, "_", sjwytt))  %>%
    mutate(scwyt = as.integer(scwyt), sjwyt = as.integer(sjwyt)) 
  
  df <- df %>%  mutate(nxtscwyt = lead(scwyt,5)) %>%
    mutate(nxtscwytt = ifelse(nxtscwyt == 1, "wt", ifelse(nxtscwyt == 2, "an", ifelse(nxtscwyt == 3, "bn", ifelse(nxtscwyt == 4, "dr", 
                                                                                                                  ifelse(nxtscwyt ==5, "cr", NA))))))  %>% mutate(scwyt2 = paste0(nxtscwyt, "_", nxtscwytt))
  
  lastwyt <- df %>% filter(scen == "baseline", yearmon == "Apr 2003") %>% select(scwyt2) 
  lastwyt <- paste0(lastwyt[1])
  df <- df %>% mutate(scwyt2 = ifelse(scwyt2 == "NA_NA", lastwyt, scwyt2 )) 
  yrange <- df  %>% group_by(dv, scen, scwyt2) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf))
  ymax <- max(yrange$mnanntaf_perav_wyt)
  p <- df  %>% group_by(dv, scen, scwyt2) %>%  summarize(mnanntaf_perav_wyt =  12*mean(taf)) %>% 
    ggplot(aes(x = scwyt2, y = mnanntaf_perav_wyt, fill = scwyt2, label = round(mnanntaf_perav_wyt,0))) +
    geom_bar(position = "dodge",stat = "identity") + 
    theme_gray()   + guides(colour = guide_legend(override.aes = list(size=2))) + theme(plot.margin=grid::unit(c(8,8,8,8), "mm")) +
    ylab("taf") + 
    #geom_text(color = "dark blue", angle = 90) +
    facet_grid(dv~scen) +
    scale_fill_discrete(name = "sac wyt") + theme(axis.title.x=element_blank()) +
    geom_hline(data = df %>% filter( scen == "baseline") %>% 
                 group_by(dv, scwyt2) %>%
                 summarize(mean = 12*mean(taf)),
               mapping = aes(yintercept = mean, color = scwyt2), show.legend = FALSE) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    geom_hline(data = df %>% filter( scen == "baseline") %>% group_by(dv, scwyt2) %>% 
                 summarize(mean = 12*mean(taf)),
               mapping = aes(yintercept = mean), show.legend = FALSE, linetype = "dashed", color = "black", size = 0.2) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    scale_y_continuous(expand = c(0.01,0.01)) + ggtitle("Surplus and Carriage (82 water years)\nby Sacramento Water Year Type Means (82 water years)") +
    coord_cartesian(ylim=c(600, ymax)) 
  p
  setwd("./plots")
  ggsave(paste0(paste(dvs,collapse="&"), "_sacwyt_bars_diffs.jpg"), dpi = 300, width = 13.333, height = 7.5, units = "in") 
  setwd('..')
  setwd("./plotexportscripts")