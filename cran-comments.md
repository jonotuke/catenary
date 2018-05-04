## 2015-11-18
Made edits so ready for new version of ggplot2

Added importsFrom to Roxygen so adds

importFrom("methods", "callNextMethod", "slot")
importFrom("stats", "lm", "nls", "optim", "predict", "quantile",
             "resid", "uniroot")

to NAMESPACE

## 2018-05-04

Correct fitCatEndPt function so do not get "if() with conditions of length greater than one" warning.