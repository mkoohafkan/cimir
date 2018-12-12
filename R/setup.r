#' Specify CIMIS API key
#'
#' Enter your CIMIS AppKey for web API data access.
#'
#' @param key A CIMIS AppKey.
#'
#' @examples
#' \dontrun{
#' set_key("YOUR-APP-KEY")
#' is_key_set()
#' remove_key()
#' }
#'
#' @export
set_key = function(key) {
  assign("appkey", key, envir = authenv)
  assign("is_key_set", TRUE, envir = authenv)  
  invisible(TRUE)
}

#' @rdname set_key
#'
#' @export
remove_key = function() {
  assign("appkey", character(0), envir = authenv)
  assign("is_key_set", FALSE, envir = authenv)
  invisible(TRUE)
}

#' @rdname set_key
#'
#' @export
is_key_set = function() {
  get("is_key_set", envir = authenv)
}
