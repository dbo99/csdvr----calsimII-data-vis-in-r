# csdvr
 calsim data vis in r. version 1.0_8.10.2018
 
##### workflow #####

0. Requires `.csv` output (no `.dss`). Typing `.csv` instead of `.dss` in WRIMS' dv field produces both a .csv and .dss output "dv" file. Requires WRIMS
   versions from 2018 or later
1. Download csdvr_versiondate.zip as entire package (33 kb) 
3. Drop calsim csvs in `csv` folder
2. In `csv_list.r`, enter csv file names and give scenarios nicknames

3a.  If order matters for on-the-fly plots or batch plots, enter same nicknames to scenfacts.r, in order you prefer (top to bottom here will enforce top to bottom in legend). Otherwise skip step.  Default order without 2a is alphabetic or similar

4. In `control.r`: in three places at top, enter the working folder path (eg use as a stand alone post-processor location or in a project-specific folder?)

5. In `control.r`, run blocks from top down as needed: single run-clicks there let you read in csvs, build `data.frames`, and either batch export `ggplot2` or `plotly` plots or tables to examine certain decision variables (dvs)

#### notes #####
- assumes you know names of variables to search for, ie names of dvs, eg "s17" (dss records reveal names conveniently), next steps are for auto-completion of dv names while typing. `varcodes.csv` identifies some
- as needed enter other name/nickname descriptions for dvs in `varcodes.csv` - only a few mapped currently, eg `Jones (CVP)` for `d419`. some plots label the `df$dv`, the actual calsim name, and other `df$dv_name`, the nickname
- as needed/time allows save/generalize your working plots in plot scripts folder to add to collection of templates
- currently only handles one climate change scenario (ie tied to wyt.csv - adjustment needed to accommodate more)
- default plot size is widescreen powerpoint. to change, search and replace (ie Ctrl-F `width = 13.333, height = 7.5`, replace all with 
  desired dimensions, eg `width = 10, height = 6` and filetype, eg .jpg, .pdf)
  
  access calsim benchmark studies:
  
  https://water.ca.gov/Library/Modeling-and-Analysis/Central-Valley-models-and-tools/CalSim-2

