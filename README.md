# csdvr
 calsim data vis in r | 
 version 1.0_8.10.2018 | 
 visualize calsim output for large numbers of variables or scenarios | 
 export report or presentation ready plot images (eg jpgs, pdfs) or interactive plots (html)  | developed by Bureau of Reclamation staff 
 
### uses ###

- WRIMS CalSim decision variable ("DV") output in `.csv` format. If csv file(s) needed, specify in WRIMS2's `Dvar DSS file:`'s field in versions from 2018 or later: `outputfilename.csv` instead of: `outputfilename.dss` (both will be created with `'csv`) (WRIMS2 is free from California Dept. of Water Resources, see link at bottom for request - currently distrubuted via email list distribution)
- R, and R libraries specified in `libs.r`. Probably relies most on `dplyr` and `ggplot2` libraries of the `tidyverse`

### steps ###

#### A #### 
   Download most recent csdvr scripts: `csdvr_mm.dd.yyyy.zip` (~15 mb: ~30 kb of scripts, ~15 mb of sample plots) 

#### B #### 
   Place your CalSim csvs in the `csv` folder 

#### C #### 
   In `csv_list.r`, enter each csv file name (eg `040812_BO_Y1a1.csv`) and a nickame (eg `Scen1_Y1A1`). Short labels make room for plot space

#### D #### 
   If scenario/legend order matters for audience for on-the-fly plots or batch plots, enter same nicknames in `scenfacts.r` in user-defined order: top to bottom in `scenfacts.r` gives top to bottom order in legend. Otherwise skip step; default order without specification in `scenfacts.r` is alphabetic

#### E ####
   In `control.r`, three main choices/blocks to run:

##### 1 #####
 read in libraries,  functions, and csv data (do sparingly as ~1/6 min read-in time per scenario) (~500 mb each) (option to append). 2 & 3 need 1 run first.
  
##### 2 #####
 generate plots in batches with pre-defined templates for common DVs of interest -- call scripts of plots
  
##### 3 #####
 generate individual plots or data summaries (eg `tibble`,`.csv`) for any DVs of interest with individual functions listed
   below this block (80+)

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

