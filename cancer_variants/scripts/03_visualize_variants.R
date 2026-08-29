# 03_visualize_variants.R
# Generate publication-quality lollipop plot for annotated variants
library(ggplot2)
library(ggrepel)

# Set up a robust color palette for the clinical significance classes in your data
clin_colors <- c(
    "Pathogenic" = "#e41a1c", # Red
    "drug response" = "#ff7f00", # Orange
    "Unknown" = "#999999" # Gray
)

# 1. Load annotated clinical variants
cat("Loading annotated clinical variants...\n")
# This reads the exact CSV file you validated in the last turn
variants_df <- read.csv("../results/annotated_clinical_variants.csv")

# Create mutation labels for plotting from Gene and Position
variants_df$Label <- paste0(variants_df$Gene, ":", variants_df$Position)

# 2. Create the lollipop plot
cat("Generating variant landscape visualization...\n")
plot <- ggplot(variants_df, aes(x = Label, y = 1, color = Significance)) +
    # Base horizontal line
    geom_hline(yintercept = 0, color = "gray80", size = 1) +
    # Draw the lollipop segment, coloring by Significance
    geom_linerange(aes(ymin = 0, ymax = 1), size = 1.5, position = position_dodge(width = 0.8)) +
    # Draw the lollipop head (point), coloring and filling by Significance
    geom_point(aes(y = 1, fill = Significance), size = 6, shape = 21, stroke = 1.5, position = position_dodge(width = 0.8)) +
    # Apply the custom color and fill scales defined above
    scale_color_manual(values = clin_colors) +
    scale_fill_manual(values = clin_colors) +
    # Add bold, non-overlapping labels
    geom_text_repel(aes(y = 1, label = Label), color = "black", size = 5, fontface = "bold", nudge_y = 0.15) +
    # Set professional titles and labels
    labs(
        title = "Clinical Landscape of Cancer Variants",
        subtitle = "High-confidence Somatic Mutations (GATK Mutect2) with REST API Annotation",
        x = "Genomic Position",
        y = "Variant Status"
    ) +
    # Apply clean minimalist theme
    theme_minimal(base_size = 14) +
    theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "bottom"
    )

# 3. Save the final visualization
cat("Saving clinical landscape report...\n")
# Save a high-resolution image ready for presentation or portfolio use
ggsave("../results/variant_lollipop_plot.png", plot, width = 10, height = 6, dpi = 300)
cat("Pipeline visualization complete! File saved in results/.\n")
