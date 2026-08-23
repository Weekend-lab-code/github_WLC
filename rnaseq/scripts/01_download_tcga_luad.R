# Load libraries
library(TCGAbiolinks)
library(SummarizedExperiment)

# 1. Define the query for Lung Adenocarcinoma (LUAD)
query <- GDCquery(
  project = "TCGA-LUAD",
  data.category = "Transcriptome Profiling",
  data.type = "Gene Expression Quantification",
  workflow.type = "STAR - Counts",
  sample.type = c("Primary Tumor", "Solid Tissue Normal")
)

# 2. Download the actual files
GDCdownload(query)

# 3. Assemble the files into a single R object
tcga_data <- GDCprepare(query)

# 4. Extract the raw count matrix and the metadata
count_matrix <- assay(tcga_data, "unstranded")
metadata <- as.data.frame(colData(tcga_data))

# FIX: Find any columns that are lists and flatten them into text
for(col in names(metadata)) {
  if(is.list(metadata[[col]])) {
    metadata[[col]] <- sapply(metadata[[col]], paste, collapse=";")
  }
}

# 5. Save the data into your structured folders
write.csv(count_matrix, "../data/raw/TCGA_LUAD_raw_counts.csv")
write.csv(metadata, "../data/raw/TCGA_LUAD_metadata.csv")

print("Download complete. Files saved to rnaseq/data/raw/")