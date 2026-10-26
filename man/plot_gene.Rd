\name{plot_gene}
\alias{plot_gene}
\title{plot gene}
\description{Embryo workflow helper. Local checks do not confirm official scoring.}
\usage{plot_gene(sce, gene, assay_name = "X")}
\arguments{
\item{sce}{A SingleCellExperiment with genes by cells.}
\item{assay_name}{Expression assay name; scale is preserved.}
\item{gene}{Gene symbol to plot.}
}
\value{A ggplot object.}
