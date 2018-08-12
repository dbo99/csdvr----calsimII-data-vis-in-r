# csdvr
 calsim data visualization (post-processor) in r | 
 version 1.0_8.10.2018 | 
 analyze calsim output for large numbers of variables or scenarios | 
 export report or presentation ready plot images (jpgs, pdfs, etc) or interactive html plots  

   key file  | use
------------ | -------------
`csv_list.r` | list csv file names and associate unique scenario nickname
`scen_facts.r` | give an order to plot scenarios in (ie left to right data/top to bottom legend)
`control.r` | main user interface - actually read-in data and analyze or batch export plots
`plotexport.r` | turn on which plot scripts to run for exporting (want huge set or just a few?)
`fun_defs.r` | data summary/plotting function definitions - add new ones here

## Uses ##

- WRIMS2 CalSim decision variable ("DV") output in `.csv` format.
   If csv file(s) needed, enter in 2018 or later versions of WRIMS2's GUI's `Dvar DSS file:`'s field: `outputfilename.csv` instead of: `outputfilename.dss` (both will be created using `.csv` alone). WRIMS2 is free from California Dept. of Water Resources, see link at bottom for request - currently distrubuted via email list
- R, and R libraries specified in `libs.r`. Probably relies most on `dplyr` and `ggplot2` of the [`tidyverse`](https://www.tidyverse.org/)

## Steps ##

**Download** `csdvr_date.zip` (~15 mb: ~30 kb of scripts, ~15 mb of sample plots)
   https://github.com/dbo99/csdvr----calsimII-data-vis-in-r/blob/master/csdvr_aug18.zip

**Drop** your calsim csvs in `csv` folder (or save them there initially from WRIMS2)

**Point to files and ID scenarios** in **`csv_list.r`**: enter each csv file name (eg `040812_bo_y1a1.csv`) and give unique nickname (eg `Scen1_Y1A1`) for each

**Specify plotting order of scenarios** (groupings to facilitate data vis): in **`scenfacts.r`** enter same nicknames in user-defined order: top to bottom in **`scenfacts.r`** produces top to bottom order in plot legend. Nickname spelling in **`scenfacts.r`** must match identically those in **`csv_list.r`**)

`control.r`  | action
------------ | -------------
`1` | **read in libraries,  functions, and csv data** (do first then sparingly as ~1/6 min read-in time per scenario) (~0.5 gb `.csv` each) (option to append in **`csv._list.r`**). 2a & 2b need 1 run first.
`2a` | **generate plots in batches** with pre-defined templates for common DVs of interest -- call scripts of plots
`2b` | **generate individual data summaries** (ie tabular as `tibble`,`.csv`) **or individual plots** for any DVs of interest by searching for DVs here and by running individual functions listed below this block (~80)

### notes ###
- assumes DV name familiarity, eg Folsom Lake is `s8`. If not consult `.wresl` or `.dss` files.  `varcodes.csv` identifies some dvname-commonname pairs, add more as desired. Some plots label the `df$dv`, the actual CalSim name, and others the `df$dv_name`, the common name (standardizing in progress)
- save new finished plot scripts in `plotexportscripts` folder to add to collection of templates & add folder of file name
- currently assumes all scenarios are under same climate scenario (tied to wyt.csv - adjustment needed to accomodate more for any water  year type functions - other functions still applicable as is if multiple climate scenarios used) (sample's uses Q5 Early Long Term)
- default plot size is widescreen to exactly fit default `.pptx`. To change, search and replace all (from Ctrl-F) `width = 13.333, height = 7.5`, to desired dimensions, eg `width = 10, height = 6` , same with desired filetype, eg `.jpg`, `.pdf`, `.html`)
- accepts either CalSimII or CalSim 3.0 output, but set up currently for CalSimII's time range only
- currently lacks any diagnostics on "controls" - hoping to add directly in `.wresl` files for ease in csdvr, other post-processors, in future
- currently lacks any geospatial ability
  
  Access CalSim benchmark studies and contact info for WRIMS software:
  
  https://water.ca.gov/Library/Modeling-and-Analysis/Central-Valley-models-and-tools/CalSim-2

