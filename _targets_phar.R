# Philippine HIV/AIDS Registry datasets ----------------------------------------

## PHAR data targets ----
phar_data_targets <- tar_plan(
  tar_target(
    name = phar_gdrive_files,
    command = openxlsx::read.xlsx(
      xlsxFile = doh_disease_surveillance_file,
      sheet = 3
    )
  ),
  tar_target(
    name = phar_gdrive_file_id,
    command = get_gdrive_id(gdrive_files = phar_gdrive_files)
  ),
  tar_target(
    name = phar_gdrive_file_name,
    command = get_gdrive_filename(gdrive_file_id = phar_gdrive_file_id),
    pattern = map(phar_gdrive_file_id)
  ),
  tar_target(
    name = phar_gdrive_directory,
    command = create_gdrive_folder(
      gdrive = himsog_gdrive_directory, dir_name = "phar"
    )
  ),
  tar_target(
    name = phar_gdrive_directory_files,
    command = googledrive::drive_ls(phar_gdrive_directory)
  ),
  tar_target(
    name = phar_gdrive_file_copy,
    command = copy_gdrive(
      id = phar_gdrive_file_id, gdrive = phar_gdrive_directory,
      gdrive_files = phar_gdrive_directory_files
    ),
    pattern = map(phar_gdrive_file_id)
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