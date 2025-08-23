#'
#' Extract data from EDCS 2010 pdf/s
#' 

edcs_extract_data_2010 <- function(text_data, disease_list) {
  x <- c(
    "cases_cum_week51", "deaths_cum_week51", 
    "cases_n_week52", "deaths_n_week52"
  )

  df_names <- lapply(
    X = disease_list$disease_code, FUN = paste, x, sep = "_"
  ) |>
    unlist()
  df_names <- c("region", df_names)

  df <- text_data |>
    stringr::str_split(pattern = "\n") |>
    lapply(
      FUN = function(x) {
        start_line <- get_start_line(x)
        end_line <- get_end_line(x)
        x[start_line:end_line] |>
          stringr::str_remove_all(
            pattern = "^\\|\\s|^\\)\\s\\|\\s|^\\.\\s|\\s\\-"
          ) |>
          stringr::str_remove(pattern = "^.*(?=(CAR))") |>
          stringr::str_split(pattern = "\\s{1}", simplify = TRUE)
      }
    ) |>
    do.call(cbind, args = _) |>
    (\(x) x[ , c(1:13, 15:26, 28:39, 41:52, 54:65, 67:78, 80:91, 93:96, 98:101)])() |>
    data.frame() |>
    setNames(nm = df_names) |>
    tibble::as_tibble() |>
    dplyr::mutate(
      dplyr::across(
        .cols = dplyr::everything(),
        .fns = function(x) {
          dplyr::case_when(
            x %in% c("if", "1.", "a:", "£", ":", "i.", "d,", "dt:", "ic") ~ "1",
            x %in% c("6)", ")", "8)", "Os") ~ "0",
            x %in% c("a2", "SZ") ~ "32",
            x == "ee" ~ "5917",
            x == "aL" ~ "51",
            x == "2/" ~ "27",
            x %in% c("a.", "S") ~ "3",
            x == "Bi," ~ "11",
            x == "L9" ~ "15",
            x == "TL" ~ "77",
            .default = x
          )
        }
      ),
      ili_deaths_cum_week51 = ifelse(
        ili_deaths_cum_week51 == "=", 5, ili_deaths_cum_week51
      ),
      pts_cases_cum_week51 = ifelse(
        pts_cases_cum_week51 == "=", 4, pts_cases_cum_week51
      ),
      aes_deaths_cum_week51 = ifelse(
        aes_deaths_cum_week51 == "Z", 2, aes_deaths_cum_week51
      ),
      tys_deaths_cum_week51 = ifelse(
        tys_deaths_cum_week51 == "Z", 7, tys_deaths_cum_week51
      )
    ) |>
    dplyr::mutate(
      dplyr::across(.cols = !region, .fns = function(x) as.integer(x))
    ) |>
    tidyr::pivot_longer(
      cols = !region, 
      names_to = c("disease_code", "type1", "type2", "week"), names_sep = "_",
      values_to = "n"
    ) |>
    dplyr::left_join(
      y = disease_list |>
        dplyr::select(disease_code, disease),
      by = "disease_code"
    ) |>
    dplyr::mutate(
      week = stringr::str_remove_all(string = week, pattern = "week"),
      type2 = ifelse(type2 == "cum", "cumulative", "current week")
    ) |>
    dplyr::relocate(disease, .after = disease_code)

  df
}


get_start_line <- function(x) {
  grep(pattern = "^1\\s{1}", x = x)
}

get_end_line <- function(x) {
  grep(pattern = "^NCR\\s{1}", x = x)
}