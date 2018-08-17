# :earth_asia: **csdvr** :earth_americas: #  
 version 1.01_8.15.2018 
 
 `csdvr` visualizes [calsim]( https://water.ca.gov/Library/Modeling-and-Analysis/Central-Valley-models-and-tools/CalSim-2) output in [R](https://www.r-project.org/) | analyze output for large numbers of variables or scenarios | export plots (jpg, interactive [html](https://plot.ly/r/), pdf, etc) |
 
calsim is a california water resources planning model application developed jointly by [usbr](https://www.usbr.gov/) and [ca-dwr](https://water.ca.gov/) to help analyze limitations and possibilities of, and benefits and impacts from, the interconnected [central valley project](https://www.usbr.gov/mp/cvp/) and [state water project](https://water.ca.gov/Programs/State-Water-Project), under existing and alternative infrastructure, regulatory, operational, and climate scenarios.   calsim helps answer engineering and scientific questions and is common input to species-specific, ecosystem, economic, groundwater, and hydrodynamic models

   key file  | use
------------ | -------------
[`csv_list.r`](https://github.com/dbo99/csdvr----calsimII-data-vis-in-r/blob/Aug15/csv_list.r) | list csv file names and give brief unique scenario nicknames
[`fun_defs.r`](https://github.com/dbo99/csdvr----calsimII-data-vis-in-r/blob/Aug15/fun_defs.r) | function definitions - add to as necessary
[`scen_facts.r`](https://github.com/dbo99/csdvr----calsimII-data-vis-in-r/blob/Aug15/scenfacts.r) | list nicknames top down to order the left to right position of scenarios in the plot (instead of alphabetic)
[`plotexport.r`](https://github.com/dbo99/csdvr----calsimII-data-vis-in-r/blob/Aug15/plotexport.r) | select which plot scripts.r to run for export (wait 1-2 minutes for a comprehensive set or a few seconds for 20 or so?)
[`control.r`](https://github.com/dbo99/csdvr----calsimII-data-vis-in-r/blob/Aug15/control.R) | main user interface - actually read-in data and analyze or batch export plots

## Uses ##

- WRIMS2 CalSim decision variable ("DV") output in `.csv` format.
   If csv file(s) needed, specify in 2018 or later versions of WRIMS2's GUI's field: `Dvar DSS file:`  `outputfilename.csv` instead of: `outputfilename.dss` ([.dss](http://www.hec.usace.army.mil/software/hec-dssvue/) and `.csv` will be created using `.csv` alone). [WRIMS2](https://water.ca.gov/Library/Modeling-and-Analysis/Modeling-Platforms/Water-Resource-Integrated-Modeling-System) is free from California Dept. of Water Resources - currently distributed via email list
- Relies heavily on `dplyr` and `ggplot2` libraries of the [`tidyverse`](https://www.tidyverse.org/). Instructions only tested with [RStudio](https://www.rstudio.com/) freeware

## To Use ##

[**Download**](https://github.com/dbo99/csdvr----calsimII-data-vis-in-r)  (~20.03 mb: ~20 mb sample plots, ~30 kb scripts)

**Drop** your calsim csvs in `csv` folder (or write there directly from WRIMS2)

**Open RStudio and files** by double clicking on **`control.r`**, then open  `csv_list.r` and `scen_facts.r`

**Point to files and ID scenarios** in `csv_list.r`: enter each csv file name (eg `040812_bo_y1a1.csv`) and give unique nickname to each (eg `Scen1_Y1A1`)

**Specify plotting order of scenarios** (groupings to facilitate data vis): in `scenfacts.r` enter same nicknames in user-defined order: top to bottom in `scenfacts.r` Nickname spelling in `csv_list.r` must match `scen_facts.r`

`control.r`  | action
------------ | -------------
run-click `1` | **read in libraries,  functions, and csv data** (do first then sparingly as ~1/6 min read-in time per scenario) (~0.5 gb `.csv` each) (option to append in `csv._list.r`). 2a & 2b need this (`1`) run first.
run-click `2a` | **generate plots in batches** with pre-defined templates for common DVs of interest -- call scripts of plots
run-click `2b` | **generate individual data summaries** (ie tabular as `tibble`,`.csv`) **or individual plots** for any DVs of interest by searching for DVs here and by running individual functions listed below

### notes ###
- `2a` will auto export batches of plots. functions are listed below for `2b`, for reference/new analysis/making new plot scripts
- assumes DV name familiarity, eg Folsom Lake is `s8`. consult `.wresl`, `.dss`, [schematic](http://baydeltaoffice.water.ca.gov/modeling/hydrology/CalSim/Downloads/CalSimDownloads/BST_CALSIMII_schematic_040110.pdf), or report files as needed.  [`varcodes.csv`](https://github.com/dbo99/csdvr----calsimII-data-vis-in-r/blob/1.01/varcodes.csv) identifies some dvname-commonname pairs. add more as desired. By default plots label the `df$dv`, the actual CalSim name not the `df$dv_name`
- save new finished plot scripts in `plotexportscripts` folder to add to collection of templates & add folder in plots folder with name of new file name
- currently assumes all scenarios are under same climate scenario (tied to wyt.csv - adjustment needed to accommodate more for any water  year type functions - other functions still applicable as is if multiple climate scenarios used) (sample's uses Q5 Early Long Term)
- default plot size is widescreen to exactly fit default `.pptx`. To change, search and replace all (from Ctrl-F) `width = 13.333, height = 7.5`, to desired dimensions, eg `width = 10, height = 6` , same with desired filetype, eg `.jpg`, `.pdf`)
- tweaks needed around date functions and limits to work with CalSim 3.0's longer period of record
- needs functions for diagnostics on system controls (or add to`.wresl` directly)
- no geospatial plotting. planned for [CalSim 3.0](https://water.ca.gov/Library/Modeling-and-Analysis/Central-Valley-models-and-tools/CalSim-3)'s channels and aquifers
  
# Functions
#  Data Summary - tabular
#### select DVs and run `df_create.r` to create `df` and `df_diff` `data.frame`s ####
- use `samefunction(df)` for regular output and `samefunction(df_diff)` for the scenario minus baseline difference
- add `%>% write.csv("processedDVsofinterest.csv")` after any to export `processedDVsofinterest.csv` to working directory

### annual avgs  ###
   function  | for
------------ | -------------
mn_ann_perav_taf(df) |  mean annual for period avg (flow/delivery) in taf (if nothing: makes sure dv not storage)
eg mn_ann_perav_taf(df_diff) |  mean annual diff. rel. to baseline for period avg (flow/delivery) in taf
md_ann_perav_taf() |  median annual flow/delivery in taf
md_ann_perav_taf(df_diff) |  median annual diff. rel. to baseline for flow/delivery in taf
mn_ann_eomstor_taf(df) | mean annual end of month storage (if nothing: makes sure a storage term selected)
mn_ann_eomstor_taf(df_diff) | mean annual diff. rel. to baseline for end of month storage (if nothing: makes sure a storage term selected)
mn_ann_perav_native(df) | mean annual flow/delivery in calsim native units
md_ann_perav_native(df) | median annual flow/delivery in calsim native units

### water year type avgs ###
   function  | for
------------ | -------------
mn_ann_scwyt_perav_taf(df) | mean annual flow/delivery total by sacramento year type in taf
mn_ann_scwyt_perav_taf(df_diff) | mean annual difference rel. to baseline for flow/delivery total by sacramento year type in taf
mn_ann_perav_sjwyt_taf(df) | mean annual flow/delivery total by san joaquin year type in taf
mn_ann_perav_sjwyt_taf(df_diff)| meann annual flow/delivery total by san joaquin year type in taf

### global mins and maxs ###
   function  | for
------------ | -------------
max_mon_native(df) | maximum monthly value of all months
min_mon_native(df) | minimum monthly value of all months

### mean end of may, end of september storage ###
   function  | for
------------ | -------------
eo_may_stor_taf(df) | mean end of may storage
eo_sep_stor_taf(df) | mean end of septemeber storage
eo_may_stor_taf(df_diff) | mean difference relative to baseline for mean end of may storage
eo_sep_stor_taf(df_diff) | mean difference relative to baseline for mean end of septemeber storage

### find timesteps - for single DV only! ### 
   function  | for
------------ | -------------
showtstepsallscensunder(df, 800) | shows all time steps all scenarios are under ("find first month all under x")
showtstepsallscensunder(df_diff, 800) | shows all time steps all scenario differences are under x
showtstepsallscensover(df, 10) | shows all time steps all scenarios are over
showtstepsallscensover(df_diff, 10) | shows all time steps all differnces are over x

### Period of Record mean, total ###
   function  | for
------------ | -------------
mn984_taf(df) | mean monthly value
mn984_taf_d(df) | mean monthly difference
sum984_taf(df) | sum of all months
sum984_taf_d(df_diff) | sum of all differences
  
#  Plotting - summary statistics first, timeseries below #
#### select DVs and run `df_create.r` to create `df` and `df_diff` `data.frame`s ####
- use functions with suffix *`_d`* on `data.frame` `df_diff` for difference plots (ie unlike above a separate function assumed for each `df` (use function without *`_d`* suffix) and `df_diff` (use function with *`_d`* suffix )

## bar plots - annual means and medians ## 
### pb - plot bars - annual mean  ###
   function  | for
------------ | -------------
pb_mn_ann_perav_taf(df) |   bars of mean annuals with vertical labels (good for ~10 scenarios?)
pb_mn_ann_perav_taf_nolab(df) | bars of mean annuals without labels (good for many scenarios)
pb_mn_ann_perav_taf_nolab_rank(df) | bar of mean annuals without labels, ranked highest to lowest left to right
pb_mn_ann_perav_taf_hlab(df) | bars of mean annuals with horizontal labels (good for few scenarios)
pb_md_ann_perav_taf(df) | bars of annual medians with vertical labels 

### pb - plot bars - annual mean by water year type ###
   function  | for
------------ | -------------
pb_mn_scwyt_perav_taf(df) | bars of mean annual flow/delivery total by sacramento year type (feb-jan in calsim)
pb_mn_scwyt_perav_taf_nolab(df) | label-less bars of mean annual flow/delivery total by sacramento year type (feb-jan in calsim)
pb_mn_scwyt2_perav_taf(df) | bars of mean annual flow/delivery total by sacramento year type in taf (coerced to oct-sep)
pb_mn_sjwyt_perav_taf(df) | bars of mean annual flow/delivery total by san joaquin year type (feb-jan in calsim)

### pb - plot pars - monthly mean ###
   function  | for
------------ | -------------
pb_mn_eomay_stor_taf(df) | bars of mean end of may storage
pb_mn_eosep_stor_taf(df) | bars of mean end of september storage

### pb - plot bars - annual mean differences   ###
   function  | for
------------ | -------------
pb_mn_ann_perav_taf_d(df_diff) | difference bars of mean annuals with vertical labels (good for many scenarios)
pb_mn_ann_perav_taf_d_hlab(df_diff) | difference bars of mean annuals with horizontal labels (good for few scenarios)
pb_md_ann_perav_taf_d(df_diff) | difference bars of annual medians with vertical labels 
pb_mn_ann_perav_taf_d_nolab_rank(df_diff) | label-less difference bars of mean annuals without labels, ranked highest to lowest left to right (good for very many scenarios)

### pb - plot bars - annual mean by wyt differences ###
   function  | for
------------ | -------------
pb_mn_scwyt_perav_taf_d(df_diff)| difference bars of mean annual flow/delivery total by sacramento year type (feb-jan in calsim)
pb_mn_scwyt_perav_taf_d_nolab(df_diff) | label-less difference bars of mean annual flow/delivery total by sacramento year type (feb-jan in calsim)
pb_mn_scwyt_perav_taf_d_hlab(df_diff) | horizontally labeled difference bars of mean annual flow/delivery total by sacramento year type (feb-jan in calsim)
pb_mn_scwyt2_perav_taf_d(df_diff) | difference bars of mean annual flow/delivery total by sacramento year type in taf (coerced to oct-sep)
pb_mn_sjwyt_perav_taf_d(df_diff) | difference bars of mean annual flow/delivery total by san joaquin year type (feb-jan in calsim)

### month-specific mean differences ###
   function  | for
------------ | -------------
pb_eomay_stor_taf_d(df_diff)  | difference bars of mean end of may storage
pb_eosep_stor_taf_d(df_diff) | difference bars of mean end of september storage

## bar plots - all years - ranked by water year type showing overall and wyt means ## 
   function  | for
------------ | -------------
pb_ann_fjwysum_scwyt_taf(df) | ranked bars of feb-jan totals by sacramento water year type
pb_ann_fjwysum_sjwyt_taf(df) | ranked bars of feb-jan totals by san joaquin water year type
pb_ann_fjwysum_scwyt_taf_d(df_diff) | ranked difference bars of feb-jan totals by sacramento water year type
pb_ann_fjwysum_sjwyt_taf_d(df_diff) | ranked difference bars of feb-jan totals by san joaquin water year type
pb_eomay_stor_scwyt_taf(df) | ranked bars of end of may storages by sacramento water year type
pb_eosep_stor_scwyt_taf(df) | ranked bars of end of september storages by sacramento water year type
pb_eomay_stor_scwyt_taf_d(df_diff) | ranked difference bars of end of may storages by sacramento water year type
pb_eosep_stor_scwyt_taf_d(df_diff) | ranked difference bars of end of september storages by sacramento water year type

## line plots - monthly and annual probability of exceedance ## 

### monthly - line ### 
   function  | for
------------ | -------------
p_mon_excd_taf(df) |   monthly exceedance in taf
p_mon_excd2_taf(df) |  monthly exceedance in taf, style 2 (plot for each dv)
p_mon_excd_cfs(df) |   monthly exceedance in cfs
p_mon_excd2_cfs(df) | monthly exceedance in cfs, style 2 
p_mon_excd_native(df) |  monthly exceedance in calsim native units, eg EC, km get unit 'unassigned'
p_mon_excd2_native(df) | monthly exceedance in calsim native units style 2 eg EC, km get unit 'unassigned'

### annual - line ### 
   function  | for
------------ | -------------
p_ann_wysum_excd_taf(df) |    annual exceedance - 82 oct-sep totals
p_ann_wysum_excd2_taf(df) |   annual exceedance - 82 oct-sep totals, in columns (style 2)
p_ann_wysum_excd3_taf(df) |   annual exceedance - 82 oct-sep totals, in rows (style 3)
p_ann_fjwysum_excd_taf(df) |  annual exceedance - 81 feb-jan totals
p_ann_fjwysum_excd2_taf(df) | annual exceedance - 81 feb-jan totals, style 2
p_ann_mfwysum_excd_taf(df) |  annual exceedance - 81 mar-feb totals (popular cvp contract)
p_ann_mfwysum_excd2_taf(df) | annual exceedance - 81 mar-feb totals (popular cvp contract), style 2
p_ann_jdwysum_excd_taf(df) |  annual exceedance - 81 jan-dec totals (popular swp contract)
p_ann_jdwysum_excd2_taf(df) | annual exceedance - 81 jan-dec totals (popular swp contract), style 2
p_ann_wymn_excd_taf(df) |     annual exceedance -  82 oct-sep means
p_ann_wymn_excd2_taf(df) |   annual exceedance -  82 oct-sep means, style 2 

### monthly difference - line ###
   function  | for
------------ | -------------
p_mon_excd_taf_d(df_diff) | monthly exceedance of differences in taf
p_mon_excd2_taf_d(df_diff)| monthly exceedance of differences in taf, style 2 
p_mon_excd_cfs_d(df_diff) | monthly exceedance of differences in cfs
p_mon_excd2_cfs_d(df_diff)| monthly exceedance of differences in cfs, style 2

### annual difference - line ### 
   function  | for
------------ | -------------
p_ann_wysum_excd_taf_d(df_diff) | annual exceedance - differences of 82 oct-sep totals
p_ann_wysum_excd2_taf_d(df_diff)| annual exceedance - differences of 82 oct-sep totals, style 2
p_ann_fjwysum_excd_taf_d(df_diff)| annual exceedance - differences of 81 feb-jan totals
p_ann_fjwysum_excd2_taf_d(df_diff)| annual exceedance - differences of 81 feb-jan totals, style 2
p_ann_mfwysum_excd_taf_d(df_diff) | annual exceedance - differences of 81 mar-feb totals
p_ann_mfwysum_excd2_taf_d(df_diff) | annual exceedance - differences of 81 mar-feb totals, style 2
p_ann_jdwysum_excd_taf_d(df_diff) | annual exceedance - differences of 81 jan-dec totals
p_ann_jdwysum_excd2_taf_d(df_diff) | annual exceedance - differences of 81 jan-dec totals, style 2
p_ann_wymn_excd_taf_d(df_diff) | annual exceedance - differences of 82 oct-sep means
p_ann_wymn_excd2_taf_d(df_diff)| annual exceedance - differences of 82 oct-sep means, style 2


### annual by wyt grid - line ###
   function  | for
------------ | -------------
p_ann_fjwysum_scwyt_excd_taf(df) |    6 plots (5 wyts and 1 overall) of feb-jan totals by sac wyt
p_ann_fjwysum_scwyt_excd2_taf(df) |   6 plots (5 wyts and 1 overall) of feb-jan totals by sac wyt, style 2 
p_ann_fjwysum_sjwyt_excd_taf(df) |    6 plots (5 wyts and 1 overall) of feb-jan totals by sj wyt
p_ann_fjwysum_sjwyt_excd2_taf(df) |   6 plots (5 wyts and 1 overall) of feb-jan totals by sj wyt, style 2


### annual by wyt grid, difference - line ###
   function  | for
------------ | -------------
p_ann_fjwysum_scwyt_excd_taf_d(df_diff) |  difference - 6 plots (5 wyts and 1 overall) of feb-jan totals by sac wyt
p_ann_fjwysum_scwyt_excd2_taf_d(df_diff) | difference - 6 plots (5 wyts and 1 overall) of feb-jan totals by sac wyt, style 2 
p_ann_fjwysum_sjwyt_excd_taf_d(df_diff) | difference - 6 plots (5 wyts and 1 overall) of feb-jan totals by sj wyt
p_ann_fjwysum_sjwyt_excd2_taf_d(df_diff)|  difference - 6 plots (5 wyts and 1 overall) of feb-jan totals by sj wyt, style 2

### plot for each month, linear - line ###
   function  | for
------------ | -------------
p_ann_monfacetg_excd_taf(df) | 12 plots of individual months in a line (Grid) in taf 
p_ann_monfacetg_excd_taf_d(df_diff)| difference - 12 plots of individual months in a line in taf
p_ann_monfacetg_excd_cfs(df) | 12 plots of individual months in a line in cfs
p_ann_monfacetg_excd_cfs_d(df_diff)| difference - 12 plots of individual months in a line in cfs

### plot for each month, matrix - line ###
   function  | for
------------ | -------------
p_ann_monfacetw_excd_taf(df) | 12 plots of individual months in a matrix (Wrap) in taf
p_ann_monfacetw_excd_taf_d(df_diff) | difference - 12 plots of individual months in a matrix in taf
p_ann_monfacetw_excd_cfs(df) | 12 plots of individual months in a matrix in cfs
p_ann_monfacetw_excd_cfs_d(df_diff) | difference - 12 plots of individual months in a matrix in cfs

## tukey box plots - pbp - plot box plots ## 

### monthly - box plots ###
   function  | for
------------ | -------------
pbp_mon_taf(df) |  monthly taf box plots      
pbp_mon_taf_d(df_diff)  | monthly taf box plots of differences
pbp_mon_scwyt_taf(df) |  monthly taf box plots by sacramento water year type
pbp_mon_scwyt_taf_d(df_diff) |  monthly taf box plots of differences by sacramento water year type
- pbly best for only one dv (too busy) 
- good for plotly/ggplotly - medians/hinges/outliars hoverable

### annual - box plots ###
   function  | for
------------ | -------------
pbp_ann_perav_wysum_taf(df) | box plots of water year totals
pbp_ann_perav_wysum_taf_d(df_diff)| box plots of differences of water year totals
pbp_ann_perav_fjwysum_taf(df) | box plots of feb-jan totals
pbp_ann_perav_fjwysum_taf_d(df_diff) | box plots of differences of feb-jan totals
pbp_ann_perav_fjwysum_scwyt_taf(df) | box plots of feb-jan totals by sacramento water year type
pbp_ann_perav_fjwysum_scwyt_taf_d(df_diff)| box plots of differences of feb-jan totals by sacramento water year type
pbp_ann_perav_mfwysum_taf(df) | box plots of mar-feb totals
pbp_ann_perav_mfwysum_taf_d(df_diff) box plots of mar-feb totals

## tukey box plots with data points shown (and mean) - pdp - plot dot plots ## 
   function  | for
------------ | -------------
pdp_ann_perav_wysum_taf(df, binwidth, dotsize) | dot plot of water year totals
pdp_ann_perav_wysum_taf_d(df_diff, 1, 5)| dot plot of difference of water year totals
pdp_ann_perav_mfwysum_taf(df, 1,5)| dot plot of mar-feb year totals
pdp_ann_perav_mfwysum_taf_d(df_diff, 1,5)| dot plot of difference of mar-feb year totals


##   bell plots  (probability density) - pdr - plot density ridges ##
   function  | for
------------ | -------------
pdr_ann_perav_wysum_taf(df) | bell curve with individual water year distribution shown (ticks), .25, .5, & .75 quantiles (vertical lines), w/mean (circle symbol)
pdr2_ann_perav_wysum_taf(df) | bell curve with individual year distribution shown, .25, .5, & .75 quantiles, w/mean labelled, separate scenario colors
pdr_ann_perav_mfwysum_taf(df) | bell curve with individual mar-feb year distribution shown, .25, .5, & .75 quantiles, w/mean (circle symbol)
pdr_ann_perav_wysum_taf_d(df_diff)| as above, difference
pdr2_ann_perav_wysum_taf_d(df_diff)|as above,  difference
pdr_ann_perav_mfwysum_taf_d(df_diff)| as above,  difference

# Timeseries #

## monthly - line ## 
   function  | for
------------ | -------------
p_mon_ts_taf(df, 1921, 2004)  | monthly timeseries from start to end year, taf
p_mon_ts_may_taf(df, 1929, 1937) | monthly timeseries of just mays from start to end year, taf
p_mon_ts_sep_taf(df, 1929, 1937) | monthly timeseries of just seps from start to end year, taf
p_mon_ts_taf_maysseps_taf(df, 1922, 2003) |  monthly timeseries of just mays & seps from start to end year, taf
p_mon_ts_cfs(df, 1920, 2003) | monthly timeseries from start to end year, cfs
p_mon_ts_native(df, 1930, 1935) | monthly timeseries from start to end year, native calsim unit

## annual - line ## 
   function  | for
------------ | -------------
p_ann_ts_sum_taf(df, 1977, 1978) | timeseries of annual totals, taf
p_ann_ts_sum_native(df, 1930, 1990)| timeseries of annual totals, native calsim unit
p_annmean_ts_mn_taf (df, 1922, 1990) | timeseries of annual mean, taf


## monthly difference - line ## 
   function  | for
------------ | -------------
p_mon_ts_taf_d (df_diff, 1922, 1925)| monthly timeseries of difference from start to end year, taf
p_mon_ts2_taf_d (df_diff, 1922, 2003)| monthly timeseries of difference from start to end year, taf, style 2
p_mon_ts3_taf_d (df_diff, 1922, 2003)| monthly timeseries of difference from start to end year, taf, style 3
p_mon_ts_cfs_d (df_diff, 1922, 2003)| monthly timeseries of difference from start to end year, cfs
p_mon_ts_native_d(df_diff, 1922, 1923)| monthly timeseries of difference from start to end year, native
p_mon_ts2_native_d(df_diff, 1921, 1930)|monthly timeseries of difference from start to end year, native, style 2

## annual difference - line and bar ##
   function  | for
------------ | -------------
p_ann_ts_sum_taf_d (df_diff, 1975, 1978) | timeseries of differences of annual totals, taf
p_ann_ts_mn_taf_d (df_diff, 1955.2, 1956.5)| timeseries of differences of annual means
pb_ann_ts_sum_taf_d(df_diff, 1922, 2003)| bar plot - timeseries of differences of annual totals, taf


## timeseries ridges - pr - plot ridges - one dv only! ##
   function  | for
------------ | -------------
pr_ts_taf(df, 1921, 2007, asmallscalingfactor)| whole monthly timeseries stacked on one page - color scale: water year totals (sums)
pr_ts_taf_d(df_diff, 1921, 2007, 0.009)| whole monthly timeseries of differences. divergent scale
pr_ts_eomstormean_taf(df, 1970, 1995, 0.00001)| whole monthly timeseries of storage - color scale: mean end of month (dont add storage)
pr_ts_eomstormean_taf_d(df_diff, 1922, 2004, 0.0005)| whole monthly timeseries of difference of storage. divergent scale

- plots monthly y, color scaled to  wy sum) (dataframe, yrmin, yrmax, scaling factor). for one dv only (no room for two) (otherwise averaged)


## timeseries grids #
   function  | for
------------ | -------------
prast_mon_ts_taf(df) | timeseries raster of monthly taf
prast_ann_ts_sum_taf(df) | timeseries raster (stripes) of water year totals (sums) in taf
prast_ann_ts_mn_taf(df) | timeseries raster (stripes) of water year means in taf
prast_mon_ts_taf_d(df_diff)| timeseries raster of monthly difference in taf
prast_ann_ts_sum_taf_d(df_diff)|timeseries raster of annual total difference in taf
prast_ann_ts_mn_taf_d(df_diff)| timeseries raster of annual mean difference in taf
ptile_mon_ts_taf(df) | timeseries tile of monthly in taf - tile adds ability to color cell outline, eg highlight Wet & AN only
ptile_ann_ts_sum_taf(df) | timeseries tile (stripes) of water year totals (sums) in taf
prast_ann_ts_mn_taf(df) |  timeseries tile (stripes) of water year means in taf
ptile_mon_ts_taf_d(df_diff)|timeseries tile of monthly difference in taf
ptile_ann_ts_sum_taf_d(df_diff)|timeseries tile of annual total difference in taf
ptile_ann_ts_mn_taf_d(df_diff)|timeseries tile of annual mean difference in taf

# **:earth_americas: csdvr :earth_americas:** #
