# 01_circadian_timeseries.R
# Harmonic regression for circadian time-series gene expression

library(ggplot2)

cat("Simulating 48-hour circadian time-course data...\n")
set.seed(123)

# Simulate sampling every 4 hours for 48 hours (standard transcriptomic design)
time_points <- seq(0, 48, by = 4)
n_samples <- length(time_points)

# Generate synthetic oscillatory expression (e.g., a clock gene)
# Formula: Baseline + Amplitude * cos(2 * pi * (t - phase) / 24) + noise
baseline <- 10
amplitude <- 4
phase <- 6 # Peak expression at CT6
noise <- rnorm(n_samples, mean = 0, sd = 0.8)

expression <- baseline + amplitude * cos(2 * pi * (time_points - phase) / 24) + noise

df <- data.frame(Time = time_points, Expression = expression)

cat("Fitting harmonic regression model (24-hour period)...\n")
# Linear model using sine and cosine terms to fit the rhythmic pattern
# Expression ~ sin(2*pi*t/24) + cos(2*pi*t/24)
df$sin_t <- sin(2 * pi * df$Time / 24)
df$cos_t <- cos(2 * pi * df$Time / 24)

fit <- lm(Expression ~ sin_t + cos_t, data = df)

# Output statistical summary of the rhythmicity
sink("../results/timeseries_summary.txt")
cat("=========================================\n")
cat("CIRCADIAN HARMONIC REGRESSION ANALYSIS\n")
cat("=========================================\n\n")
print(summary(fit))
cat("\nAdjusted R-squared indicates the strength of the 24h rhythm.\n")
sink()

cat("Generating time-series visualization...\n")
# Generate high-resolution curve for smooth plotting
plot_time <- seq(0, 48, by = 0.1)
plot_df <- data.frame(
    Time = plot_time,
    sin_t = sin(2 * pi * plot_time / 24),
    cos_t = cos(2 * pi * plot_time / 24)
)
plot_df$Predicted <- predict(fit, newdata = plot_df)

plot <- ggplot() +
    geom_point(data = df, aes(x = Time, y = Expression), size = 3, color = "darkblue", alpha = 0.8) +
    geom_line(data = plot_df, aes(x = Time, y = Predicted), color = "firebrick", size = 1.2) +
    scale_x_continuous(breaks = seq(0, 48, by = 6)) +
    theme_minimal(base_size = 14) +
    labs(
        title = "Circadian Gene Expression Over 48 Hours",
        subtitle = "Harmonic regression fit (24h period) on transcriptomic time-series data",
        x = "Circadian Time (Hours)",
        y = "Normalized Expression"
    ) +
    theme(panel.grid.minor = element_blank())

ggsave("../results/circadian_timeseries_plot.pdf", plot, width = 8, height = 5, dpi = 300)
cat("Analysis complete! Check statistics/results/ for the plot and statistical summary.\n")
