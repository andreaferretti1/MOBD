function show_numerical_feature_graphs(features, feature_names)
%Questa funzione mostra a schermo il valore massimo del valore assoluto delle componenti di
%ciascuna feature


% Definisco l'array contenente i valori massimi di ciascuna feature
max_vals = zeros(length(feature_names), 1);

% Per ogni colonna, calcolo il massimo dei valori assoluti delle componenti
for idx = 1:length(feature_names)
    max_vals(idx) = max(abs(features(:, idx)));
end

% Disegno il grafico
figure;
bar(feature_names, max_vals);
title("Massima componente in valore assoluto");
ylabel("Valori");



end

