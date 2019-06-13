# cimir 0.4-0

This release includes the following changes:

- References to defunct functions were removed.
- Fixed bug in function `cimis_to_datetime()` regarding timezone 
  specification.
- Fixed bug in function `cimis_split_query()` where sub-queries 
  sometimes exceeded the specified length.
- New function `cimis_flags()` provides information on CIMIS Quality 
  Control flags.
- Added a new vignette describing helper functions.



# cimir 0.3-0 (2019-06-10)

This release includes the following changes:

- **(Breaking change)** Deprecated functions are now defunct.
- Package import "Rcurl" replaced with "curl" (>= 3.3).
- Data items not listed in the CIMIS Web API documentation were 
  identified and added to output of `cimis_items()`.
- Function `cimis_to_datetime()` now explicitly uses Etc/GMT+8 
  timezone to ensure match with standard timezone used by CIMIS (PST).
- New helper function `cimis_split_query()` splits a long-duration 
  query into multiple smaller-duration queries.
- New helper function `cimis_compass_to_degrees()` returns the middle 
  azimuths of a vector of compass direction labels.
- New helper function `cimis_format_location()` formats station 
  latitudes and longitudes as either decimal degrees (numeric) or 
  Hours Minutes Seconds.
- Text encoding of Web API results are set to "UTF-8", fixing potential 
  formatting issues.
- HTTP errors now include the message text provided by CIMIS to 
  describe the issue.

# cimir 0.2-0 (2019-03-14)

This release includes the following changes:

- **(Warning)** Function names have been updated to follow best 
  (or at least better) practices for avoiding
  naming conflicts and improving clarity. Old function names
  have been deprecated.
- HTTPS is now used to access the CIMIS web API.
- The URL formatting has bee updated to reflect a change in
  how the CIMIS web API formats the prioritizeSCS argument.
- The quickstart vignette has been updated to use the new function
  names.

# cimir 0.1-0 (2019-01-04)

This is the first submission of this package to CRAN. 