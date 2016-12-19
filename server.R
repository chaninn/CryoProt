library(shiny)
library(shinyjs)
library(seqinr)
library(protr)
library(randomForest)


# Model Building
training <- read.csv("balanced_data_AAC_DPC.csv", header=TRUE)
fit = randomForest(Class ~ ., training, ntree= 100)

shinyServer(function(input, output, session) {
  
  observe({
    
    shinyjs::hide("downloadData") # Hide download button before input submission
    if(input$submitbutton>0)
      shinyjs::show("downloadData") # Show download button after input submission
    
    FASTADATA <- ''
    fastaexample <- '>AFP_1
MALSLFTVGQLIFLFWTLRITEANPDPAAKAAPAAVADPAAAAAAAVADTASDAAAAAAATAAAAAKAAADTAAAAAKAAADTAAAAAEAAAATARG
>AFP_2
MKSAILTGLLFVLLCVDHMSSASQQSVVATQLIPINTALTPIMMKGQVVNPAGIPFAEMSQIVGKQVNRAVAKDETLMPNMVKTYRAAK
>Non-AFP_1
MAPRSLLLLFSGALALTETWAGSHSLRYFSTAVSRPGRGEPRYIAVEYVDDTQFLRFDSDAAIPRMEPREPWVEQEGPQYWERTTGYAKANAQTDRVALRNLLRRYNQSEAGSHTLQGMNGCDMGPDGRLLRGYHQHAYDGKDYISLNEDLRSWTAADTVAQITQRFYEAEEYAEEFRTYLEGECLELLRRYLENGKETLQRADPPKAHIAHHPISDHEATLRCWALGFYPAEITLTWQRDGEEQTQDTELVETRPAGDGNFQKWAAVVVPSGEEQRYTCHVQHEGLPQPLTLRWEQSPQPTIPIVGIVAGLVVLGAVVTGAVVAAVMWRKKSSDRNRGSYSQAAV
>Non-AFP_2
MLPSLQSLTKKVLAGQCLPTDQYYLLKCYDLWWYDSPITFDHNLGLIKSAGIKDGLDLNTALVKAVRENNYNLIKLFTEWGADINYGLVSVNTEHTRDLCRELGAKETLNEEEILRIFIDLKFYKTSSNIILCHEVFSNNPLLQKVNNLKMRIEIFWELRELIKKTDLLNNEFSLNTLLLKYWYAIAVRYNLKEAIQYFYQKYTHLNTWRLTCALCFNNVFDLHEAYEKDKIYMDLEEMMRVACIKDHNLSTIYYCYVLGANINQAMLASIQYYNIENMFFCMDLGADVFEENMPVGEGYELIRNILSLKIYSPSTAPLPKNTDPEIIDHVLKNYKSKNMMTFLSYDLR
'
    
    if(input$addlink>0) {
      isolate({
        FASTADATA <- fastaexample
        updateTextInput(session, inputId = "Sequence", value = FASTADATA)
      })
    }
  })
  
  datasetInput <- reactive({
    
    inFile <- input$file1 
    inTextbox <- input$Sequence
    
    if (is.null(inTextbox)) {
      return("Please insert/upload sequence in FASTA format")
    } else {
      if (is.null(inFile)) {
        # Read data from text box
        x <- inTextbox
        write.fasta(sequence = x, names = names(x),
                    nbchar = 80, file.out = "text.fasta")
        x <- readFASTA("text.fasta")
        
        # Compute features
        x <- x[(sapply(x, protcheck))]
        AAC <- t(sapply(x, extractAAC))
        DPC <- t(sapply(x, extractDC))
     
        # Construct predictive model
        test = data.frame(AAC,DPC)
        Prediction <- predict(fit, test)
        Prediction <- as.data.frame(Prediction)
        Protein <- cbind(Name = rownames(test, test))
        results <- cbind(Protein, Prediction)
        results <- data.frame(results, row.names=NULL)
        print(results)
      } 
      else {  
        # Read data from uploaded file
        x <- readFASTA(inFile$datapath)
        
        # Compute features
        x <- x[(sapply(x, protcheck))]
        AAC <- t(sapply(x, extractAAC))
        DPC <- t(sapply(x, extractDC))

        # Construct predictive model
        test = data.frame(AAC,DPC)
        Prediction <- predict(fit, test)
        Prediction <- as.data.frame(Prediction)
        Protein <- cbind(Protein = rownames(test, test))
        results <- cbind(Protein, Prediction)
        results <- data.frame(results, row.names=NULL)
        print(results)
      }
    }
  })
  
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } else {
      return("Server is ready for prediction.")
    }
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { paste('predicted_results', '.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(), file, row.names=FALSE)
    })
  
})
