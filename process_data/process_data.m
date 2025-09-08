function [processed_X, processed_Y] = process_data(dataset)
% Questa funzione processa il dataset, eliminando campioni con valori
% mancanti o duplicati
% La funzione riceve in input il dataset importato dal file csv, e
% dopo averlo processato, restituisce un array contenenti i campioni, e un
% array contenente le label.


cleaned_dataset = dataset;

% Rimuovo dati con features mancanti
if(any(ismissing(dataset)))
    cleaned_dataset = rmmissing(dataset);
end

% Divido il dataset in una matrice contenente i campioni e le relative
% feature, e in un array di valori della label
processed_X = cleaned_dataset(:, 1 : 16);
processed_Y = cleaned_dataset.y;

% Codifico la label
processed_Y = encode_label(processed_Y);

% Codifico giorno e mese in seno e coseno
[cos_out, sin_out] = encode_day_and_month(processed_X(:, ["day", "month"]));

% Aggiungo la colonna was_not_previously_contacted ed elimino il valore -1
% dalla colonna pdays
[processed_X.was_not_previously_contacted, processed_X.pdays] = add_was_not_previously_contacted(processed_X.pdays);

% Elimino le colonne non codificate e aggiungo quelle codificate
processed_X.day = cos_out;
processed_X.month = sin_out;

% Applico il logaritmo alle fearures con distribuzione asimmetrica
processed_X.balance = apply_log(processed_X.balance);
processed_X.duration = apply_log(processed_X.duration);
processed_X.campaign = apply_log(processed_X.campaign);
processed_X.pdays = apply_log(processed_X.pdays);
processed_X.previous = apply_log(processed_X.previous);

% Dichiaro le colonne che rappresentano features categoriche
columns_to_encode = [2, 3, 4, 5, 7, 8, 9, 16];

% Dichiaro una cella che mantiene le features codificate
encoded_parts = cell(1, numel(columns_to_encode));

% Codifico le features categoriche
for idx = 1:numel(columns_to_encode)
    feature_encoded = encode_categorical_features(processed_X(:, columns_to_encode(idx)));
    encoded_parts{idx} = feature_encoded;

end

% Eliminio le feature categoriche non codificate da processed_X
processed_X( : , columns_to_encode) = [];

% processed_X è di tipo table. Effettuo il cast in matrice numerica
processed_X = table2array(processed_X);

% Aggiungo le colonne codificate
processed_X = [processed_X, horzcat(encoded_parts{ : })];
end

