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

googlesheets4::gs4_auth(
  email = Sys.getenv("GOOGLE_AUTH_EMAIL"),
  path = Sys.getenv("GOOGLE_AUTH_FILE")  
)


## Data targets ----
data_targets <- tar_plan(
  ## URL for himsog directory in Google Drive ----
  gdrive_directory_id = googledrive::as_id(
    "https://drive.google.com/drive/folders/0AKwv_i3QrXCtUk9PVA"
  ),
  gdrive_directory = googledrive::shared_drive_get(id = gdrive_directory_id),
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
    name = himsog_gdrive_directory,
    command = create_gdrive_folder(
      gdrive = gdrive_directory, dir_name = "himsog"
    )
  ),
  tar_target(
    name = edcs_gdrive_directory,
    command = create_gdrive_folder(
      gdrive = himsog_gdrive_directory, dir_name = "edcs"
    )
  ),
  tar_target(
    name = edcs_gdrive_directory_files,
    command = googledrive::drive_ls(edcs_gdrive_directory),
    cue = tar_cue("always")
  ),
  tar_target(
    name = edcs_gdrive_file_copy,
    command = copy_gdrive(
      id = edcs_gdrive_file_id, gdrive = edcs_gdrive_directory,
      gdrive_files = edcs_gdrive_directory_files
    ),
    pattern = map(edcs_gdrive_file_id)
  ),
  tar_target(
    name = edcs_gdrive_download_file,
    command = download_gdrive(
      id = edcs_gdrive_file_id,
      dir_path = "pdf/edcs",
      overwrite = TRUE
    ),
    pattern = map(edcs_gdrive_file_id)
  )
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
