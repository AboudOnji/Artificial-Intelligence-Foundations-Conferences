%% ========================================================================
% TÍTULO: Generación de Datos Sintéticos para Sistema de Inferencia Difusa
%         Pronóstico de Propina en función de Calidad de Comida y Servicio
% Autor:  Prof. D.Sc. Aboud Barsekh-Onji
% Institución: Universidad Anáhuac México
% Fecha:  Junio 2026
%
% Descripción:
%   Genera N observaciones sintéticas (comida, servicio, propina) con una
%   lógica no-lineal intencionada, adecuada para entrenar un FIS Mamdani o
%   Sugeno de dos entradas / una salida.
%
%   Entradas : calidad_comida  ∈ [0, 10]
%              calidad_servicio ∈ [0, 10]
%   Salida   : propina          ∈ [0, 20]  (porcentaje)
%
%   Regla experta embebida (surface goal):
%     - Comida pésima   + Servicio pésimo   → ~2 %
%     - Comida buena    + Servicio pésimo   → ~10 %
%     - Comida pésima   + Servicio excelente → ~12 %
%     - Comida excelente + Servicio excelente → ~20 %
%     - Peso del servicio > peso de la comida (factor humano)
%
%% ========================================================================

clc; clear; close all;
rng(42);  % Semilla fija → reproducibilidad

%% -----------------------------------------------------------------------
%  1. PARÁMETROS DE CONFIGURACIÓN
%% -----------------------------------------------------------------------

N          = 500;   % Número de muestras sintéticas
ruido_std  = 0.8;   % Desviación estándar del ruido gaussiano aditivo
alpha      = 0.40;  % Peso de calidad_comida  en el cómputo de propina
beta       = 0.60;  % Peso de calidad_servicio (beta > alpha → el servicio pesa más)

% Límites de las variables
lim_entrada = [0, 10];
lim_salida  = [0, 20];

%% -----------------------------------------------------------------------
%  2. GENERACIÓN DE ENTRADAS (muestreo cuasi-uniforme + clústeres)
%% -----------------------------------------------------------------------

% Distribución base: uniforme para cubrir todo el espacio de entrada
comida   = lim_entrada(1) + (lim_entrada(2) - lim_entrada(1)) * rand(N, 1);
servicio = lim_entrada(1) + (lim_entrada(2) - lim_entrada(1)) * rand(N, 1);

% Adicionalmente, inyectar 20 % de muestras concentradas en zonas extremas
% (esquinas del espacio de entrada) para que el FIS aprenda bien los bordes
N_extremos = round(0.20 * N);
idx_extr   = randperm(N, N_extremos);

% Asignar aleatoriamente a una de las 4 esquinas con ruido pequeño
esquinas = [0 0; 0 10; 10 0; 10 10];
asign    = randi(4, N_extremos, 1);

comida(idx_extr)   = esquinas(asign, 1) + randn(N_extremos, 1) * 0.5;
servicio(idx_extr) = esquinas(asign, 2) + randn(N_extremos, 1) * 0.5;

% Recortar al dominio [0, 10]
comida   = max(lim_entrada(1), min(lim_entrada(2), comida));
servicio = max(lim_entrada(1), min(lim_entrada(2), servicio));

%% -----------------------------------------------------------------------
%  3. FUNCIÓN EXPERTA DE PROPINA (superficie de decisión no-lineal)
%% -----------------------------------------------------------------------
%
%  Modelo matemático embebido:
%
%    score(x,y) = alpha * f(x) + beta * g(y)
%
%  donde f y g son transformaciones sigmoideas que capturan la saturación
%  característica de la percepción humana de calidad.
%
%    f(x) = 1 / (1 + exp(-k*(x - 5)))   → sigmoide centrada en 5
%    g(y) = ídem para y
%
%  Luego se escala score ∈ [0,1] al rango de propina [0, 20].
%  Se añade un término de interacción x*y / 100 para capturar sinergia
%  (cuando ambas calidades son altas, la propina sube más que la suma).

k          = 0.9;   % Pendiente de la sigmoide (controla cuán suave es la transición)
interaccion = 0.15; % Peso del término de interacción

f_comida   = 1 ./ (1 + exp(-k .* (comida   - 5)));
f_servicio = 1 ./ (1 + exp(-k .* (servicio - 5)));

% Score base ∈ [0, 1]
score = alpha * f_comida + beta * f_servicio ...
      + interaccion * (comida .* servicio) / 100;

% Normalizar score para que quede en [0, 1] considerando el término de interacción
score_max = alpha * 1 + beta * 1 + interaccion * 1;  % valor máximo teórico
score = score / score_max;

% Escalar a [0, 20]
propina_det = lim_salida(2) * score;

%% -----------------------------------------------------------------------
%  4. AÑADIR RUIDO GAUSSIANO (variabilidad humana real)
%% -----------------------------------------------------------------------

ruido   = randn(N, 1) * ruido_std;
propina = propina_det + ruido;

% Recortar al rango válido [0, 20]
propina = max(lim_salida(1), min(lim_salida(2), propina));

%% -----------------------------------------------------------------------
%  5. EXPORTAR DATASET
%% -----------------------------------------------------------------------

% Tabla con nombres de columna descriptivos
T = table(comida, servicio, propina, ...
    'VariableNames', {'Calidad_Comida', 'Calidad_Servicio', 'Propina_Pct'});

% Guardar como CSV (fácil de leer desde MATLAB, Python, Excel)
nombre_archivo = 'datos_propina_sinteticos.csv';
writetable(T, nombre_archivo);
fprintf('✔  Dataset exportado: %s  (%d muestras)\n', nombre_archivo, N);

