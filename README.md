# cspp
 calsimII data vis in r (csdvr). version august beta 18.
 
##### workflow #####
1. drop calsim csvs in csv folder
2. in csv_list.r, spell csv file names and give scenarios nicknames

2a.  if order matters for on-the-fly plots or batch plots, remember/cut-and-paste same nicknames to scenfacts.r,otherwise skip step. default order without 2a is alphabetic or similar)

3. open control.r: in three places at top, spell working folder path (use as/in a stand alone post-processor location or in a proj-specific folder, choice)

4. stay at control.r to run blocks from top down as needed: read in csvs, build data.frames, and either batch export plot templates or investigate certain DVs. 

- need familiarity with calsim dvs (dss records spell names)
- as needed spell other english/nickname descriptions for dvs in varcores.csv - only a few mapped currently, eg "Jones (CVP)" for "d419"
- as needed/time allows save/generalize your working plots in plot scripts folder to add to collection of templates
- currently only handles one climate change scenario (ie tied to wyt.csv - adjustment needed to accomodate more)
- default plot size is widescreen powerpoint. to change, search and replace (ie Ctrl-F "width = 13.333, height = 7.5" replace all to 
  desired dimensions, filetype, eg .jpg, .pdf)
