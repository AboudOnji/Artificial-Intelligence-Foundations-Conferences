# Proyecto 1 — Agente de Auditoría Documental con Aprendizaje Activo

---

## Descripción general

Se propone diseñar un **agente inteligente de auditoría documental** que analiza documentos administrativos (contratos, facturas, expedientes, actas) en busca de inconsistencias, campos faltantes o patrones anómalos. Su característica distintiva es que incorpora un ciclo de **aprendizaje activo**: cuando el agente detecta un caso ambiguo, solicita la intervención del usuario humano, y esa retroalimentación se integra al modelo para mejorar iterativamente su precisión sin necesidad de etiquetar todo el conjunto de datos.

---

## Objetivo

Construir un pipeline completo donde un agente:
1. Recibe documentos administrativos (texto extraído de PDF/Word).
2. Los clasifica como *conforme*, *inconsistente* o *ambiguo*.
3. Solicita etiquetado humano únicamente sobre los casos ambiguos (*query strategy*).
4. Reentrena el modelo con las nuevas etiquetas y actualiza su umbral de confianza.

---

## Stack tecnológico

| Componente | Herramienta sugerida |
|---|---|
| Extracción de texto | `PyMuPDF`, `python-docx` |
| Representación semántica | `TF-IDF` + `SVD` o `sentence-transformers` |
| Modelo base | `Logistic Regression` / `SVM` (scikit-learn) |
| Aprendizaje activo | `modAL` (Python) o implementación manual |
| Interfaz de etiquetado | `Streamlit` (loop humano-agente) |
| Agente | Arquitectura reactiva simple (reglas + modelo) |

---

## Metodología

1. **Preprocesamiento:** Normalización, tokenización y vectorización del corpus documental.
2. **Entrenamiento inicial:** Modelo supervisado con un subconjunto pequeño etiquetado manualmente (seed set ~50–100 documentos).
3. **Ciclo activo:**
   - El agente infiere sobre documentos no etiquetados.
   - Aplica *uncertainty sampling* o *margin sampling* para seleccionar los k casos más informativos.
   - El usuario etiqueta esos k casos en la interfaz Streamlit.
   - El modelo se reentrena con el conjunto expandido.
4. **Evaluación:** Curva de aprendizaje activo (accuracy vs. número de etiquetas usadas) comparada contra baseline supervisado completo.

---


## Extensiones opcionales

- Incorporar un módulo de **detección de anomalías** (Isolation Forest) como segunda capa de análisis.
- Usar embeddings de `sentence-transformers` para capturar semántica contextual más rica.
- Exportar un log de auditoría en formato estructurado (JSON/CSV) por cada ciclo de revisión.