% Guardar también en formato .mat (carga rápida en MATLAB)
save('datos_propina_sinteticos.mat', 'comida', 'servicio', 'propina', 'T');
fprintf('✔  Workspace guardado: datos_propina_sinteticos.mat\n\n');

%% -----------------------------------------------------------------------
%  6. ESTADÍSTICAS DESCRIPTIVAS
%% -----------------------------------------------------------------------

fprintf('=== ESTADÍSTICAS DESCRIPTIVAS ===\n');
fprintf('Variable         Min     Max    Media   Desv.Est.\n');
fprintf('%-16s %6.2f  %6.2f  %6.2f  %6.2f\n', ...
    'Calidad Comida',   min(comida),   max(comida),   mean(comida),   std(comida));
fprintf('%-16s %6.2f  %6.2f  %6.2f  %6.2f\n', ...
    'Calidad Servicio', min(servicio), max(servicio), mean(servicio), std(servicio));
fprintf('%-16s %6.2f  %6.2f  %6.2f  %6.2f\n\n', ...
    'Propina (%)',      min(propina),  max(propina),  mean(propina),  std(propina));

%% -----------------------------------------------------------------------
%  7. VISUALIZACIÓN
%% -----------------------------------------------------------------------

%% 7a. Scatter plot: Propina vs. cada entrada (coloreado por la otra)
figure('Color','w','Position',[100 100 1200 450]);

subplot(1,2,1);
scatter(comida, propina, 30, servicio, 'filled', 'MarkerFaceAlpha', 0.6);
colorbar; colormap(turbo);
xlabel('Calidad de la Comida',  'FontSize', 12, 'Interpreter', 'latex');
ylabel('Propina (\%)',           'FontSize', 12, 'Interpreter', 'latex');
title('Propina vs. Comida (color $=$ Servicio)', ...
    'FontSize', 13, 'Interpreter', 'latex');
grid on; set(gca, 'FontSize', 11);

subplot(1,2,2);
scatter(servicio, propina, 30, comida, 'filled', 'MarkerFaceAlpha', 0.6);
colorbar; colormap(turbo);
xlabel('Calidad del Servicio', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('Propina (\%)',          'FontSize', 12, 'Interpreter', 'latex');
title('Propina vs. Servicio (color $=$ Comida)', ...
    'FontSize', 13, 'Interpreter', 'latex');
grid on; set(gca, 'FontSize', 11);

sgtitle('Dataset Sintético — Inferencia Difusa de Propina', ...
    'FontSize', 14, 'Interpreter', 'latex', 'FontWeight', 'bold');

%% 7b. Superficie de respuesta (interpolación sobre grilla regular)
figure('Color','w','Position',[100 100 700 560]);

% Grilla 50×50 para interpolar la superficie subyacente
[Xg, Yg] = meshgrid(linspace(0,10,50), linspace(0,10,50));

f_xg  = 1 ./ (1 + exp(-k .* (Xg - 5)));
f_yg  = 1 ./ (1 + exp(-k .* (Yg - 5)));
sc_g  = alpha * f_xg + beta * f_yg + interaccion * (Xg .* Yg) / 100;
sc_g  = sc_g / score_max;
Zg    = lim_salida(2) * sc_g;

surf(Xg, Yg, Zg, 'EdgeColor', 'none', 'FaceAlpha', 0.85);
colormap(turbo); colorbar;
xlabel('Calidad Comida',   'FontSize', 12, 'Interpreter', 'latex');
ylabel('Calidad Servicio', 'FontSize', 12, 'Interpreter', 'latex');
zlabel('Propina (\%)',     'FontSize', 12, 'Interpreter', 'latex');
title('Superficie Experta de Propina (sin ruido)', ...
    'FontSize', 13, 'Interpreter', 'latex');
view(45, 30); grid on;
set(gca, 'FontSize', 11);

%% 7c. Histograma de la variable de salida
figure('Color','w','Position',[100 100 600 420]);
histogram(propina, 25, 'FaceColor', [0.20 0.45 0.75], ...
    'EdgeColor', 'white', 'FaceAlpha', 0.85);
xlabel('Propina (\%)',    'FontSize', 12, 'Interpreter', 'latex');
ylabel('Frecuencia',      'FontSize', 12, 'Interpreter', 'latex');
title('Distribución de la Propina Sintética', ...
    'FontSize', 13, 'Interpreter', 'latex');
grid on; set(gca, 'FontSize', 11);

%% -----------------------------------------------------------------------
%  8. SUGERENCIA DE PARTICIÓN TRAIN / TEST
%% -----------------------------------------------------------------------

pct_train = 0.80;
idx_perm  = randperm(N);
n_train   = round(pct_train * N);

idx_train = idx_perm(1 : n_train);
idx_test  = idx_perm(n_train+1 : end);

T_train = T(idx_train, :);
T_test  = T(idx_test,  :);

writetable(T_train, 'datos_propina_train.csv');
writetable(T_test,  'datos_propina_test.csv');

fprintf('=== PARTICIÓN TRAIN / TEST ===\n');
fprintf('Train: %d muestras (%.0f%%)  →  datos_propina_train.csv\n', ...
    n_train, pct_train*100);
fprintf('Test : %d muestras (%.0f%%)  →  datos_propina_test.csv\n\n', ...
    N - n_train, (1-pct_train)*100);

fprintf('¡Listo! Usa T_train para entrenar el FIS y T_test para evaluarlo.\n');


