#' CIMIS Data Items
#'
#' List CIMIS data items.
#'
#' @param type The type of data item, i.e. `"Daily"` or `"Hourly"`.
#' @return a dataframe of data items.
#'
#' @examples
#' data_items()
#'
#' @importFrom stringr str_to_title
#' @importFrom dplyr filter
#' @export
data_items = function(type = c("Daily", "Hourly")) {
  type = match.arg(str_to_title(type), c("Daily", "Hourly"), TRUE)
  filter(dataitems, .data$Class %in% type)
}

# Default CIMIS query items
default.items = c("day-asce-eto", "day-precip", "day-sol-rad-avg",
  "day-vap-pres-avg", "day-air-tmp-max", "day-air-tmp-min",
  "day-air-tmp-avg", "day-rel-hum-max", "day-rel-hum-min",
  "day-rel-hum-avg", "day-dew-pnt", "day-wind-spd-avg",
  "day-wind-run", "day-soil-tmp-avg")

#' Get CIMIS Data
#'
#' Query CIMIS data using the Web API.
#'
#' @param targets geographies or weather stations of interest. This 
#'   parameter may specify one or many stations, zip codes, 
#'   coordinates, or street addresses; however, you are not allowed to 
#'   mix values from different categories. This means the targets 
#'   parameter must contain only stations, only zip codes, only 
#'   coordinates, or only street addresses. You will receive an error 
#'   if you attempt to mix different category types. The formats are
#'   accepted:
#'   - A comma delimited list of WSN station numbers
#'   - A comma delimited list of California zip codes
#'   - A semicolon delimited list of decimal - degree coordinates
#'   - A semicolon delimited list of street addresses
#' @param items specifies one or more comma-delimited data elements to 
#'   include in your response. See `data_items()` for a complete list 
#'   of possible data element values. Default: day-asce-eto, 
#'   day-precip, day-sol-rad-avg, day-vap-pres-avg, day-air-tmp-max, 
#'   day-air-tmp-min, day-air-tmp-avg, day-rel-hum-max, 
#'   day-rel-hum-min, day-rel-hum-avg, day-dew-pnt, day-wind-spd-avg, 
#'   day-wind-run, day-soil-tmp-avg.
#' @param start.date Specifies the start date. The data format is 
#'   `"yyyy-mm-dd"`. 
#' @param end.date Specifies the end date. The data format is 
#'   `"yyyy-mm-dd"`.
#' @param measure.unit The unit of measure may be either `"E"` for 
#'   English units or `"M"` for metric units. The value of this 
#'   parameter will affect data values in the response. For 
#'   example, designating English units will result in temperature 
#'   values being returned in Fahrenheit rather than Celsius.
#' @param prioritize.SCS This parameter is relevant only when the 
#'   targets parameter contains zip code(s). If `TRUE`, the Spatial
#'   CIMIS System (SCS) will be used as the preferred data provider.
#' @return A `tibble` object.
#'
#' @examples
#' if(is_key_set()) {
#'   get_data(targets = 170, start.date = Sys.Date() - 4, 
#'     end.date = Sys.Date() - 1)
#' } 
#'
#' @importFrom glue glue
#' @importFrom stringr str_c str_to_upper
#' @export
get_data = function(targets, start.date, end.date, items,
  measure.unit = c("E", "M"), prioritize.SCS = TRUE) {
  if (any(is.na(suppressWarnings(as.numeric(targets))))) {
    target.sep = ";"
  } else {
    target.sep = ","
  }
  if (missing(items))
    items = default.items 
  measure.unit = match.arg(str_to_upper(measure.unit), c("E", "M"), FALSE)
  prioritize.SCS = ifelse(prioritize.SCS, "Y", "N")
  start.date = as.Date(start.date)
  end.date = as.Date(end.date)
  # query
  result = basic_query(
    glue("http://et.water.ca.gov/api/data?",
      "appKey={authenv$appkey}", "&",
      "targets={str_c(targets, collapse = target.sep)}", "&",
      "startDate={start.date}", "&",
      "endDate={end.date}", "&",
      "dataItems={str_c(items, collapse = ',')}", "&",
      "unitOfMeasure={measure.unit}", ";",
      "prioritizeSCS={prioritize.SCS}"
    )
  )
  bind_records(result)
}

#' Get CIMIS Station Data
#'
#' Get CIMIS station metadata.
#'
#' @param station The station ID. If missing, metadata for all stations
#'   is returned.
#' @return A `tibble` object.
#'
#' @examples
#' if(is_key_set()) {
#'   get_station()
#'   get_station_zipcode()
#'   get_station_spatial_zipcode()
#' } 
#' @importFrom purrr map map_dfr
#' @importFrom glue glue
#' @importFrom dplyr as_tibble bind_rows
#' @export
get_station = function(station) {
  if (missing(station)) {
    url = "http://et.water.ca.gov/api/station"
  } else {
    url = glue("http://et.water.ca.gov/api/station/{station}")
  }
  result = map(url, basic_query)
  map_dfr(result, function(s) map_dfr(s$Stations, as_tibble))
}

#' @rdname get_station
#'
#' @param zipcode The (spatial) zip code. If missing, metadata for all 
#'   stations is returned.
#'
#' @importFrom purrr map_dfr
#' @importFrom glue glue
#' @importFrom dplyr as_tibble bind_rows
#' @export
get_station_spatial_zipcode = function(zipcode) {
  if (missing(zipcode)) {
    url = "http://et.water.ca.gov/api/spatialzipcode"
  } else {
    url = glue("http://et.water.ca.gov/api/spatialzipcode/{zipcode}")
  }
  result = map(url, basic_query)
  map_dfr(result, function(s) map_dfr(s$ZipCodes, as_tibble))
}

#' @rdname get_station
#'
#' @importFrom purrr map_dfr
#' @importFrom glue glue
#' @importFrom dplyr as_tibble bind_rows
#' @export
get_station_zipcode = function(zipcode) {
  if (missing(zipcode)) {
    url = "http://et.water.ca.gov/api/stationzipcode"
  } else {
    url = glue("http://et.water.ca.gov/api/stationzipcode/{zipcode}")
  }
  result = map(url, basic_query)
  map_dfr(result, function(s) map_dfr(s$ZipCodes, as_tibble))
}


#' Basic Query
#'
#' Helper function for CIMIS query handling.
#'
#' @param url The query URL.
#' @return The parsed JSON string, as a list.
#'
#' @importFrom RCurl getURL basicHeaderGatherer basicTextGatherer curlOptions
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_replace_all
#' @keywords internal
basic_query = function(url) {
  if (length(authenv$appkey) < 1)
    stop('No API key available. Specify key with "set_key()".')
  header = basicHeaderGatherer()
  content = basicTextGatherer()
  opts = curlOptions(connecttimeout = options()[["cimir.timeout"]])
  getURL(url, httpheader = c(Accept = "application/json"),
    header = FALSE, headerfunction = header$update,
    write = content$update, curl = authenv$handle,
    .opts = opts)

  if (header$value()[['status']] != "200")
    stop("CIMIS query failed. HTTP status ",
      header$value()[["status"]], ": ",
      header$value()[["statusMessage"]], "\n",
      parse(text = content$value()), call. = FALSE)

  fromJSON(str_replace_all(content$value(), ":null", ':[null]'),
    simplifyDataFrame = FALSE)
}