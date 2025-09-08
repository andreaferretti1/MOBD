function show_numerical_feature_graphs(features, feature_names)
%Questa funzione mostra i grafici delle distribuzioni dei valori delle
%features numeriche.


% Per ogni colonna, calcolo la distribuzione dei valori
for feature = 1:length(feature_names)

    % Seleziono la feature
    feature_values = features(:, feature);
    
    % Calcolo il numero di campioni per ogni valore della feature
    [unique_vals, ~, ic] = unique(feature_values);
    values_counts = accumarray(ic, 1);
    
    % Disegno il grafico
    figure;
    bar(unique_vals, values_counts);

    title(['Distribuzione valori - ' feature_names{feature}]);
    xlabel('Valore');
    ylabel('Frequenza');
    
    % Salvo il grafico
    saveas(gcf, ['resources\grafico_' feature_names{feature} '.png']);

end

end

