library(shiny)
library(shinyjs)
library(shinythemes)
library(seqinr)
library(protr)
library(markdown)

shinyUI(fluidPage(title="CryoProtect: a web server for classifying antifreeze proteins from non-antifreeze proteins", theme=shinytheme("spacelab"),
                  useShinyjs(),
                  navbarPage(strong("CryoProtect"), collapsible = TRUE,
                             titleContent <- HTML("<font color='#5DADE2'><b>Cryo</b></font><font color='#515A5A'><b>Protect</b>:</font> <font color='#707B7C'>a web server for classifying antifreeze proteins from non-antifreeze proteins</font>"),
                             tabPanel("Submit Job", titlePanel(titleContent),
                                      sidebarLayout(
                                        
                                        sidebarPanel(
                                          tags$label("Enter your input sequence(s) in FASTA format",style="float: none; width: 100%;"),
                                          actionLink("addlink", "Insert example data"),
                                          tags$textarea(id="Sequence", rows=5, cols=180, style="float: none; width:100%;", ""),
                                         
                                          fileInput('file1', 'or upload file',accept=c('text/FASTA','FASTA','.fasta','.txt')),
                                          
                                          actionButton("submitbutton", "Submit", class = "btn btn-primary"),
                                          HTML("<a class='btn btn-default' href='/cryoprotect/'>Clear</a>")
                                        ), #sidebarPanel
                                        
                                        mainPanel(
                                          tags$label("Status/Output",style="float: none; width: 100%;"),
                                          verbatimTextOutput('contents'),
                                          downloadButton('downloadData', 'Download CSV')
                                        )  
                                      ) #sidebarLayout
                             ), #tabPanel Submit Job
                             
                             tabPanel("About", titlePanel("About"), div(includeMarkdown("about.md"), align="justify")),
                             tabPanel("Citing Us", titlePanel("Citing Us"), includeMarkdown("cite.md")),
                             tabPanel("Contact", titlePanel("Contact"), includeMarkdown("contact.md")),	
                             
                             copyright <- div(HTML("<br><table border=0 cellpadding=10 cellspacing=10 width='100%' height='50'><tr><td bgcolor='#f2f2f2' align='center'>Copyright © 2016 <a href='http://codes.bio'>codes.bio</a>. All rights reserved.</td></tr></table>")),
                             cat(as.character(copyright))
                  ) #navbarPage
) #fluidPage	
) #shinyUI
