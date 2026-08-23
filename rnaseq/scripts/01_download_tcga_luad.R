# Load libraries
library(TCGAbiolinks)
library(SummarizedExperiment)

# 1. Define the query for Lung Adenocarcinoma (LUAD)
# We specifically ask for both 'Primary Tumor' and 'Solid Tissue Normal'
query <- GDCquery(
  project = "TCGA-LUAD",
  data.category = "Transcriptome Profiling",
  data.type = "Gene Expression Quantification",
  workflow.type = "STAR - Counts",
  sample.type = c("Primary Tumor", "Solid Tissue Normal")
)

# 2. Download the actual files (this caches them in a temporary folder)
GDCdownload(query)

# 3. Assemble the files into a single R object
tcga_data <- GDCprepare(query)

# 4. Extract the raw count matrix and the metadata
count_matrix <- assay(tcga_data, "unstranded")
metadata <- colData(tcga_data)

# 5. Save the data into your structured folders
# Because this script runs from rnaseq/scripts/, we use ../ to go up one level
write.csv(count_matrix, "../data/raw/TCGA_LUAD_raw_counts.csv")
write.csv(metadata, "../data/raw/TCGA_LUAD_metadata.csv")

print("Download complete. Files saved to rnaseq/data/raw/")
