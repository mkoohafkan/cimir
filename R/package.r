#' cimir: R Interface to CIMIS
#'
#' This package provides an R interface to the 
#' [California Irrigation Management Information System](https://cimis.water.ca.gov/)
#' (CIMIS) [Web API](http://et.water.ca.gov/Home/Index). In order to use 
#' this package, you will need to 
#' [create a CIMIS account](https://cimis.water.ca.gov/Auth/Register.aspx) 
#' and request a web services AppKey. 
#'
#' @section Package options:
#'
#' cimir uses the following [options()] to configure behavior:
#'
#' \itemize{
#'   \item `cimir.appkey`: The CIMIS AppKey to use for queries.
#'   \item `cimir.timeout`: The maximum time to wait for a response 
#'     from the CIMIS Web API.
#' }
#' Alternatively, the CIMIS App Key can be saved to an environment
#' variable `CIMIS_APPKEY`.
#'
#' @docType package
#' @name cimir
"_PACKAGE"



#' @importFrom RCurl getCurlHandle
.onLoad = function(libname, pkgname) {
  # set up environment for authentication storage
  authenv = new.env(parent = getNamespace(pkgname))
  assign("authenv", authenv, envir = getNamespace(pkgname))
  assign("handle", getCurlHandle(), envir = authenv)
}

.onAttach = function(libname, pkgname) {
  # check for existing AppKey
  if (!is.null(options()[["cimir.appkey"]]) &&
      nchar(options()[["cimir.appkey"]]) > 0L) {
    set_key(options()[["cimir.appkey"]])
    packageStartupMessage("Using existing App Key from ",
      'option "cimir.appkey".')
  } else if (nchar(Sys.getenv("CIMIS_APPKEY")) > 0L) {
    set_key(Sys.getenv("CIMIS_APPKEY"))
    packageStartupMessage("Using existing App Key from ",
      '"CIMIS_APPKEY" environment variable.')
  } else {
    remove_key()
  }
  if (is.null(options()[["cimir.timeout"]])) {
    options(cimir.timeout = 30)
  }
}

.onDetach = function(libname) {
  #delete authentication information
  remove_key()
}
