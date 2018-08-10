# csdvr
 calsim data vis in R | 
 version 1.0_8.10.2018 | 
 filter, visualize, and analyze calsim output for any number of variables and reasonable number of calsim scenarios | 
 export report/presentation ready images (eg jpgs, pdfs) or interactive plots (html) | currently no geospatial ability
 
### uses ###

- WRIMS CalSim decision variable ("DV") output in `.csv` format (not `.dss`). If csv file needed, specify `outputfilename.csv` instead of `outputfilename.dss` in WRIMS' `Dvar DSS file:` field to return both `.csv` and `.dss` files via WRIMS versions 2018 or later (free from California Dept. of Water Resources, see link at bottom for request - currently through email list distribution)
- R, and R libraries specified in `libs.r`. Probably relies most on `dplyr` and `ggplot2` libraries, both conveniently in the `tidyverse`

### steps ###

1. Download  most recent csdvr_mm.dd.yyyy.zip (~30 kb) 
3. Place your CalSim csvs in the `csv` folder 
2. In `csv_list.r`, enter your complete csv file names (eg `040812_BO_Y1a1.csv`) and enter scenario nicknames (eg `Scen1_Y1A1`). Short labels make room for plot space


4. If scenario order matters for on-the-fly plots or batch plots, enter same nicknames in `scenfacts.r` in order you prefer: top to bottom in `scenfacts.r` yields top to bottom order in legend. Otherwise skip step; default order without specification in `scenfacts.r` is alphabetic

5. In `control.r`: in three places at top, enter the working folder path (eg, this program (the working folder) could live somewhere as a stand alone post-processor and another could be in a project folder for a specific project - user preference

6. In `control.r`, run blocks from top down as needed: single run-clicks here let you read in csvs, build `data.frame`s, and either batch export `ggplot2` or `plotly` plots or see/export tables as `tibble`/`.csv` to examine certain DVs individually or together, by running the individual functions listed

#### notes ####
- assumes you know names of DVs to view, eg Folsom Lake is `S8`. If not, consult `.wresl` or `.dss` files. To-do list: auto-fill DV names while typing. `varcodes.csv` identifies some dvname-commonname pairs, add more as needed. Some plots label the `df$dv`, the actual CalSim name, and others the `df$dv_name`, the common name 
- as needed/time allows save/generalize your working plots in `plotexportscripts` folder to add to collection of templates
- currently assumes all scenarios are under same climate scenario (tied to wyt.csv - adjustment needed to accomodate more for any water  year type functions - other functions still applicable as is if multiple climate scenarios used)
- default plot size is widescreen to exactly fit default `.pptx`. To change, search and replace all (from Ctrl-F) `width = 13.333, height = 7.5`, to desired dimensions, eg `width = 10, height = 6` , same with desired filetype, eg `.jpg`, `.pdf`, `.html`)
- Accepts either CalSimII or CalSim 3.0 output, but set up currently for CalSimII's time range only
  
  Access CalSim benchmark studies and contact info for WRIMS software:
  
  https://water.ca.gov/Library/Modeling-and-Analysis/Central-Valley-models-and-tools/CalSim-2

