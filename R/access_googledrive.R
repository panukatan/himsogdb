#'
#' Get Google Sheets ID
#' 

get_gsheets_id <- function(path, filename) {  
  id <- googledrive::drive_ls(
    path = path, pattern = filename, recursive = TRUE
  ) |>
    dplyr::pull(id)

  id
}


#'
#' Download files from Google Drive
#'

download_gdrive <- function(filename, 
                            path,
                            overwrite = FALSE) {  
  ## 
  googledrive::drive_download(
    file = filename,
    path = path,
    overwrite = overwrite
  )
}