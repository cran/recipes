% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extension_check.R
\name{recipes_extension_check}
\alias{recipes_extension_check}
\title{Checks that steps have all S3 methods}
\usage{
recipes_extension_check(
  pkg,
  exclude_steps = character(),
  exclude_methods = character()
)
}
\arguments{
\item{pkg}{Character, name of package containing steps to check}

\item{exclude_steps}{Character, name of steps to exclude. This is mostly used
to remove false positives.}

\item{exclude_methods}{Character, which methods to exclude testing for. Can
take the values "prep", "bake", "print", "tidy", and "required_pkgs".}
}
\value{
cli output
}
\description{
This is a developer tool intended to help making sure all methods for each
step have been created.
}
\details{
It is recommended that the following test in placed in packages that add
recipes steps to help keep everything up to date.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{test_that("recipes_extension_check", \{
  expect_snapshot(
    recipes::recipes_extension_check(
      pkg = "pkgname"
    )
  )
\})
}\if{html}{\out{</div>}}
}
\examples{
recipes_extension_check(
  pkg = "recipes"
)

recipes_extension_check(
  pkg = "recipes",
  exclude_steps = "step_testthat_helper",
  exclude_methods = c("required_pkgs")
)
}
\seealso{
\link{developer_functions}
}
