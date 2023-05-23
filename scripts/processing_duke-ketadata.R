library(readxl)
library(tidyverse)

sampbox <- read_excel("../data/16S/ANL/argonne_spakowicz_sampleboxmap.xlsx")
mimbox <- read_excel("../data/16S/ANL/argonne_spakowicz_mimicboxmap.xlsx")
barcode <- read.delim("../data/16S/ANL/230428_Williams_16sFWD_230426.txt") %>%
  rename("sampleID" = "X.SampleID")

break_plates <- function(boxdat){
  pstarts <- grep("Plate", colnames(boxdat))
  pends <- unlist(lapply(boxdat, function(x) all(is.na(x))))
  pends <-c(grep("TRUE", pends), ncol(boxdat))
  
  platelist <- lapply(1:length(pstarts), function(x)
    boxdat[,pstarts[x]:pends[x]])
  plateform <- lapply(1:length(platelist), 
                      function(x)
                        platelist[[x]] %>%
                        mutate(plate = x) %>%
                        rename("row" := paste("Plate", x)) %>%
                        pivot_longer(-c("plate", "row"),
                                     names_to = "column",
                                     values_to = "sample") %>%
                        filter(!is.na(sample))) %>%
    bind_rows() %>%
    mutate(column = gsub("\\..*", "", column))
  
  return(plateform)
}

samplelong <- sampbox %>%
  filter(!is.na(`Plate 1`)) %>%
  mutate(`4...5` = as.numeric(`4...5`)) %>%
  break_plates()
mimiclong <- break_plates(mimbox)

joined.dat <- samplelong %>%
  rename("sampleID" = "sample") %>%
  left_join(mimiclong) %>%
  rename("mimicID" = "sample") %>%
  left_join(barcode)

any(is.na(joined.dat$mimicID))

write.csv(joined.dat, "../data/16S/ANL/metadat.csv", row.names = F)
