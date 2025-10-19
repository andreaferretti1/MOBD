function feature_label_frequency(categorical_feature, feature_name, Y)
% Questa funzione calcola, per ogni categoria di pdays, la percentuale di
% utenti che hanno accettato di sottoscrivere il fondo e la percentuale di
% utenti che non lo hanno sottoscritto.
% 
% Input:
% - pdays_categorical è la feature pdays dopo essere stata trasformata in una feature categorica
% - feature_name è il nome della feature
% - Y è l'array delle label

% Estraggo le categorie
my_categories = categories(categorical_feature);
num_of_categories = length(my_categories);

% Dichiaro gli array in cui memorizzare le percentuali
pos_perc = zeros(num_of_categories, 1);
neg_perc = zeros(num_of_categories, 1);

% Calcolo le percentuali
for idx = 1:num_of_categories

    category = my_categories{idx};

    % Calcolo il numero di campioni per categoria
    indexes = (categorical_feature == category);
    total = sum(indexes);
    
    % Calcolo le percentuali
    pos_perc(idx) = sum(Y(indexes) == 1) / total;
    neg_perc(idx) = sum(Y(indexes) == 0) / total;


end


% Disegno un grafico a barre
figure;
bar([pos_perc, neg_perc]);
grid on;
set(gca, 'XTickLabel', my_categories);
xlabel('Categoria ' + feature_name);
ylabel('Percentuale (%)');
legend({'Label 1','Label 0'}, 'Location','best');
title('Distribuzione label per categoria di ' + feature_name);

end

