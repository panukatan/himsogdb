# Himsog Database Workflow -----------------------------------------------------


## Load libraries and custom functions ----
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


## Build options ----

### Google deauthorisation ----
googledrive::drive_deauth()
googlesheets4::gs4_deauth()


## Data targets ----
data_targets <- tar_plan(
  ## URL for himsog directory in Google Drive ----
  himsog_gdrive_directory_id = googledrive::as_id(
    "https://drive.google.com/drive/folders/1BP9eXlBo3dpX0c9itcbwQe9OSSZcUm2w"
  ),
  tar_target(
    name = himsog_gdrive_file_list_id,
    command = get_gsheets_id(
      path = himsog_gdrive_directory_id, 
      filename = "doh_disease_surveillance_files"
    )
  ),
  tar_target(
    name = himsog_edcs_gdrive_files,
    command = googlesheets4::read_sheet(
      ss = himsog_gdrive_file_list_id, sheet = 1
    )
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
