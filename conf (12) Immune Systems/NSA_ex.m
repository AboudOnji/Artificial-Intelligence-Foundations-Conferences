% =========================================================================
% Ejemplo conceptual de NSA en MATLAB para una señal 1D
% Aboud BARSEKH - ONJI (D.Sc.)
% aboud.barsekh@anahuac.mx
% ORCID: 0009-0004-5440-8092
% =========================================================================

clear; close all; clc;


%  Definir Parámetros 
n_self = 200;           % Número de muestras "propias"
n_detectors = 500;      % Número de detectores a generar
affinity_threshold = 0.05; % Radio del detector (sensibilidad)
data_min = 0;           % Límite inferior del espacio de datos
data_max = 1;           % Límite superior del espacio de datos

%  Generación de Datos Hipotéticos "Propios" (Self) 
% Creamos un grupo de datos "normales" alrededor de 0.5
self_center = 0.5;
self_std_dev = 0.08; % Desviación estándar (qué tan dispersos)
self_signal = self_center + self_std_dev * randn(n_self, 1);
% Nos aseguramos de que los datos estén dentro de los límites [0, 1]
self_signal = max(data_min, min(data_max, self_signal));

detectors = []; % Aquí guardaremos los detectores válidos

%  Fase 1: Censura (Entrenamiento) --- 
% El objetivo es generar detectores que NO cubran el espacio "propio".
while length(detectors) < n_detectors
    % 4. Generar detector aleatorio en el espacio del problema [0, 1]
    d_center = (data_max - data_min) * rand() + data_min; 
    
    % 5. Comprobar si coincide con 'propio' (si está demasiado cerca)
    is_self = false;
    for i = 1:length(self_signal)
        % abs(A - B) es la distancia en 1D
        if abs(d_center - self_signal(i)) < affinity_threshold
            is_self = true; % El detector está muy cerca de "propio"
            break;          % No necesitamos seguir comprobando
        end
    end
    
    % 6. Añadir a la lista de detectores si es 'no-propio'
    if ~is_self
        detectors = [detectors; d_center];
    end
end

fprintf('Fase 1 completada. Se generaron %d detectores.\n\n', length(detectors));

%  Generación de Datos de Monitoreo (Nuevos Datos) ---
% Creamos una mezcla de datos normales y anómalos
n_normal_monitoring = 100;
n_anomaly_monitoring = 40; % 20 en cada grupo

% Datos normales (similares a "propio")
normal_part = self_center + self_std_dev * randn(n_normal_monitoring, 1);

% Datos anómalos (lejos de "propio")
anomaly_part1 = 0.1 + 0.02 * randn(n_anomaly_monitoring/2, 1); % Cerca de 0.1
anomaly_part2 = 0.9 + 0.02 * randn(n_anomaly_monitoring/2, 1); % Cerca de 0.9

% Combinar y barajar los datos
new_data = [normal_part; anomaly_part1; anomaly_part2];
new_data = new_data(randperm(length(new_data))); % Barajar aleatoriamente
% Asegurar que estén dentro de los límites [0, 1]
new_data = max(data_min, min(data_max, new_data));

%  Fase 2: Monitorización  
fprintf('Iniciando Fase 2: Monitorización con %d nuevos datos...\n', length(new_data));

% Almacenamos los resultados para graficarlos
anomalies_detected_data = [];   % Qué datos fueron detectados
anomalies_detected_indices = []; % En qué índice ocurrieron

for k = 1:length(new_data)
    m = new_data(k); % El dato actual
    is_anomaly = false;
    
    for j = 1:length(detectors)
        % 11. Comprobar si coincide con un detector
        if abs(m - detectors(j)) < affinity_threshold 
            fprintf('¡Anomalía detectada en el dato %d: %f!\n', k, m); % 12. 'non-self'
            is_anomaly = true;
            
            % Guardar para la gráfica
            anomalies_detected_data = [anomalies_detected_data; m];
            anomalies_detected_indices = [anomalies_detected_indices; k];
            
            break; % Pasar al siguiente dato (ya sabemos que es anomalía)
        end
    end
    
    if ~is_anomaly
        % fprintf('Dato %d: %f es Normal (Propio).\n', k, m); % 14. 'self'
    end
end

fprintf('Fase 2 completada. Se detectaron %d anomalías.\n\n', length(anomalies_detected_data));

% =========================================================================
%  Visualización de Resultados 
% =========================================================================
fprintf('Generando visualización de resultados...\n');

figure; % Crear una nueva ventana para la figura
hold on; % Mantener los plots en la misma figura

% 1. Graficar la señal "Propia" (Self)
% Usamos un valor 'y' de 1.0 solo para separarlos visualmente
plot(self_signal, ones(size(self_signal)) * 1.0, 'bo', ...
    'DisplayName', 'Señal "Propia" (Entrenamiento)', 'MarkerFaceColor', 'b');

% 2. Graficar los Detectores generados
% Usamos un valor 'y' de 1.05 para ponerlos justo encima
plot(detectors, ones(size(detectors)) * 1.05, 'rx', ...
    'DisplayName', 'Detectores (No-Propio)', 'MarkerSize', 8);

% 3. Graficar TODOS los nuevos datos de monitoreo
% Usamos un valor 'y' de 0.95 para ponerlos justo debajo
plot(new_data, ones(size(new_data)) * 0.95, 'r.', ...
    'DisplayName', 'Datos de Monitoreo (Todos)', 'MarkerSize', 12);

% 4. Resaltar las Anomalías Detectadas
% Dibujamos un círculo verde encima de los datos que fueron detectados
if ~isempty(anomalies_detected_data)
    plot(anomalies_detected_data, ones(size(anomalies_detected_data)) * 0.95, 'go', ...
        'DisplayName', 'Anomalías Detectadas', 'MarkerSize', 10, 'LineWidth', 2);
end

%  Configuración de la Gráfica 
hold off;
title('Visualización del Algoritmo de Selección Negativa (NSA) en 1D');
xlabel('Espacio de la Señal (de 0 a 1)');
% Ocultamos los números del eje Y ya que solo los usamos para separar
set(gca, 'YTick', []); 
ylim([0.9, 1.1]); % Ajustar el zoom vertical
legend('show', 'Location', 'best');
grid on;

fprintf('¡Ejemplo completado!\n');