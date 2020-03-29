"This script knits the final report together.
Usage: scripts/knit.R --finalreport=<finalreport>" -> doc

suppressMessages(library(docopt))

opt <- docopt(doc)

main <- function(finalreport) {
  rmarkdown::render(finalreport, 
                    c("html_document", "pdf_document"))
}

main(opt$finalreport)