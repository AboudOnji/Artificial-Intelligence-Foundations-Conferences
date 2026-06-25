% Crear el sistema de inferencia difusa
fis = mamfis(Name="Credit_score");
% Agregar inputs y output
fis = addInput(fis,[0,10],"Name","IDR");
fis = addInput(fis,[0,10],"Name","HD_pago");
fis = addOutput (fis,[0,100],"Name","Risk");
% Agregar MFs
% Para el primer input
fis = addMF(fis,"IDR","trapmf",[-2.5 -0.2778 0.2778 2.5], ...
    "Name", "Insuficiente");
fis = addMF(fis,"IDR","trimf",[0.556 3.33 6.11],"Name", "Bajo");
fis = addMF(fis,"IDR","trimf",[3.88 6.66 9.44],"Name", "Adecuado");
fis = addMF(fis,"IDR","trapmf",[7.5 9.72 10.28 12.5], ...
    "Name", "Alto");
% Para el segundo input
fis = addMF(fis,"HD_pago","trapmf",[-2.5 -0.2778 0.2778 2.5], ...
    "Name", "Malo");
fis = addMF(fis,"HD_pago","trimf",[0.556 3.33 6.11],"Name", "Regular");
fis = addMF(fis,"HD_pago","trimf",[3.88 6.66 9.44],"Name", "Bueno");
fis = addMF(fis,"HD_pago","trapmf",[7.5 9.72 10.28 12.5], ...
    "Name", "Excelente");
% Para el output
fis = addMF(fis,"Risk","trapmf",[-18.75 -2.083 2.083 18.75], ...
    "Name", "Muy_bajo");
fis = addMF(fis,"Risk","trimf",[4.16 25 45.83],"Name", "bajo");
fis = addMF(fis,"Risk","trimf",[29.16 50 70.83],"Name", "Moderad");
fis = addMF(fis,"Risk","trimf",[54.16 75 95.83],"Name", "Alto");
fis = addMF(fis,"Risk","trapmf",[81.25 97.92 102.1 118.7], ...
    "Name", "Muy_Alto");

% Agregar las reglas
fis = addRule(fis,["if IDR is Alto or HD_pago is Excelente then Risk is Muy_bajo(0.5)",...
    "if IDR is Insuficiente and HD_pago is Malo then Risk is Muy_Alto (1)"]);
% Dibujar
plotfis (fis)

%%
options=tunefisOptions("Method","ga", "OptimizationType","learning");
options.MethodOptions.MaxGenerations=100;
options.Display="all";
options.MethodOptions.PlotFcn= "gaplotbestf"
fis2=tunefis(fis,[],Input,Output,options)
%%
plotfis(fis2)
%%
[in,out,rule] = getTunableSettings(fis2);
options.OptimizationType="tuning";
options.Method='patternsearch';
options.MethodOptions.MaxIterations=200;
options.Display="all";
fis3=tunefis(fis2,[in;out;rule],Input,Output,options)
%%
outmodel=evalfis(fis3,inputTest);
residuals=outmodel-outputTest;
RMSE= sqrt(mean(residuals.^2))
%%

%% 7. Figura 1 — Serie temporal: Real vs Predicho
figure('Color','w','Position',[100 200 900 380]);
    plot(outputTest, 'b-o', 'LineWidth',1.5, 'MarkerSize',4, ...
         'DisplayName','Real');
    hold on;
    plot(yPred, 'r--s', 'LineWidth',1.5, 'MarkerSize',4, ...
         'DisplayName','fis3 Predicho');
    xlabel('Muestra',  'FontSize',12, 'Interpreter','latex');
    ylabel('Risk',     'FontSize',12, 'Interpreter','latex');
    title('Real vs.\ Predicho --- fis3 (Test Set)', ...
          'FontSize',13, 'Interpreter','latex');
    legend('Location','best','FontSize',11);
    grid on;
    set(gca,'FontSize',11,'TickLabelInterpreter','latex');

%% 
R2   = 1 - sum(residuals.^2) / sum((outputTest - mean(outputTest)).^2);
figure('Color','w','Position',[100 100 1100 420]);

% 
subplot(1,2,1)
    scatter(outputTest, outmodel, 50, residuals, 'filled', ...
            'MarkerFaceAlpha', 0.75);
    colormap(gca, 'cool');
    cb = colorbar;  cb.Label.String = 'Residual';
    hold on;
    lims = [min([outputTest; outmodel])-2, max([outputTest; outmodel])+2];
    plot(lims, lims, 'k--', 'LineWidth', 1.4);   % línea identidad y = x
    xlim(lims);  ylim(lims);
    xlabel('Risk real',     'FontSize',12, 'Interpreter','latex');
    ylabel('Risk predicho', 'FontSize',12, 'Interpreter','latex');
    title(sprintf('Scatter $\\quad R^2 = %.4f$', R2), ...
          'FontSize',12, 'Interpreter','latex');
    grid on;
    set(gca,'FontSize',11,'TickLabelInterpreter','latex');

%
subplot(1,2,2)
    histogram(residuals, 20, 'FaceColor',[0.2 0.5 0.8], ...
              'EdgeColor','w', 'FaceAlpha',0.85);
    xline(0,  'k--', 'LineWidth',1.4, 'DisplayName','Cero');
    xline( RMSE, 'r-', 'LineWidth',1.2, 'DisplayName',sprintf('RMSE = %.2f', RMSE));
    xline(-RMSE, 'r-', 'LineWidth',1.2, 'HandleVisibility','off');
    xlabel('Residual (Real $-$ Pred.)', 'FontSize',12, 'Interpreter','latex');
    ylabel('Frecuencia',               'FontSize',12, 'Interpreter','latex');
    title(sprintf('Distribución de Residuales $\\quad$ RMSE = %.4f', RMSE), ...
          'FontSize',12, 'Interpreter','latex');
    legend('Location','best','FontSize',10);
    grid on;
    set(gca,'FontSize',11,'TickLabelInterpreter','latex');

sgtitle('Evaluación del FIS Afinado (fis3) --- Test Set', ...
        'FontSize',14, 'FontWeight','bold', 'Interpreter','latex');