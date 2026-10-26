\name{validate_board}
\alias{validate_board}
\title{validate board}
\description{Embryo workflow helper. Local checks do not confirm official scoring.}
\usage{validate_board(sce, board, contract_dir = system.file("extdata", package = "EmbryoR"), ...)}
\arguments{
\item{sce}{A SingleCellExperiment with genes by cells.}
\item{...}{Additional local contract checks.}
\item{board}{Official board identifier.}
\item{contract_dir}{Folder containing the public index and panels.}
}
\value{A local validation report.}
