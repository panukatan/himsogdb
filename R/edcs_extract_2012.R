#'
#' Extract data from EDCS 2012 pdf/s
#' 

edcs_extract_data_2012 <- function(text_data, disease_list) {
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
            pattern = "^\\|\\s|^\\)\\s\\|\\s|^\\.\\s|^\\;\\s|^\\:\\s|^oe\\s|\\s\\-|SC\\s|\\|\\s|\\(\\s|\\s\\|"
          ) |>
          stringr::str_remove(pattern = "© ") |>
          stringr::str_replace(pattern = "CARAGA \\\\? ", replacement = "CARAGA ") |>
          stringr::str_split(pattern = "\\s{1}", simplify = TRUE)
      }
    ) |>
    do.call(cbind, args = _) |>
    (\(x) x[ , c(1:13, 15:26, 28:39, 41:52, 54:65, 67:78, 80:91, 93:104, 106:117)])() |>
    data.frame() |>
    setNames(nm = df_names) |>
    tibble::as_tibble() |>
    dplyr::mutate(
      dplyr::across(
        .cols = dplyr::everything(),
        .fns = function(x) {
          dplyr::case_when(
            x == "o/" ~ "97",
            x %in% c("0)", "0.","8)", ")", "02==|==20", "0S") ~ "0",
            x %in% c("s", "_", "Z") ~ "2",
            x %in% c("A", "i.", "i:", "iL", "cf", "1;") ~ "1",
            x %in% c("Sek", "LJ", "Ea") ~ "17",
            stringr::str_detect(x, pattern = "3994*") ~ "3994",
            x == "LS" ~ "19",
            x == "=" ~ "37",
            x == "aa" ~ "51",
            x == "Lis" ~ "113",
            x == "a3" ~ "13",
            x == "é" ~ "4",
            x == "ZA." ~ "51",
            x == "S77" ~ "577",
            .default = x
          )
        }
      ),
      cho_cases_cum_week51 = stringr::str_remove_all(
        string = cho_cases_cum_week51, pattern = "\\(|\\)|\\\\?"
      ),
      ili_deaths_cum_week51 = ifelse(
        ili_deaths_cum_week51 == "LS", "19", ili_deaths_cum_week51
      ),
      lep_cases_cum_week51 = ifelse(
        lep_cases_cum_week51 == "LS", "15", lep_cases_cum_week51
      ),
      dpt_cases_cum_week51 = ifelse(
        dpt_cases_cum_week51 == "a", "1", dpt_cases_cum_week51
      ),
      net_cases_cum_week51 = ifelse(
        net_cases_cum_week51 == "a", "9", net_cases_cum_week51
      ),
      net_deaths_cum_week51 = ifelse(
        net_deaths_cum_week51 == "a", "9", net_deaths_cum_week51
      ),
      net_deaths_n_week52 = ifelse(
        net_deaths_n_week52 == "", "0", net_deaths_n_week52
      ),
      pts_deaths_n_week52 = ifelse(
        pts_deaths_n_week52 == "", "0", pts_deaths_n_week52
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
