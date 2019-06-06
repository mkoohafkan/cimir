dataitems = as.data.frame(readxl::read_excel("dataitems.xlsx"))
usethis::use_data(dataitems, overwrite = TRUE, internal = TRUE)
