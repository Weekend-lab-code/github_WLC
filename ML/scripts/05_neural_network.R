# 05_neural_network.R
# Multi-Layer Perceptron (MLP) for Clinical Biomarker Classification

library(neuralnet)

cat("Simulating clinical biomarker dataset...\n")
set.seed(42)
n <- 500
GeneA <- rnorm(n, 50, 10)
GeneB <- rnorm(n, 100, 20)
GeneC <- rnorm(n, 10, 2)

prob <- 1 / (1 + exp(-(0.05 * GeneA - 0.02 * GeneB + 0.5 * GeneC - 5)))
Response <- ifelse(runif(n) < prob, 1, 0)
data <- data.frame(GeneA, GeneB, GeneC, Response)

cat("Min-Max scaling data (Critical for neural network convergence)...\n")
maxs <- apply(data, 2, max)
mins <- apply(data, 2, min)
scaled_data <- as.data.frame(scale(data, center = mins, scale = maxs - mins))

train_idx <- sample(1:nrow(scaled_data), round(0.7 * nrow(scaled_data)))
train_data <- scaled_data[train_idx, ]
test_data <- scaled_data[-train_idx, ]

cat("Training Neural Network (Topology: 3 Inputs -> 5 Hidden -> 3 Hidden -> 1 Output)...\n")
nn_model <- neuralnet(Response ~ GeneA + GeneB + GeneC, 
                      data = train_data, 
                      hidden = c(5, 3), 
                      linear.output = FALSE, 
                      stepmax = 1e6)

sink("../results/05_nn_summary.txt")
cat("===========================================\n")
cat("NEURAL NETWORK CLASSIFICATION REPORT\n")
cat("===========================================\n\n")
cat("Training Steps: ", nn_model$result.matrix["steps", 1], "\n")
cat("Training Error: ", round(nn_model$result.matrix["error", 1], 4), "\n\n")

cat("--- Test Set Performance ---\n")
predictions <- compute(nn_model, test_data[, 1:3])
predicted_class <- ifelse(predictions$net.result > 0.5, 1, 0)

conf_matrix <- table(Predicted = predicted_class, Actual = test_data$Response)
print(conf_matrix)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
cat(sprintf("\nTest Accuracy: %.2f%%\n", accuracy * 100))
sink()

cat("Generating neural network topology visualization as PNG...\n")
# Using PNG natively supports neuralnet's grid graphics on Mac
png("../results/05_nn_topology.png", width = 800, height = 600, res = 100)
plot(nn_model, rep = "best")
dev.off()

cat("Neural Network analysis complete! Check ML/results/ for the plot and report.\n")
