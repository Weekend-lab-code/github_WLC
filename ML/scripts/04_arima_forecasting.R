# 04_arima_forecasting.R
# Seasonal ARIMA (SARIMA) forecasting for cyclic biological data

library(forecast)
library(ggplot2)

cat("Simulating bioreactor data with weekly feeding cycles...\n")
set.seed(123)

# Simulate 100 days: Upward trend + 7-day seasonal cycle + biological noise
days <- 1:100
cell_density <- 50 + 1.2 * days + 15 * sin(2 * pi * days / 7) + rnorm(100, mean = 0, sd = 3)

# frequency = 7 explicitly tells the model to look for weekly seasonality
ts_data <- ts(cell_density, frequency = 7)

cat("Fitting Seasonal auto-ARIMA model...\n")
# auto.arima will now detect both the trend and the seasonal pattern
arima_model <- auto.arima(ts_data)

sink("../results/04_arima_summary.txt")
cat("===========================================\n")
cat("SEASONAL ARIMA FORECASTING REPORT\n")
cat("===========================================\n\n")
print(summary(arima_model))
sink()

cat("Forecasting the next 30 days...\n")
forecast_data <- forecast(arima_model, h = 30)

cat("Generating forecast visualization...\n")
plot <- autoplot(forecast_data) +
    theme_minimal(base_size = 14) +
    labs(
        title = "SARIMA Forecast: Bioreactor Cell Density",
        subtitle = paste("Model:", forecast_data$method),
        x = "Time (Days)",
        y = "Cell Density (10^6 cells/mL)"
    ) +
    theme(
        panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold")
    ) +
    geom_line(color = "darkblue", linewidth = 0.8)

ggsave("../results/04_arima_forecast_plot.pdf", plot, width = 8, height = 5, dpi = 300)
cat("SARIMA analysis complete! Check ML/results/ for the plot.\n")
