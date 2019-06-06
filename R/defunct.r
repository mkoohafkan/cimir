#' @title Defunct functions in package \pkg{cimir}.
#' @description The functions listed below were deprecated in the previous 
#'   release and are now defunct. Alternative functions with similar
#'   functionality are mentioned. Help pages for defunct functions are
#'   available at \code{help("cimir-defunct")}.
#' @name cimir-defunct
#' @keywords internal
NULL

#' @rdname cimir-defunct
#' @section \code{get_data}:
#' For \code{get_data}, use \code{\link{cimis_data}}.
#'
#' @export
get_data = function(targets, start.date, end.date, items,
  measure.unit = c("E", "M"), prioritize.SCS = TRUE) {
  .Defunct("cimis_data")
  cimis_data(targets, start.date, end.date, items,
  measure.unit, prioritize.SCS)
}

#' @rdname cimir-defunct
#' @section \code{get_station}:
#' For \code{get_station}, use \code{\link{cimis_station}}.
#'
#' @export
get_station = function(station) {
  .Defunct("cimis_station")
  cimis_station(station)
}

#' @rdname cimir-defunct
#' @section \code{get_station_spatial_zipcode}:
#' For \code{get_station_spatial_zipcode}, use \code{\link{cimis_spatial_zipcode}}.
#'
#' @export
get_station_spatial_zipcode = function(zipcode) {
  .Defunct("cimis_spatial_zipcode")
  cimis_spatial_zipcode(zipcode)
}

#' @rdname cimir-defunct
#' @section \code{get_station_zipcode}:
#' For \code{get_station_zipcode}, use \code{\link{cimis_zipcode}}.
#'
#' @export
get_station_zipcode = function(zipcode) {
  .Defunct("cimis_zipcode")
  cimis_zipcode(zipcode)
}


#' @rdname cimir-defunct
#' @section \code{to_datetime}:
#' For \code{to_datetime}, use \code{\link{cimis_to_datetime}}.
#'
#' @export
to_datetime = function(d) {
  .Defunct("cimis_to_datetime")
  cimis_to_datetime(d)
}

#' @rdname cimir-defunct
#' @section \code{data_items}:
#' For \code{data_items}, use \code{\link{cimis_items}}.
#'
#' @export
data_items = function(type = c("Daily", "Hourly")) {
  .Defunct("cimis_items")
  cimis_items(type)
}
