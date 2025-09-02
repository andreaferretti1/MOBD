function [encoded_Y] = encode_label(Y)
%ENCODE_LABEL Questa funzione codifica la label, utilizzando un 1 o 0
%La funzione riceve in input l'array delle label da codificare, e
%restituisce l'array codificato

%Creo il nuovo vettore
encoded_Y = zeros(height(Y), 1);

%Codifico i valori
encoded_Y(strcmp(Y, 'yes')) = 1;
end

