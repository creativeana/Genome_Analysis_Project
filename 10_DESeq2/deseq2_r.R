library(DESeq2)

# Load input data

counts <- read.delim(
  "counts_matrix.tsv",
  row.names = 1,
  check.names = FALSE
)

metadata <- read.delim(
  "sample_info.tsv",
  row.names = 1
)

# Create DESeq2 dataset

dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = metadata,
  design = ~ condition
)

# Run differential expression analysis

dds <- DESeq(dds)

res <- results(dds)

# Save complete results

write.csv(
  as.data.frame(res),
  "DESeq2_output.csv"
)

# Find the strongest genes

ordered_res <- res[order(res$padj), ]
write.csv(
as.data.frame(head(ordered_res, 50)),
"top50_genes.csv"
)
# Create summary report

sink("DESeq2_summary.txt")

cat("DESeq2 Summary\n\n")

cat("Condition levels:\n")
print(levels(dds$condition))

cat("\n")

summary(res)

sig <- subset(
  as.data.frame(res),
  padj < 0.05
)

cat("\nNumber of significant genes (padj < 0.05):\n")
cat(nrow(sig), "\n")

sink()

# Save significant genes

write.csv(
  sig,
  "significant_genes.csv"
)

# Save normalized counts

norm_counts <- counts(
  dds,
  normalized = TRUE
)

write.csv(
  norm_counts,
  "normalized_counts.csv"
)

# Generate PCA plot

vsd <- vst(dds)

png(
  "PCA_plot.png",
  width = 1200,
  height = 1000
)

plotPCA(
  vsd,
  intgroup = "condition"
)

dev.off()

# Generate count distribution plot

png(
  "count_distribution.png",
  width = 1200,
  height = 1000
)

hist(
  rowMeans(counts(dds)),
  breaks = 100,
  main = "Distribution of Mean Gene Counts",
  xlab = "Mean Counts"
)

dev.off()

# Generate sample distance heatmap

sampleDists <- dist(t(assay(vsd)))

png(
  "sample_distance_heatmap.png",
  width = 1200,
  height = 1000
)

heatmap(
  as.matrix(sampleDists),
  symm = TRUE,
  margins = c(8,8)
)

dev.off()

# Save 20 most significant genes

ordered_res <- res[order(res$padj), ]

write.csv(
  as.data.frame(head(ordered_res, 20)),
  "top20_genes.csv"
)

cat("DESeq2 analysis completed.\n")
