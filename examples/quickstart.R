library(EmbryoR)
library(SingleCellExperiment)
x <- matrix(seq_len(60),nrow=5,dimnames=list(paste0("g",1:5),paste0("c",1:12)))
a <- SingleCellExperiment(assays=list(X=x),colData=S4Vectors::DataFrame(cell_type=rep(c("progenitor","descendant"),6)))
b <- a;SummarizedExperiment::assay(b,"X") <- x+2
prediction <- pseudobulk_shift(a,b,c(8.5,9.5),10.5)
stopifnot(validate_contract(prediction,rownames(a))$valid)
print(plot_composition(prediction))
# With zellkonverter installed: write_submission(prediction,"prediction.h5ad",rownames(a))
