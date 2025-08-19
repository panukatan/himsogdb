# Philippine TB Information System datasets ------------------------------------

## TBIS data targets ----
tbis_data_targets <- tar_plan(
  tar_target(
    name = tbis_gdrive_files,
    command = googlesheets4::read_sheet(
      ss = gdrive_file_list_id, sheet = 6
    )
  ),
  tar_target(
    name = tbis_gdrive_file_id,
    command = get_gdrive_id(gdrive_files = tbis_gdrive_files)
  ),
  tar_target(
    name = tbis_gdrive_file_name,
    command = get_gdrive_filename(gdrive_file_id = tbis_gdrive_file_id),
    pattern = map(tbis_gdrive_file_id)
  ),
  tar_target(
    name = tbis_gdrive_directory,
    command = create_gdrive_folder(
      gdrive = himsog_gdrive_directory, dir_name = "tbis"
    )
  ),
  tar_target(
    name = tbis_gdrive_directory_files,
    command = googledrive::drive_ls(tbis_gdrive_directory)
  ),
  tar_target(
    name = tbis_gdrive_file_copy,
    command = copy_gdrive(
      id = tbis_gdrive_file_id, gdrive = tbis_gdrive_directory,
      gdrive_files = tbis_gdrive_directory_files
    ),
    pattern = map(tbis_gdrive_file_id)
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