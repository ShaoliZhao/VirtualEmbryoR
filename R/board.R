validate_board <- function(sce, board, contract_dir = system.file("extdata",package="EmbryoR"), ...) {
  index <- jsonlite::fromJSON(file.path(contract_dir,"index.json"),simplifyVector=FALSE)
  spec <- index[[board]]
  if (is.null(spec)) stop("Unknown board")
  panel <- readLines(file.path(contract_dir,spec$genes_file),warn=FALSE)
  if (length(panel)!=spec$n_genes) stop("Corrupt panel length")
  validate_contract(sce,panel,spec$task,min_cells=spec$min_cells,max_cells=spec$max_cells,...)
}
