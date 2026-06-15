% Sentiment Analysis of News Articles using NewsAPI.org
% Author: Aboud BARSEKH-ONJI (D.Sc.)
% Universidad Anáhuac México Sur - Faculty of Engineering
% Email: aboud.barsekh@anahuac.mx
% ORCID: 0009-0004-5440-8092
% (Requiered: Text Analytics Toolbox and API Key from NewsAPI.org)
% =========================================================================

clear; clc; close all;

% API configuration
apiKey = 'XXXXXXXXXXXXXX'; % My API Key for NewsAPI.org
termino_busqueda = 'Elon Musk'; % Keyword phrase in quotes
lenguaje = 'en';

fecha_desde = '2025-09-30'; % YYYY-MM-DD
fecha_hasta = '2025-10-30'; % YYYY-MM-DD

url = sprintf(['https://newsapi.org/v2/everything?q=%s&from=%s&to=%s&' ...
               'language=%s&sortBy=publishedAt&apiKey=%s'], ...
               termino_busqueda, fecha_desde, fecha_hasta, lenguaje, apiKey);

options = weboptions('MediaType', 'application/json', 'Timeout', 30);

% API Call
fprintf('Llamando a NewsAPI para buscar: %s\n', termino_busqueda);
try
    data = webread(url, options);
catch ME
    error('Falló la llamada a la API. Verifica tu API Key y la conexión. Error: %s', ME.message);
end

fprintf('Se encontraron %d artículos.\n', data.totalResults);

if isempty(data.articles)
    fprintf('No se encontraron artículos para este rango de fechas.\n');
    return;
end

% NLP process 
% Title and Description Extraction
textos = cell(length(data.articles), 1);
fechas_articulos = NaT(length(data.articles), 1); % NaT = Not-a-Time

for i = 1:length(data.articles)
    titulo = data.articles(i).title;
    descripcion = data.articles(i).description;
    
    if ischar(titulo)
        textos{i} = [titulo, '. '];
    end
    if ischar(descripcion)
        textos{i} = [textos{i}, descripcion];
    end

    fechas_articulos(i) = datetime(data.articles(i).publishedAt, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss''Z''');
end

% Clean empty entries
textos(cellfun(@isempty, textos)) = [];
fechas_articulos(isnat(fechas_articulos)) = [];

if isempty(textos)
    fprintf('No hay texto válido para analizar.\n');
    return;
end

% Sentiment Analysis
fprintf('Iniciando análisis de sentimiento...\n');
documents = tokenizedDocument(textos);
documents = addPartOfSpeechDetails(documents);
documents = normalizeWords(documents);
documents = removeStopWords(documents);
documents = erasePunctuation(documents);

% VADER algorithm
sentimentScores = vaderSentimentScores(documents);
compoundScores = sentimentScores;

sentimiento_promedio = mean(compoundScores);
fprintf('Sentimiento promedio (Safety Sentiment): %.4f\n', sentimiento_promedio);

% Results table creation
T_sentimiento_diario = table(fechas_articulos, compoundScores, 'VariableNames', {'Fecha', 'Sentimiento_Seguridad'});

T_sentimiento_diario = retime(timetable(T_sentimiento_diario.Fecha, T_sentimiento_diario.Sentimiento_Seguridad), ...
                              'daily', 'mean');
T_sentimiento_diario = timetable2table(T_sentimiento_diario);
T_sentimiento_diario.Properties.VariableNames{1} = 'Fecha';
T_sentimiento_diario.Properties.VariableNames{2} = termino_busqueda;

disp(T_sentimiento_diario);
save('NewsSentiment_Procesado.mat', 'T_sentimiento_diario');