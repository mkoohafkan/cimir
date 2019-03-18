Submission of cimir 0.2-0. 

This release includes the following changes:

- HTTPS is now used to access the CIMIS web API.
- The URL formatting has bee updated to reflect a change in
  how the CIMIS web API formats the prioritizeSCS argument.
- Function names have been updated to follow best 
  (or at least better) practices for avoiding
  naming conflicts and improving clarity. Old function names
  have been soft-deprecated.
- The quickstart vignette has been updated to use the new function
  names.

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
