function [encoded_feature] = encode_categorical_features(categorical_feature)
% Questa funzione codifica una feature categorica utilizzando la one hot
% encoding. 
% La funzione riceve in input la colonna da convertire, e restituisce il
% risultato al chiamante


% Cerco le categorie della colonna
categories = unique(categorical_feature);

%Calcolo il numero di campioni e di categorie
data_size = numel(categorical_feature);
categories_number = numel(categories);

% Per ogni campione assegno la colonna che deve essere impostata a 1
[~, column_to_set] = ismember(categorical_feature, categories);

% Creo la matrice che rappresenta la codifica
encoded_feature = zeros(data_size, categories_number);

% Popolo la matrice di codifica
for data_idx = 1:data_size
    index_to_set = column_to_set(data_idx);
    encoded_feature(data_idx, index_to_set) = 1;
end

end

