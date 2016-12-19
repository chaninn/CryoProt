# CryoProtect
CryoProtect is a web server for classifying query protein sequence as being an antifreeze protein or non-antifreeze protein.

### Prerequisites

Before beginning, please make sure to install the following R packages: *shiny*, *shinyjs* and *shinythemes*, *protr*, *seqinr*, *RWeka* and *markdown* which can be performed by typing the following commands into an R environment:

```
install.packages(c('shiny','shinyjs','shinythemes','protr','seqinr','randomForest','markdown'))
```

### Launching the application
To launch the application on your own computer, in an R environment, type the following:

```
shiny::runGitHub('cryoprotect','chaninn')
```
In a few moments, the application should launch from your web browser.

### Using the application
To use the application:

**Step 1.** Before starting, please wait until you see the following message in the **Status/Output** text box:
```
[1] "Server is ready for prediction."
```
**Step 2.** Paste your sequences in FASTA format into the text box *or* Upload your input FASTA files
**Step 3.** The prediction results will appear in the **Status/Output** box. Users can also download the prediction results in CSV file format by clicking on the **Download** button.

### Citing this work
If you find the CryoProtect web server useful, please cite:
```
Pratiwi R, Malik AA, Schaduangrat N, Prachayasittikul V, Wikberg JES, Nantasenamat C, Shoombuatong, W. *CryoProtect: A web server for classifying antifreeze proteins from non-antifreeze proteins*. **Journal of Chemistry**, (2016) Invited Manuscript Submitted as Revision.
```
