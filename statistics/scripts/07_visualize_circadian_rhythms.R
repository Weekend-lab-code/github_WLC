# 03_visualize_circadian_rhythms.R
# Visualizes significant rhythmic genes validated by MetaCycle

library(ggplot2)
library(tidyr)

cat("Loading raw data and MetaCycle results...\n")
expr_data <- read.csv("../data/raw/circadian_expression.csv")
meta_results <- read.csv("../results/meta2d_circadian_expression.csv")

# 1. Filter for statistically significant genes (JTK p-value < 0.05)
sig_genes <- meta_results$CycID[meta_results$meta2d_pvalue < 0.05]
cat("Statistically significant genes identified:", paste(sig_genes, collapse=", "), "\n")

# 2. Subset the raw data to only include rhythmic genes
plot_data <- expr_data[expr_data$Gene_ID %in% sig_genes, ]

# 3. Reshape data from "wide" to "long" for ggplot
long_data <- pivot_longer(plot_data, 
                          cols = starts_with("CT"),
                          names_to = "Time", 
                          values_to = "Expression")

# Clean up the "Time" column (convert "CT4" to the number 4)
long_data$Time <- as.numeric(gsub("CT", "", long_data$Time))

cat("Generating circadian phase visualization...\n")
# 4. Generate the plot
plot <- ggplot(long_data, aes(x = Time, y = Expression, color = Gene_ID, group = Gene_ID)) +
  geom_point(size = 3, alpha = 0.7) +
  # Add a smooth curve to highlight the rhythmic oscillation
  geom_smooth(method = "loess", se = FALSE, span = 0.4, linewidth = 1.2) +
  scale_x_continuous(breaks = seq(0, 48, by = 6)) +
  theme_minimal(base_size = 14) +
  labs(title = "Core Circadian Clock Gene Expression",
       subtitle = "MetaCycle-validated rhythmic genes demonstrating anti-phase oscillations",
       x = "Circadian Time (Hours)",
       y = "Simulated Expression Level") +
  # Assign distinct colors so the anti-phase relationship pops
  scale_color_manual(values = c("per" = "#e41a1c", "tim" = "#ff7f00", "clk" = "#377eb8")) +
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold"))

# 5. Save the high-resolution visualization
ggsave("../results/circadian_phase_plot.pdf", plot, width = 8, height = 5, dpi = 300)
cat("Visualization complete! Saved to statistics/results/circadian_phase_plot.pdf\n")