

#' @importFrom RCurl getCurlHandle
.onLoad = function(libname, pkgname) {
  # set up environment for authentication storage
  authenv = new.env(parent = getNamespace(pkgname))
  assign("authenv", authenv, envir = getNamespace(pkgname))
  assign("handle", getCurlHandle(), envir = authenv)
}

.onAttach = function(libname, pkgname) {
  # check for existing AppKey
  if (!is.null(options()[["cimisr.appkey"]])) {
    assign("appkey", options()[["cimisr.appkey"]], envir = authenv)
    packageStartupMessage("Using existing CIMIS appkey.")
  } else {
    assign("appkey", character(0), envir = authenv)
  }
}

.onDetach = function(libname) {
  #delete authentication information
  remove_key()
}
