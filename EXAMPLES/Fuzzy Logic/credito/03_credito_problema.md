# Sistema de Inferencia Difusa: Score de Riesgo Crediticio Simplificado

**Autor:** Prof. D.Sc. Aboud Barsekh-Onji
**Institución:** Universidad Anáhuac México
**Contexto:** Material didáctico para curso de Sistemas de Inferencia Difusa

---

## 1. Descripción del Problema

Las instituciones financieras deben decidir si otorgan crédito a un solicitante, y en
qué condiciones, evaluando su **riesgo** de incumplimiento. En este ejercicio
simplificado, dicho riesgo se estima a partir de dos indicadores:

1. La **capacidad de pago relativa**, expresada como un ratio normalizado entre el
   ingreso mensual del solicitante y su nivel de deuda actual (entre más alto, mejor
   capacidad de pago).
2. El **historial de pago**, una calificación de 0 a 10 que resume el comportamiento
   pasado del solicitante (pagos puntuales, atrasos, incumplimientos previos).

El objetivo del sistema es producir un **score de riesgo crediticio** en una escala
de 0 a 100, donde 0 representa riesgo nulo (cliente ideal) y 100 representa riesgo
máximo (alta probabilidad de incumplimiento).

Este problema es uno de los ejemplos más citados en la literatura de lógica difusa
aplicada a finanzas, porque combina **criterios cuantitativos con juicios
cualitativos** que tradicionalmente formulan los analistas de crédito en lenguaje
natural ("buen ingreso pero mal historial = riesgo considerable").

---

## 2. Naturaleza de las Variables

### 2.1 Variables de Entrada

| Variable | Rango | Naturaleza | Conjuntos difusos sugeridos |
|---|---|---|---|
| **Ingreso relativo a deuda** (ratio normalizado) | 0 – 10 | Continua, cuantitativa, derivada de datos financieros objetivos (ingreso / deuda, normalizado) | Insuficiente, Bajo, Adecuado, Alto |
| **Historial de pago** | 0 – 10 | Discreta/continua, semicuantitativa — suele construirse a partir de un score crediticio existente o de conteos de incidencias (atrasos, defaults) | Malo, Regular, Bueno, Excelente |

Ambas variables provienen de **fuentes de datos verificables** (estados de cuenta,
buró de crédito), pero su interpretación en términos de "riesgo" depende de criterios
expertos que varían entre instituciones, regiones y contextos económicos — exactamente
el tipo de conocimiento que un FIS puede encapsular.

### 2.2 Variable de Salida

| Variable | Rango | Naturaleza | Conjuntos difusos sugeridos |
|---|---|---|---|
| **Score de riesgo crediticio** | 0 – 100 | Continua, índice compuesto utilizado para decisiones (aprobar/rechazar, definir tasa de interés, límite de crédito) | Muy Bajo, Bajo, Moderado, Alto, Muy Alto |

La salida es un **índice de decisión**: no mide directamente una cantidad física,
sino que sintetiza el juicio de un analista experto en una escala continua que
posteriormente puede mapearse a decisiones discretas (por ejemplo, score > 70 →
rechazar; score < 30 → aprobar con tasa preferencial).

---

## 3. ¿Por qué Lógica Difusa es Recomendable Aquí?

1. **El conocimiento crediticio experto es naturalmente lingüístico.**
   Los analistas de crédito razonan en términos como "ingreso adecuado", "historial
   bueno" o "riesgo moderado", no con umbrales numéricos rígidos. Un FIS permite
   capturar directamente reglas como *"SI el ingreso relativo es Bajo Y el historial
   es Malo, ENTONCES el riesgo es Muy Alto"*, preservando el razonamiento experto sin
   forzarlo a una fórmula estadística cerrada.

2. **Evita las discontinuidades artificiales de los sistemas basados en reglas
   rígidas (`if-else`).**
   Un sistema de scoring tradicional basado en umbrales fijos (por ejemplo,
   "historial < 5 → rechazar") genera saltos abruptos: dos solicitantes con
   historiales de 4.9 y 5.1 recibirían decisiones opuestas, pese a ser
   prácticamente idénticos. La lógica difusa suaviza estas fronteras mediante
   funciones de membresía superpuestas, produciendo un score que varía de forma
   continua y más justa.

