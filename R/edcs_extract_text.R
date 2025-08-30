#'
#' Extract text from EDCS pdfs
#' 

edcs_extract_text <- function(gdrive, pages) {

}



#'
#' 
#' 

edcs_extract_text_2010_2014 <- function(gdrive) {
  destfile <- file.path(tempdir(), gdrive$name)
  googledrive::drive_download(file = gdrive, path = destfile, overwrite = TRUE)

  text_pdf <- pdftools::pdf_ocr_text(destfile) |>
    list()

  names(text_pdf) <- gdrive$name

  unlink(destfile)
  
  text_pdf
}


#'
#' 
#' 

edcs_extract_text_2016 <- function(gdrive, pages = 1) {
  destfile <- file.path(tempdir(), gdrive$name)
  googledrive::drive_download(file = gdrive, path = destfile, overwrite = TRUE)

  text_pdf <- pdftools::pdf_ocr_text(destfile, pages = pages)
}