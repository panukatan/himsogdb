#'
#' List diseases
#' 

edcs_list_diseases <- function() {
  tibble::tribble(
    ~year,  ~disease_code, ~disease,                                ~diagnosis_type,
    "2010", "abd",         "Acute Bloody Diarrhoea",                NA_character_,
    "2010", "aes",         "Acute Encephalitis Syndrome",           NA_character_,
    "2010", "afp",         "Acute Flaccid Paralysis",               "with polio virus isolate",
    "2010", "ahf",         "Acute Hemorrhagic Fever",               NA_character_,
    "2010", "aei",         "Adverse Events following Immunization", NA_character_,
    "2010", "ant",         "Anthrax",                               "suspected/clinically-confirmed",
    "2010", "cho",         "Cholera",                               "suspected/clinically-confirmed",
    "2011", "chl",         "Cholera",                               "laboratory-confirmed", 
    "2010", "den",         "Dengue",                                "suspected/clinically-confirmed",
    "2010", "dpt",         "Diptheria",                             "suspected/clinically-confirmed",
    "2013", "hfm",         "Hand, foot, and mouth Disease",         "suspected/clinically-confirmed",
    "2010", "hep",         "Hepatitis",                             "laboratory-confirmed",
    "2010", "ili",         "Influenza-like Illness",                NA_character_,
    "2010", "lep",         "Leptospirosis",                         "suspected/clinically-confirmed",
    "2011", "let",         "Leptospirosis",                         "laboratory-confirmed",
    "2010", "mal",         "Malaria",                               "laboratory-confirmed",
    "2010", "mea",         "Measles",                               "laboratory-confirmed",
    "2010", "meb",         "Bacterial Meningitis",                  "suspected/clinically-confirmed",
    "2011", "mel",         "Bacterial Meningitis",                  "laboratory-confirmed",
    "2010", "med",         "Meningococcal Disease",                 "suspected/clinically-confirmed",
    "2011", "men",         "Meningococcal Disease",                 "laboratory-confirmed",
    "2010", "net",         "Neonatal Tetanus",                      NA_character_,
    "2010", "nnt",         "Non-neonatal Tetanus",                  NA_character_,
    "2010", "psp",         "Paralytic Shellfish Poisoning",         "suspected/clinically-confirmed",
    "2010", "pts",         "Pertussis",                             "suspected/clinically-confirmed",
    "2010", "rab",         "Rabies",                                NA_character_,
    "2010", "tys",         "Typhoid Fever",                         "suspected/clinically-confirmed",
    "2010", "typ",         "Typhoid Fever",                         "laboratory-confirmed"
  ) |>
    dplyr::mutate(
      dplyr::across(.cols = disease_code, .fns = factor),
      dplyr::across(.cols = disease, .fns = factor)
    )
}