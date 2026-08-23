# Load required libraries
library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(ggplot2)
library(ReactomePA)

print("Loading DEG results...")
res <- read.csv("../data/processed/DEG_results.csv")
colnames(res)[1] <- "GeneID" 

# Strip version numbers from Ensembl IDs
res$GeneID <- gsub("\\..*", "", res$GeneID)

print("Filtering for significant genes (padj < 0.05 & |log2FC| > 1)...")
sig_genes <- subset(res, padj < 0.05 & abs(log2FoldChange) > 1)

print("Translating Ensembl IDs to Entrez IDs...")
# The ~30% mapping failure warning here is expected and safe to ignore
gene_map <- bitr(sig_genes$GeneID, fromType="ENSEMBL", toType=c("ENTREZID", "SYMBOL"), OrgDb="org.Hs.eg.db")

print("Running Gene Ontology (GO) Enrichment...")
go_results <- enrichGO(gene = gene_map$ENTREZID,
                       OrgDb = org.Hs.eg.db,
                       ont = "BP", 
                       pAdjustMethod = "BH",
                       pvalueCutoff = 0.05,
                       qvalueCutoff = 0.05,
                       readable = TRUE) 

print("Generating GO Dotplot...")
go_plot <- dotplot(go_results, showCategory=15) + ggtitle("GO Pathway Enrichment (Biological Process)")
ggsave("../results/GO_enrichment_dotplot.pdf", plot=go_plot, width=8, height=6)

print("Running Reactome Pathway Enrichment (Local Database)...")
reactome_results <- enrichPathway(gene = gene_map$ENTREZID,
                                  organism = 'human',
                                  pvalueCutoff = 0.05,
                                  readable = TRUE)

print("Generating Reactome Dotplot...")
reactome_plot <- dotplot(reactome_results, showCategory=15) + ggtitle("Reactome Pathway Enrichment")
ggsave("../results/Reactome_enrichment_dotplot.pdf", plot=reactome_plot, width=8, height=6)

print("Saving tabular results...")
write.csv(as.data.frame(go_results), "../data/processed/GO_results.csv")
write.csv(as.data.frame(reactome_results), "../data/processed/Reactome_results.csv")

print("Enrichment analysis complete! Plots saved to rnaseq/results/")