
# Informe Final: Comparativo de Modelos de Regresión

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 📘 Descripción

Este repositorio contiene el desarrollo del proyecto académico **"Análisis Comparativo de Modelos de Regresión"** realizado por **Santiago Alejandro Zúñiga Melo** como parte del Máster en Business Intelligence y Big Data. El objetivo fue comparar el desempeño de cuatro modelos de regresión sobre un conjunto de datos sintético con ruido:

- Regresión Polinomial de grado 5  
- Árbol de Decisión (rpart)  
- Random Forest  
- Red Neuronal (nnet)

Se evaluaron los modelos con métricas como MSE (Error Cuadrático Medio) y R² (coeficiente de determinación), así como con análisis gráfico de los ajustes y residuos.

---

## 📁 Estructura del Repositorio

```
Informe-Final/
├── data/                   # Scripts para generación y partición de datos
│   └── generate_data.R
├── models/                 # Scripts de entrenamiento de modelos
│   ├── train_models.R
│   └── hyperparameter_grids.R
├── figures/                # Gráficos generados por los modelos
│   ├── mse_train_test.png
│   ├── curvas_ajustadas.png
│   ├── residuos_vs_x.png
│   └── decision_tree.png
├── report/                 # Informe en formato LaTeX
│   ├── main.tex
│   └── refs.bib
├── README.md               # Este archivo
└── LICENSE                 # Licencia del proyecto
```

---

## 🛠️ Requisitos

- R (versión 4.0 o superior)
- Paquetes R:
  - `caret`
  - `rpart`
  - `rpart.plot`
  - `randomForest`
  - `nnet`
  - `ggplot2`
  - `gridExtra`
  - `reshape2`

---

## 🚀 Uso del Proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/sazuniga06/Informe-Final.git
cd Informe-Final
```

### 2. Instalar los paquetes requeridos en R

```r
install.packages(c(
  "caret", "rpart", "rpart.plot",
  "randomForest", "nnet",
  "ggplot2", "gridExtra", "reshape2"
))
```

### 3. Generar los datos

```r
source("data/generate_data.R")
```

### 4. Entrenar los modelos

```r
source("models/train_models.R")
```

Esto generará las predicciones, métricas y los gráficos comparativos que se guardarán automáticamente en la carpeta `figures/`.

### 5. Compilar el informe

Entra en la carpeta `report/` y compila el informe con un compilador LaTeX:

```bash
cd report
pdflatex main.tex
biber main
pdflatex main.tex
pdflatex main.tex
```

El informe final en PDF incluirá análisis, tablas y visualizaciones.

---

## 📊 Resultados Generados

- `figures/mse_train_test.png`: comparación visual del error en entrenamiento y prueba.
- `figures/curvas_ajustadas.png`: curvas ajustadas por cada modelo vs. función original.
- `figures/residuos_vs_x.png`: distribución de errores.
- `figures/decision_tree.png`: estructura final del árbol de decisión.

---

## 🧾 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más información.

---

## 🔗 Enlace al Informe

Para más detalles y análisis completo, visita el repositorio oficial:

📎 https://github.com/sazuniga06/Informe-Final
