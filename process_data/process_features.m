function [processed_X] = process_features(X)
% Questa funzione processa le features del dataset
% 
% Input:
% - X è la tabella delle features preprocessata
% 
% Output:
% - processed_X è la tabella delle features processate


processed_X = X;

% Codifico giorno e mese in seno e coseno
[cos_out, sin_out] = encode_day_and_month(processed_X(:, ["day", "month"]));

% Elimino le colonne non codificate e aggiungo quelle codificate
processed_X.date_cos = cos_out;
processed_X.date_sin = sin_out;

processed_X(:, ["day", "month"]) = [];

% Applico il logaritmo alle fearures con distribuzione asimmetrica
processed_X.age = apply_log(processed_X.age);
processed_X.balance = apply_log(processed_X.balance);
processed_X.duration = apply_log(processed_X.duration);
processed_X.previous = apply_log(processed_X.previous);

% Codifico le colonne binarie
binary_cols = ["default", "housing", "loan"];

for idx = 1:numel(binary_cols)

    col_to_encode = binary_cols(idx);
    processed_X.(col_to_encode) = encode_binary_column(processed_X.(col_to_encode));

end

% Trasformo "pdays" e "campaign" in colonne categoriche
processed_X.pdays = transform_pdays(X.pdays);
processed_X.campaign = transform_campaign(X.campaign);

% Codifico le colonne categoriche
categorical_columns = ["job", "marital", "education", "contact", "poutcome", "pdays", "campaign"];

encoded_tables = cell(1, numel(categorical_columns));

% Codifico le features categoriche
for idx = 1:numel(categorical_columns)
    
    feature_encoded = encode_categorical_features(processed_X(:, categorical_columns(idx)));
    encoded_tables{idx} = feature_encoded;

end

% Eliminio le feature categoriche non codificate da processed_X
processed_X( : , categorical_columns) = [];


% Aggiungo le tabelle codificate alla tabella principale
processed_X = horzcat(processed_X, encoded_tables{:});

end