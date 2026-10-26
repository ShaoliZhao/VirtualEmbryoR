# Executed validation — 2026-10-11

R 4.4.0; SingleCellExperiment and zellkonverter 1.14.1. `R CMD build` generated both vignettes; `R CMD check --no-manual` finished **Status: OK**, with no check errors/warnings/notes. Network index access messages occurred during dependency inspection, but installed dependency checks and full checks passed.

Ten test assertions passed: panel order, missing/valid spatial coordinates, negative expression, time scaling, invalid times, h5ad write/read roundtrip, exact 498-gene embryo panel and official minimum count. The writer used an existing Python 3.9 environment with anndata 0.10.9 via zellkonverter conversion, and the roundtrip used the native R reader. The default basilisk-managed writer was not separately provisioned/tested. All public panels were fetched and match the official newline-joined gene-hash prefixes (distinct from raw file-byte hashes).

CI configuration is provided but no remote GitHub CI run has occurred. This is local contract validation; no challenge submission or official scoring was performed. DESCRIPTION has an explicit placeholder maintainer address to replace before publication.
