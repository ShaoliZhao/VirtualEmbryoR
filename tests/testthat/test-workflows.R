make_sce <- function() {
  x <- matrix(1:12,3,dimnames=list(c("A","B","C"),paste0("c",1:4)))
  SingleCellExperiment::SingleCellExperiment(assays=list(X=x))
}
test_that("contract rejects panel order, negative values and missing spatial", {
  s <- make_sce();p <- rownames(s)
  expect_true(validate_contract(s,p)$valid)
  expect_false(validate_contract(s,rev(p))$valid)
  expect_false(validate_contract(s,p,"T2")$valid)
  SingleCellExperiment::reducedDim(s,"spatial_3D") <- matrix(0,4,3)
  expect_true(validate_contract(s,p,"T2")$valid)
  SummarizedExperiment::assay(s,"X")[1,1] <- -1
  expect_false(validate_contract(s,p)$valid)
})
test_that("mean shift uses time scaling and preserves residuals", {
  a <- make_sce();b <- a;SummarizedExperiment::assay(b,"X") <- SummarizedExperiment::assay(a,"X")+2
  c <- pseudobulk_shift(a,b,c(8.5,9.5),10.5)
  expect_equal(SummarizedExperiment::assay(c,"X"),SummarizedExperiment::assay(b,"X")+2)
  expect_error(pseudobulk_shift(a,b,c(1,1),2))
})
test_that("h5ad roundtrip when optional bridge is installed", {
  skip_if_not_installed("zellkonverter")
  s <- make_sce();p <- tempfile(fileext=".h5ad")
  env <- Sys.getenv("EMBRYOR_TEST_PYTHON",unset="")
  write_submission(s,p,rownames(s),python_env=if (nzchar(env)) env else NULL);r <- read_submission(p)
  expect_equal(as.matrix(SummarizedExperiment::assay(r,"X")),as.matrix(SummarizedExperiment::assay(s,"X")),ignore_attr=TRUE)
})
