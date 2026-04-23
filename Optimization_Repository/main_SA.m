% =========================================================================
%  main_SA.m  —  Simulated Annealing sobre una función objetivo arbitraria
%
%  Autor  : Prof. Dr. Aboud Barsekh-Onji
%           Universidad Anáhuac México, Facultad de Ingeniería
%  Curso  : Fundamentos de Inteligencia Artificial
%  Fecha  : Abril 2026
%
%  DESCRIPCIÓN DEL ALGORITMO
%  -------------------------
%  Simulated Annealing (SA) es una metaheurística inspirada en el proceso
%  de recocido metalúrgico: al enfriar lentamente un material fundido, los
%  átomos se organizan en la estructura de menor energía (mínimo global).
%
%  El algoritmo acepta soluciones peores con probabilidad:
%
%       P(aceptar) = exp( -ΔE / T )
%
%  donde ΔE = f_nueva - f_actual  y  T es la temperatura actual.
%  Cuando T → 0, el algoritmo se convierte en búsqueda local pura.
%
%  CONVERGENCIA GARANTIZADA (Kirkpatrick et al., 1983):
%  Si T_0 es suficientemente alta y el enfriamiento es suficientemente
%  lento (alpha → 1), SA converge al óptimo global con probabilidad 1.
%
%  CÓMO ADAPTAR A OTRA FUNCIÓN
%  ---------------------------
%  1. Coloca el nuevo archivo .m de la función en esta misma carpeta.
%  2. Modifica ÚNICAMENTE la sección marcada con:
%         >>>  CONFIGURAR AQUÍ  <<<
%     Cambia el nombre de la función, la dimensión y los límites del dominio.
%  3. Ejecuta el script. El resto del algoritmo no necesita modificaciones.
%
% =========================================================================

clear; clc; close all;

% =========================================================================
% >>>  CONFIGURAR AQUÍ  <<<   (única sección que debes modificar)
% =========================================================================

% --- Nombre de la función objetivo ---
% La función debe aceptar un vector fila xx = [x1, x2, ..., xd]
% y devolver un escalar y = f(xx).
% Cambia 'ackley' por el nombre de tu función (sin extensión .m).
FUN_NAME       = 'Ackley';
objective_fun  = @(x) Ackley(x);

% --- Dimensión del problema (número de variables) ---
d = 2;

% --- Dominio de búsqueda  [lb_i, ub_i]  para cada variable ---
% Ackley: xi ∈ [-32.768, 32.768]  — óptimo global en (0, 0), f = 0
lb = -32.768 * ones(1, d);
ub =  32.768 * ones(1, d);

% =========================================================================
% PARÁMETROS DEL ALGORITMO SIMULATED ANNEALING
% (ajústalos si los resultados no son satisfactorios)
% =========================================================================

T0       = 1000;    % Temperatura inicial  — debe ser alta para aceptar
% casi cualquier movimiento al principio.
T_min    = 1e-8;    % Temperatura de corte — el algoritmo para cuando T < T_min.
alpha    = 0.995;   % Factor de enfriamiento geométrico: T_{k+1} = alpha * T_k
% Valores típicos: 0.90 – 0.999
% Más cercano a 1 → enfriamiento más lento → mejor calidad,
% pero más iteraciones.
max_iter = 20000;   % Número máximo de iteraciones globales (cota de seguridad)
sigma    = 1.0;     % Desviación estándar de la perturbación gaussiana.
% Controla el tamaño del "salto" al generar un vecino.

% =========================================================================
% INICIALIZACIÓN
% =========================================================================

rng('shuffle');  % Semilla aleatoria distinta en cada ejecución.
% Usa rng(42) para reproducibilidad exacta.

% Solución inicial: punto aleatorio uniforme dentro del dominio
x_current = lb + (ub - lb) .* rand(1, d);
f_current = objective_fun(x_current);

% Mejor solución encontrada (se actualiza a lo largo del algoritmo)
x_best = x_current;
f_best = f_current;

% Vectores para registrar la convergencia
hist_f_best = NaN(max_iter, 1);   % mejor f por iteración
hist_f_curr = NaN(max_iter, 1);   % f actual (puede empeorar)
hist_T      = NaN(max_iter, 1);   % temperatura por iteración
hist_accept = false(max_iter, 1); % si la solución nueva fue aceptada

