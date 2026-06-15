%% ========================================================================
% TÍTULO: Generación de Datos Sintéticos — Riesgo de Deshidratación
%         en Ejercicio (FIS Mamdani)
% Autor:  Prof. D.Sc. Aboud Barsekh-Onji
% Institución: Universidad Anáhuac México
% Fecha:  Junio 2026
%
% Descripción:
%   Genera N observaciones sintéticas (temperatura, duración, riesgo) con
%   una función experta no-lineal de interacción multiplicativa fuerte,
%   adecuada para construir/validar un FIS Mamdani de dos entradas.
%
%   Entradas : temperatura ∈ [15, 45] °C
%              duracion    ∈ [0, 180]  min
%   Salida   : riesgo       ∈ [0, 10]
%
%   Regla experta embebida (objetivo de la superficie):
%     - Temp baja  + Duración corta  → riesgo ≈ 0.5
%     - Temp baja  + Duración larga  → riesgo ≈ 3
%     - Temp alta  + Duración corta  → riesgo ≈ 3.5
%     - Temp alta  + Duración larga  → riesgo ≈ 9.5  (efecto sinérgico)
%
%% ========================================================================

clc; clear; close all;
rng(42);  % Semilla fija → reproducibilidad

%% -----------------------------------------------------------------------
%  1. PARÁMETROS DE CONFIGURACIÓN
%% -----------------------------------------------------------------------

N         = 500;   % Número de muestras sintéticas
ruido_std = 0.4;   % Desviación estándar del ruido gaussiano aditivo

% Límites de las variables
lim_temp     = [15, 45];   % °C
lim_duracion = [0, 180];   % min
lim_riesgo   = [0, 10];

% Pesos relativos en la función experta
w_temp = 0.35;  % Peso del efecto individual de la temperatura
w_dur  = 0.25;  % Peso del efecto individual de la duración
w_int  = 0.40;  % Peso del término de interacción multiplicativa (dominante)

%% -----------------------------------------------------------------------
%  2. GENERACIÓN DE ENTRADAS
%% -----------------------------------------------------------------------

% Distribución base uniforme sobre todo el espacio de entrada
temperatura = lim_temp(1) + (lim_temp(2) - lim_temp(1)) * rand(N, 1);
duracion    = lim_duracion(1) + (lim_duracion(2) - lim_duracion(1)) * rand(N, 1);

% Reforzar 20% de muestras en las esquinas del espacio (zonas críticas:
% calor extremo + ejercicio prolongado, y sus combinaciones opuestas)
N_extremos = round(0.20 * N);
idx_extr   = randperm(N, N_extremos);

esquinas_temp = [lim_temp(1), lim_temp(1), lim_temp(2), lim_temp(2)];
esquinas_dur  = [lim_duracion(1), lim_duracion(2), lim_duracion(1), lim_duracion(2)];
asign         = randi(4, N_extremos, 1);

temperatura(idx_extr) = esquinas_temp(asign)' + randn(N_extremos, 1) * 1.0;
duracion(idx_extr)    = esquinas_dur(asign)'  + randn(N_extremos, 1) * 3.0;

% Recortar al dominio válido
temperatura = max(lim_temp(1), min(lim_temp(2), temperatura));
duracion    = max(lim_duracion(1), min(lim_duracion(2), duracion));

%% -----------------------------------------------------------------------
%  3. FUNCIÓN EXPERTA DE RIESGO (interacción multiplicativa fuerte)
%% -----------------------------------------------------------------------
%
%  Normalizar entradas a [0, 1]:
%    x = (temperatura - 15) / (45 - 15)
%    y = duracion / 180
%
%  Componente individual (efecto suave tipo sigmoide):
%    f(x) = x^1.5   (crecimiento acelerado a medida que sube la temperatura)
%    g(y) = y^1.2   (crecimiento ligeramente acelerado con la duración)
%
%  Componente de interacción (DOMINANTE):
%    h(x,y) = (x * y)^0.8
%
%  Score combinado ∈ [0, 1]:
%    score = w_temp*f(x) + w_dur*g(y) + w_int*h(x,y)
%
%  Escalado final a [0, 10]

x = (temperatura - lim_temp(1)) / (lim_temp(2) - lim_temp(1));
y = (duracion - lim_duracion(1)) / (lim_duracion(2) - lim_duracion(1));

f_temp = x .^ 1.5;
g_dur  = y .^ 1.2;
h_int  = (x .* y) .^ 0.8;

score = w_temp * f_temp + w_dur * g_dur + w_int * h_int;

% Normalizar por el valor máximo teórico (x=1, y=1)
score_max = w_temp * 1 + w_dur * 1 + w_int * 1;
score = score / score_max;

% Escalar a [0, 10]
riesgo_det = lim_riesgo(2) * score;

%% -----------------------------------------------------------------------
%  4. AÑADIR RUIDO GAUSSIANO (variabilidad fisiológica individual)
%% -----------------------------------------------------------------------

ruido  = randn(N, 1) * ruido_std;
riesgo = riesgo_det + ruido;

% Recortar al rango válido [0, 10]
riesgo = max(lim_riesgo(1), min(lim_riesgo(2), riesgo));

%% -----------------------------------------------------------------------
%  5. EXPORTAR DATASET
%% -----------------------------------------------------------------------

