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
    name = doh_disease_surveillance_file,
    command = download_doh_stats_files_list(
      gdrive_directory = gdrive_directory,
      destfile = "data/doh_disease_surveillance_files.xlsx",
      overwrite = TRUE
    ),
    format = "file"
  ),
  tar_target(
    name = gdrive_file_list_id,
    command = get_gsheets_id(
      path = gdrive_directory_id, 
      filename = "doh_disease_surveillance_files"
    )
  ),
  tar_target(
    name = himsog_gdrive_directory,
    command = create_gdrive_folder(
      gdrive = gdrive_directory, dir_name = "himsog"
    )
  ),
  edcs_disease_list = edcs_list_diseases()
)


## EDCS targets ----
source("_targets_edcs.R")


## PIDSR targets ----
source("_targets_pidsr.R")


## PHAR targets ----
source("_targets_phar.R")


## FHSIS targets ----
source("_targets_fhsis.R")


## TBIS targets ----
source("_targets_tbis.R")



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
