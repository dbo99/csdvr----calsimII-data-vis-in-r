library(tidyverse) # gets dplyr, ggplot2, readr, lubridate -- install by pasting install.packages("tidyverse") into console  (https://www.tidyverse.org/ - wonderful libraries!)
library(magrittr)  # %<>% pipes  
library(zoo)       # used for mon-years in timeseries plots  
library(plotly)    # ggplotly() converts ggplot to interactive html - good with lots of scenarios as colors become hard to distinguish
library(lubridate) # for easy dates #should be part of tidyverse, but seems sometimes needed for `month` function being unrecognized w/o it (zoo interference?)
library(cowplot)   # not used in core files, but makes easy stacking plots, with plot_grid, eg plot <- plot_grid(p1, p2, ncol = 1) #or nrow = 2, or both (2x2), good default plot aesthetics
library(ggridges)  # ridge plots!
library(viridis)   # nice color scale, robust to colorblindness
library(RColorBrewer) # more color stuff
library(scales)    # more color stuff
