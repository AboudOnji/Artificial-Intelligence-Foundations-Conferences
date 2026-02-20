
%=================================================
% Optimization using Genetic Algorithm (GA)
%=================================================
% Objective Function: f(x1, x2) = x1^2 + x2^2 + 2*sin(x1)*sin(x2)
% Constraints: -5 <= x1, x2 <= 5
% Author: Aboud BARSEKH-ONJI (D.sc.) 
% Email:aboud.barsekh@anahauc.mx
% Date: June 2023
%=================================================
x1_range = linspace(-5, 5, 100); 
x2_range = linspace(-5, 5, 100);
[X1, X2] = meshgrid(x1_range, x2_range); %Crear una malla de puntos para evaluar la función en un grid
Z = X1.^2 + X2.^2 + 2 * sin(X1).* sin(X2); % Evaluar la función en cada punto de la malla

% Figura (Gráfica de la función objetivo)
figure;
surf(X1, X2, Z,"EdgeColor","flat");
xlabel('x1');
ylabel('x2');
zlabel('f(x1, x2)');
title('Objective function');
grid on
%%
colorbar;% Barra de color para indicar los valores de Z
view(45, 30); % Ajustar la vista para una mejor visualización 3
% Contour plot
figure;
contour(X1, X2, Z, 50); % El valor 50 indica el número de niveles de contorno
xlabel(['variable x1']);
ylabel('variable x2');
title('Contour of Objective function');
colorbar;
%%
objFunc = @(x) x(1)^2 + x(2)^2 + 2 * sin(x(1)) * sin(x(2)); % Definimos la función objetivo
options = optimoptions('ga', 'Display','diagnose' ,'PlotFcn','gaplotbestf','FunctionTolerance',1e-8,...
    'CreationFcn','gacreationlinearfeasible','MutationFcn','mutationadaptfeasible',...
    'HybridFcn','patternsearch',MaxGenerations=50);
% Ejecutamos el algoritmo genético

[x_opt, fval] = ga(objFunc, 2, [], [], [], [], [-5, -5], [0, 0], [], options);
% Resultados
fprintf('Optimal value of x : [%f, %f]\n', x_opt(1), x_opt(2));
fprintf('Best fitness value: %f\n', fval);