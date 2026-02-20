% Script para implementar un Algoritmo Genético (GA) 
% para encontrar el mínimo global de la función de Ackley con animación 3D

% Limpiar espacio de trabajo y consola
clear;
clc;
close all;

%% 1. Definición del Problema
% Parámetros opcionales para la función de Ackley (según la nueva versión)
a = 20; 
b = 0.2; 
c = 2 * pi;

% Se define la función objetivo utilizando una función anónima
objectiveFunction = @(x) Ackley(x, a, b, c);

nvars = 2; 

% Límites inferiores y superiores del espacio de búsqueda
lb = -32.768 * ones(1, nvars);
ub = 32.768 * ones(1, nvars);

%% 2. Preparación de la Gráfica Interactiva (Subplots)
% Solo se dibuja si el problema es de 2 dimensiones
if nvars == 2
    figure('Name', 'Optimización GA de Función Ackley', 'Position', [100, 100, 1000, 500]);
    
    % --- Subplot 1: Animación 3D ---
    subplot(1, 2, 1);
    
    % Crear malla de puntos para dibujar la superficie
    x1_val = linspace(max(lb(1), -10), min(ub(1), 10), 100); 
    x2_val = linspace(max(lb(2), -10), min(ub(2), 10), 100);
    [X1, X2] = meshgrid(x1_val, x2_val);
    Z = zeros(size(X1));
    
    % Evaluar la función de Ackley en cada punto de la malla
    for i = 1:size(X1, 1)
        for j = 1:size(X1, 2)
            Z(i, j) = Ackley([X1(i, j), X2(i, j)], a, b, c);
        end
    end
    
    % Dibujar la superficie de la función en 3D
    surf(X1, X2, Z, 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    hold on;
    
    % Detalles del gráfico 3D
    title('Evolución del GA (3D)');
    xlabel('x_1');
    ylabel('x_2');
    zlabel('f(x)');
    colormap jet;
    view(45, 30); 
    
    % Objeto scatter3 que se actualizará iteración a iteración
    h_scatter = scatter3([], [], [], 30, 'k', 'filled', 'MarkerEdgeColor', 'w');
    
    % --- Subplot 2: Gráfica de Convergencia (Mejor individuo) ---
    subplot(1, 2, 2);
    h_line = plot(0, 0, 'b-', 'LineWidth', 2);
    title('Convergencia del GA');
    xlabel('Generación');
    ylabel('Mejor Valor f(x)');
    grid on;
    % Limites del eje Y tentativos, se ajustarán dinámicamente si es necesario
    ylim([0, max(Z(:))]);
end

%% 3. Configuración del Algoritmo Genético (GA)
% Función de salida (OutputFcn) para actualizar ambos subplots
outfun = @(options, state, flag) plot3d_ga_evolution(options, state, flag, nvars, h_scatter, h_line, objectiveFunction);

% Configurar opciones del GA (quitamos el PlotFcn por defecto para usar el nuestro)
options = optimoptions('ga', ...
    'PopulationSize', 100, ...         
    'MaxGenerations', 150, ...         
    'Display', 'iter', ...             
    'OutputFcn', outfun);

%% 4. Ejecución del GA
disp('Ejecutando el Algoritmo Genético...');
[xf, fval, exitflag, output] = ga(objectiveFunction, nvars, [], [], [], [], lb, ub, [], options);

%% 5. Mostrar Resultados
fprintf('\n--- Resultados de la Optimización ---\n');
fprintf('Mejor posición encontrada (x): \n');
disp(xf);
fprintf('Valor mínimo de la función f(x): %f\n', fval);
fprintf('Criterio de parada: %s\n', output.message);

% Marcar el punto óptimo encontrado al terminar en el 3D
if nvars == 2
    subplot(1, 2, 1);
    plot3(xf(1), xf(2), fval, 'rs', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
    legend('Superficie', 'Individuos', 'Óptimo', 'Location', 'best');
    hold off;
end

%% Función Auxiliar para la Animación de los Subplots
function [state, options, optchanged] = plot3d_ga_evolution(options, state, flag, nvars, h_scatter, h_line, objFun)
    optchanged = false;
    
    if nvars ~= 2
        return;
    end
    
    switch flag
        case 'init'
            % Iniciar grafica de linea vacia
            h_line.XData = [];
            h_line.YData = [];
            
        case 'iter'
            % --- 1. Obtener la población ---
            pop = state.Population;
            pop_z = zeros(size(pop, 1), 1);
            for i = 1:size(pop, 1)
                pop_z(i) = objFun(pop(i, :));
            end
            
            % --- 2. Actualizar Plot 3D ---
            h_scatter.XData = pop(:, 1);
            h_scatter.YData = pop(:, 2);
            h_scatter.ZData = pop_z + 0.5; 
            
            % --- 3. Actualizar Plot 2D (Convergencia) ---
            bestFval = min(pop_z);
            h_line.XData = [h_line.XData, state.Generation];
            h_line.YData = [h_line.YData, bestFval];
            
            % Cambiar el título del plot 2D para mostrar el progreso
            subplot(1, 2, 2);
            title(sprintf('Generación: %d | Mejor f(x): %.4f', state.Generation, bestFval));
            
            % --- 4. Renderizar ---
            drawnow;
            pause(0.05); 
    end
end
