Resubmission of cimir 0.1-0. 

- Removed redundant R in title
- Added link to the CIMIS service in the form <http...>

Because the CIMIS Web API requires an App Key, examples are only
run on build if the App Key is defined. In my test environments, 
I created the environment variable CIMIS_APPKEY with my personal 
key to run the examples on build.

## Test environments

* Local Windows 10 install, R 3.5.1
* Ubuntu 14.04 (on travis-ci), R-oldrel, R-release, R-devel

## R CMD check results

0 ERRORs | 0 WARNINGs | 0 NOTES