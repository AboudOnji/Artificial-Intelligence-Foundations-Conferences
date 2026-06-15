# Proyectos Finales — Machine Learning Aplicado
**Facultad de Ingeniería · Universidad Anáhuac México**
Prof. D.Sc. Aboud Barsekh-Onji

---

## Proyecto 1 — Agente de Auditoría Documental con Aprendizaje Activo
**Temas:** Clasificación supervisada · Aprendizaje activo · SVM / Regresión Logística  
**Área:** Gobernanza e inteligencia artificial aplicada

Diseño de un agente inteligente que analiza documentos administrativos (contratos, facturas, expedientes) en busca de inconsistencias y patrones anómalos. Incorpora un ciclo de **aprendizaje activo**: cuando el agente detecta un caso ambiguo, solicita intervención humana y esa retroalimentación se integra al modelo para mejorar iterativamente su precisión sin necesidad de etiquetar todo el conjunto de datos. El pipeline cubre preprocesamiento textual, vectorización TF-IDF, *uncertainty sampling*, reentrenamiento incremental y visualización de la curva de aprendizaje activo mediante interfaz Streamlit.

---

## Proyecto 2 — Sistema de Alerta Temprana de Incumplimiento en Contratos con Lógica Difusa
**Temas:** Clasificación supervisada · Lógica difusa · Random Forest / XGBoost · SHAP  
**Área:** Gobernanza e inteligencia artificial aplicada

Sistema de predicción de riesgo de incumplimiento contractual que combina un clasificador supervisado (Random Forest / XGBoost) con un módulo de **lógica difusa** para categorización cualitativa del riesgo. El clasificador estima la probabilidad de incumplimiento a partir de variables históricas del contrato y del proveedor (COMPRANET); el sistema difuso integra esa probabilidad con variables contextuales (monto, antigüedad, tipo de contrato) y produce un *Índice de Riesgo Agregado* defuzzificado por método centroide. El agente emite alertas categorizadas (*bajo / medio / alto / crítico*) y genera fichas de riesgo con SHAP local.

---

## Proyecto 3 — Clasificación de Anomalías en Telemetría de Satélite
**Temas:** SVM · Árboles de decisión · Regresión Logística · Comparativa de clasificadores  
**Área:** Tecnología espacial (IEEE SpaceTech — Mission Area 2: Robótica y Automatización)

Pipeline de detección de fallas en telemetría satelital (temperatura, voltaje, corriente de paneles solares). El alumno entrena y compara tres clasificadores —SVM con kernel RBF, árbol de decisión y regresión logística— sobre datos sintéticos o públicos de satélites LEO. La evaluación incluye AUC-ROC, F1-score y análisis de frontera de decisión. El proyecto discute qué requisitos de confiabilidad impondría un estándar de certificación de ML para sistemas autónomos espaciales.

---

## Proyecto 4 — Optimización de Gestión Energética en Satélites con PSO y Lógica Difusa
**Temas:** PSO · Lógica difusa · Clustering fuzzy · Regresión  
**Área:** Tecnología espacial (IEEE SpaceTech — Mission Area 5: Sostenibilidad Espacial)

Sistema de despacho energético para satélites con restricciones de energía solar y batería. Un módulo de **clustering fuzzy** identifica perfiles de consumo según el modo operativo del satélite (ciencia, comunicaciones, standby); un optimizador **PSO** resuelve el problema de asignación de energía sujeto a restricciones de capacidad y profundidad de descarga. Se evalúa convergencia del PSO, calidad del clustering (índice de partición) y comparativa contra despacho estático por reglas.

---

## Proyecto 5 — Predicción de Precios de Electricidad en el Mercado Spot con PSO-Fuzzy
**Temas:** PSO · Lógica difusa · Regresión · Clustering  
**Área:** Sistemas de energía y mercados eléctricos

Modelo híbrido de predicción de precios spot en el mercado eléctrico (CENACE / datos públicos) basado en **clustering fuzzy substractivo** para identificar regímenes de precio y **PSO** para ajuste de parámetros del sistema difuso. El alumno construye el pipeline completo: preprocesamiento de series temporales, extracción de características (hora, día, temperatura, demanda), entrenamiento del modelo híbrido y evaluación con RMSE, MAPE y R². Se contrasta contra regresión lineal y árbol de regresión como baselines.

