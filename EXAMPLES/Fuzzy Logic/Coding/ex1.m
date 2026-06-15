%% Matlab example Fuzzy logic (2 inputs and 1 output)

% Define FIS
fis = mamfis(Name='tipp');

% Adding input variables

fis = addInput(fis,[0,10],'Name','service');
fis = addInput(fis,[0,10],'Name','Food');
fis = addOutput(fis,[0,25],'Name','tip');

fis = addMF(fis,'service','trapmf',[0 0 1 3], 'Name','poor');
fis = addMF(fis,'service','trimf',[2 5 8], 'Name','acceptable');
fis = addMF(fis,'service','trapmf',[7 10 10 10], 'Name','excellent');


fis = addMF(fis,'Food','trapmf',[0 0 1 3], 'Name','bad');
fis = addMF(fis,'Food','trimf',[2 5 8], 'Name','good');
fis = addMF(fis,'Food','trapmf',[7 10 10 10], 'Name','delicious');


fis = addMF(fis,'tip','trimf',[0 5 10], 'Name', 'low');
fis = addMF(fis,'tip','trimf',[10 15 20], 'Name', 'medium');
fis = addMF(fis,'tip','trimf',[20 25 25], 'Name', 'high');


fis = addRule(fis, ["if service is poor or Food is bad then tip is low";
    "if service is acceptable or Food is good then tip is medium";
    "if service is excellent or Food is delicious then tip is high"])

plotfis(fis)

%entrenar el modelo
