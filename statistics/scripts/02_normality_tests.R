# Open a text file to capture the normality results
sink("../results/02_normality_results.txt")

print("=======================================")
print("SHAPIRO-WILK NORMALITY TEST")
print("H0: The data is normally distributed.")
print("Decision Rule:")
print("- If p > 0.05: Normal (Use T-Test / ANOVA)")
print("- If p < 0.05: Not Normal (Use Mann-Whitney / Kruskal-Wallis)")
print("=======================================")

print("\n--- 1. Testing mtcars 'mpg' by transmission ---")
print("Auto (am=0):")
print(shapiro.test(mtcars$mpg[mtcars$am == 0]))

print("Manual (am=1):")
print(shapiro.test(mtcars$mpg[mtcars$am == 1]))

print("\n--- 2. Testing iris 'Sepal.Width' by species ---")
print("Using tapply() to quickly test all 3 species at once:")
# tapply is a brilliant R function that applies a test to a variable, split by a factor
print(tapply(iris$Sepal.Width, iris$Species, shapiro.test))

# Stop writing to the text file
sink()

print("Normality tests complete! Check the statistics/results/ folder.")
