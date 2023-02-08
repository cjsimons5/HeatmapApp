library(shiny)
library(gplots)

#data loading from csv
reads <- read.csv("count_tables.csv", header = T, row.names = "X")
#Sample names passed as header
#Row/gene names default to 'X' since there is no label with the data

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
      plotOutput("heat")
    )
  )
  
)

## Define server logic required to draw the heatmap, taking in the selected
## subset of samples as input and plots only those samples

server <- function(input, output) {
  cols=colnames(reads)
  output$heat <- renderPlot({
    heatmap.2(data.matrix(reads[,input$subset]), Colv = NA, Rowv = NA, 
              col=colorRampPalette(c("white", "black"))(n=max(reads)),
            #Changed colors to gradient from white to black so it is more obvious
            # when there are areas of low read counts. Also changed the gradient
            # to have as many different shades as there are the highest number of counts
            # so each count value has a different shade.
              offsetCol = -200,
            #Moves the column labels to the top of the plot, increased readability
              trace = "none", dendrogram = "none", lhei = c(1,25), lwid = c(1,5))},
            #heatmap.2 has lines that plot over each box of data, setting trace
            # to none shuts this off so it is easier to visualize the data. Dendrogram
            # set to none to prevent the rearranging of data by Colv and Rowv.
            # lhei and lwid parameters condense color key histogram plot.
    
    height = 2500
    #Changed height so there would be easier visibility of the difference in the
    #bands of the counts
    )
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)