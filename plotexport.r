# choose what plots/plotgroups to run or turn off by commenting out
setwd(here("plotexportscripts"))

{
  


source("outflow&deliv(a).r") #ten or so plots
source("outflow&deliv(b)&exports&omr&stor&alloc.r") #thirty or so

 ### deliveries ###

 ## bar plots #
source("delivplot_cvpgrp_diffs.r") #not many
source("delivplot_cvpswp_n&s_rankedtots&diffs.r") #not many
source("do&cvpswp_n&sdelivs_plot_bardiffs.r") #not many
#source("northbayaqueduct.r")
#
# #### delta outflow ###
source("doplot_many.r") #thirty or so

setwd(here())

}

