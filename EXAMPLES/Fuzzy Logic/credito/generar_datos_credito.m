% TÍTULO: Generación de Datos Sintéticos — Score de Riesgo Crediticio
%         Simplificado (FIS Mamdani)
% Autor:  Prof. D.Sc. Aboud Barsekh-Onji
% Institución: Universidad Anáhuac México
% Fecha:  Junio 2026
%
% Descripción:
%   Genera N observaciones sintéticas (ingreso_relativo, historial, riesgo)
%   con una función experta no-lineal donde el historial de pago tiene
%   mayor peso relativo que el ingreso (asimetría intencional), adecuada
%   para construir/validar un FIS Mamdani de dos entradas.
%
%   Entradas : ingreso_relativo ∈ [0, 10]  (ratio ingreso/deuda normalizado)
%              historial_pago   ∈ [0, 10]
%   Salida   : riesgo_score      ∈ [0, 100]
%
%   Regla experta embebida (objetivo de la superficie):
%     - Ingreso alto + Historial excelente → riesgo ≈ 3   (muy bajo)
%     - Ingreso alto + Historial malo      → riesgo ≈ 60  (alto, pesa el historial)
%     - Ingreso bajo + Historial excelente → riesgo ≈ 40  (moderado)
%     - Ingreso bajo + Historial malo      → riesgo ≈ 95  (muy alto, sinergia negativa)
%
%% ========================================================================

clc; clear; close all;
rng(42);  % Semilla fija → reproducibilidad

%% -----------------------------------------------------------------------
%  1. PARÁMETROS DE CONFIGURACIÓN
%% -----------------------------------------------------------------------

N         = 500;  % Número de muestras sintéticas
ruido_std = 4.0;  % Desviación estándar del ruido gaussiano (en escala 0-100)

% Límites de las variables
lim_ingreso   = [0, 10];
lim_historial = [0, 10];
lim_riesgo    = [0, 100];

% Pesos relativos en la función experta
% El historial de pago pesa MÁS que el ingreso (asimetría intencional:
% un mal historial es más "castigado" que un buen ingreso "premiado")
w_ingreso = 0.35;
w_hist    = 0.45;
w_int     = 0.20;  % Término de interacción (sinergia negativa cuando ambos son malos)

%% -----------------------------------------------------------------------
%  2. GENERACIÓN DE ENTRADAS
%% -----------------------------------------------------------------------

% Distribución base uniforme sobre todo el espacio de entrada
ingreso_relativo = lim_ingreso(1) + (lim_ingreso(2) - lim_ingreso(1)) * rand(N, 1);
historial_pago   = lim_historial(1) + (lim_historial(2) - lim_historial(1)) * rand(N, 1);

% Reforzar 20% de muestras en las esquinas del espacio (perfiles
% extremos: cliente ideal, cliente de alto riesgo, y combinaciones mixtas)
N_extremos = round(0.20 * N);
idx_extr   = randperm(N, N_extremos);

esquinas_ingreso = [lim_ingreso(1),   lim_ingreso(1),   lim_ingreso(2),   lim_ingreso(2)];
esquinas_hist    = [lim_historial(1), lim_historial(2), lim_historial(1), lim_historial(2)];
asign            = randi(4, N_extremos, 1);

ingreso_relativo(idx_extr) = esquinas_ingreso(asign)' + randn(N_extremos, 1) * 0.4;
historial_pago(idx_extr)   = esquinas_hist(asign)'    + randn(N_extremos, 1) * 0.4;

% Recortar al dominio válido
ingreso_relativo = max(lim_ingreso(1),   min(lim_ingreso(2),   ingreso_relativo));
historial_pago   = max(lim_historial(1), min(lim_historial(2), historial_pago));

