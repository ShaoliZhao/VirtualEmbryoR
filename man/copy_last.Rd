\name{copy_last}
\alias{copy_last}
\title{copy last}
\description{Embryo workflow helper. Local checks do not confirm official scoring.}
\usage{copy_last(sce, panel = rownames(sce))}
\arguments{
\item{sce}{A SingleCellExperiment with genes by cells.}
\item{panel}{Unique ordered gene symbols.}
}
\value{A SingleCellExperiment.}
