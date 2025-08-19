# Field Health Services Information System datasets ----------------------------

## FHSIS data targets ----
fhsis_data_targets <- tar_plan(
  tar_target(
    name = fhsis_gdrive_files,
    command = googlesheets4::read_sheet(
      ss = gdrive_file_list_id, sheet = 4
    )
  ),
  tar_target(
    name = fhsis_gdrive_file_id,
    command = get_gdrive_id(gdrive_files = fhsis_gdrive_files)
  ),
  tar_target(
    name = fhsis_gdrive_file_name,
    command = get_gdrive_filename(gdrive_file_id = fhsis_gdrive_file_id),
    pattern = map(fhsis_gdrive_file_id)
  ),
  tar_target(
    name = fhsis_gdrive_directory,
    command = create_gdrive_folder(
      gdrive = himsog_gdrive_directory, dir_name = "fhsis"
    )
  ),
  tar_target(
    name = fhsis_gdrive_directory_files,
    command = googledrive::drive_ls(fhsis_gdrive_directory)
  ),
  tar_target(
    name = fhsis_gdrive_file_copy,
    command = copy_gdrive(
      id = fhsis_gdrive_file_id, gdrive = fhsis_gdrive_directory,
      gdrive_files = fhsis_gdrive_directory_files
    ),
    pattern = map(fhsis_gdrive_file_id)
  )#,
  # tar_target(
  #   name = edcs_gdrive_download_file,
  #   command = download_gdrive(
  #     id = edcs_gdrive_file_id,
  #     dir_path = "pdf/edcs",
  #     overwrite = TRUE
  #   ),
  #   pattern = map(edcs_gdrive_file_id)
  # )
)