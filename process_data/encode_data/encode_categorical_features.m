function [encoded_feature] = encode_categorical_features(categorical_feature)
% Questa funzione codifica una feature categorica utilizzando la one hot
% encoding. 
% 
% Input:
% - categorical_feature è la feature da codificare
% 
% Output:
% - encoded_feature è una table, dove ciascuna colonna è una categoria della feature

% Estraggo il nome della feature per dare il nome alle colonne di encoded_feature
feature_name = categorical_feature.Properties.VariableNames{1};

% Converto la feature a un array di tipo categorico
categorical_feature.(feature_name) = categorical(categorical_feature.(feature_name));

% Estraggo le categorie della feature
feature_categories = categories(categorical_feature.(feature_name));

% Converto la feature in una matrice one-hot encoded
categories_num = numel(feature_categories);
data_num = numel(categorical_feature.(feature_name));
encoded_matrix = zeros(data_num, categories_num);

for i = 1:categories_num
    encoded_matrix( :, i) = (categorical_feature.(feature_name) == feature_categories{i});
end

% Creo i nomi delle colonne in formato nomeVariabile_categoria
column_names = strcat(feature_name, "_", feature_categories);

% Converto la matrice in una tabella
encoded_feature = array2table(encoded_matrix, 'VariableNames', column_names);

end