---

## Proyecto 6 — Selección de Hiperparámetros en Redes Neuronales con Algoritmos Genéticos
**Temas:** Algoritmos genéticos · Redes neuronales · Clasificación  
**Área:** Optimización de modelos de aprendizaje automático

Uso de un **algoritmo genético** para optimizar simultáneamente la arquitectura y los hiperparámetros de una red neuronal MLP (número de capas, neuronas por capa, tasa de aprendizaje, función de activación). El cromosoma codifica la configuración del modelo; la función de aptitud es el accuracy de validación cruzada. Se evalúan la curva de convergencia del AG, el frente de soluciones encontrado y la comparación contra búsqueda aleatoria y grid search en tiempo de cómputo y rendimiento final.

---

## Proyecto 7 — Optimización Multi-Objetivo de Despacho Energético Renovable con MOPSO
**Temas:** MOPSO · Lógica difusa · Regresión · Optimización multi-objetivo  
**Área:** Sistemas de energía y sostenibilidad

Formulación y resolución de un problema de despacho de energía eólica y solar con dos objetivos en conflicto: minimización de costo de generación y minimización de emisiones de CO₂. El alumno implementa **MOPSO** (Multi-Objective PSO) con repositorio de frente de Pareto y operador de crowding distance. Un módulo de **lógica difusa** actúa como decisor para seleccionar la solución de compromiso a partir del frente. Se visualiza el frente de Pareto y se analiza el trade-off costo-emisiones.

---

## Proyecto 8 — Clasificación de Terreno para Rover Espacial con SVM Multiclase
**Temas:** SVM · Funciones kernel · Clasificación multiclase  
**Área:** Tecnología espacial (IEEE SpaceTech — Mission Area 2: Robótica y Automatización)

Clasificador SVM multiclase para distinguir tipos de terreno a partir de datos de sensores de proximidad y acelerómetro simulados (terreno plano / roca / pendiente / arena). Se implementan y comparan tres kernels (lineal, RBF, polinomial) con ajuste de C y γ por validación cruzada. El proyecto incluye visualización de vectores de soporte, mapa de decisión en espacio reducido (PCA 2D) y análisis de qué kernel sería recomendable para un sistema de navegación autónoma bajo estándares de certificación espacial.

---

## Proyecto 9 — Detección de Deserción Escolar con Clasificadores y Explicabilidad
**Temas:** Regresión logística · Árboles de decisión · Random Forest · SHAP  
**Área:** Inteligencia artificial aplicada a educación

Sistema predictivo de riesgo de deserción escolar a partir de variables académicas, socioeconómicas y de asistencia (dataset público UCI Student Performance o equivalente). El alumno entrena regresión logística, árbol de decisión y Random Forest; compara desempeño con AUC-ROC, F1 y precisión; y aplica **SHAP values** para explicar qué variables impulsan el riesgo individual de cada estudiante. El proyecto discute implicaciones éticas del uso de ML en decisiones educativas.

---

## Proyecto 10 — Ruteo Óptimo de Vehículos de Transporte Público con Algoritmo Genético
**Temas:** Algoritmos genéticos · Optimización combinatoria · Regresión  
**Área:** Movilidad urbana inteligente

Resolución del problema de ruteo de vehículos (VRP) para una red de transporte público urbano usando un **algoritmo genético** con representación de permutación, operadores de cruce PMX y mutación de inversión. El objetivo es minimizar distancia total recorrida respetando capacidad de los vehículos y ventanas de tiempo en paradas clave. Un modelo de **regresión** preestima la demanda por ruta a partir de datos históricos de pasaje. El proyecto genera mapas de rutas optimizadas y analiza la convergencia del AG versus solución greedy.

---

*Los proyectos 1–2 abordan gobernanza algorítmica; 3–4 y 8 se alinean con la IEEE SpaceTech Initiative (Region 9); 5 y 7 se conectan con la línea de investigación en mercados eléctricos; 6, 9 y 10 cubren aplicaciones de optimización y ML en otros dominios de ingeniería.*
