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

create_gdrive_folder <- function(gdrive, dir_name, overwrite = FALSE) {
  x <- try(
    googledrive::drive_mkdir(
      name = dir_name, path = gdrive, overwrite = overwrite
    ),
    silent = TRUE
  )

  if (is(x, "try-error")) {
    x <- googledrive::drive_ls(path = gdrive$id) |>
      dplyr::filter(name == dir_name)
  }

  x
}


#'
#' Copy Google Drive files from one Drive to another
#' 

copy_gdrive <- function(id, gdrive, gdrive_files, overwrite = FALSE) {
  filename <- googledrive::drive_get(id = id)$name

  file_exists <- filename %in% gdrive_files$name

  if (!file_exists | (file_exists & overwrite)) {
    googledrive::drive_cp(
      file = id, path = gdrive, name = filename,
      overwrite = overwrite
    )
  } else {
    gdrive_files |>
      dplyr::filter(name == filename)
  }
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


#'
#' Download Google Sheets listing of available health statistics files
#' 

download_doh_stats_files_list <- function(gdrive_directory, destfile, 
                                          overwrite = FALSE) {
  file <- gdrive_directory |>
    googledrive::drive_ls() |>
    dplyr::filter(name == "doh_disease_surveillance_files")

  googledrive::drive_download(
      file = file,
      path = destfile,
      overwrite = overwrite
    )
  
  destfile
}