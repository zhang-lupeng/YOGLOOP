library(pheatmap)
library(RColorBrewer)

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- sub("\\.txt$", ".pdf", input_file)
mymatrix <- read.table(input_file)

bk <- c(seq(0,1,by=0.01))
coul <- colorRampPalette(brewer.pal(9, "OrRd"))(100)
pheatmap(mymatrix,border_color=NA,cluster_rows = FALSE,cluster_cols = FALSE,show_rownames = FALSE,col = coul,breaks = bk,
         show_colnames = FALSE,cellwidth = 2,cellheight = 2,filename = output_file)

if (length(args) >= 3) {
  min_val <- args[2]
  max_val <- args[3]
  bk <- seq(min_val, max_val, length.out = 101)
  coul <- colorRampPalette(brewer.pal(9, "OrRd"))(100)
  pheatmap(mymatrix,border_color=NA,cluster_rows = FALSE,cluster_cols = FALSE,show_rownames = FALSE,col = coul,breaks = bk,
  show_colnames = FALSE,cellwidth = 2,cellheight = 2,filename = output_file)
} else {
  coul <- colorRampPalette(brewer.pal(9, "OrRd"))(100)
  pheatmap(mymatrix,border_color=NA,cluster_rows = FALSE,cluster_cols = FALSE,show_rownames = FALSE,col = coul,
  show_colnames = FALSE,cellwidth = 2,cellheight = 2,filename = output_file)
  }
