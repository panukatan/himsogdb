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
#' Create new Google Drive directory
#' 

create_gdrive_folder <- function(dir_name, dir_path) {
  ## Create dir_path ----
  x <- googledrive::drive_get(file.path(dir_path, dir_name))

  if (nrow(x) == 0) {
    googledrive::drive_mkdir(name = dir_name, path = dir_path)
  }

  file.path(dir_path, dir_name)
}


#'
#' Copy Google Drive files from one Drive to another
#' 

copy_gdrive <- function(id, dir_path, overwrite = FALSE) {
  filename <- googledrive::drive_get(id = id)$name

  path <- file.path(dir_path, filename)

  x <- googledrive::drive_get(path)

  if (nrow(x) == 0 | (nrow(x) != 0 & overwrite)) {
    googledrive::drive_cp(file = id, path = path, overwrite = overwrite)
  }

  path
}


#'
#' Download files from Google Drive
#'

download_gdrive <- function(id,
                            dir_path,
                            overwrite = FALSE) {
  ## Check if dir_path exists and create if it doesn't ----
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE)
  }

  ## Get filename ----
  filename <- googledrive::drive_get(id = id)$name

  ## Create path to downloaded file ----
  path <- file.path(dir_path, filename)

  if ((file.exists(path) & overwrite) | !file.exists(path)) {
    ## Download Google Drive file into dir_path ----
    googledrive::drive_download(
      file = id,
      path = path,
      overwrite = overwrite
    )
  }

  path
}


#'
#' Get Google Drive files ID
#' 

get_gdrive_id <- function(gdrive_files) {
  gdrive_files |>
    dplyr::filter(!is.na(doh_google_drive_link)) |>
    dplyr::pull(doh_google_drive_link) |>
    googledrive::as_id()
}

#'
#' Get Google Drive file names
#' 

get_gdrive_filename <- function(gdrive_file_id) {
  googledrive::drive_get(gdrive_file_id) |>
    dplyr::pull(name)
}