T = table(temperatura, duracion, riesgo, ...
    'VariableNames', {'Temperatura_C', 'Duracion_min', 'Riesgo_Deshidratacion'});

nombre_archivo = 'datos_deshidratacion_sinteticos.csv';
writetable(T, nombre_archivo);
fprintf('✔  Dataset exportado: %s  (%d muestras)\n', nombre_archivo, N);

save('datos_deshidratacion_sinteticos.mat', 'temperatura', 'duracion', 'riesgo', 'T');
fprintf('✔  Workspace guardado: datos_deshidratacion_sinteticos.mat\n\n');

%% -----------------------------------------------------------------------
%  6. ESTADÍSTICAS DESCRIPTIVAS
%% -----------------------------------------------------------------------

fprintf('=== ESTADÍSTICAS DESCRIPTIVAS ===\n');
fprintf('Variable              Min     Max    Media   Desv.Est.\n');
fprintf('%-20s %6.2f  %6.2f  %6.2f  %6.2f\n', ...
    'Temperatura (C)', min(temperatura), max(temperatura), mean(temperatura), std(temperatura));
fprintf('%-20s %6.2f  %6.2f  %6.2f  %6.2f\n', ...
    'Duracion (min)',  min(duracion),    max(duracion),    mean(duracion),    std(duracion));
fprintf('%-20s %6.2f  %6.2f  %6.2f  %6.2f\n\n', ...
    'Riesgo (0-10)',   min(riesgo),      max(riesgo),      mean(riesgo),      std(riesgo));

%% -----------------------------------------------------------------------
%  7. VISUALIZACIÓN
%% -----------------------------------------------------------------------

%% 7a. Scatter plots
figure('Color','w','Position',[100 100 1200 450]);

subplot(1,2,1);
scatter(temperatura, riesgo, 30, duracion, 'filled', 'MarkerFaceAlpha', 0.6);
colorbar; colormap(turbo);
xlabel('Temperatura ($^\circ$C)', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('Riesgo de Deshidratacion', 'FontSize', 12, 'Interpreter', 'latex');
title('Riesgo vs. Temperatura (color $=$ Duracion)', ...
    'FontSize', 13, 'Interpreter', 'latex');
grid on; set(gca, 'FontSize', 11);

subplot(1,2,2);
scatter(duracion, riesgo, 30, temperatura, 'filled', 'MarkerFaceAlpha', 0.6);
colorbar; colormap(turbo);
xlabel('Duracion (min)', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('Riesgo de Deshidratacion', 'FontSize', 12, 'Interpreter', 'latex');
title('Riesgo vs. Duracion (color $=$ Temperatura)', ...
    'FontSize', 13, 'Interpreter', 'latex');
grid on; set(gca, 'FontSize', 11);

sgtitle('Dataset Sintético — Riesgo de Deshidratación en Ejercicio', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontWeight', 'bold');

%% 7b. Superficie de respuesta experta (sin ruido)
figure('Color','w','Position',[100 100 700 560]);

[Xg, Yg] = meshgrid(linspace(lim_temp(1), lim_temp(2), 50), ...
                     linspace(lim_duracion(1), lim_duracion(2), 50));

Xg_n = (Xg - lim_temp(1)) / (lim_temp(2) - lim_temp(1));
Yg_n = Yg / lim_duracion(2);

f_g = Xg_n .^ 1.5;
g_g = Yg_n .^ 1.2;
h_g = (Xg_n .* Yg_n) .^ 0.8;

sc_g = (w_temp * f_g + w_dur * g_g + w_int * h_g) / score_max;
Zg   = lim_riesgo(2) * sc_g;

surf(Xg, Yg, Zg, 'EdgeColor', 'none', 'FaceAlpha', 0.85);
colormap(turbo); colorbar;
xlabel('Temperatura ($^\circ$C)', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('Duracion (min)',          'FontSize', 12, 'Interpreter', 'latex');
zlabel('Riesgo (0-10)',           'FontSize', 12, 'Interpreter', 'latex');
title('Superficie Experta de Riesgo (sin ruido)', ...
    'FontSize', 13, 'Interpreter', 'latex');
view(45, 30); grid on;
set(gca, 'FontSize', 11);

%% 7c. Histograma de la salida
figure('Color','w','Position',[100 100 600 420]);
histogram(riesgo, 25, 'FaceColor', [0.85 0.35 0.25], ...
    'EdgeColor', 'white', 'FaceAlpha', 0.85);
xlabel('Riesgo de Deshidratacion (0-10)', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('Frecuencia',                       'FontSize', 12, 'Interpreter', 'latex');
title('Distribución del Riesgo Sintético', ...
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

writetable(T_train, 'datos_deshidratacion_train.csv');
writetable(T_test,  'datos_deshidratacion_test.csv');

fprintf('=== PARTICIÓN TRAIN / TEST ===\n');
fprintf('Train: %d muestras (%.0f%%)  →  datos_deshidratacion_train.csv\n', ...
    n_train, pct_train*100);
fprintf('Test : %d muestras (%.0f%%)  →  datos_deshidratacion_test.csv\n\n', ...
    N - n_train, (1-pct_train)*100);

fprintf('¡Listo! Usa T_train para validar el FIS Mamdani y T_test para evaluarlo.\n');
