#' Specify CIMIS API key
#'
#' Enter your CIMIS AppKey for web API data access.
#'
#' @param key A CIMIS AppKey.
#'
#' @export
set_key = function(key) {
  assign("appkey", key, envir = authenv)
  invisible(TRUE)
}

#' Remove CIMIS API key
#'
#' Remove existing CIMIS AppKey for web API data access.
#'
#' @export
remove_key = function() {
  assign("appkey", character(0), envir = authenv)
  invisible(TRUE)
}
