Submission of cimir 0.3-0.

This release includes the following changes:

- Package import "Rcurl" replaced with "curl" (>= 3.3).
- Data items not listed in the CIMIS Web API documentation were 
  identified and added to output of `cimis_items()`.
- Function `cimis_to_datetime()` now explicitly uses Etc/GMT+8 
  timezone to ensure match with standard timezone used by CIMIS (PST).
- New helper function `cimis_split_query` to split a long-duration query
  into multiple smaller-duration queries.

## Test environments

* Local Windows 10 install, R 3.5.1
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
