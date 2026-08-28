# Open a text file to capture the results
sink("../results/04_welch_results.txt")

print("=======================================")
print("1. WELCH'S T-TEST (Unequal Variances, 2 Groups)")
print("=======================================")
# var.equal = FALSE is the default, but we write it explicitly for clarity
welch_t <- t.test(mpg ~ am, data = mtcars, var.equal = FALSE)
print(welch_t)

print("=======================================")
print("2. WELCH'S ANOVA (Unequal Variances, 3+ Groups)")
print("Uses oneway.test() instead of aov()")
print("=======================================")
welch_aov <- oneway.test(Sepal.Width ~ Species, data = iris, var.equal = FALSE)
print(welch_aov)

# Stop writing to the text file
sink()

print("Welch tests complete! Check the statistics/results/ folder.")