%% -----------------------------------------------------------------------
%  3. FUNCIÓN EXPERTA DE RIESGO (asimetría historial > ingreso)
%% -----------------------------------------------------------------------
%
%  Normalizar entradas a [0, 1]:
%    x = ingreso_relativo / 10     (a mayor x, MENOR riesgo)
%    y = historial_pago   / 10     (a mayor y, MENOR riesgo)
%
%  Para que el riesgo sea ALTO cuando ingreso y/o historial son BAJOS,
%  trabajamos con los "complementos" (1-x) y (1-y) como impulsores de riesgo.
%
%  Componente individual:
%    f(x) = (1 - x)^1.3   (penalización por bajo ingreso, ligeramente acelerada)
%    g(y) = (1 - y)^1.6   (penalización por mal historial, MÁS acelerada → asimetría)
%
%  Componente de interacción (sinergia negativa):
%    h(x,y) = ((1-x) * (1-y))^0.9
%
%  Score combinado ∈ [0, 1]:
%    score = w_ingreso*f(x) + w_hist*g(y) + w_int*h(x,y)
%
%  Escalado final a [0, 100]

x = ingreso_relativo / lim_ingreso(2);
y = historial_pago   / lim_historial(2);

f_ingreso = (1 - x) .^ 1.3;
g_hist    = (1 - y) .^ 1.6;
h_int     = ((1 - x) .* (1 - y)) .^ 0.9;

score = w_ingreso * f_ingreso + w_hist * g_hist + w_int * h_int;

% Normalizar por el valor máximo teórico (x=0, y=0 → riesgo máximo)
score_max = w_ingreso * 1 + w_hist * 1 + w_int * 1;
score = score / score_max;

% Escalar a [0, 100]
riesgo_det = lim_riesgo(2) * score;

%% -----------------------------------------------------------------------
%  4. AÑADIR RUIDO GAUSSIANO (variabilidad entre solicitantes)
%% -----------------------------------------------------------------------

ruido       = randn(N, 1) * ruido_std;
riesgo_score = riesgo_det + ruido;

% Recortar al rango válido [0, 100]
riesgo_score = max(lim_riesgo(1), min(lim_riesgo(2), riesgo_score));

%% -----------------------------------------------------------------------
%  5. EXPORTAR DATASET
%% -----------------------------------------------------------------------

T = table(ingreso_relativo, historial_pago, riesgo_score, ...
    'VariableNames', {'Ingreso_Relativo', 'Historial_Pago', 'Score_Riesgo'});

nombre_archivo = 'datos_credito_sinteticos.csv';
writetable(T, nombre_archivo);
fprintf('✔  Dataset exportado: %s  (%d muestras)\n', nombre_archivo, N);

save('datos_credito_sinteticos.mat', 'ingreso_relativo', 'historial_pago', 'riesgo_score', 'T');
fprintf('✔  Workspace guardado: datos_credito_sinteticos.mat\n\n');

%% -----------------------------------------------------------------------
%  6. ESTADÍSTICAS DESCRIPTIVAS
%% -----------------------------------------------------------------------

fprintf('=== ESTADÍSTICAS DESCRIPTIVAS ===\n');
fprintf('Variable              Min     Max    Media   Desv.Est.\n');
fprintf('%-20s %6.2f  %6.2f  %6.2f  %6.2f\n', ...
    'Ingreso Relativo', min(ingreso_relativo), max(ingreso_relativo), mean(ingreso_relativo), std(ingreso_relativo));
fprintf('%-20s %6.2f  %6.2f  %6.2f  %6.2f\n', ...
    'Historial Pago',   min(historial_pago),   max(historial_pago),   mean(historial_pago),   std(historial_pago));
fprintf('%-20s %6.2f  %6.2f  %6.2f  %6.2f\n\n', ...
    'Score Riesgo',     min(riesgo_score),     max(riesgo_score),     mean(riesgo_score),     std(riesgo_score));

%% -----------------------------------------------------------------------
%  7. VISUALIZACIÓN
%% -----------------------------------------------------------------------

%% 7a. Scatter plots
figure('Color','w','Position',[100 100 1200 450]);

