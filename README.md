# cspp
 calsimII r post processor (csrpp). version august beta 18.
 
##### workflow #####
1. drop calsim csvs in csv folder
2. in csv_list.r, spell csv file names and give scenarios nicknames
2a. remember/cut-and-paste same nicknames to scenfacts.r (only necessary for batch plots or if order matters for on-the-fly plots, otherwise skip 2a). default without 2a is ~alphabetic.
3. open control.r: spell working folder path (stand alone post-processor location or in a proj-specific folder?), in three places at top 
4. stay at control.r to run blocks from top down as needed: read in csvs, build data.frames, and either batch export plot templates or investigate certain DVs!

- as needed spell other english/nickname descriptions for dvs in varcores.csv - only a few mapped currently, eg "Jones (CVP)" for "d419"
- as needed/time allows save/generalize working plots in plot scripts folder to add to collection of templates
- current only handles one climate change scenario (ie tied to wyt.csv - adjustment needed to accomodate more)
- default plot size is widescreen powerpoint. to change, search and replace (eg Ctrl-F/Ctrl-H? "width = 13.333, height = 7.5" for desired size)
