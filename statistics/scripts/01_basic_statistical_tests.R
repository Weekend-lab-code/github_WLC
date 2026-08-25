# Load required library for plotting
library(ggplot2)

# 1. Open a text file to capture the statistical results
sink("../results/01_stat_test_results.txt")

print("=======================================")
print("1. T-TEST (Parametric, 2 Groups)")
print("Testing if Miles Per Gallon (mpg) differs by Transmission (am: 0=auto, 1=manual) in mtcars")
print("=======================================")
t_res <- t.test(mpg ~ am, data = mtcars)
print(t_res)

print("=======================================")
print("2. MANN-WHITNEY U TEST (Non-parametric, 2 Groups)")
print("Same test as above, but using rank-sums instead of raw means")
print("=======================================")
mw_res <- wilcox.test(mpg ~ am, data = mtcars)
print(mw_res)

print("=======================================")
print("3. ANOVA (Parametric, 3+ Groups)")
print("Testing if Sepal Width differs across 3 Iris flower species")
print("=======================================")
aov_res <- aov(Sepal.Width ~ Species, data = iris)
print(summary(aov_res))

print("=======================================")
print("4. KRUSKAL-WALLIS TEST (Non-parametric, 3+ Groups)")
print("Same test as above, but non-parametric")
print("=======================================")
kw_res <- kruskal.test(Sepal.Width ~ Species, data = iris)
print(kw_res)

# Stop writing to the text file
sink()

# 2. Generate Boxplots to visualize the data
print("Generating boxplots for visualization...")
pdf("../results/01_stat_test_boxplots.pdf", width=8, height=10)

# Plot 1: 2 Groups (T-test / MW)
p1 <- ggplot(mtcars, aes(x = factor(am, labels=c("Auto", "Manual")), y = mpg, fill = factor(am))) +
  geom_boxplot(alpha=0.7) +
  theme_minimal(base_size = 14) +
  labs(title = "Miles per Gallon by Transmission", 
       subtitle = "Used for T-test & Mann-Whitney U", x = "Transmission", y = "MPG") +
  theme(legend.position = "none")

# Plot 2: 3 Groups (ANOVA / KW)
p2 <- ggplot(iris, aes(x = Species, y = Sepal.Width, fill = Species)) +
  geom_boxplot(alpha=0.7) +
  theme_minimal(base_size = 14) +
  labs(title = "Sepal Width by Iris Species", 
       subtitle = "Used for ANOVA & Kruskal-Wallis", x = "Species", y = "Sepal Width") +
  theme(legend.position = "none")

# Print plots to the PDF
print(p1)
print(p2)
dev.off()

print("Analysis complete! Check the statistics/results/ folder.")