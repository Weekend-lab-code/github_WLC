# 01_svm_classification.R
# Support Vector Machine (SVM) on the built-in Iris dataset

# 1. Load required libraries
cat("Loading libraries: e1071, caret, ggplot2...\n")
library(e1071)
library(caret)
library(ggplot2)

# Set seed for reproducibility
set.seed(123)

# 2. Load and prepare data (using Iris species for classification)
data(iris)
# Create a training (70%) and testing (30%) split
cat("Splitting data into 70% training and 30% testing...\n")
train_index <- createDataPartition(iris$Species, p = 0.7, list = FALSE)
train_data <- iris[train_index, ]
test_data <- iris[-train_index, ]

# 3. Open result file
sink("../results/01_svm_results.txt")

cat("===========================================\n")
cat("SUPPORT VECTOR MACHINE CLASSIFICATION REPORT\n")
cat("Dataset: Iris\n")
cat("Model: Linear SVM (C=1)\n")
cat("===========================================\n\n")

# 4. Train the SVM model
cat("Training linear SVM model...\n\n")
svm_model <- svm(Species ~ ., data = train_data, kernel = "linear", cost = 1)

# Print model summary
print(summary(svm_model))

# 5. Make predictions on the test set
cat("\nMaking predictions on test data...\n")
predictions <- predict(svm_model, test_data)

# 6. Evaluate the model performance
cat("\nModel Evaluation (Confusion Matrix):\n")
confusion_mtx <- confusionMatrix(predictions, test_data$Species)
print(confusion_mtx)

cat("\n===========================================\n")
cat("SVM Classification Complete.\n")
cat("===========================================\n")

# 7. Close result file
sink()

# 8. Create and save visualization of test set performance
cat("Generating prediction plot...\n")
pdf("../results/01_svm_plots.pdf", width = 8, height = 6)

# Create a test set performance plot (color by prediction, shape by actual)
test_data$Predicted <- predictions
p <- ggplot(test_data, aes(x = Sepal.Length, y = Sepal.Width, color = Predicted, shape = Species)) +
    geom_point(size = 4, alpha = 0.8) +
    scale_color_manual(values = c("setosa" = "#e41a1c", "versicolor" = "#377eb8", "virginica" = "#4daf4a")) +
    theme_minimal(base_size = 14) +
    labs(
        title = "Iris Species Prediction with Linear SVM",
        subtitle = "Color = Predicted Species | Shape = Actual Species",
        x = "Sepal Length",
        y = "Sepal Width"
    ) +
    theme(legend.position = "bottom")

print(p)
dev.off()

cat("Analysis complete! Results saved in ML/results/.\n")
