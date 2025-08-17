## Load .env if present
if (file.exists(".env")) {
  try(readRenviron(".env"), silent = TRUE)
}

source("renv/activate.R")

options(
  repos = c(
    IHTM = "https://oxfordihtm.r-universe.dev",
    CRAN = "https://cloud.r-project.org"
  )
)