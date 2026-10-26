\name{read_submission}
\alias{read_submission}
\title{read submission}
\description{Embryo workflow helper. Local checks do not confirm official scoring.}
\usage{read_submission(path, reader = "R")}
\arguments{
\item{path}{Input or output h5ad path.}
\item{reader}{zellkonverter reader backend.}
}
\value{A SingleCellExperiment.}
