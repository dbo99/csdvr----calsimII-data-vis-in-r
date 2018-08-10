# choose what plots/plotgroups, run whole block

{setwd("./plotexportscripts")

# previous bunchings  
source("june2018plots.r") #all sorts, takes a minute takes 20 s?
source("july2018plots.r") #all sorts, takes a minute takes 20 s?

#### deliveries ###

# bar plots #
source("delivplot_cvpgrp_diffs.r") #one or a few plots, instant
source("delivplot_cvpswp_n&s_rankedtots&diffs.r") #one or a few plots, instant


#### delta outflow ###
source("doplot_many.r") #all sorts, takes 20 s?


#### deliveries & outflow together ###
source("do&cvpswp_n&sdelivs_plot_bardiffs.r") #one or a few plots, instant


}

