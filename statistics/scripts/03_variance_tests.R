# Load the package needed for Levene's test
library(car)

# Open a text file to capture the results
sink("../results/03_variance_results.txt")

print("=======================================")
print("HOMOGENEITY OF VARIANCE TESTS")
print("H0: The variances are equal across groups.")
print("Decision Rule:")
print("- If p > 0.05: Variances are equal (Use standard t-test/ANOVA)")
print("- If p < 0.05: Variances are unequal (Use Welch's t-test/ANOVA)")
print("=======================================")

print("\n--- 1. Testing mtcars 'mpg' by transmission ---")
print("Bartlett's Test:")
print(bartlett.test(mpg ~ am, data = mtcars))

print("Levene's Test:")
# By default, Levene's test in the 'car' package centers around the median
print(leveneTest(mpg ~ factor(am), data = mtcars))

print("\n--- 2. Testing iris 'Sepal.Width' by species ---")
print("Bartlett's Test:")
print(bartlett.test(Sepal.Width ~ Species, data = iris))

print("Levene's Test:")
print(leveneTest(Sepal.Width ~ Species, data = iris))

# Stop writing to the text file
sink()

print("Variance tests complete! Check the statistics/results/ folder.")
