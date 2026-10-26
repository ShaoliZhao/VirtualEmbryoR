# X is represented by a genes x cells SCE assay; spatial_3D by reducedDim.
read_submission <- function(path, reader = "R") {
  if (!requireNamespace("zellkonverter", quietly = TRUE)) stop("Install zellkonverter")
  zellkonverter::readH5AD(path, reader = reader)
}

validate_contract <- function(sce, panel, task = c("T1", "T2", "T3"),
                              min_cells = 1L, max_cells = Inf,
                              assay_name = "X", max_bytes = Inf, path = NULL) {
  task <- match.arg(task)
  errors <- character()
  add <- function(x) errors <<- c(errors, x)
  if (!methods::is(sce, "SingleCellExperiment")) stop("Expected SingleCellExperiment")
  if (!length(panel) || anyNA(panel) || anyDuplicated(panel) || any(panel == ""))
    stop("Panel must be nonempty, unique and non-missing")
  if (!identical(rownames(sce), as.character(panel))) add("Gene panel or order mismatch")
  if (ncol(sce) < min_cells || ncol(sce) > max_cells) add("Cell count out of range")
  if (anyDuplicated(colnames(sce)) || is.null(colnames(sce))) add("Cell IDs must be unique")
  if (!(assay_name %in% SummarizedExperiment::assayNames(sce))) add("Missing expression assay") else {
    x <- SummarizedExperiment::assay(sce, assay_name)
    for (start in seq.int(1L, max(1L,ncol(x)), by=2048L)) {
      if (ncol(x) == 0) break
      block <- as.matrix(x[,start:min(ncol(x),start+2047L),drop=FALSE])
      if (any(!is.finite(block)) || any(block < 0)) {add("Expression must be finite and nonnegative"); break}
    }
  }
  if (task != "T1") {
    if (!("spatial_3D" %in% SingleCellExperiment::reducedDimNames(sce))) add("Missing spatial_3D") else {
      xyz <- SingleCellExperiment::reducedDim(sce, "spatial_3D")
      if (!identical(dim(xyz), c(ncol(sce),3L)) || any(!is.finite(xyz))) add("Invalid spatial_3D")
    }
  }
  if (!is.null(path) && (!file.exists(path) || file.info(path)$size > max_bytes)) add("File missing or too large")
  list(valid = !length(errors), errors = errors, task = task,
       scope = "Configurable local checks; not an official acceptance or scoring result")
}

copy_last <- function(sce, panel = rownames(sce)) {
  if (!all(panel %in% rownames(sce))) stop("Panel genes missing")
  sce[panel,,drop=FALSE]
}

pseudobulk_shift <- function(earlier, later, times, target_time, assay_name = "X") {
  if (length(times) != 2L || any(!is.finite(c(times,target_time))) || times[2] <= times[1]) stop("Invalid times")
  if (!identical(rownames(earlier),rownames(later))) stop("Align genes before shifting")
  # Baseline extrapolates means on the supplied expression scale, preserves later residuals.
  a <- SummarizedExperiment::assay(earlier,assay_name)
  b <- SummarizedExperiment::assay(later,assay_name)
  shift <- (rowMeans(b)-rowMeans(a))*(target_time-times[2])/(times[2]-times[1])
  out <- later
  shifted <- sweep(as.matrix(b),1,shift,"+")
  shifted[shifted < 0] <- 0
  SummarizedExperiment::assay(out,assay_name) <- shifted
  out
}

write_submission <- function(sce,path,panel,task="T1",assay_name="X",python_env=NULL,...) {
  report <- validate_contract(sce,panel,task,assay_name=assay_name,...)
  if (!report$valid) stop(paste(report$errors,collapse="; "))
  if (!requireNamespace("zellkonverter",quietly=TRUE)) stop("Install zellkonverter")
  if (file.exists(path)) stop("Refusing to overwrite existing output")
  tmp <- tempfile(fileext=".h5ad",tmpdir=dirname(path))
  on.exit(unlink(tmp),add=TRUE)
  if (is.null(python_env)) {
    zellkonverter::writeH5AD(sce,tmp,X_name=assay_name)
  } else {
    if (!requireNamespace("reticulate",quietly=TRUE)) stop("Install reticulate for an existing Python environment")
    reticulate::use_python(python_env,required=TRUE)
    obj <- zellkonverter::SCE2AnnData(sce,X_name=assay_name)
    obj$write_h5ad(tmp)
  }
  roundtrip <- read_submission(tmp)
  check <- validate_contract(roundtrip,panel,task,assay_name="X",path=tmp,...)
  if (!check$valid) stop(paste(check$errors,collapse="; "))
  if (!file.rename(tmp,path)) stop("Could not publish output")
  invisible(path)
}

plot_composition <- function(sce,label="cell_type") {
  if (!(label %in% colnames(SummarizedExperiment::colData(sce)))) stop("Missing label column")
  x <- as.data.frame(table(as.character(SummarizedExperiment::colData(sce)[[label]])))
  names(x) <- c("cell_type","n");x$fraction <- x$n/sum(x$n)
  ggplot2::ggplot(x,ggplot2::aes(x=.data$cell_type,y=.data$fraction)) + ggplot2::geom_col() + ggplot2::coord_flip()
}
plot_gene <- function(sce,gene,assay_name="X") {
  if (!(gene %in% rownames(sce))) stop("Gene not found")
  x <- data.frame(expression=as.numeric(SummarizedExperiment::assay(sce,assay_name)[gene,]))
  ggplot2::ggplot(x,ggplot2::aes(x=.data$expression)) + ggplot2::geom_histogram(bins=30) + ggplot2::labs(title=gene)
}
plot_spatial <- function(sce) {
  xyz <- SingleCellExperiment::reducedDim(sce,"spatial_3D")
  if (ncol(xyz)!=3L) stop("Expected three coordinates")
  x <- data.frame(x=xyz[,1],y=xyz[,2],z=xyz[,3])
  ggplot2::ggplot(x,ggplot2::aes(x=.data$x,y=.data$y,colour=.data$z)) + ggplot2::geom_point(size=.5) + ggplot2::coord_equal() + ggplot2::labs(subtitle="XY projection; colour is Z")
}
