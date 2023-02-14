# Interactive Gene Read Counts Heat Map

### Functionality:

This shiny app adjusts a heat map of gene read counts based on which samples the user wants to subset. Subsets start with the entire set selected, and users can deselect samples so the subset of interest remains. The heat map was created using the `heatmap.2` function from the `gplots` library. Thresholds for gene by gene filtering was counts greater than equal to 240 across all 6 samples.

Genes Clustered using the default hierarchical clustering `hclust()` function in `heatmap.2()`.

### How to Run:

The counts file provided is in the folder, so the local reference will run. To start this app, (using an R or RStudio console) run `library(shiny)` (if not installed, run `install.packages("shiny")`) . Then, use the shiny function `runApp("/path/HeatmapApp/ReadsTask.R")` where path is the file path that leads to the folder HeatmapApp.
