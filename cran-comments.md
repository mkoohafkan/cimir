Submission of cimir 0.4-1.

# cimir 0.4-1

This patch provides better handling of queries
that return empty record sets. Functionality is
otherwise unchanged.

## Test environments


R-CMD-check using GitHub Actions and the following environments:

- {os: macOS-latest,   r: 'devel'}
- {os: macOS-latest,   r: 'release'}
- {os: macOS-latest,   r: 'oldrel'}
- {os: windows-latest, r: 'devel'}
- {os: windows-latest, r: 'release'}
- {os: windows-latest, r: 'oldrel'}
- {os: ubuntu-16.04,   r: 'devel', rspm: "https://packagemanager.rstudio.com/cran/__linux__/xenial/latest", http-user-agent: "R/4.0.0 (ubuntu-16.04) R (4.0.0 x86_64-pc-linux-gnu x86_64 linux-gnu) on GitHub Actions" }
- {os: ubuntu-16.04,   r: 'release', rspm: "https://packagemanager.rstudio.com/cran/__linux__/xenial/latest"}
- {os: ubuntu-16.04,   r: 'oldrel',  rspm: "https://packagemanager.rstudio.com/cran/__linux__/xenial/latest"}

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
