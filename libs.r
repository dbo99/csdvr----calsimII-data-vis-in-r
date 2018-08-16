## these will need a one-time install first - code block at bottom - then nothing more required here
library(data.table) #speedy joins & operations, good for derived timeseries
library(tidyverse) # gets dplyr, ggplot2, readr, lubridate -- install by pasting install.packages("tidyverse") into console  (https://www.tidyverse.org/ - wonderful libraries!)
library(magrittr)  # %<>% pipes!  
library(zoo)       # used for mon-years in timeseries plots  
library(plotly)    # ggplotly() converts ggplot to interactive html - good with lots of scenarios as colors become hard to distinguish
library(lubridate) # for easy dates #should be in already as part of tidyverse, but seems sometimes needed for `month` function being unrecognized w/o it (zoo interference?)
library(cowplot)   # not used in core files, but makes easy stacking plots with `plot_grid`, eg plot <- plot_grid(p1, p2, ncol = 1) #or nrow = 2, or both (2x2), good default plot aesthetics
library(ggridges)  # ridge plots!
library(viridis)   # nice color scale, robust to colorblindness
library(RColorBrewer) # more color stuff
library(scales)    # more color stuff
library(here)      # for relative path names and better csdvr portability - not implemented fully in scripts - still testing


#install.packages("tidyverse") 
#install.packages("magrittr")   
#install.packages("zoo")       
#install.packages("plotly")    
#install.packages("lubridate") 
#install.packages("cowplot")    
#install.packages("ggridges")  
#install.packages("viridis")    
#install.packages("RColorBrewer")
#install.packages("scales")    
#install.packages("here")      
#install.packages("data.table") 
