# 0. Instalar y cargar librerías
#install.packages(c("caret", "rpart", "rpart.plot", "randomForest", "nnet", "ggplot2", "gridExtra", "reshape2"))
library(caret)
library(rpart)
library(rpart.plot)
library(randomForest)
library(nnet)
library(ggplot2)
library(gridExtra)
library(reshape2)

# 1. Generar el dataset según el enunciado
f <- function(x) {
  if (x < 0) {
    x * sin(1/x)
  } else if (x <= 40) {
    sin(x/40*5*pi)
  } else {
    -log(x-39)
  }
}
set.seed(308)
x <- c(seq(-30, 0, length.out = 50),
       seq(-5, 0,  length.out = 100),
       seq(0,  40, length.out = 500),
       seq(40, 100,length.out = 50))
y <- sapply(x, f) + rnorm(length(x), sd = 0.7)
data <- data.frame(x = x, y = y)
data <- data[sample(nrow(data)), ]

# 2. Partición train/test 50/50
set.seed(123)
train_idx <- createDataPartition(data$y, p = 0.5, list = FALSE)
train <- data[train_idx, ]
test  <- data[-train_idx, ]

# 3. Control de validación cruzada (10-fold)
cv_ctrl <- trainControl(method = "cv", number = 10)

# 4. Ajuste de modelos vía caret::train

## 4.1 Regresión lineal polinomial (grado 5)
set.seed(1)
lm_poly <- train(y ~ poly(x, 5), data = train, method = "lm", trControl = cv_ctrl)

## 4.2 Árbol de decisión (rpart) con tuning de cp
set.seed(2)
rpart_tuned <- train(y ~ x, data = train, method = "rpart", tuneLength = 10, trControl = cv_ctrl)

## 4.3 Random Forest
set.seed(3)
rf_mod <- train(y ~ x, data = train, method = "rf", tuneLength = 5, trControl = cv_ctrl)

## 4.4 Red neuronal (nnet) con tuning de size y decay
set.seed(4)
nnet_mod <- train(
  y ~ x, data = train, method = "nnet",
  tuneGrid = expand.grid(size = c(5,10,15), decay = c(0,0.1,0.5)),
  trControl = cv_ctrl, linout = TRUE, trace = FALSE
)

# 5. Cálculo de métricas
models <- list(
  "Poly5"        = lm_poly,
  "Tree"         = rpart_tuned,
  "RandomForest" = rf_mod,
  "NeuralNet"    = nnet_mod
)
metrics_df <- do.call(rbind, lapply(names(models), function(name) {
  mod <- models[[name]]
  pred_tr <- predict(mod, newdata = train)
  pred_te <- predict(mod, newdata = test)
  data.frame(
    Model     = name,
    MSE_Train = mean((train$y - pred_tr)^2),
    MSE_Test  = mean((test$y  - pred_te)^2),
    R2_Test   = cor(test$y, pred_te)^2,
    row.names = NULL
  )
}))
print(metrics_df)

# 6. Gráfico de MSE Train vs Test (guardar PNG)
png("mse_train_test.png", width = 800, height = 600, res = 100)
err_df <- melt(metrics_df[,c("Model","MSE_Train","MSE_Test")],
               id.vars="Model", variable.name="Set", value.name="MSE")
err_df$Set <- factor(err_df$Set, levels=c("MSE_Train","MSE_Test"), labels=c("Train","Test"))
p_mse <- ggplot(err_df, aes(x=Set,y=MSE,fill=Model)) +
  geom_bar(stat="identity", position="dodge") +
  labs(title="Comparación de MSE Train vs Test",
       subtitle="Detección de sesgo y varianza")
print(p_mse)
dev.off()

# 7. Curvas ajustadas vs patrón real (guardar PNG)
png("curvas_ajustadas.png", width = 800, height = 1000, res = 100)
p_base <- ggplot(train, aes(x=x,y=y)) +
  geom_point(color="red70", alpha=0.6) +
  stat_function(fun=f, color="black", size=1) +
  labs(title="Patrón real (negro) y ajustes")
p_models <- p_base +
  geom_line(aes(y = predict(lm_poly, newdata=train)), color="blue") +
  geom_line(aes(y = predict(rpart_tuned, newdata=train)), color="green") +
  geom_line(aes(y = predict(rf_mod, newdata=train)), color="purple") +
  geom_line(aes(y = predict(nnet_mod, newdata=train)), color="red") +
  labs(subtitle="Poly5 (azul), Tree (verde), RF (morado), NN (rojo)")
print(grid.arrange(p_base, p_models, ncol=1))
dev.off()

# 8. Análisis de residuos vs x (guardar PNG)
png("residuos_vs_x.png", width = 1200, height = 800, res = 100)
res_plots <- lapply(names(models), function(name) {
  mod <- models[[name]]
  resid <- test$y - predict(mod, newdata = test)
  ggplot(data.frame(x=test$x, Resid=resid), aes(x=x,y=Resid)) +
    geom_point(alpha=0.6) +
    geom_hline(yintercept=0, linetype="dashed") +
    labs(title=paste("Residuos vs x –", name), y="Residuo")
})
print(do.call(grid.arrange, c(res_plots, ncol=2)))
dev.off()

# 9. Árbol de decisión y guardado de PNG
final_tree <- rpart_tuned$finalModel
png("decision_tree.png", width = 800, height = 600, res = 100)
rpart.plot(final_tree,
           main=paste("Árbol de decisión (cp =", rpart_tuned$bestTune$cp, ")"),
           type=2, extra=101)
dev.off()
