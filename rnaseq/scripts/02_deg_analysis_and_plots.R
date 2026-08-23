# Load required libraries
library(DESeq2)
library(ggplot2)
library(pheatmap)
library(umap)
library(EnhancedVolcano)

print("Loading data...")
counts <- read.csv("../data/raw/TCGA_LUAD_raw_counts.csv", row.names=1, check.names=FALSE)
meta <- read.csv("../data/raw/TCGA_LUAD_metadata.csv", row.names=1, check.names=FALSE)

# Clean up the condition column
meta$condition <- as.factor(ifelse(grepl("Normal", meta$sample_type), "Normal", "Tumor"))

print("Aligning counts and metadata...")
# 1. Find only the samples that exist in BOTH files
common_samples <- intersect(colnames(counts), rownames(meta))

# 2. Subset both tables to those exact samples, forcing them into identical order
counts <- counts[, common_samples]
meta <- meta[common_samples, ]

# 3. Force counts to be an integer matrix (removes any hidden data frame formatting)
counts <- as.matrix(counts)
mode(counts) <- "integer"

print("Building DESeq2 object and filtering low counts...")
dds <- DESeqDataSetFromMatrix(countData = counts, colData = meta, design = ~ condition)

# Filter: Keep genes with at least 10 counts across at least 10 samples
keep <- rowSums(counts(dds) >= 10) >= 10
dds <- dds[keep,]

print("Running DESeq2 (This may take 10-20 minutes for TCGA data)...")
dds <- DESeq(dds)
res <- results(dds, contrast=c("condition", "Tumor", "Normal"))

# Save processed DEG table
write.csv(as.data.frame(res), "../data/processed/DEG_results.csv")

print("Transforming data for visualization...")
vsd <- vst(dds, blind=FALSE)
vsd_mat <- assay(vsd)

print("Generating PCA Plot...")
pca_plot <- plotPCA(vsd, intgroup="condition") + 
  theme_minimal() + 
  ggtitle("PCA of TCGA LUAD (Tumor vs Normal)")
ggsave("../results/PCA_plot.pdf", plot=pca_plot, width=7, height=5)

print("Generating UMAP Plot...")
set.seed(42)
umap_results <- umap(t(vsd_mat))
umap_df <- data.frame(UMAP1 = umap_results$layout[,1], 
                      UMAP2 = umap_results$layout[,2], 
                      Condition = meta$condition)
umap_plot <- ggplot(umap_df, aes(x=UMAP1, y=UMAP2, color=Condition)) +
  geom_point(alpha=0.7, size=2) + theme_minimal() + ggtitle("UMAP of TCGA LUAD")
ggsave("../results/UMAP_plot.pdf", plot=umap_plot, width=7, height=5)

print("Generating Volcano Plot...")
volcano <- EnhancedVolcano(res, lab = rownames(res), x = 'log2FoldChange', y = 'pvalue',
                           title = 'Tumor vs Normal', pCutoff = 1e-05, FCcutoff = 1.5,
                           pointSize = 1.5, labSize = 3)
ggsave("../results/Volcano_plot.pdf", plot=volcano, width=8, height=8)

print("Generating Heatmap of Top 50 DEGs...")
top_genes <- head(order(res$padj), 50)
pdf("../results/Heatmap_top50.pdf", width=8, height=10)
pheatmap(vsd_mat[top_genes, ], scale="row", show_colnames=FALSE, 
         annotation_col=data.frame(Condition=meta$condition, row.names=rownames(meta)),
         main="Top 50 Differentially Expressed Genes")
dev.off()

print("Analysis complete! All plots saved to rnaseq/results/")