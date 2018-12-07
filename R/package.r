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
#' }
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
  if (!is.null(options()[["cimir.appkey"]])) {
    assign("appkey", options()[["cimir.appkey"]], envir = authenv)
    packageStartupMessage("Using existing CIMIS appkey.")
  } else {
    assign("appkey", character(0), envir = authenv)
  }
}

.onDetach = function(libname) {
  #delete authentication information
  remove_key()
}
