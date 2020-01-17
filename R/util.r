cimis.tz = "Etc/GMT+8"

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
      format = "%Y-%m-%d %H%M", tz = cimis.tz)),
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
  ), cols = c(Data))
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
    Records = map(.data$Records, record_to_df)),
    cols = c(.data$Records)), Value = as.numeric(.data$Value))
}

#' Split CIMIS Query
#'
#' Split a large CIMIS query into multiple smaller queries based on a 
#' time interval.
#'
#' @inheritParams cimis_data
#' @param max.records The maximum number of records returned by a query. 
#'   The default value is the the maximum data limit allowed by the 
#'   CIMIS Web API (1,750 records).
#' @return A data frame with columns "targets", "start.date", "end.date", and
#'   "items". 
#'
#' @details Queries are not split by `targets` or `items`, i.e. each resulting
#'   query will include all targets and items. 
#'
#' @examples
#' cimis_split_query(170, "2000-01-01", "2010-12-31", "day-air-tmp-avg")
#' cimis_split_query(c(149, 170), "2018-01-01", "2018-12-31", 
#'   c("day-air-tmp-avg", "hly-air-tmp", "hly-rel-hum"))
#'
#' @importFrom dplyr tibble n mutate bind_rows
#' @export
cimis_split_query = function(targets, start.date, end.date, items, max.records = 1750L) {
  hourly.items = intersect(items, cimis_items("Hourly")[["Data Item"]])
  daily.items = intersect(items, cimis_items("Daily")[["Data Item"]])
  if (length(hourly.items) > 0L) {
    hourly.ranges = mutate(date_seq(start.date, end.date, max.records,
      24 * length(targets) * length(hourly.items)),
      items = rep(list(hourly.items), n()))
  } else {
    hourly.ranges = NULL
  }
  if (length(daily.items) > 0L) {
    daily.ranges = mutate(date_seq(start.date, end.date, max.records,
      length(targets) * length(daily.items)),
      items = rep(list(daily.items), n()))
  } else {
    daily.ranges = NULL
  }
  mutate(bind_rows(daily.ranges, hourly.ranges),
    targets = rep(list(targets), n()))
}

#' @importFrom dplyr tibble
#' @importFrom utils head tail
#' @keywords internal
date_seq = function(start.date, end.date, max.length, multiplier) {
  start.date = as.Date(start.date)
  end.date = as.Date(end.date)
  num.records = as.numeric(end.date - start.date) * multiplier
  if (num.records < max.length) {
    tibble(start.date = start.date, end.date = end.date)
  } else {
    num.queries = as.integer(ceiling(num.records / max.length))
    seq.start = seq(start.date, end.date, length.out = num.queries + 1)
    starts = head(seq.start, -1)
    ends = c(head(tail(seq.start, -1), -1) - 1, tail(seq.start, 1))
    tibble(start.date = starts, end.date = ends)
  }
}


#' Compass Direction To Degrees
#'
#' Convert the Compass direction labels to degrees.
#'
#' @param x A vector of compass directions, i.e. the data item labels
#'  "DayWindNnw", "DayWindSse", etc. Recognized directions are 
#'   North-northeast (NNE), East-northeast (ENE), East-southeast (ESE),
#'   South-southeast (SSE), South-southwest (SSW), West-southwest (WSW),
#'   West-northwest (WNW), and North-northwest (NNW).
#'
#' @return A numeric vector of degrees corresponding to the middle azimuth
#'   of the corresponding compass direction.
#'
#' @examples
#' cimis_compass_to_degrees("day-wind-nne")
#' cimis_compass_to_degrees(c("SSE", "SSW", "wsw", "Wnw", "nnw"))
#'
#' @seealso [cimis_degrees_to_compass()]
#'
#' @importFrom dplyr case_when
#' @importFrom stringr str_to_upper str_detect
#' @export
cimis_compass_to_degrees = function(x) {
  x = str_to_upper(x)
  res = case_when(
    str_detect(x, "NNE$") ~ 22.5,
    str_detect(x, "ENE$") ~ 67.5,
    str_detect(x, "ESE$") ~ 112.5,
    str_detect(x, "SSE$") ~ 157.5,
    str_detect(x, "SSW$") ~ 202.5,
    str_detect(x, "WSW$") ~ 247.5,
    str_detect(x, "WNW$") ~ 292.5,
    str_detect(x, "NNW$") ~ 337.5,
    TRUE ~ NA_real_
  )
  if (any(is.na(res)))
    stop('Unrecognized values in arugment "x".')
  res
}

#' Degrees to Compass Direction
#'
#' Convert decimal degrees to Compass direction.
#'
#' @param x A vector of directions in decimal degrees.
#' @return A factor vector of compass directions.
#'
#' @details Degrees are labeled with their corresponding 
#'   Primary InterCardinal compass direction, following the
#'   convention of the CIMIS daily wind data items.
#' 
#' @examples
#' cimis_degrees_to_compass(c(30, 83, 120, 140, 190, 240, 300, 330))
#' cimis_degrees_to_compass(cimis_compass_to_degrees(c("NNE", "ENE", "ESE", 
#'   "SSE", "SSW", "WSW", "WNW", "NNW")))
#'
#' @seealso [cimis_compass_to_degrees()]
#' @export
cimis_degrees_to_compass = function(x) {
  breaks = c(0, 45, 90, 135, 180, 225, 270, 315, 360)
  labels = c("NNE", "ENE", "ESE", "SSE", "SSW", "WSW", "WNW", "NNW")
  cut(x, breaks, labels, include.lowest = TRUE)
}


#' Format CIMIS Station Location
#'
#' Format the latitude and longitude of station in
#'   Decimal Degrees (DD) or Hour Minutes Seconds (HMS).
#'
#' @inheritParams cimis_to_datetime 
#' @param format The format to use, either Decimal Degrees (`"DD"`)
#'   or Hour Minutes Seconds (`"HMS"`).
#'
#' @return The data frame, with a new `"Latitude"` and `"Longitude"` 
#'   columns replacing the `"HmsLatitude"` and `"HmsLongitude"` 
#'   columns.
#'
#' @examples
#' if(is_key_set()) {
#'   d = cimis_station(170)
#'   cimis_format_location(d, "DD")
#'   cimis_format_location(d, "HMS")
#' } 
#'
#' @importFrom dplyr mutate_at rename
#' @importFrom stringr str_split str_replace
#' @export
cimis_format_location = function(d, format = c("DD", "HMS")) {
  format = match.arg(str_to_upper(format), c("DD", "HMS"))
  if (format == "HMS") {
    fun = function(x)
      str_replace(str_split(x, " / ", simplify = TRUE)[, 1], "^-", "")
    } else {
      fun = function(x)
        as.numeric(str_split(x, " / ", simplify = TRUE)[, 2])
      }
  rename(
    mutate_at(d, c("HmsLatitude", "HmsLongitude"), fun),
    Latitude = .data$HmsLatitude, Longitude = .data$HmsLongitude
  )
}
