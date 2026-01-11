function [processed_X] = process_features(X)
% Questa funzione processa le features del dataset
% 
% Input:
% - X è la tabella delle features preprocessata
% 
% Output:
% - processed_X è la tabella delle features processate


processed_X = X;

% Modifico la colonna pdays
[was_not_previously_contacted, new_pdays] = add_was_not_previously_contacted(processed_X.pdays);

% Aggiungo la nuova colonna e aggiorno la colonna pdays originale
processed_X.was_not_previously_contacted = was_not_previously_contacted;
processed_X.pdays = new_pdays;

% Codifico giorno e mese in seno e coseno
[cos_out, sin_out] = encode_day_and_month(processed_X(:, ["day", "month"]));

% Elimino le colonne non codificate e aggiungo quelle codificate
processed_X.date_cos = cos_out;
processed_X.date_sin = sin_out;

processed_X(:, ["day", "month"]) = [];

% Codifico le colonne binarie
binary_cols = ["default", "housing", "loan"];

for idx = 1:numel(binary_cols)

    col_to_encode = binary_cols(idx);
    processed_X.(col_to_encode) = encode_binary_column(processed_X.(col_to_encode));

end


% Codifico le colonne categoriche
categorical_columns = ["job", "marital", "education", "contact", "poutcome"];

encoded_tables = cell(1, numel(categorical_columns));

% Codifico le features categoriche
for idx = 1:numel(categorical_columns)
    
    feature_encoded = encode_categorical_features(processed_X(:, categorical_columns(idx)));
    encoded_tables{idx} = feature_encoded;

end

% Eliminio la versione non codificata delle feature categoriche da processed_X
processed_X( : , categorical_columns) = [];


% Aggiungo le tabelle codificate alla tabella principale
processed_X = horzcat(processed_X, encoded_tables{:});

head(processed_X, 1);
end