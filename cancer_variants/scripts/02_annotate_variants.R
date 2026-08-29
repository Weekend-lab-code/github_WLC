# Load required libraries
library(httr)
library(jsonlite)

print("Loading VCF data...")
vcf <- read.table(gzfile("../results/somatic_filtered.vcf.gz"), comment.char = "#", stringsAsFactors = FALSE)
rsids <- vcf$V3

print("Querying MyVariant.info REST API for clinical annotations...")
results_list <- list()

for (i in 1:length(rsids)) {
    url <- paste0("https://myvariant.info/v1/query?q=", rsids[i], "&fields=all")
    req <- GET(url)

    # Parse JSON and flatten it into a simple searchable vector
    data <- fromJSON(content(req, "text", encoding = "UTF-8"))
    flat_data <- unlist(data)

    # Safely search the vector for the gene name
    gene_idx <- grep("gene.symbol|genename", names(flat_data))
    gene <- ifelse(length(gene_idx) > 0, flat_data[gene_idx[1]], "Unknown")

    # Safely search the vector for pathogenicity
    sig_idx <- grep("clinical_significance", names(flat_data))
    sig <- ifelse(length(sig_idx) > 0, flat_data[sig_idx[1]], "Unknown")

    results_list[[i]] <- data.frame(
        rsID = rsids[i],
        Gene = gene,
        Significance = sig
    )
}

# Bind the results and merge with original coordinates
final_df <- do.call(rbind, results_list)
annotated_vcf <- cbind(vcf[, c("V1", "V2", "V4", "V5")], final_df)
colnames(annotated_vcf)[1:4] <- c("Chromosome", "Position", "Ref", "Alt")

# Save the clean report
write.csv(annotated_vcf, "../results/annotated_clinical_variants.csv", row.names = FALSE)
print("Annotations saved successfully.")
