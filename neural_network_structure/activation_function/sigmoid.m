function [y] = sigmoid(x)
% Questa funzione implementa la funzione sigmoide
% Input:
% - x rappresenta il vettore su cui calcolare la sigmoide
% Output:
% - y è il vettore restituito dalla sigmoide

y = 1 ./ (1 + exp(-x));
end

