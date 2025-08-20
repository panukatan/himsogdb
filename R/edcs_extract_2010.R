#'
#' Extract data from EDCS 2010 pdf/s
#' 

edcs_extract_data_2010 <- function(gdrive, edcs_disease_list) {
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
    tibble::as_tibble()
    
  x <- c(
    "cases_cum_week_51", "deaths_cum_week_51", 
    "cases_n_week_52", "deaths_n_week_52"
  )

  df_names <- lapply(
    X = edcs_disease_list$disease_code, FUN = paste, x, sep = "_"
  ) |>
    unlist()

  names(pdf_data) <- df_names

  pdf_data
}


get_start_line <- function(x) {
  grep(pattern = "^1\\s{1}", x = x)
}

get_end_line <- function(x) {
  grep(pattern = "^NCR\\s{1}", x = x)
}