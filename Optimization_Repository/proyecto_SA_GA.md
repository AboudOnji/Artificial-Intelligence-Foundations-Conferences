---
title: "Proyecto: Optimización Metaheurística con Simulated Annealing y Algoritmos Genéticos"
subtitle: "Fundamentos de Inteligencia Artificial — Universidad Anáhuac México"
author: "Prof. Dr. Aboud Barsekh-Onji"
date: "Abril 2026"
geometry: "margin=2.5cm, top=3cm, bottom=3cm"
fontsize: 11pt
documentclass: article
colorlinks: true
linkcolor: "blue"
urlcolor: "blue"
header-includes:
  - \usepackage{fancyhdr}
  - \usepackage{booktabs}
  - \usepackage{xcolor}
  - \usepackage{listings}
  - \usepackage{mdframed}
  - \usepackage{enumitem}
  - \pagestyle{fancy}
  - \fancyhf{}
  - \fancyhead[L]{\small Universidad Anáhuac México --- Fundamentos de IA}
  - \fancyhead[R]{\small Prof. Dr. Barsekh-Onji}
  - \fancyfoot[C]{\thepage}
  - \definecolor{anahuac}{RGB}{0,56,101}
  - \definecolor{goldcolor}{RGB}{180,140,0}
  - \definecolor{codeblue}{RGB}{0,0,180}
  - \definecolor{codered}{RGB}{160,0,0}
  - \definecolor{codegray}{RGB}{110,110,110}
  - \lstset{language=Matlab,basicstyle=\small\ttfamily,keywordstyle=\color{codeblue}\bfseries,commentstyle=\color{codegray}\itshape,stringstyle=\color{codered},numbers=left,numberstyle=\tiny\color{codegray},frame=single,breaklines=true,keepspaces=true,tabsize=2}
  - \newmdenv[linecolor=anahuac,backgroundcolor=blue!5,linewidth=1.5pt,innerleftmargin=8pt,innerrightmargin=8pt,innertopmargin=6pt,innerbottommargin=6pt]{instruccion}
  - \newmdenv[linecolor=goldcolor,backgroundcolor=yellow!8,linewidth=1.5pt,innerleftmargin=8pt,innerrightmargin=8pt,innertopmargin=6pt,innerbottommargin=6pt]{entregable}
---

\vspace{0.3cm}
\begin{mdframed}[linecolor=anahuac,backgroundcolor=anahuac!8,linewidth=2pt]
\textbf{Objetivo del Proyecto.} Ampliar un script base de \textbf{Simulated Annealing (SA)} para aplicarlo a cuatro funciones de prueba clásicas en optimización, y luego implementar el mismo experimento usando \textbf{Algoritmos Genéticos (GA)}. Al finalizar, el alumno será capaz de adaptar algoritmos metaheurísticos a funciones arbitrarias, visualizar paisajes de optimización y comparar el desempeño de distintas metaheurísticas.
\end{mdframed}

\vspace{0.3cm}

# Archivos de Partida

La carpeta del proyecto contiene los siguientes archivos que ya están implementados:

| Archivo | Descripción |
|:---|:---|
| `main_SA.m` | Script principal de Simulated Annealing. Funciona con la función Ackley. |
| `Ackley.m` | Función Ackley (fuente: SFU Optimization Test Functions). |

Ejecuta `main_SA.m` en MATLAB **antes de cualquier modificación** para verificar que funciona. Debes obtener un valor de función cercano a $f^* = 0$ con $x^* \approx (0,\,0)$.

---

# Parte 1 — Visualización de la Función Ackley

\begin{instruccion}
\textbf{Tarea 1.1 --- Gráfica de superficie.} Crea un script \texttt{plot\_ackley.m} que genere la gráfica de superficie 3D y el mapa de contorno de la función Ackley en 2D sobre el dominio $[-5,\,5]^2$. Usa \texttt{surf}, \texttt{contourf} y \texttt{shading interp}.
\end{instruccion}

**Guía:** El script `main_SA.m` ya genera un contorno en la subgráfica 4 cuando `d = 2`. Inspírate en esa sección para construir `plot_ackley.m`.

**Preguntas a responder en el reporte:**

1. ¿Por qué la función Ackley es un reto para los optimizadores? Identifica en la gráfica el mínimo global y los mínimos locales.
2. ¿Qué relación tiene la temperatura inicial $T_0$ del SA con el paisaje de la función?

---

# Parte 2 — Descarga y Adaptación de Nuevas Funciones

Descarga los scripts MATLAB del repositorio de funciones de prueba de la Universidad Simon Fraser:

