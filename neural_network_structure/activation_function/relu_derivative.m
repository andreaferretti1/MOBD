function [derivative] = relu_derivative(x)
% relu_derivative rappresenta la derivata della funzione di attivazione
% relu. Poichè la funzione è non derivabile in x = 0, si pone, per convenzione,
% la derivata in x = 0 pari a 0.

% La funzione è element-wise, quindi può essere usata anche se in input sono passati vettori o matrici

derivative = x > 0;
end

