# Sistema de Inferencia Difusa: Riesgo de Deshidratación en Ejercicio

**Autor:** Prof. D.Sc. Aboud Barsekh-Onji
**Institución:** Universidad Anáhuac México
**Contexto:** Material didáctico para curso de Sistemas de Inferencia Difusa

---

## 1. Descripción del Problema

Durante la práctica de ejercicio físico, el riesgo de deshidratación de una persona
depende principalmente de dos factores ambientales y temporales: la **temperatura
ambiente** en la que se realiza la actividad y la **duración** de dicha actividad.

El objetivo del sistema es estimar, a partir de estas dos variables, un **nivel de
riesgo de deshidratación** en una escala continua de 0 a 10, donde 0 representa
ausencia total de riesgo y 10 representa riesgo severo que requeriría intervención
inmediata.

Este problema es un ejemplo clásico en la literatura de lógica difusa porque combina
dos variables con una **interacción multiplicativa** muy marcada: el efecto conjunto
de calor y tiempo es mucho mayor que la suma de sus efectos individuales.

---

## 2. Naturaleza de las Variables

### 2.1 Variables de Entrada

| Variable | Rango | Naturaleza | Conjuntos difusos sugeridos |
|---|---|---|---|
| **Temperatura ambiente** (°C) | 15 – 45 | Continua, física, medible con instrumento (termómetro) | Fresco, Templado, Caluroso, Muy Caluroso |
| **Duración del ejercicio** (min) | 0 – 180 | Continua, temporal, controlable por el usuario | Corta, Moderada, Larga, Muy Larga |

Ambas variables son de naturaleza **continua y de fácil medición objetiva**, pero su
*efecto fisiológico* sobre el cuerpo humano no es lineal ni aditivo: el cuerpo tolera
bien temperaturas altas durante poco tiempo, y tolera bien ejercicio prolongado a
temperaturas bajas, pero la combinación de ambas condiciones extremas produce un
salto cualitativo en el riesgo.

### 2.2 Variable de Salida

| Variable | Rango | Naturaleza | Conjuntos difusos sugeridos |
|---|---|---|---|
| **Riesgo de deshidratación** | 0 – 10 | Continua, índice compuesto, no medible directamente (es una *estimación*) | Muy Bajo, Bajo, Moderado, Alto, Muy Alto |

