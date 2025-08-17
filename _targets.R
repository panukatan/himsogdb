# Himsog Database Workflow -----------------------------------------------------


## Load libraries and custom functions ----
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


## Build options ----

### Google authorisation ----
googledrive::drive_auth(
  email = Sys.getenv("GOOGLE_AUTH_EMAIL"),
  path = Sys.getenv("GOOGLE_AUTH_FILE")
)


## Data targets ----
data_targets <- tar_plan(
  ## URL for himsog directory in Google Drive ----
  gdrive_directory_id = googledrive::as_id(
    "https://drive.google.com/drive/folders/1BP9eXlBo3dpX0c9itcbwQe9OSSZcUm2w"
  ),
  tar_target(
    name = gdrive_file_list_id,
    command = get_gsheets_id(
      path = gdrive_directory_id, 
      filename = "doh_disease_surveillance_files"
    )
  ),
  tar_target(
    name = edcs_gdrive_files,
    command = googlesheets4::read_sheet(
      ss = gdrive_file_list_id, sheet = 1
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
      dir_name = "edcs", dir_path = "philippines/himsog"
    )
  )#,
  # tar_target(
  #   name = edcs_gdrive_file_copy,
  #   command = copy_gdrive(
  #     id = edcs_gdrive_file_id, dir_path = edcs_gdrive_directory
  #   ),
  #   pattern = map(edcs_gdrive_file_id)
  # )
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


## Processing targets ----
processing_targets <- tar_plan(
  
)


## Analysis targets ----
analysis_targets <- tar_plan(
  
)


## Output targets ----
output_targets <- tar_plan(
  
)


## Reporting targets ----
report_targets <- tar_plan(
  
)


## Deploy targets ----
deploy_targets <- tar_plan(
  
)


## List targets
all_targets()
