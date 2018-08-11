# csdvr
 calsim data vis (post-processor) in r | 
 version 1.0_8.10.2018 | 
 analyze calsim output for large numbers of variables or scenarios | 
 export report or presentation ready plot images (jpgs, pdfs, etc) or interactive plots (html)  | developed by Bureau of Reclamation staff 

   key file  | use
------------ | -------------
`csv_list.r` | point to your file names of csvs and give them scenario nicknames
`scen_facts.r` | tell order to plot scenarios in (ie left to right data/top to bottom legend)
`control.r` | main user interface - actually read-in data and analyze or batch export plots
`plotexport.r` | turn on/off which plot scripts to run for exporting (want huge set or just a few?)

### uses ###

- WRIMS2 CalSim decision variable ("DV") output in `.csv` format.
   If csv file(s) needed, enter in 2018 or later versions of WRIMS2's GUI's `Dvar DSS file:`'s field: `outputfilename.csv` instead of: `outputfilename.dss` (both will be created using `.csv` alone). WRIMS2 is free from California Dept. of Water Resources, see link at bottom for request - currently distrubuted via email list
- R, and R libraries specified in `libs.r`. Probably relies most on `dplyr` and `ggplot2` of the `tidyverse`

### steps ###

#### A *download* `csdvr_date.zip` (~15 mb: ~30 kb of scripts, ~15 mb of sample plots)
   https://github.com/dbo99/csdvr----calsimII-data-vis-in-r/blob/master/csdvr_11Aug2018.zip

#### B *drop* your calsim csvs in `csv` folder 

#### C *point to* files and *ID* scenarios in `csv_list.r`: enter each csv file name (eg `040812_BO_Y1a1.csv`) and give a nickname (eg `Scen1_Y1A1`)


#### D *specify* plotting order of scenarios (groupings to facilitate data vis): in `scenfacts.r` enter same nicknames in user-defined order: top to bottom in `scenfacts.r` produces top to bottom order in plot legend. nickname spelling in `scenfacts.r` must match in `csv_list.r`)

#### E ####   in `control.r`:

##### 1 #####
 read in libraries,  functions, and csv data (do sparingly as ~1/6 min read-in time per scenario) (~0.5 gb each) (option to append sequentially in `csv._list.r`). 2a & 2b need 1 run first.
  
##### 2a #####
 generate plots in batches with pre-defined templates for common DVs of interest -- call scripts of plots
  
##### 2b #####
 generate individual data summaries (ie tabular as `tibble`,`.csv`) or plots for any DVs of interest with individual functions listed
   below this block (~80)

#### notes ####
- assumes you know names of DVs to view, eg Folsom Lake is `S8`. If not consult `.wresl` or `.dss` files. To-do: auto-fill DV names while typing. `varcodes.csv` identifies some dvname-commonname pairs, add more as needed. Some plots label the `df$dv`, the actual CalSim name, and others the `df$dv_name`, the common name 
- save new finished plot scripts in `plotexportscripts` folder to add to collection of templates
- currently assumes all scenarios are under same climate scenario (tied to wyt.csv - adjustment needed to accomodate more for any water  year type functions - other functions still applicable as is if multiple climate scenarios used) (sample's uses Q5 Early Long Term)
- default plot size is widescreen to exactly fit default `.pptx`. To change, search and replace all (from Ctrl-F) `width = 13.333, height = 7.5`, to desired dimensions, eg `width = 10, height = 6` , same with desired filetype, eg `.jpg`, `.pdf`, `.html`)
- accepts either CalSimII or CalSim 3.0 output, but set up currently for CalSimII's time range only
- currently lacks any diagnostics on "controls" - hoping to add directly in `.wresl` files for ease in csdvr, other post-processors, in future
- currently lacks any geospatial ability
  
  Access CalSim benchmark studies and contact info for WRIMS software:
  
  https://water.ca.gov/Library/Modeling-and-Analysis/Central-Valley-models-and-tools/CalSim-2

