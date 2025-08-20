#'
#' 
#' 

list_diseases <- function(year) {
  df <- tibble::tribble(
    ~year, ~disease_code, ~disease_name,
    "2010", "abd", "acute bloody diarrhoea",
    "2010", "aes", "acute encephalitis syndrome",
    "2010", "afp_pv", "acute flaccid paralysis with polio virus isolate",
    "2010", "ahf", "acute haemorrhagic fever",
    "2010", "aefi", "adverse events following immunisation",
    "2010", "ant", "anthrax",
    "2010", ""
  )
}