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
  )
)


## EDCS data extraction targets ----
edcs_data_extract_targets <- tar_plan(
  tar_target(
    name = edcs_gdrive_file_2010_2014,
    command = edcs_gdrive_select(
      gdrive = edcs_gdrive_file_copy, pattern = "2010|2011|2012|2013|2014"
    )
  ),
  tar_target(
    name = edcs_weekly_text_2010_2014,
    command = edcs_extract_text_2010_2014(gdrive = edcs_gdrive_file_2010_2014),
    pattern = map(edcs_gdrive_file_2010_2014)
  ),
  tar_target(
    name = edcs_weekly_2010,
    command = edcs_extract_data_2010(
      text_data = edcs_weekly_text_2010_2014[[1]],
      disease_list = edcs_disease_list |>
        dplyr::filter(year == 2010)
    )
  ),
  tar_target(
    name = edcs_weekly_2011,
    command = edcs_extract_data_2011(
      text_data = edcs_weekly_text_2010_2014[[2]],
      disease_list = edcs_disease_list |>
        dplyr::filter(year %in% 2010:2011)
    )
  )
)