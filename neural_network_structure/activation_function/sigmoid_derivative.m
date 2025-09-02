function [y] = sigmoid_derivative(x)
% Questa funzione calcola la derivata della sigmoide
% Input:
% - x è il vettore su cui deve essere calcolata la derivata
% Output
% - y è il vettore restituito dalla derivata della sigmoide

y = sigmoid(x) .* (1 - sigmoid(x));
end

