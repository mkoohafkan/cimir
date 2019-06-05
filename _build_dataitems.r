dataitems = readr::read_tsv("dataitems.tsv")
usethis::use_data(dataitems, overwrite = TRUE, internal = TRUE)
