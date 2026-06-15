% ============================================================
% APLICACIÓN DEL ALGORITMO SIMULATED ANNEALING ACKLEY FUNCTION
% Prof. Dr. Aboud BARSEKH-ONJI 
% Email: aboud.barsekh@anahuac.mx
% https://orcid.org/0009-0004-5440-8092
% Universidad Anáhuac México Sur - Facultad de Ingeniería 
% ============================================================
clear all
clc
ackley = @(x) -20 * exp(-0.2 * sqrt(0.5 * (x(1)^2 + x(2)^2))) ...
              - exp(0.5 * (cos(2 * pi * x(1)) + cos(2 * pi * x(2)))) ...
              + 20 + exp(1);

[x_grid, y_grid] = meshgrid(-10:0.1:10, -10:0.1:10);
z_grid = arrayfun(@(x, y) ackley([x, y]), x_grid, y_grid);

T = 1000;              % Temperatura inicial
T_min = 0.1;         % Temperatura mínima
alpha = 0.99;          % Factor de enfriamiento
max_iter = 1200;      % Número máximo de iteraciones
x = [0.1,0.1];   % Solución inicial aleatoria
best_sol = x;
best_cost = ackley(x);
figure;
surf(x_grid, y_grid, z_grid,'EdgeColor', 'interp'); 
colormap jet;
hold on;
xlabel('x');
ylabel('y');
zlabel('f(x, y)');
title('Ackley Function');

%figure;
scatter3(x(1), x(2), best_cost, 100, 'b', 'filled'); % Punto inicial
pause(1);
costs = zeros(1, max_iter);

trace_x = x(1);  % Inicializar el rastro en X
trace_y = x(2);  % Inicializar el rastro en Y
trace_z = best_cost;  % Inicializar el rastro en Z (costo)
%% 

for iter = 1:max_iter
    new_x = x + randn(1, 2);  % Movimiento aleatorio
    new_cost = ackley(new_x);  % Evaluar nueva solución
    if new_cost < best_cost
        best_sol = new_x;
        best_cost = new_cost;
        x = new_x;
    else
        delta_cost = new_cost - ackley(x);
        if rand < exp(-delta_cost / T)
            x = new_x;
        end
    end
    costs(iter) = best_cost;
    trace_x(end+1) = x(1);
    trace_y(end+1) = x(2);
    trace_z(end+1) = ackley(x);
    scatter3(trace_x, trace_y, trace_z, 50, 'k', 'filled');  % Mostrar los puntos explorados
    drawnow;  % Actualizar la gráfica
    T = T * alpha;
    if T < T_min
        break;
    end
end

fprintf('Mejor solución encontrada: (%.4f, %.4f)\n', best_sol(1), best_sol(2));
fprintf('Costo de la mejor solución: %.4f\n', best_cost);
figure;
plot(1:iter, costs(1:iter), 'LineWidth', 2);
xlabel('Iteración');
ylabel('Costo');
title('Convergencia del costo durante Simulated Annealing');
grid on;

