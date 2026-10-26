test_that("official board uses exact 498-gene panel and count limits", {
  p <- system.file("extdata",package="EmbryoR")
  panel <- readLines(file.path(p,"T2__embryo__val_interp.genes.txt"))
  s <- SingleCellExperiment::SingleCellExperiment(assays=list(X=matrix(0,length(panel),583,dimnames=list(panel,paste0("c",1:583)))))
  SingleCellExperiment::reducedDim(s,"spatial_3D") <- matrix(0,583,3)
  expect_true(validate_board(s,"T2:embryo:val_interp")$valid)
  expect_false(validate_board(s[,1:582],"T2:embryo:val_interp")$valid)
})
