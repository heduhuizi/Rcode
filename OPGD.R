install.packages("GD")
install.packages("ggplot2")

library(GD)
library(ggplot2)

setwd("C:/Users/hdhz/Desktop/xgboost-shap")

data <- read.csv("2023FP2.CSV", as.is = TRUE)
head(data, 5)

discmethod <- c("equal", "natural", "quantile", "geometric", "sd")  
discitv <- c(4:6)  

datagdm <- gdm(
  formula = FP~Slope+ET+Cons+Pop+DEM+Primary, 
  continuous_variable = c("Slope","ET","Cons","Pop","DEM","Primary"), 
  data = data,
  discmethod = discmethod,
  discitv = discitv
)


par(mar = c(3, 3, 2, 2))
datagdm
plot(datagdm)

optimal_discretization <- datagdm[["Discretization"]]
optimal_df <- do.call(rbind, lapply(names(optimal_discretization), function(var_name) {
  var_info <- optimal_discretization[[var_name]]
  data.frame(
    Variable_Name = var_name,
    Optimal_Discretization_Method = var_info$method,
    Optimal_Class_Number = var_info$n.itv,
    stringsAsFactors = FALSE
  )
}))
cat("\n===== Summary of Optimal Discretization Parameters for Each Variable =====\n")
print(optimal_df)


factor_result <- datagdm[["Factor.detector"]][["Factor"]]
p_data <- factor_result[, c("variable", "sig")]
colnames(p_data) <- c("Variable", "P_value")
cat("\n===== P-values for Each Variable (Extracted from 'sig' column) =====\n")
print(p_data)


factor_result <- datagdm[["Factor.detector"]][["Factor"]]
print("Columns in Factor Detector result:")
print(colnames(factor_result))  

q_data <- factor_result[, c("variable", "qv")] 
colnames(q_data) <- c("Variable", "Q_value")  




cat("\n===== Q-values for Each Variable (Extracted from 'qv' column) =====\n")
q_data$Q_value <- round(q_data$Q_value, 3)
print(q_data)


windowsFonts(Times = windowsFont("Times New Roman"))

ggplot(q_data, aes(x = reorder(Variable, -Q_value), y = Q_value)) +
  geom_bar(stat = "identity", aes(fill = Q_value), width = 0.8) +
  scale_fill_gradient(low = "#87CEEB", high = "#00008B", guide = "none") + 
  coord_flip() +  
  labs(x = "", y = "q value") + 
  expand_limits(y = c(0, max(q_data$Q_value) * 1.05)) +  
  theme_bw() +  
  theme(
    text = element_text(family = "Times", color = "black", size = 22), 
    axis.text = element_text(family = "Times", color = "black", size = 22),
    axis.title = element_text(family = "Times", color = "black", size = 24, face = "bold"),  
    plot.title = element_blank(),
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 1), 
    panel.grid = element_blank(),
    axis.ticks = element_line(colour = "black", linewidth = 0.8),
    plot.margin = margin(10, 20, 10, 10, "pt")
  )