\begin{center}
\texttt{https://www.sfu.ca/\textasciitilde ssurjano/optimization.html}
\end{center}

Necesitas las siguientes tres funciones. Para cada una, navega a su página, descarga el archivo `.m` y **colócalo en la misma carpeta** que `main_SA.m`.

## 2.1 Bukin Function N. 6

- **Página:** `https://www.sfu.ca/~ssurjano/bukin6.html`
- **Archivo a descargar:** `bukin6.m`
- **Dimensión:** $d = 2$ únicamente
- **Dominio:** $x_1 \in [-15,\,-5]$, $\quad x_2 \in [-3,\;3]$ *(dominio asimétrico)*
- **Óptimo global:** $f(-10,\;1) = 0$
- **Fórmula:**
$$f(\mathbf{x}) = 100\sqrt{|x_2 - 0.01\,x_1^2|} + 0.01\,|x_1 + 10|$$

> **Nota importante:** los límites de búsqueda son **diferentes** para $x_1$ y $x_2$. El vector `lb` y `ub` en `main_SA.m` debe reflejar esto: `lb = [-15, -3]`, `ub = [-5, 3]`.

## 2.2 Levy Function

- **Página:** `https://www.sfu.ca/~ssurjano/levy.html`
- **Archivo a descargar:** `levy.m`
- **Dimensión:** cualquier $d \geq 1$ (usa $d = 2$ para comparar, $d = 10$ como experimento extra)
- **Dominio:** $x_i \in [-10,\;10]$
- **Óptimo global:** $f(1,\ldots,1) = 0$
- **Fórmula:** sea $w_i = 1 + \tfrac{x_i - 1}{4}$, entonces
$$f(\mathbf{x}) = \sin^2(\pi w_1) + \sum_{i=1}^{d-1}(w_i-1)^2\left[1+10\sin^2(\pi w_{i+1})\right] + (w_d-1)^2\left[1+\sin^2(2\pi w_d)\right]$$

## 2.3 Rastrigin Function

- **Página:** `https://www.sfu.ca/~ssurjano/rastr.html`
- **Archivo a descargar:** `rastr.m`
- **Dimensión:** cualquier $d \geq 1$ (usa $d = 2$ para comparar, $d = 10$ como experimento extra)
- **Dominio:** $x_i \in [-5.12,\;5.12]$
- **Óptimo global:** $f(0,\ldots,0) = 0$
- **Fórmula:**
$$f(\mathbf{x}) = 10d + \sum_{i=1}^{d}\left[x_i^2 - 10\cos(2\pi x_i)\right]$$

---

# Parte 3 — SA sobre las Cuatro Funciones

\begin{instruccion}
\textbf{Tarea 3.1 --- Adaptar \texttt{main\_SA.m} para cada función.} Para cada una de las tres funciones descargadas, crea una copia de \texttt{main\_SA.m} con el nombre indicado y modifica \textbf{únicamente la sección} marcada con \texttt{>>> CONFIGURAR AQUÍ <<<}.
\end{instruccion}

| Script a crear | Función | `FUN_NAME` | `d` | `lb` | `ub` |
|:---|:---|:---:|:---:|:---|:---|
| `main_SA_bukin6.m` | Bukin N.6 | `'bukin6'` | `2` | `[-15, -3]` | `[-5, 3]` |
| `main_SA_levy.m` | Levy | `'levy'` | `2` | `[-10, -10]` | `[10, 10]` |
| `main_SA_rastrigin.m` | Rastrigin | `'rastr'` | `2` | `[-5.12, -5.12]` | `[5.12, 5.12]` |

**Cambios mínimos requeridos en cada copia** (el resto del script queda intacto):

```matlab
% >>> CONFIGURAR AQUÍ <<<
FUN_NAME       = 'bukin6';
objective_fun  = @(x) bukin6(x);   % <-- cambia al nombre de tu función

d  = 2;
lb = [-15, -3];                     % <-- límites inferiores
ub = [ -5,  3];                     % <-- límites superiores
```

\begin{instruccion}
\textbf{Tarea 3.2 --- Ajuste de hiperparámetros.} El SA tiene tres parámetros críticos: \texttt{T0}, \texttt{alpha} y \texttt{sigma}. Para cada función, experimenta con al menos dos configuraciones distintas y reporta cuál dio mejor resultado. Guía de ajuste:
\begin{itemize}
  \item Funciones muy multimodales (Bukin, Rastrigin): necesitan \texttt{T0} más alto y \texttt{alpha} cercano a 1 (0.995--0.999).
  \item Funciones más suaves (Levy): pueden funcionar bien con \texttt{T0} menor.
  \item Si converge demasiado rápido a un mal mínimo: reduce \texttt{alpha} (enfría más lento).
\end{itemize}
\end{instruccion}

\begin{instruccion}
\textbf{Tarea 3.3 --- Tabla comparativa.} Ejecuta cada script \textbf{10 veces} (usa semillas del 1 al 10: \texttt{rng(1)}, \texttt{rng(2)}, \ldots) y completa la tabla siguiente en tu reporte.
\end{instruccion}

| Función | $f^*$ teórico | Media $f_{best}$ | Desv. est. | Mejor $f_{best}$ | Peor $f_{best}$ |
|:---|:---:|:---:|:---:|:---:|:---:|
| Ackley | 0 | | | | |
| Bukin N.6 | 0 | | | | |
| Levy | 0 | | | | |
| Rastrigin | 0 | | | | |

**Pregunta:** ¿Qué función resultó más difícil para el SA? ¿Por qué?

---

# Parte 4 — Algoritmos Genéticos sobre las Mismas Funciones

\begin{instruccion}
\textbf{Tarea 4.1 --- Script \texttt{main\_GA.m}.} Crea \texttt{main\_GA.m} usando la función \texttt{ga()} del \textbf{MATLAB Optimization Toolbox} (disponible en R2025b). El script debe seguir la misma filosofía modular que \texttt{main\_SA.m}: una sección \texttt{>>> CONFIGURAR AQUÍ <<<} donde se cambia la función, la dimensión y los límites. Documenta cada parámetro del GA con comentarios explicativos, igual que en \texttt{main\_SA.m}.
\end{instruccion}

\begin{instruccion}
\textbf{Tarea 4.2 --- GA para las cuatro funciones.} Crea cuatro scripts (uno por función) modificando solo la sección de configuración. Completa la misma tabla comparativa que en la Tarea 3.3, ahora para el GA.
\end{instruccion}

\begin{instruccion}
\textbf{Tarea 4.3 --- Comparación SA vs.\ GA.} Genera una gráfica de barras comparando la media del error absoluto $|f_{best} - f^*|$ de SA y GA para cada función. Responde en el reporte:
\begin{enumerate}[noitemsep]
  \item ¿Cuál algoritmo convergió mejor en cada función?
  \item ¿Cuál fue más rápido en tiempo de cómputo?
  \item ¿Qué parámetro del GA tiene mayor impacto sobre la calidad del resultado?
\end{enumerate}
\end{instruccion}

---

# Parte 5 — Experimento de Alta Dimensión (Extra)

\begin{instruccion}
\textbf{Tarea 5 (Extra) --- SA y GA en $d = 10$.} Repite el experimento de las Partes 3 y 4 para la función \textbf{Rastrigin} con $d = 10$ dimensiones. ¿Cómo cambia la dificultad del problema? ¿Cuál algoritmo escala mejor?
\end{instruccion}

---

# Entregables

\begin{entregable}
\textbf{Qué debes entregar (archivo .zip):}

\medskip
\textbf{1. Scripts MATLAB:}
\begin{itemize}[noitemsep]
  \item \texttt{main\_SA.m} (original o con ajustes documentados)
  \item \texttt{main\_SA\_bukin6.m}, \texttt{main\_SA\_levy.m}, \texttt{main\_SA\_rastrigin.m}
  \item \texttt{main\_GA.m}, \texttt{main\_GA\_bukin6.m}, \texttt{main\_GA\_levy.m}, \texttt{main\_GA\_rastrigin.m}
  \item \texttt{plot\_ackley.m}
  \item Funciones descargadas: \texttt{Ackley.m}, \texttt{bukin6.m}, \texttt{levy.m}, \texttt{rastr.m}
\end{itemize}

\medskip
\textbf{2. Reporte en PDF} que incluya:
\begin{itemize}[noitemsep]
  \item Respuestas a las preguntas de cada sección
  \item Gráficas de convergencia del SA y del GA para cada función (1 figura por función)
  \item Tablas comparativas de la Tarea 3.3 y 4.2
  \item Gráfica de barras SA vs.\ GA (Tarea 4.3)
  \item Conclusión de media página: ¿qué aprendiste sobre la selección de metaheurísticas?
\end{itemize}
\end{entregable}

---

# Criterios de Evaluación

| Criterio | Puntos |
|:---|:---:|
| Código funcional: SA en las 4 funciones | 30 |
| Código funcional: GA en las 4 funciones | 25 |
| Visualización de funciones y convergencia | 15 |
| Análisis y tablas comparativas | 20 |
| Conclusión y calidad del reporte | 10 |
| **Total** | **100** |

---

# Referencias

- Kirkpatrick, S., Gelatt, C.D., Vecchi, M.P. (1983). *Optimization by Simulated Annealing*. **Science**, 220(4598), 671--680.
- Holland, J.H. (1992). *Adaptation in Natural and Artificial Systems*. MIT Press.
- Surjanovic, S. & Bingham, D. (2013). *Virtual Library of Simulation Experiments: Test Functions and Datasets*. Simon Fraser University. `https://www.sfu.ca/~ssurjano/optimization.html`
- MathWorks (2025). *ga — Find minimum of function using genetic algorithm*. MATLAB R2025b Documentation.
