#'
#' Select EDCS google drive files to use 
#' 

edcs_gdrive_select <- function(gdrive, pattern) {
  gdrive |>
    dplyr::filter(
      stringr::str_detect(
        string = name, pattern = pattern
      )
    )
} 