T    = T0;        % temperatura de trabajo
iter = 0;         % contador de iteraciones

fprintf('╔══════════════════════════════════════════════════════╗\n');
fprintf('║         SIMULATED ANNEALING — Resultados             ║\n');
fprintf('╠══════════════════════════════════════════════════════╣\n');
fprintf('║  Función  : %-40s║\n', FUN_NAME);
fprintf('║  Dimensión: %-3d                                      ║\n', d);
fprintf('║  T0 = %-8.2f  alpha = %-6.4f  T_min = %-10.2e ║\n', T0, alpha, T_min);
fprintf('╚══════════════════════════════════════════════════════╝\n\n');
fprintf('  Iter     Temperatura       f_actual       f_best\n');
fprintf('  ----  ---------------  -------------  -------------\n');

% =========================================================================
% BUCLE PRINCIPAL
% =========================================================================

while T > T_min && iter < max_iter

    iter = iter + 1;

    % ------------------------------------------------------------------
    % 1. GENERACIÓN DEL VECINO
    %    Se aplica una perturbación gaussiana N(0, sigma) a la solución
    %    actual. Esto es el "movimiento" en el espacio de búsqueda.
    % ------------------------------------------------------------------
    x_candidate = x_current + sigma * randn(1, d);

    % Proyección sobre el dominio: si el candidato se sale de [lb, ub],
    % se "recorta" al límite más cercano (operación de clipping).
    x_candidate = max(lb, min(ub, x_candidate));

    % ------------------------------------------------------------------
    % 2. EVALUACIÓN DE LA FUNCIÓN OBJETIVO
    % ------------------------------------------------------------------
    f_candidate = objective_fun(x_candidate);

    % ------------------------------------------------------------------
    % 3. CRITERIO DE ACEPTACIÓN DE METROPOLIS
    %    ΔE = f_nueva - f_actual
    %    • Si ΔE < 0 (mejora): aceptar siempre.
    %    • Si ΔE ≥ 0 (empeoramiento): aceptar con probabilidad exp(-ΔE/T).
    %      — A temperatura alta, casi todo se acepta (exploración).
    %      — A temperatura baja, raramente se acepta algo peor (explotación).
    % ------------------------------------------------------------------
    delta_E = f_candidate - f_current;

    if delta_E < 0
        % La nueva solución es mejor: aceptar sin condición
        accepted = true;
    else
        % La nueva solución es peor: aceptar con probabilidad de Boltzmann
        p_accept = exp(-delta_E / T);
        accepted = (rand() < p_accept);
    end

    if accepted
        x_current = x_candidate;
        f_current = f_candidate;
    end

    % ------------------------------------------------------------------
    % 4. ACTUALIZACIÓN DEL MEJOR GLOBAL
    % ------------------------------------------------------------------
    if f_current < f_best
        x_best = x_current;
        f_best = f_current;
    end

    % ------------------------------------------------------------------
    % 5. REGISTRO DEL HISTORIAL
    % ------------------------------------------------------------------
    hist_f_best(iter) = f_best;
    hist_f_curr(iter) = f_current;
    hist_T(iter)      = T;
    hist_accept(iter) = accepted;

    % ------------------------------------------------------------------
    % 6. ENFRIAMIENTO GEOMÉTRICO
    %    T_{k+1} = alpha * T_k
    %    Es el schedule más común. Alternativas: lineal, logarítmico.
    % ------------------------------------------------------------------
    T = alpha * T;

    % ------------------------------------------------------------------
    % 7. REPORTE PERIÓDICO EN CONSOLA
    % ------------------------------------------------------------------
    if mod(iter, 2000) == 0 || iter == 1
        fprintf('  %5d  %15.6e  %13.6f  %13.6f\n', ...
            iter, T, f_current, f_best);
    end

end  % fin del bucle principal

% Truncar vectores al número real de iteraciones
hist_f_best = hist_f_best(1:iter);
hist_f_curr = hist_f_curr(1:iter);
hist_T      = hist_T(1:iter);
hist_accept = hist_accept(1:iter);

% =========================================================================
% RESULTADOS FINALES
% =========================================================================

