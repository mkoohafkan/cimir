Submission of cimir 0.4-0.

# cimir 0.4-0

This release includes the following changes:

- References to defunct functions were removed.
- New function `cimis_flags()` provides information on CIMIS data 
  quality control flags.
- Fixed a bug in function `cimis_to_datetime()` regarding timezone 
  specification.
- Fixed a bug in function `cimis_split_query` where sub-queries 
  sometimes exceeded the specified length.
- Added a new vignette describing helper functions.

## Test environments

* Local Windows 10 install, R 3.6.0
* Ubuntu 14.04 (on travis-ci), R-oldrel, R-release, R-devel

Because the CIMIS Web API requires an App Key, examples are only
run on build if the App Key is defined. In my test environments, 
I created the environment variable CIMIS_APPKEY with my personal 
key to run the examples on build.

## R CMD check results

0 ERRORs | 0 WARNINGs | 0 NOTES

Sometimes a NOTE is returned stating that one or more of the URLS
in the DESCRIPTION cannot be reached. This seems to be a problem
with the CIMIS server, not the package itself. The error is not
usually reproduced on recheck. Please advise on how to skip checking
of the URLs in the DESCRIPTION if this is an issue.