subplot(1,2,1);
scatter(ingreso_relativo, riesgo_score, 30, historial_pago, 'filled', 'MarkerFaceAlpha', 0.6);
colorbar; colormap(turbo);
xlabel('Ingreso Relativo a Deuda', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('Score de Riesgo (0-100)',  'FontSize', 12, 'Interpreter', 'latex');
title('Riesgo vs. Ingreso (color $=$ Historial)', ...
    'FontSize', 13, 'Interpreter', 'latex');
grid on; set(gca, 'FontSize', 11);

subplot(1,2,2);
scatter(historial_pago, riesgo_score, 30, ingreso_relativo, 'filled', 'MarkerFaceAlpha', 0.6);
colorbar; colormap(turbo);
xlabel('Historial de Pago',       'FontSize', 12, 'Interpreter', 'latex');
ylabel('Score de Riesgo (0-100)', 'FontSize', 12, 'Interpreter', 'latex');
title('Riesgo vs. Historial (color $=$ Ingreso)', ...
    'FontSize', 13, 'Interpreter', 'latex');
grid on; set(gca, 'FontSize', 11);

sgtitle('Dataset Sintético — Score de Riesgo Crediticio', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontWeight', 'bold');

%% 7b. Superficie de respuesta experta (sin ruido)
figure('Color','w','Position',[100 100 700 560]);

[Xg, Yg] = meshgrid(linspace(lim_ingreso(1), lim_ingreso(2), 50), ...
                     linspace(lim_historial(1), lim_historial(2), 50));

Xg_n = Xg / lim_ingreso(2);
Yg_n = Yg / lim_historial(2);

f_g = (1 - Xg_n) .^ 1.3;
g_g = (1 - Yg_n) .^ 1.6;
h_g = ((1 - Xg_n) .* (1 - Yg_n)) .^ 0.9;

sc_g = (w_ingreso * f_g + w_hist * g_g + w_int * h_g) / score_max;
Zg   = lim_riesgo(2) * sc_g;

surf(Xg, Yg, Zg, 'EdgeColor', 'none', 'FaceAlpha', 0.85);
colormap(turbo); colorbar;
xlabel('Ingreso Relativo a Deuda', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('Historial de Pago',        'FontSize', 12, 'Interpreter', 'latex');
zlabel('Score de Riesgo (0-100)',  'FontSize', 12, 'Interpreter', 'latex');
title('Superficie Experta de Riesgo Crediticio (sin ruido)', ...
    'FontSize', 13, 'Interpreter', 'latex');
view(45, 30); grid on;
set(gca, 'FontSize', 11);

%% 7c. Histograma de la salida
figure('Color','w','Position',[100 100 600 420]);
histogram(riesgo_score, 25, 'FaceColor', [0.30 0.55 0.35], ...
    'EdgeColor', 'white', 'FaceAlpha', 0.85);
xlabel('Score de Riesgo (0-100)', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('Frecuencia',              'FontSize', 12, 'Interpreter', 'latex');
title('Distribución del Score de Riesgo Sintético', ...
    'FontSize', 13, 'Interpreter', 'latex');
grid on; set(gca, 'FontSize', 11);

%% -----------------------------------------------------------------------
%  8. PARTICIÓN TRAIN / TEST
%% -----------------------------------------------------------------------

pct_train = 0.80;
idx_perm  = randperm(N);
n_train   = round(pct_train * N);

idx_train = idx_perm(1 : n_train);
idx_test  = idx_perm(n_train+1 : end);

T_train = T(idx_train, :);
T_test  = T(idx_test,  :);

writetable(T_train, 'datos_credito_train.csv');
writetable(T_test,  'datos_credito_test.csv');

fprintf('=== PARTICIÓN TRAIN / TEST ===\n');
fprintf('Train: %d muestras (%.0f%%)  →  datos_credito_train.csv\n', ...
    n_train, pct_train*100);
fprintf('Test : %d muestras (%.0f%%)  →  datos_credito_test.csv\n\n', ...
    N - n_train, (1-pct_train)*100);

fprintf('¡Listo! Usa T_train para validar el FIS Mamdani y T_test para evaluarlo.\n');
