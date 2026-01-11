function [X, Y] = preprocess_data(dataset)
% Questa funzione esegue un processamento parziale dei dati, in modo tale
% da poterli analizzare. Le operazioni eseguite sono la rimozione di valori 
% duplicati o mancanti e la codifica della label in valore binario  
% 
% Input:
% - dataset è la tabella del dataset caricata dal file csv
% 
% Output:
% - X è la tabella delle features preprocessata
% - Y è il vettore delle label codificate

cleaned_dataset = dataset;

% Rimuovo dati con features mancanti
if(any(ismissing(dataset)))
    cleaned_dataset = rmmissing(dataset);
end

% Rimuovo eventuali duplicati
cleaned_dataset = unique(cleaned_dataset, 'rows');

% Divido il dataset in una matrice contenente i campioni e le relative feature, e in un array di valori della label
X = removevars(cleaned_dataset, 'y');
Y = cleaned_dataset.y;

% Codifico la label
Y = encode_binary_column(Y);

head(X, 1);
end