3. **Captura interacciones no-lineales entre criterios sin necesidad de un modelo
   estadístico complejo.**
   El efecto combinado de "buen ingreso + mal historial" no es simplemente la suma
   de ambos efectos por separado: un historial de incumplimientos reciente puede
   pesar mucho más que un buen ingreso actual. Las reglas difusas permiten codificar
   estas asimetrías directamente, sin necesidad de ajustar coeficientes de
   regresión o entrenar un modelo de machine learning con grandes volúmenes de
   datos históricos.

4. **Transparencia y explicabilidad regulatoria.**
   En el sector financiero, las decisiones de crédito suelen requerir
   justificación ante el cliente y ante reguladores. Un FIS basado en reglas
   lingüísticas es inherentemente más explicable ("se le asignó riesgo alto porque
   su historial de pago es regular y su ingreso relativo es bajo") que un modelo de
   caja negra (por ejemplo, una red neuronal profunda), lo cual lo hace atractivo
   como capa de decisión interpretable.

---

## 4. Modelo Sugerido: Mamdani vs. Sugeno

### Recomendación: **Mamdani**

**Justificación:**

- **Naturaleza evaluativa de la salida.** El "score de riesgo" es un juicio
  compuesto, análogo a una calificación cualitativa expresada numéricamente. Los
  modelos Mamdani son más adecuados cuando la salida representa una *evaluación
  experta* (Muy Bajo, Bajo, Moderado, Alto, Muy Alto) en lugar de una función
  matemática explícita de las entradas.

- **Interpretabilidad ante stakeholders no técnicos.** En un contexto financiero,
  poder mostrar "el score de riesgo es Alto porque el ingreso es Bajo y el
  historial es Regular" (lenguaje de las reglas Mamdani) es más útil para
  comunicación con comités de crédito o auditores que los coeficientes de una
  función Sugeno de tipo polinomial.

- **Diseño basado en conocimiento experto, no en datos masivos.** Este ejercicio
  parte de reglas que el profesor y los estudiantes definen con base en criterio
  experto (similar a cómo un analista de crédito razona), no de un proceso de
  ajuste automático sobre un histórico extenso de créditos otorgados. Mamdani es
  el enfoque natural cuando el FIS se construye "a mano".
s

**Cuándo se preferiría Sugeno en su lugar:** si la institución contara con un
histórico extenso de créditos (miles de casos con resultado conocido: pagó / no
pagó) y se quisiera **entrenar automáticamente** el FIS con ANFIS para optimizar la
predicción de incumplimiento, Sugeno sería la opción natural por su eficiencia
computacional y compatibilidad con el aprendizaje supervisado. Para este ejercicio
didáctico, basado en reglas expertas explícitas, Mamdani es la recomendación.

---

## 5. Estructura Sugerida del FIS

```
Entradas:
  Ingreso relativo a deuda [0, 10]
    - Insuficiente (trapmf)
    - Bajo         (trimf)
    - Adecuado     (trimf)
    - Alto         (trapmf)

  Historial de pago [0, 10]
    - Malo      (trapmf)
    - Regular   (trimf)
    - Bueno     (trimf)
    - Excelente (trapmf)

Salida:
  Score de riesgo crediticio [0, 100]
    - Muy Bajo  (trimf)
    - Bajo      (trimf)
    - Moderado  (trimf)
    - Alto      (trimf)
    - Muy Alto  (trapmf)

Ejemplos de reglas:
  SI Ingreso es Alto         Y Historial es Excelente ENTONCES Riesgo es Muy Bajo
  SI Ingreso es Adecuado     Y Historial es Bueno      ENTONCES Riesgo es Bajo
  SI Ingreso es Bajo         Y Historial es Regular    ENTONCES Riesgo es Moderado
  SI Ingreso es Insuficiente Y Historial es Malo       ENTONCES Riesgo es Muy Alto
  SI Ingreso es Alto         Y Historial es Malo       ENTONCES Riesgo es Alto
  SI Ingreso es Insuficiente Y Historial es Excelente  ENTONCES Riesgo es Moderado
```

Nota pedagógica: las dos últimas reglas son las más interesantes para discusión en
clase, ya que ilustran cómo el historial de pago puede pesar más que el ingreso
actual (asimetría de criterios), un matiz que un modelo lineal simple no captura.

---

## 6. Datos Sintéticos

El script `generar_datos_credito.m` genera un conjunto de datos sintéticos (ingreso
relativo, historial de pago, score de riesgo) siguiendo una función experta no-lineal
en la que el historial de pago tiene mayor peso relativo que el ingreso (asimetría
intencional), más ruido gaussiano para simular variabilidad real entre solicitantes.
Los datos se exportan en formato `.csv` y `.mat`, con partición train/test (80/20).
