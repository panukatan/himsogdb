# Epidemic-prone disease case surveillance -------------------------------------

## EDCS data targets ----
edcs_data_targets <- tar_plan(
  tar_target(
    name = edcs_gdrive_files,
    command = openxlsx::read.xlsx(
      xlsxFile = doh_disease_surveillance_file,
      sheet = 1
    )
  ),
  tar_target(
    name = edcs_gdrive_file_id,
    command = get_gdrive_id(gdrive_files = edcs_gdrive_files)
  ),
  tar_target(
    name = edcs_gdrive_file_name,
    command = get_gdrive_filename(gdrive_file_id = edcs_gdrive_file_id),
    pattern = map(edcs_gdrive_file_id)
  ),
  tar_target(
    name = edcs_gdrive_directory,
    command = create_gdrive_folder(
      gdrive = himsog_gdrive_directory, dir_name = "edcs"
    )
  ),
  tar_target(
    name = edcs_gdrive_directory_files,
    command = googledrive::drive_ls(edcs_gdrive_directory)
  ),
  tar_target(
    name = edcs_gdrive_file_copy,
    command = copy_gdrive(
      id = edcs_gdrive_file_id, gdrive = edcs_gdrive_directory,
      gdrive_files = edcs_gdrive_directory_files
    ),
    pattern = map(edcs_gdrive_file_id)
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


## EDCS data extraction targets ----
edcs_data_extract_targets <- tar_plan(
  tar_target(
    name = edcs_weekly_2010,
    command = edcs_extract_data_2010(
      gdrive = edcs_gdrive_file_copy |>
        dplyr::filter(stringr::str_detect(string = name, pattern = "2010")),
      edcs_disease_list = edcs_disease_list
    )
  )
)