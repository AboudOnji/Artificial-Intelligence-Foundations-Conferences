# Proyecto 2 — Predicción de Riesgo de Incumplimiento en Contratos

---

## Descripción general

Se propone un **sistema de alerta temprana** que estima la probabilidad de que un proveedor o contratista incumpla un contrato público (o privado), combinando técnicas de clasificación supervisada con un módulo de **lógica difusa** para la evaluación cualitativa del riesgo. El resultado es un agente que emite alertas categorizadas (*riesgo bajo / medio / alto*) antes de que ocurra el incumplimiento, apoyando decisiones de auditoría preventiva.

---

## Objetivo

Construir un pipeline de predicción donde:
1. Un modelo supervisado estima la **probabilidad de incumplimiento** a partir de variables históricas del contrato y del proveedor.
2. Un sistema difuso transforma esa probabilidad junto con variables contextuales (monto, antigüedad, tipo de contrato) en una **categoría de riesgo lingüística**.
3. El agente emite alertas y genera un reporte por contrato.

---

## Stack tecnológico

| Componente | Herramienta sugerida |
|---|---|
| Datos | COMPRANET (México) / UCI Contract Dataset |
| Clasificación | `Random Forest`, `XGBoost` (scikit-learn) |
| Variables temporales | `pandas` + features de series de tiempo |
| Explicabilidad | `SHAP` |
| Lógica difusa | `scikit-fuzzy` (`skfuzzy`) |
| Agente de alertas | Script Python con umbral + reglas difusas |
| Visualización | `matplotlib`, `seaborn`, `plotly` |

---

## Metodología

### Módulo 1 — Clasificación supervisada
- Variables de entrada: monto del contrato, tipo de licitación, historial del proveedor, sector, número de contratos previos, ratio cumplimiento/incumplimiento histórico.
- Variable objetivo: incumplimiento binario (sí/no).
- Métricas: AUC-ROC, F1-score, matriz de confusión.
- Importancia de variables con **SHAP values**.

### Módulo 2 — Sistema difuso de categorización de riesgo
Tres variables de entrada difusas:
- **Probabilidad de incumplimiento** (output del clasificador): {baja, media, alta}
- **Monto del contrato** (normalizado): {pequeño, mediano, grande}
- **Antigüedad del proveedor**: {nuevo, experimentado, consolidado}

Reglas difusas (ejemplos):
```
IF prob_incumplimiento IS alta AND monto IS grande → riesgo IS crítico
IF prob_incumplimiento IS media AND antigüedad IS nuevo → riesgo IS alto
IF prob_incumplimiento IS baja AND antigüedad IS consolidado → riesgo IS bajo
```
Output difuso: **Índice de Riesgo Agregado** → defuzzificado con método centroide.

### Módulo 3 — Agente de alertas
- Monitorea contratos activos y emite notificaciones por categoría de riesgo.
- Genera ficha de riesgo por contrato con SHAP local y categoría difusa.

---

## Extensiones opcionales

- Incorporar variables macroeconómicas (inflación, tipo de cambio) como contexto temporal.
- Comparar el sistema difuso contra un **clasificador multiclase** directo (riesgo bajo/medio/alto) para contrastar enfoques.
- Implementar un módulo de **retroalimentación activa**: el auditor humano valida las alertas y corrige el índice de riesgo, generando datos para reentrenamiento.
