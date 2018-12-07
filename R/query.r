#' CIMIS Data Items
#'
#' List CIMIS data items.
#'
#' @param type The type of data item, i.e. `"Daily"` or `"Hourly"`.
#' @return a dataframe of data items.
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
#' @importFrom RCurl getURL basicHeaderGatherer basicTextGatherer
#' @importFrom glue glue
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_c str_to_upper
#' @export
get_data = function(targets, start.date, end.date, items,
  measure.unit = c("E", "M"), prioritize.SCS = TRUE) {
  if (length(authenv$appkey) < 1)
    stop('No API key available. Specify key with"set_key()"')
  if (missing(items))
    items = default.items 
  measure.unit = match.arg(str_to_upper(measure.unit), c("E", "M"), FALSE)
  prioritize.SCS = ifelse(prioritize.SCS, "Y", "N")
  start.date = as.Date(start.date)
  end.date = as.Date(end.date)
  # query
  header = basicHeaderGatherer()
  content = basicTextGatherer()
  getURL(
    glue("http://et.water.ca.gov/api/data?",
      "appKey={authenv$appkey}", "&",
      "targets={str_c(targets, collapse = ',')}", "&",
      "startDate={start.date}", "&",
      "endDate={end.date}", "&",
      "dataItems={str_c(items, collapse = ',')}", "&",
      "unitOfMeasure={measure.unit}", ";",
      "prioritizeSCS={prioritize.SCS}"
    ),
    httpheader = c(Accept = "application/json"),
    header = FALSE, headerfunction = header$update,
    write = content$update, curl = authenv$handle
  )

  if (header$value()[['status']] != "200")
    stop("CIMIS query failed. HTTP status ",
      header$value()[["status"]], ": ",
      header$value()[["statusMessage"]])
  result = fromJSON(content$value(), simplifyDataFrame = FALSE)
  bind_records(result)
}
