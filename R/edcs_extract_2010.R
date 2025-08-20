#'
#' Extract data from EDCS 2010 pdf/s
#' 

edcs_extract_data_2010 <- function(gdrive) {
  destfile <- file.path(tempdir(), gdrive$name)
  googledrive::drive_download(file = gdrive, path = destfile, overwrite = TRUE)

  pdf_data <- pdftools::pdf_ocr_text(destfile) |>
    stringr::str_split(pattern = "\n") |>
    lapply(
      FUN = function(x) {
        start_line <- get_start_line(x)
        end_line <- get_end_line(x)
        x[start_line:end_line] |>
          stringr::str_remove_all(
            pattern = "^\\|\\s|^\\)\\s\\|\\s|^\\.\\s|\\s\\-"
          ) |>
          stringr::str_remove(pattern = "^.*(?=(CAR))") |>
          stringr::str_split(pattern = "\\s{1}", simplify = TRUE)
      }
    ) |>
    do.call(cbind, args = _) |>
    tibble::as_tibble() |>
    

}


get_start_line <- function(x) {
  grep(pattern = "^1\\s{1}", x = x)
}

get_end_line <- function(x) {
  grep(pattern = "^NCR\\s{1}", x = x)
}