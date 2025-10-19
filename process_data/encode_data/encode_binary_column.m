function [encoded_column] = encode_binary_column(column)
% Questa funzione codifica le colonne binarie, utilizzando un 1 o 0
% 
% Input: 
% - column è la colonna binaria
%
% Output:
% - encoded_column è la colonna codificata

% Creo il nuovo vettore
encoded_column = zeros(height(column), 1);

% Imposto a 1 le componenti che hanno label 'yes'
encoded_column(strcmp(column, 'yes')) = 1;
end

