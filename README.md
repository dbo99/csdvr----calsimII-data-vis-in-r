# csdvr
 calsim data visualization (post-processor) in R | 
 version 1.0_8.10.2018 | 
 analyze calsim output for large numbers of variables or scenarios | 
 export report or presentation ready plot images (jpgs, pdfs, etc) or interactive html plots  

   key file  | use
------------ | -------------
`csv_list.r` | list csv file names and associate unique scenario nickname
`scen_facts.r` | give an order to plot scenarios in (ie left to right data/top to bottom legend)
`control.r` | main user interface - actually read-in data and analyze or batch export plots
`plotexport.r` | select which plot scripts to run for export (wait 1-2 minutes for a huge set or need some instantly?)
`fun_defs.r` | data summary/plotting function definitions - add new ones here

## Uses ##

- WRIMS2 CalSim decision variable ("DV") output in `.csv` format.
   If csv file(s) needed, enter in 2018 or later versions of WRIMS2's GUI's `Dvar DSS file:`'s field: `outputfilename.csv` instead of: `outputfilename.dss` (both will be created using `.csv` alone). WRIMS2 is free from California Dept. of Water Resources, see link at bottom for request - currently distrubuted via email list
- R, and R libraries specified in `libs.r`. Probably relies most on `dplyr` and `ggplot2` of the [`tidyverse`](https://www.tidyverse.org/)

## Steps ##

**Download** `csdvr_date.zip` (~15 mb: ~30 kb of scripts, ~15 mb of sample plots)
   https://github.com/dbo99/csdvr----calsimII-data-vis-in-r/blob/master/csdvr_aug18.zip

**Drop** your calsim csvs in `csv` folder (or save them there initially from WRIMS2).

**Open RStudio and files** by clicking on `control.r`, then open  `csv_list.r` and `scen_facts.r`

**Point to files and ID scenarios** in **`csv_list.r`**: enter each csv file name (eg `040812_bo_y1a1.csv`) and give unique nickname (eg `Scen1_Y1A1`) for each

**Specify plotting order of scenarios** (groupings to facilitate data vis): in **`scenfacts.r`** enter same nicknames in user-defined order: top to bottom in **`scenfacts.r`** produces top to bottom order in plot legend. Nickname spelling in **`csv_list.r`** must match  in **`scen_facts.r`**

`control.r`  | action
------------ | -------------
`1` | **read in libraries,  functions, and csv data** (do first then sparingly as ~1/6 min read-in time per scenario) (~0.5 gb `.csv` each) (option to append in **`csv._list.r`**). 2a & 2b need 1 run first.
`2a` | **generate plots in batches** with pre-defined templates for common DVs of interest -- call scripts of plots
`2b` | **generate individual data summaries** (ie tabular as `tibble`,`.csv`) **or individual plots** for any DVs of interest by searching for DVs here and by running individual functions listed below this block (~80)

### notes ###
- assumes DV name familiarity, eg Folsom Lake is `s8`. If not consult `.wresl` or `.dss` files.  `varcodes.csv` identifies some dvname-commonname pairs, add more as desired. By defaults plots label the `df$dv`, the actual CalSim name, not the `df$dv_name`, the common name (development of a switch is in progress)
- save new finished plot scripts in `plotexportscripts` folder to add to collection of templates & add folder of file name
- currently assumes all scenarios are under same climate scenario (tied to wyt.csv - adjustment needed to accomodate more for any water  year type functions - other functions still applicable as is if multiple climate scenarios used) (sample's uses Q5 Early Long Term)
- default plot size is widescreen to exactly fit default `.pptx`. To change, search and replace all (from Ctrl-F) `width = 13.333, height = 7.5`, to desired dimensions, eg `width = 10, height = 6` , same with desired filetype, eg `.jpg`, `.pdf`, `.html`)
- accepts either CalSimII or CalSim 3.0 output, but set up currently for CalSimII's time range only
- currently lacks any diagnostics on "controls" - hoping to add directly in `.wresl` files for ease in csdvr, other post-processors, in future
- currently lacks any geospatial ability
  
  Access CalSim benchmark studies and contact info for WRIMS software:
  
  https://water.ca.gov/Library/Modeling-and-Analysis/Central-Valley-models-and-tools/CalSim-2
  
## functions ##

#  Data Summary Functions #
add `%>% write.csv("csvname.csv")` to any to export

## annual Avgs ##
   function  | for
------------ | -------------
mn_ann_perav_taf(df) |  mean annual for period avg (flow/delivery) in taf (if nothing: makes sure dv not storage)
md_ann_perav_taf(df) |  median annual flow/delivery in taf
mn_ann_eomstor_taf(df) | mean annual end of month storage (if nothing: makes sure a storage term selected)
mn_ann_perav_native(df) | mean annual flow/delivery in calsim native units
md_ann_perav_native(df) | median annual flow/delivery in calsim native units

## annual Avg diffs ##

mn_ann_perav_taf(df_diff) # %>% write.csv("enterdv(s)_mnanntaf_perav_diff.csv")
md_ann_perav_taf(df_diff)
mn_ann_eomstor_taf(df_diff)

## WYT Avgs ##

#sac
mn_ann_scwyt_perav_taf(df) |
mn_ann_scwyt_perav_taf(df_diff)

## sj
mn_ann_perav_sjwyt_taf(df) |
mn_ann_perav_sjwyt_taf(df_diff)

## month extremes ##

max_mon_native(df) |
min_mon_native(df) |

### eo may & eo sep storage ###

eo_may_stor_taf(df) | #if error or nothing shows up, no storage terms were selected (same with plots)
eo_sep_stor_taf(df) |

eo_may_stor_taf(df_diff) 
eo_sep_stor_taf(df_diff)

### find timesteps ###  for single DV only! 

showtstepsallscensunder(df, 800) #shows all time steps all scens are <##, lists left to right
showtstepsallscensover(df, 10)

## Period of record mean/total

mn984_taf(df) |
sum984_taf(df) | 
  
  
  
  
  
  
 ##############################################################################################################################
####    plotting functions    ################################ data summaries w/o plots toward bottom ########################
##############################################################################################################################

##########################
## overall stats - bars ##
##########################

### Ann Avgs ###

#plot bars of mean annual period average 
pb_mn_ann_perav_taf(df) |    #if blank, verify not a storage
pb_mn_ann_perav_taf_nolab(df) |
pb_mn_ann_perav_taf_nolab_rank(df) |
pb_mn_ann_perav_taf_hlab(df) |
pb_md_ann_perav_taf(df) | 
pb_mn_ann_eomstor_taf(df) |  #if blank, verify not a non-storage (same for rest)

### WYT Avgs ###
pb_mn_scwyt_perav_taf(df) |
pb_mn_scwyt_perav_taf_nolab(df) |
pb_mn_scwyt2_perav_taf(df) | #scwyt2 breaks feb-jan water years - uses oct-seps like cwf hearings
pb_mn_sjwyt_perav_taf(df) |


### month specific storage ###

pb_mn_eomay_stor_taf(df) |
pb_mn_eosep_stor_taf(df) |

################
## difference ##
################

### Ann Avgs ###
pb_mn_ann_perav_taf_d(df_diff) 
pb_mn_ann_perav_taf_d_hlab(df_diff)
pb_md_ann_perav_taf_d(df_diff)
pb_mn_ann_perav_taf_d_nolab_rank(df_diff)
pb_mn_ann_eomstor_taf_d(df_diff) 

### WYT Avgs ###
pb_mn_scwyt_perav_taf_d(df_diff)
pb_mn_scwyt_perav_taf_d_nolab(df_diff)
pb_mn_scwyt_perav_taf_d_hlab(df_diff)
pb_mn_scwyt2_perav_taf_d(df_diff)
pb_mn_sjwyt_perav_taf_d(df_diff)

### month specific diff ###

pb_eosep_stor_d_taf(df_diff)
pb_eomay_stor_d_taf(df_diff)  
df$scwyt

#######################################################################
#######################################################################
## exceedance lines ###################################################
#######################################################################
#######################################################################

## monthly ## 

p_mon_excd_taf(df) |          # no "2", dvs together
p_mon_excd2_taf(df) |         # with "2" - dvs apart (facetted) 
p_mon_excd_cfs(df) |
p_mon_excd2_cfs(df) |
p_mon_excd_native(df) |       # use for non cfs/taf terms, eg EC, km
p_mon_excd2_native(df) |

## annual ## 

p_ann_wysum_excd_taf(df) |    #82 totals
p_ann_wysum_excd2_taf(df) |   # by columns
p_ann_wysum_excd3_taf(df) |   # by rows
p_ann_fjwysum_excd_taf(df) |  #81 feb-jan totals
p_ann_fjwysum_excd2_taf(df) | 
p_ann_mfwysum_excd_taf(df) |  #81 mar-feb totals (regular cvp contract)
p_ann_mfwysum_excd2_taf(df) | 
p_ann_jdwysum_excd_taf(df) |  #81 cal yr totals (regular swp contract)
p_ann_jdwysum_excd2_taf(df) | 
p_ann_wymn_excd_taf(df) |     #82 means
p_ann_wymn_excd2_taf(df) |    


################
## excd diff  ##
################

## monthly ## 

p_mon_excd_taf_d(df_diff) 
p_mon_excd2_taf_d(df_diff)
p_mon_excd_cfs_d(df_diff) 
p_mon_excd2_cfs_d(df_diff)

## annual ## 

p_ann_wysum_excd_taf_d(df_diff) 
p_ann_wysum_excd2_taf_d(df_diff) #if more than 1 DV, separates DVs into seperate plots
p_ann_fjwysum_excd_taf_d(df_diff)
p_ann_fjwysum_excd2_taf_d(df_diff)
p_ann_mfwysum_excd_taf_d(df_diff) 
p_ann_mfwysum_excd2_taf_d(df_diff) 
p_ann_jdwysum_excd_taf_d(df_diff) 
p_ann_jdwysum_excd2_taf_d(df_diff) 
p_ann_wymn_excd_taf_d(df_diff) 
p_ann_wymn_excd2_taf_d(df_diff)

#########################
## exceedance, WYT grid
#########################

p_ann_fjwysum_scwyt_excd_taf(df) |    # no "2", dvs together
p_ann_fjwysum_scwyt_excd2_taf(df) |   # with "2" - dvs apart (facetted)  
p_ann_fjwysum_sjwyt_excd_taf(df) |    
p_ann_fjwysum_sjwyt_excd2_taf(df) |   

#########################
## excd diff, WYT grid
#########################

p_ann_fjwysum_scwyt_excd_taf_d(df_diff)   
p_ann_fjwysum_scwyt_excd2_taf_d(df_diff)  
p_ann_fjwysum_sjwyt_excd_taf_d(df_diff)   
p_ann_fjwysum_sjwyt_excd2_taf_d(df_diff)  

###############################
## exceedance, month grid, linear
###############################

p_ann_monfacetg_excd_taf(df) |
p_ann_monfacetg_excd_taf_d(df_diff)
p_ann_monfacetg_excd_cfs(df) |
p_ann_monfacetg_excd_cfs_d(df_diff)

###############################
## excd diff, month grid, matrix
###############################

p_ann_monfacetw_excd_taf(df) |
p_ann_monfacetw_excd_taf_d(df_diff)
p_ann_monfacetw_excd_cfs(df) |
p_ann_monfacetw_excd_cfs_d(df_diff)

#######################################################################
#######################################################################
## exceedance bars         ############################################
#######################################################################
#######################################################################

#################################
## WYT sums, sequential bars
#################################

pb_ann_fjwysum_scwyt_taf(df) |
pb_ann_fjwysum_sjwyt_taf(df) |

##################################
## WYT sums, sequential bars, diff
##################################

pb_ann_fjwysum_scwyt_taf_d(df_diff)
pb_ann_fjwysum_sjwyt_taf_d(df_diff)

##################################
## WYT stors, sequential bars
##################################

pb_eomay_stor_scwyt_taf(df) |
pb_eosep_stor_scwyt_taf(df) |

###################################
## WYT stors, sequential bars, diff
###################################

pb_eomay_stor_scwyt_taf_d(df_diff)
pb_eosep_stor_scwyt_taf_d(df_diff)

#######################################################################
#######################################################################
##   box plots    #####################################################
#######################################################################
#######################################################################

##################################
### monthly ######################
##################################

#plot box plot monthly taf 
pbp_mon_taf(df) |        #pbly best for only one dv, (very busy) #good for plotly - medians/hinges/outliars hoverable
pbp_mon_scwyt_taf(df) |  #pbly best for only one dv

## diff ##
pbp_mon_taf_d(df_diff)  
pbp_mon_scwyt_taf_d(df_diff)


##################################
### annual  ######################
##################################

pbp_ann_perav_wysum_taf(df) |
pbp_ann_perav_fjwysum_taf(df) |
pbp_ann_perav_fjwysum_scwyt_taf(df) |
pbp_ann_perav_mfwysum_taf(df) |
## diff ##
pbp_ann_perav_wysum_taf_d(df_diff)
pbp_ann_perav_fjwysum_taf_d(df_diff)
pbp_ann_perav_fjwysum_scwyt_taf_d(df_diff)
pbp_ann_perav_mfwysum_taf_d(df_diff)

#######################################################################
#######################################################################
##   dots and boxes (w/means labeled)   ###############################
#######################################################################
#######################################################################

pdp_ann_perav_wysum_taf(df, 1, 5) #dataframe, binwidth, dotsize
pdp_ann_perav_mfwysum_taf(df, 1,5)

pdp_ann_perav_wysum_taf_d(df_diff, 1, 5)
pdp_ann_perav_mfwysum_taf_d(df_diff, 1,5)

#######################################################################
#######################################################################
##   translucent distributions  (density ridges)  #####################
#######################################################################
#######################################################################

#plot density ridge
pdr_ann_perav_wysum_taf(df) |
pdr2_ann_perav_wysum_taf(df) |
pdr_ann_perav_mfwysum_taf(df) |

pdr_ann_perav_wysum_taf_d(df_diff)
pdr2_ann_perav_wysum_taf_d(df_diff)
pdr_ann_perav_mfwysum_taf_d(df_diff)

#######################################################################
#######################################################################
## timeseries #########################################################
#######################################################################
#######################################################################

## monthly ## 

p_mon_ts_taf(df, 1921, 2004)  #+ coord_cartesian(ylim=c(0, 500)) #+ geom_text() 
p_mon_ts_may_taf(df, 1929, 1937) 
p_mon_ts_sep_taf(df, 1929, 1937) 
p_mon_ts_taf_maysseps_taf(df, 1922, 2003) 

p_mon_ts_cfs(df, 1920, 2003) 
p_mon_ts_native(df, 1930, 1935) #if nothing shows up, no key DVs are in cfs or taf (eg EC or KM) (same for all _natives)

## annual ## 

p_ann_ts_sum_taf(df, 1977, 1978) 
p_ann_ts_sum_native(df, 1930, 1990)
p_annmonmean_ts_mn_taf (df, 1922, 1990) 

##################################
## timeseries difference #########
##################################

## monthly ## 

#plot monthly timeseries taf difference
p_mon_ts_taf_d (df_diff, 1922, 1925)  #+ coord_cartesian(ylim=c(-75, 250)) 
p_mon_ts2_taf_d (df_diff, 1922, 2003)
p_mon_ts3_taf_d (df_diff, 1922, 2003)
p_mon_ts_cfs_d (df_diff, 1922, 2003)
p_mon_ts_native_d(df_diff, 1922, 1923)
p_mon_ts2_native_d(df_diff, 1921, 1930)

## annual ##

p_ann_ts_sum_taf_d (df_diff, 1975, 1978) 
pb_ann_ts_sum_taf_d(df_diff, 1922, 2003) #for one dv only, otherwise averaged  
p_ann_ts_mn_taf_d (df_diff, 1955.2, 1956.5) 


###################################
## timeseries ridges###############  # for one dv only! #
###################################


#plot ridges (plots monthly y, colors by wy sum) (data, yrmin, yrmax, scaling factor). for one dv only (otherwise averaged)
pr_ts_taf(df, 1921, 2007, 0.0003) #+ ggtitle("del_cvp_total_s 1922 - 2003")#will plot up to yrmax-1 (max yr not plotted, doesn't always fit) (ggridges bug)
pr_ts_taf_d(df_diff, 1921, 2007, 0.009) #+ ggtitle("del_cvp_total_s 1922 - 2003 [difference from baseline]")

pr_ts_eomstormean_taf(df, 1970, 1995, 0.00001) #will plot up to yrmax-1 (max yr not plotted, doesn't always fit) (ggridges bug)
pr_ts_eomstormean_taf_d(df_diff, 1922, 2004, 0.0005)

###################################
## timeseries tiles ###############  
###################################

prast_mon_ts_taf(df) |
prast_ann_ts_sum_taf(df) |
prast_annmonmean_ts_mn_taf(df) |

prast_mon_ts_taf_d(df_diff)
prast_ann_ts_sum_taf_d(df_diff)
prast_annmonmean_ts_mn_taf_d(df_diff)

ptile_mon_ts_taf(df) |
ptile_ann_ts_sum_taf(df) |
ptile_annmonmean_ts_mn_taf(df) |

ptile_mon_ts_taf_d(df_diff)
ptile_ann_ts_sum_taf_d(df_diff)
ptile_annmonmean_ts_mn_taf_d(df_diff)

