%% ========================================================================
% VISUALIZACIÓN: f(x, y) = 5x² + 7·cos(y)
% Función objetivo para la actividad de Simulated Annealing
%
% Prof. D.Sc. BARSEKH-ONJI Aboud
% Facultad de Ingeniería, Universidad Anáhuac México
% Email  : aboud.barsekh@anahuac.mx
% ORCID  : 0009-0004-5440-8092
% Curso  : Fundamentos de Inteligencia Artificial
%% ========================================================================

clc; clear; close all;
x = linspace(-3, 3, 300);          % 300 puntos en x ∈ [-3, 3]
y = linspace(-2*pi, 2*pi, 300);    % 300 puntos en y ∈ [-2π, 2π]
[X, Y] = meshgrid(x, y);           % Malla 2D: X e Y son matrices 300×300
F = 5*X.^2 + 7*cos(Y);
figure('Position',[50 50 900 620], 'Name','Superficie 3D');
surf(X, Y, F, 'EdgeColor','none');
colormap(jet);
colorbar;
xlabel('$x$', 'FontSize',13, 'Interpreter','latex');
ylabel('$y$', 'FontSize',13, 'Interpreter','latex');
zlabel('$f(x,y)$', 'FontSize',13, 'Interpreter','latex');
title('$f(x,y) = 5x^2 + 7\cos(y)$', ...
      'FontSize',15, 'Interpreter','latex');
view(45, 30);
grid on;
set(gca, 'FontSize',11, 'TickLabelInterpreter','latex');
hold on;
plot3(0, pi, -7, 'ro', 'MarkerSize',12, 'MarkerFaceColor','r', ...
      'DisplayName','M\''inimo global $(0,\pi,-7)$');
legend('FontSize',11, 'Interpreter','latex', 'Location','northeast');
hold off;
figure('Position',[100 100 800 560], 'Name','Mapa de Contornos');
contourf(X, Y, F, 40, 'LineColor','none');
colormap(jet);
colorbar;
hold on;
contour(X, Y, F, 12, 'LineColor','k', 'LineWidth',0.4);
plot(0, pi,  'r*', 'MarkerSize',14, 'LineWidth',2, ...
      'DisplayName','M\''inimo global $(0,\;\pi)$');
plot(0, -pi, 'r*', 'MarkerSize',14, 'LineWidth',2, 'HandleVisibility','off');
plot(0,  3*pi, 'r*', 'MarkerSize',14, 'LineWidth',2, 'HandleVisibility','off');
plot(0, -3*pi, 'r*', 'MarkerSize',14, 'LineWidth',2, 'HandleVisibility','off');

xline(0, 'w--', 'LineWidth',1.0);
yline(pi,  'w:', 'LineWidth',1.0);

xlabel('$x$',       'FontSize',13, 'Interpreter','latex');
ylabel('$y$',       'FontSize',13, 'Interpreter','latex');
title('Mapa de contornos — $f(x,y) = 5x^2 + 7\cos(y)$', ...
      'FontSize',14, 'Interpreter','latex');
legend('FontSize',11, 'Interpreter','latex', 'Location','southeast');
grid off;
set(gca, 'FontSize',11, 'TickLabelInterpreter','latex');
hold off;