La salida es un **índice**, no una magnitud física directamente observable. Esto es
típico de problemas donde la lógica difusa aporta valor: traducimos variables
medibles en un juicio experto (la opinión de un entrenador, médico deportivo o
fisiólogo) que normalmente se expresaría en lenguaje natural ("hace mucho calor y
llevas mucho rato, ten cuidado") a un número interpretable.

---

## 3. ¿Por qué Lógica Difusa es Recomendable Aquí?

1. **Las fronteras entre categorías son inherentemente imprecisas.**
   No existe un umbral exacto de temperatura (por ejemplo, 30.0 °C vs. 30.1 °C) que
   separe "templado" de "caluroso". La transición es gradual, y la lógica difusa
   modela esto de forma natural mediante funciones de membresía superpuestas, en
   lugar de reglas binarias tipo `if-else` que generarían discontinuidades
   artificiales en la salida.

2. **El conocimiento experto se expresa naturalmente como reglas lingüísticas.**
   Un especialista en medicina deportiva no diría "si T > 32.5 y t > 95, entonces
   riesgo = 7.3", sino algo como *"si hace mucho calor y el ejercicio es prolongado,
   el riesgo es alto"*. Los sistemas de inferencia difusa (FIS) permiten codificar
   directamente este tipo de conocimiento mediante reglas `SI...ENTONCES` con
   etiquetas lingüísticas (Caluroso, Larga, Alto), preservando la interpretabilidad
   del modelo.

3. **Captura interacciones no-lineales sin necesitar una fórmula matemática explícita.**
   La relación entre temperatura, tiempo y riesgo de deshidratación involucra
   procesos fisiológicos complejos (sudoración, termorregulación, pérdida de
   electrolitos) que serían difíciles de modelar con una ecuación cerrada. Un FIS
   permite que esta relación emerja de la combinación de reglas simples, sin
   necesidad de derivar un modelo fisiológico completo.

4. **Robustez ante ruido e incertidumbre en la medición.**
   En la práctica, la "temperatura ambiente" percibida puede variar según humedad,
   viento o exposición al sol, y la "duración" reportada por el usuario puede tener
   pequeños errores. Los sistemas difusos son tolerantes a estas variaciones, ya que
   las funciones de membresía suavizan el efecto de pequeñas perturbaciones en la
   entrada.

---

## 4. Modelo Sugerido: Mamdani vs. Sugeno

### Recomendación: **Mamdani**

**Justificación:**

- **El dominio es de naturaleza evaluativa/cualitativa.** El "riesgo de
  deshidratación" no es una cantidad física medible, sino un juicio compuesto. Los
  modelos Mamdani son más naturales cuando la salida representa una *evaluación* en
  lugar de una *función matemática* de las entradas (caso típico de Sugeno, donde la
  salida suele ser una combinación lineal o constante de las entradas).

- **No se requiere optimización por gradiente.** A diferencia de Sugeno, que suele
  combinarse con ANFIS para ajuste automático de parámetros, este es un ejercicio
  donde el conocimiento experto (reglas + funciones de membresía) se define
  directamente, sin necesidad de entrenamiento numérico.

- **Visualización de superficie con `gensurf`.** Mamdani facilita la generación de
  superficies de control suaves y fáciles de interpretar visualmente con las
  herramientas del *Fuzzy Logic Toolbox* de MATLAB (`mamfis`, `addRule`, `gensurf`,
  `plotmf`), ideal para el componente visual del curso.

**Cuándo se preferiría Sugeno en su lugar:** si el objetivo fuera entrenar el FIS
automáticamente con datos (ANFIS) para minimizar el error contra mediciones reales de
hidratación corporal (por ejemplo, pérdida de peso por sudoración medida en
laboratorio), Sugeno sería preferible por su eficiencia computacional y su
compatibilidad con métodos de aprendizaje. Para este ejercicio didáctico —donde se
parte de reglas expertas— Mamdani es la opción recomendada.

---

## 5. Estructura Sugerida del FIS

```
Entradas:
  Temperatura ambiente [15, 45] °C
    - Fresco       (trimf)
    - Templado     (trimf)
    - Caluroso     (trimf)
    - Muy Caluroso (trapmf)

  Duración del ejercicio [0, 180] min
    - Corta        (trimf)
    - Moderada     (trimf)
    - Larga        (trimf)
    - Muy Larga    (trapmf)

Salida:
  Riesgo de deshidratación [0, 10]
    - Muy Bajo  (trimf)
    - Bajo      (trimf)
    - Moderado  (trimf)
    - Alto      (trimf)
    - Muy Alto  (trapmf)

Ejemplos de reglas:
  SI Temperatura es Fresco        Y Duración es Corta       ENTONCES Riesgo es Muy Bajo
  SI Temperatura es Caluroso      Y Duración es Larga       ENTONCES Riesgo es Alto
  SI Temperatura es Muy Caluroso  Y Duración es Muy Larga    ENTONCES Riesgo es Muy Alto
  SI Temperatura es Muy Caluroso  Y Duración es Corta        ENTONCES Riesgo es Moderado
  SI Temperatura es Fresco        Y Duración es Muy Larga    ENTONCES Riesgo es Bajo
```

---

## 6. Datos Sintéticos

El script `generar_datos_deshidratacion.m` genera un conjunto de datos sintéticos
(temperatura, duración, riesgo) siguiendo una función experta no-lineal con
interacción multiplicativa, más ruido gaussiano para simular variabilidad real. Los
datos se exportan en formato `.csv` y `.mat`, con partición train/test (80/20), listos
para entrenar o validar el FIS construido por los estudiantes.
