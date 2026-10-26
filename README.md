# EmbryoR — embryo submissions in R

A native R/SingleCellExperiment workflow for users who work in Seurat or Bioconductor. Local contracts, temporal pseudobulk baselines, ggplot diagnostics and optional zellkonverter h5ad I/O.

## Install and five-minute quickstart

```r
BiocManager::install(c("SingleCellExperiment", "zellkonverter"))
install.packages(c("ggplot2", "testthat", "remotes"))
remotes::install_local(".")
library(EmbryoR)
source("examples/quickstart.R")
```

```r
sce <- read_submission("E9.5_RNA.h5ad")
panel <- readLines("inst/extdata/T1__val.genes.txt")
pred <- copy_last(sce, panel)
# Supply exact board limits, not the permissive defaults used for synthetic tests.
r <- validate_contract(pred, panel, "T1", min_cells=1000, max_cells=5118)
stopifnot(r$valid)
write_submission(pred, "prediction.h5ad", panel, "T1", min_cells=1000, max_cells=5118)
```

The package preserves the expression scale; it does not silently normalise counts. Real challenge `.X` is log-normalised. SCE assays are genes × cells; AnnData `.X` is cells × genes. `spatial_3D` uses SCE `reducedDim` and AnnData `obsm`. Input `obs["celltype"]` is metadata; official scorers assign their own prediction cell types. Use `plot_composition(sce, label="celltype")` on released data.

## Contracts and limitations / 范围与边界

Panels and `index.json` are public official snapshots, not competition expression data. The embryo interpolation board has **498**, not 500 genes. The default validator cell limits support synthetic examples; use `validate_board` for an official board. `copy_last` preserves the source count: resample explicitly if it exceeds a board cap. Pseudobulk shifting preserves later cells and cannot create new cell types; it is a transparent baseline, not a developmental model. Spatial plots are XY projections coloured by Z. Local validation is not official scoring or server acceptance. File-size limits must be supplied if a server specifies them.

No Python validation package is bundled. Optional h5ad I/O uses zellkonverter (its writer may provision a managed Python environment). Native R functions and synthetic tests work without that bridge. To use an existing environment, set `python_env="/absolute/path/to/python"` in `write_submission`; this path must contain anndata. R ecosystem reach is the intended distinction; no claim of being the first R contribution is made.

Run `Rscript -e 'devtools::test()'` and `R CMD build .; R CMD check --no-manual EmbryoR_0.1.0.tar.gz`. See `reports/VALIDATION.md` for checks actually performed. Before publishing, replace the explicitly placeholder maintainer address in DESCRIPTION with your own.
