library(pheatmap)

# 从命令行参数获取输入文件、最大值和最小值
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
# 生成输出文件名（去除.txt后缀，加上.pdf）
output_file <- sub("\\.txt$", ".pdf", input_file)

# 读取矩阵文件
mymatrix <- read.table(input_file)

# 计算P和L比值
P <- sum(mymatrix[10:12, 10:12])
#print(P)
L <- sum(mymatrix[18:20, 1:3])
#print(L)
ratio <- P/L
ratio_rounded <- round(ratio, 2)  # 四舍五入到小数点后2位
title_text <- paste0("P2LL = ", ratio_rounded)  # 创建标题文本

# 根据是否提供了最大值和最小值来设置breaks
if (length(args) >= 3) {
  min_val <- args[2]
  max_val <- args[3]
  bk <- seq(min_val, max_val, length.out = 101)
  pheatmap(mymatrix, 
           border_color = NA, 
           cluster_rows = FALSE, 
           cluster_cols = FALSE, 
           show_rownames = FALSE,
           color = colorRampPalette(c("#619DB8","#AECDD7","#E3EEEF","#FAE7D9","#F0B79A","#C85D4D"))(100),
           breaks = bk,
           show_colnames = FALSE, 
           cellwidth = 6, 
           cellheight = 6, 
           main = title_text,
           fontsize = 8,
           filename = output_file)  # 使用生成的输出文件名
} else {
  pheatmap(mymatrix, 
           border_color = NA, 
           cluster_rows = FALSE, 
           cluster_cols = FALSE, 
           show_rownames = FALSE,
           show_colnames = FALSE, 
           cellwidth = 6, 
           cellheight = 6, 
           main = title_text,
           fontsize = 8,
           filename = output_file)  # 使用生成的输出文件名
}
