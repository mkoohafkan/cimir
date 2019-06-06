#' To Datetime
#'
#' Collapse The Date and Hour columns to a single DateTime Column.
#'
#' @param d A data frame of CIMIS data results.
#' @return The data frame, with a new `"Datetime"` column replacing
#'   the `"Date"` and `"Hour"` columns.
#'
#' @details According to the 
#'   [CIMIS Report FAQs](https://cimis.water.ca.gov/Default.aspx),
#'   all CIMIS data is based on Pacific Standard Time (PST).
#'
#' @examples
#' if(is_key_set()) {
#'   d = cimis_data(targets = 170, start.date = Sys.Date() - 4, 
#'     end.date = Sys.Date() - 1, items = "hly-air-tmp")
#'   cimis_to_datetime(d)
#' } 
#' @importFrom dplyr select mutate if_else rename
#' @importFrom stringr str_c
#' @export
cimis_to_datetime = function(d) {
  if (!("Hour" %in% names(d)))
    d = mutate(d, Hour = "0000")
  rename(select(mutate(d,
    Hour = if_else(is.na(.data$Hour), "0000", .data$Hour),
    Date = as.POSIXct(str_c(.data$Date, " ", .data$Hour),
      format = "%Y-%m-%d %H%M"), tz = "Etc/GMT+8"),
    -.data$Hour
  ), Datetime = .data$Date)
}


#' Record to Data Frame
#'
#' Convert a single record, containing one or more data items, to a to
#' a single data frame.
#'
#' @param record A single CIMIS record, in list format.
#' @return A data frame. The column `"Item"` identifies the data item.
#'
#' @importFrom tidyr unnest
#' @importFrom dplyr mutate bind_rows setdiff as_tibble
#' @importFrom purrr map
#' @importFrom rlang .data
#' @keywords internal
record_to_df = function(record) {
  fixed = c("Date", "Hour", "Julian", "Station", "Standard", "ZipCodes", "Scope")
  data.names = setdiff(names(record), fixed)
  other.names = setdiff(names(record), data.names)
  unnest(mutate(as_tibble(record[other.names]),
    Date = as.Date(.data$Date),
    Julian = as.integer(.data$Julian),
    Data = list(bind_rows(map(record[data.names], as_tibble),
      .id = "Item"))
  ))
}


#' Bind Records
#'
#' Bind CIMIS records into a single data frame. This function 
#'   is used internally
#'
#' @param result CIMIS query results.
#' @return A data frame.
#'
#' @importFrom tidyr unnest
#' @importFrom purrr map_dfr
#' @importFrom dplyr mutate bind_rows as_tibble case_when
#' @importFrom rlang .data
#' @keywords internal
bind_records = function(result) {
  mutate(unnest(mutate(
    map_dfr(result[[c("Data", "Providers")]], as_tibble),
    Records = map(.data$Records, record_to_df)
  )), Value = as.numeric(.data$Value))
}

#' Split CIMIS Query
#'
#' Split a large CIMIS query into multiple smaller queries based on a 
#' time interval.
#'
#' @inheritParams cimis_data
#' @param num.days The maximum number of days that each query can span.
#' @return A data frame with columns "targets", "start.date", "end.date", and
#'   "items". 
#'
#' @details Queries are not split by `targets` or `items`, i.e. each resulting
#'   query will include all targets and items. 
#'
#' @examples
#' cimis_split_query(170, "2010-01-01", "2018-01-01", "hly-air-tmp", 365)
#'
#' @importFrom dplyr tibble
#' @importFrom utils head tail
#' @export
cimis_split_query = function(targets, start.date, end.date, items, num.days = 365) {
  start.date = as.Date(start.date)
  end.date = as.Date(end.date)
  interval = as.integer(ceiling((end.date - start.date) / num.days))
  daily.seq.start = seq(start.date, end.date, length.out = interval)
  starts = head(daily.seq.start, -1)
  ends = c(head(tail(daily.seq.start, -1), -1) - 1,
    tail(daily.seq.start, 1))

  tibble(
    targets = rep(list(targets), length(starts)),
    items = rep(list(items), length(starts)),
    start.date = starts, end.date = ends
  )
}
