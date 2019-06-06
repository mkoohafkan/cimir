#' To Datetime
#'
#' Collapse The Date and Hour columns to a single DateTime Column.
#'
#' @param d A data frame of CIMIS data results.
#' @return The data frame, with a new `"Datetime"` column replacing
#'   the `"Date"` and `"Hour"` columns.
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
      format = "%Y-%m-%d %H%M")),
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

#' @keywords internal
split_query = function(targets, start, end, items) {
  d = as.data.frame(expand.grid(target = targets, items = items,
    start = start, end = end))
  d['type'] = case_when(
    d$items %in% cimis_items("Daily")$Item ~ "Daily",
    d$items %in% cimis_items("Hourly")$Item ~ "Hourly",
    TRUE ~ NA_character_)

  interval = as.integer(ceiling((end - start)/365))
  daily.seq.start = seq(start, end, length.out = interval)
  starts = head(daily.seq.start, -1)
  ends = c(head(tail(daily.seq.start, -1), -1) - 1, tail(daily.seq.start, 1))

  cbind(paste(starts), paste(ends))
}
