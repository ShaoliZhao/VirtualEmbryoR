\name{validate_contract}
\alias{validate_contract}
\title{validate contract}
\description{Embryo workflow helper. Local checks do not confirm official scoring.}
\usage{validate_contract(sce, panel, task = c("T1", "T2", "T3"),
  min_cells = 1L, max_cells = Inf, assay_name = "X", max_bytes = Inf, path = NULL)}
\arguments{
\item{path}{Input or output h5ad path.}
\item{sce}{A SingleCellExperiment with genes by cells.}
\item{panel}{Unique ordered gene symbols.}
\item{task}{Challenge task ID.}
\item{assay_name}{Expression assay name; scale is preserved.}
\item{min_cells}{Minimum allowed cells.}
\item{max_cells}{Maximum allowed cells.}
\item{max_bytes}{Maximum allowed on-disk bytes.}
}
\value{A local validation report.}
