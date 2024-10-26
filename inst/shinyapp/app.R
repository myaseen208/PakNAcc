source("ui.R")
server <- function(input = input, output = output, session = NULL) {
  
  dataInput <- reactive({
    switch(input$dataset,
          "NACurrent"   = readRDS(file = system.file("extdata", "NACurrent.RDS", package = "NationalAccountsApp")),
         "NAConstant"  = readRDS(file = system.file("extdata", "NAConstant.RDS", package = "NationalAccountsApp")),
         "GNICurrent"  = readRDS(file = system.file("extdata", "GNICurrent.RDS", package = "NationalAccountsApp")),
         "GNIConstant" = readRDS(file = system.file("extdata", "GNIConstant.RDS", package = "NationalAccountsApp"))
    )
  })
  
  output$Data <- 
    DT::renderDT({
      DT::datatable(
        data  = dataInput(),
        filter = c("none", "bottom", "top")[3],
        options = list(pageLength = 50, autoWidth = TRUE)
      )
    })
  
  output$PivotTable <- renderRpivotTable({
    rpivotTable(
      data           = dataInput(),
      rows           = c("Quarter"),  
      cols           = c("Year"),
      aggregatorName = "Sum",
      vals           = "NA",
      rendererName   = "Area Chart",
      subtotals      = TRUE,
      width          = "10%",
      height         = "4000px"
    )
  })
}

shinyApp(ui = ui, server = server)