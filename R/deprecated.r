#' @title Deprecated functions in package \pkg{cimir}.
#' @description The functions listed below are deprecated and will be defunct in
#'   the near future. When possible, alternative functions with similar
#'   functionality are also mentioned. Help pages for deprecated functions are
#'   available at \code{help("-deprecated")}.
#' @name cimir-deprecated
#' @keywords internal
NULL

#' @rdname cimir-deprecated
#' @section \code{get_data}:
#' For \code{get_data}, use \code{\link{cimis_data}}.
#'
#' @export
get_data = function(targets, start.date, end.date, items,
  measure.unit = c("E", "M"), prioritize.SCS = TRUE) {
  .Deprecated("cimis_data")
  cimis_data(targets, start.date, end.date, items,
  measure.unit, prioritize.SCS)
}

#' @rdname cimir-deprecated
#' @section \code{get_station}:
#' For \code{get_station}, use \code{\link{cimis_station}}.
#'
#' @export
get_station = function(station) {
  warning('Function "get_station" is deprecated. ',
    'Use "cimis_station" instead.', call. = FALSE)
  cimis_station(station)
}

#' @rdname cimir-deprecated
#' @section \code{get_station_spatial_zipcode}:
#' For \code{get_station_spatial_zipcode}, use \code{\link{cimis_spatial_zipcode}}.
#'
#' @export
get_station_spatial_zipcode = function(zipcode) {
  .Deprecated("cimis_spatial_zipcode")
  cimis_spatial_zipcode(zipcode)
}

#' @rdname cimir-deprecated
#' @section \code{get_station_zipcode}:
#' For \code{get_station_zipcode}, use \code{\link{cimis_zipcode}}.
#'
#' @export
get_station_zipcode = function(zipcode) {
  .Deprecated("cimis_zipcode")
  cimis_zipcode(zipcode)
}


#' @rdname cimir-deprecated
#' @section \code{to_datetime}:
#' For \code{to_datetime}, use \code{\link{cimis_to_datetime}}.
#'
#' @export
to_datetime = function(d) {
  .Deprecated("cimis_to_datetime")
  cimis_to_datetime(d)
}

#' @rdname cimir-deprecated
#' @section \code{data_items}:
#' For \code{data_items}, use \code{\link{cimis_items}}.
#'
#' @export
data_items = function(type = c("Daily", "Hourly")) {
  .Deprecated("cimis_items")
  cimis_items(type)
}
