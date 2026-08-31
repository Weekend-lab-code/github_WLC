# 02_kmeans_clustering.R
# Support Vector Machine (SVM) on the built-in Iris dataset

# 1. Load required libraries
cat("Loading libraries: factoextra, ggplot2...\n")
library(ggplot2)
# We use factoextra for simplified visualization of clustering results
library(factoextra)

# Set random seed for reproducibility
set.seed(456)

# 2. Load and prepare the data (using Iris data)
cat("Loading data (Iris numerical features)...\n")
data(iris)
# K-means requires numerical inputs, so we select columns 1:4 and ignore species labels
iris_data <- iris[, 1:4]
# Standardize/Scale the data so each feature has equal weight (recommended)
iris_scaled <- scale(iris_data)

# 3. Determine the optimal number of clusters (Elbow Method)
cat("Generating elbow plot to determine optimal clusters...\n")
pdf("../results/elbow_plot.pdf", width = 8, height = 6)
elbow_plot <- fviz_nbclust(iris_scaled, kmeans, method = "wss") +
    labs(title = "Elbow Method for Optimal k", subtitle = "Within Cluster Sum of Squares (WSS)") +
    theme_minimal()
print(elbow_plot)
dev.off()

# 4. Train the K-means model with k=3
# A data-driven approach based on the elbow method suggests k=3 is optimal.
cat("Training K-means model with k=3...\n")
# nstart=25 runs 25 multiple initial configurations to avoid local minima
kmeans_model <- kmeans(iris_scaled, centers = 3, nstart = 25)

# 5. Visualize the results using PCA (Principal Component Analysis)
# This automatically reduces 4 dimensions to 2, as shown in your screen visualization.
cat("Generating final cluster visualization...\n")
pdf("../results/cluster_plot.pdf", width = 10, height = 8)
cluster_visual <- fviz_cluster(kmeans_model,
    data = iris_scaled,
    # Style matching your successful validation screen
    ellipse.type = "convex", geom = "point",
    pointsize = 3, palette = c("#e41a1c", "#377eb8", "#4daf4a"),
    ggtheme = theme_minimal(),
    main = "K-means Clustering on Iris Data (Scaled)",
    subtitle = "Unsupervized learning results showing three distinct clusters"
)
print(cluster_visual)
dev.off()

# 6. Validate result vs ground truth (Compare clusters to actual species)
cat("\nConfusion Matrix (Cluster vs Actual Species):\n")
# This crucial validation compares the clusters found with the original species labels.
# Note: K-means finds groupings, but not necessarily labels 'setosa', etc.
# A strong result shows most observations of one species fall into one cluster.
confusion_matrix <- table(Cluster = kmeans_model$cluster, Species = iris$Species)
print(confusion_matrix)

cat("\nK-means analysis complete! Check the visualizations in results/.\n")
