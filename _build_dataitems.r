dataitems = as.data.frame(readxl::read_excel("dataitems.xlsx"))
dataflags = as.data.frame(readxl::read_excel("dataflags.xlsx"))

usethis::use_data(dataitems, dataflags, overwrite = TRUE, internal = TRUE)
