library(shiny)
library(gplots)

#data loading from csv
reads <- read.csv("count_tables.csv", header = T, row.names = "X")
#Sample names passed as header
#Row/gene names default to 'X' since there is no label with the data

#data filtering, many genes with very low or no counts
filt<-c()
for (row in 1:nrow(reads)){
  if(sum(reads[row,])>=240){
    filt<-c(row, filt)
  }
}
reads<-reads[filt,]

## Define UI for app that creates a heatmap of gene read counts, selecting
## which subset of samples should be displayed

ui <- fluidPage(
  titlePanel("Heatmap of Read Counts by Sample"),
  
  sidebarLayout(
    
    sidebarPanel(
      helpText("Select which samples to create the heatmap (interactive)"),
      checkboxGroupInput("subset", label = "Sample Selection",
                         choices = list("A"="A","B"="B", "C"="C", "D"="D", "E"="E", "F"="F"),
                         #DEFAULT STARTS WITH ALL SAMPLES SELECTED AS FULL SET
                         selected = list("A","B","C","D","E","F"))
    ),
    
    mainPanel(
      
      textOutput("genes"),
      br(),
      plotOutput("heat")
    )
  )
  
)

## Define server logic required to draw the heatmap, taking in the selected
## subset of samples as input and plots only those samples

server <- function(input, output) {
  cols=colnames(reads)
  
  samp.cor<-cor(reads, use = "pairwise.complete.obs", method = "pearson")
  gene.cor<-cor(t(reads), use = "pairwise.complete.obs", method = "pearson")
  samp.clust<-hclust(as.dist(1-samp.cor))
  gene.clust<-hclust(as.dist(1-gene.cor))
  
  output$heat <- renderPlot({
    heatmap.2(data.matrix(reads[,input$subset]), dendrogram = "none",
              Colv = as.dendrogram(samp.clust), Rowv = as.dendrogram(gene.clust),
              offsetCol = -89, col = redgreen(max(reads)), trace = "none",
              lhei = c(1,10), lwid = c(1,3))},
    #heatmap.2 has lines that plot over each box of data, setting trace
    # to none shuts this off so it is easier to visualize the data.
    # lhei and lwid parameters condense color key histogram plot.
    
    height = 1200
    #Changed height so there would be easier visibility of the difference in the
    #bands of the counts
  )
  output$genes <- renderText({paste("Number of Genes: ", length(filt))})
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)