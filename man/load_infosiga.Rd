% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load_infosiga.R
\name{load_infosiga}
\alias{load_infosiga}
\title{Load data from Infosiga.SP}
\usage{
load_infosiga(
  type = c("sinistros", "vitimas", "veiculos"),
  raw = FALSE,
  use_cache = TRUE
)
}
\arguments{
\item{type}{One of \code{"sinistros"}, \code{"vitimas"}, or \code{"veiculos"}. Determines
which dataset to load.}

\item{raw}{Logical. If TRUE, loads the raw version of the dataset.}

\item{use_cache}{Logical. If TRUE (default), uses a cached version
if available.}
}
\value{
A \code{tibble} with the selected dataset.
}
\description{
Downloads and loads a \code{.parquet} dataset (sinistros, vítimas ou veículos).
}
\examples{
\dontrun{
df <- load_infosiga("sinistros")
}

}
