# 03_random_forest.R
# Random Forest Classification and Feature Importance

library(randomForest)
library(caret)
library(ggplot2)

set.seed(789)

cat("Loading Iris dataset and splitting data...\n")
data(iris)

# 70/30 Train/Test Split
train_index <- createDataPartition(iris$Species, p = 0.7, list = FALSE)
train_data <- iris[train_index, ]
test_data <- iris[-train_index, ]

cat("Training Random Forest model (500 trees)...\n")
# importance = TRUE forces the model to calculate feature importance metrics
rf_model <- randomForest(Species ~ ., data = train_data, ntree = 500, importance = TRUE)

# Save the statistical report
sink("../results/03_rf_results.txt")
cat("===========================================\n")
cat("RANDOM FOREST CLASSIFICATION REPORT\n")
cat("===========================================\n\n")
print(rf_model)

cat("\n--- Test Set Performance ---\n")
predictions <- predict(rf_model, test_data)
conf_matrix <- confusionMatrix(predictions, test_data$Species)
print(conf_matrix$table)
cat(sprintf("\nAccuracy: %.2f%%\n", conf_matrix$overall["Accuracy"] * 100))
sink()

cat("Extracting and plotting Feature Importance...\n")
# Extract the Mean Decrease in Gini (how much each feature contributes to node purity)
imp_data <- as.data.frame(importance(rf_model))
imp_data$Feature <- rownames(imp_data)

# Create a clean, sorted bar chart for feature importance
plot <- ggplot(imp_data, aes(x = reorder(Feature, MeanDecreaseGini), y = MeanDecreaseGini)) +
    geom_bar(stat = "identity", fill = "#4daf4a", width = 0.6) +
    coord_flip() +
    theme_minimal(base_size = 14) +
    labs(
        title = "Random Forest Feature Importance",
        subtitle = "Identifying key predictors using Mean Decrease Gini",
        x = "Measurements",
        y = "Importance (Mean Decrease Gini)"
    ) +
    theme(
        panel.grid.major.y = element_blank(),
        plot.title = element_text(face = "bold")
    )

ggsave("../results/03_rf_importance.pdf", plot, width = 8, height = 5, dpi = 300)
cat("Random Forest analysis complete! Check ML/results/ for the report and plot.\n")
