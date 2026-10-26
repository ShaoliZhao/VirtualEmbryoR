\name{pseudobulk_shift}
\alias{pseudobulk_shift}
\title{pseudobulk shift}
\description{Embryo workflow helper. Local checks do not confirm official scoring.}
\usage{pseudobulk_shift(earlier, later, times, target_time, assay_name = "X")}
\arguments{
\item{assay_name}{Expression assay name; scale is preserved.}
\item{earlier}{Earlier-stage SingleCellExperiment.}
\item{later}{Later-stage SingleCellExperiment.}
\item{times}{Two increasing observed stage times.}
\item{target_time}{Prediction time.}
}
\value{A SingleCellExperiment.}