fprintf('\n');
fprintf('╔══════════════════════════════════════════════════════╗\n');
fprintf('║                  RESULTADO FINAL                     ║\n');
fprintf('╠══════════════════════════════════════════════════════╣\n');
fprintf('║  Iteraciones realizadas : %-8d                  ║\n', iter);
fprintf('║  Temperatura final      : %-12.4e              ║\n', T);
fprintf('║  Mejor valor encontrado : %-14.10f            ║\n', f_best);
fprintf('║  Óptimo teórico         : 0                         ║\n');
fprintf('║  Error absoluto         : %-14.10e            ║\n', abs(f_best));
fprintf('╚══════════════════════════════════════════════════════╝\n');
fprintf('\nMejor posición x* = [ ');
fprintf('%.6f  ', x_best);
fprintf(']\n\n');

% Tasa de aceptación global
acceptance_rate = sum(hist_accept) / iter * 100;
fprintf('Tasa de aceptación global: %.2f %%\n', acceptance_rate);

% =========================================================================
% VISUALIZACIÓN
% =========================================================================

fig = figure('Name', ['SA — ' FUN_NAME], ...
    'Units', 'normalized', ...
    'Position', [0.05 0.1 0.9 0.8]);

% ---- Subgráfica 1: convergencia del mejor valor ----
subplot(2, 2, [1 2]);
plot(1:iter, hist_f_best, 'b-', 'LineWidth', 1.8, 'DisplayName', 'f_{best}');
hold on;
plot(1:iter, hist_f_curr, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.8, ...
    'DisplayName', 'f_{actual}');
yline(0, 'r--', 'LineWidth', 1.2, 'DisplayName', 'Óptimo teórico');
hold off;
xlabel('Iteración', 'FontSize', 11);
ylabel('Valor de la función', 'FontSize', 11);
title(['Convergencia del SA — ' FUN_NAME], 'FontSize', 12, 'FontWeight', 'bold');
legend('Location', 'northeast', 'FontSize', 10);
grid on;
box on;

% ---- Subgráfica 2: schedule de temperatura ----
subplot(2, 2, 3);
semilogy(1:iter, hist_T, 'r-', 'LineWidth', 1.5);
xlabel('Iteración', 'FontSize', 11);
ylabel('Temperatura T  (escala log)', 'FontSize', 11);
title('Schedule de Enfriamiento Geométrico', 'FontSize', 11);
grid on;
box on;

% ---- Subgráfica 3: paisaje de la función (solo d == 2) ----
subplot(2, 2, 4);
if d == 2
    n_grid = 200;
    x1_vec = linspace(lb(1), ub(1), n_grid);
    x2_vec = linspace(lb(2), ub(2), n_grid);
    [X1, X2] = meshgrid(x1_vec, x2_vec);
    Z = zeros(n_grid, n_grid);
    for i = 1:n_grid
        for j = 1:n_grid
            Z(i,j) = objective_fun([X1(i,j), X2(i,j)]);
        end
    end
    contourf(X1, X2, Z, 30, 'LineColor', 'none');
    colorbar;
    hold on;
    plot(x_best(1), x_best(2), 'r*', 'MarkerSize', 14, 'LineWidth', 2, ...
        'DisplayName', 'x^* encontrado');
    plot(0, 0, 'w+', 'MarkerSize', 14, 'LineWidth', 2, ...
        'DisplayName', 'Óptimo teórico');
    hold off;
    xlabel('x_1', 'FontSize', 11);
    ylabel('x_2', 'FontSize', 11);
    title(['Paisaje de ' FUN_NAME ' (d=2)'], 'FontSize', 11);
    legend('Location', 'northeast', 'FontSize', 9, ...
        'TextColor', 'white', 'Color', [0.2 0.2 0.2]);
    axis tight;
else
    text(0.5, 0.5, 'Visualización 2D\ndisponible solo\ncuando d = 2', ...
        'HorizontalAlignment', 'center', 'FontSize', 12, 'Units', 'normalized');
    axis off;
end

sgtitle(['Simulated Annealing — Función: ' FUN_NAME ...
    '  |  d=' num2str(d) ...
    '  |  \alpha=' num2str(alpha)], ...
    'FontSize', 13, 'FontWeight', 'bold');

% =========================================================================
% FIN DEL SCRIPT
% =========================================================================
