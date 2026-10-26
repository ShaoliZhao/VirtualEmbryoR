\name{write_submission}
\alias{write_submission}
\title{write submission}
\description{Embryo workflow helper. Local checks do not confirm official scoring.}
\usage{write_submission(sce, path, panel, task = "T1", assay_name = "X", python_env = NULL, ...)}
\arguments{
\item{python_env}{Optional existing Python executable with anndata for direct zellkonverter conversion.}
\item{path}{Input or output h5ad path.}
\item{sce}{A SingleCellExperiment with genes by cells.}
\item{panel}{Unique ordered gene symbols.}
\item{task}{Challenge task ID.}
\item{assay_name}{Expression assay name; scale is preserved.}
\item{...}{Additional local contract checks.}
}
\value{The output path invisibly.}
