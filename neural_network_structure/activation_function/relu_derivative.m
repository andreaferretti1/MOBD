function [derivative] = relu_derivative(x)
% Questa funzione implementa la derivata della funzione di attivazione
% relu. Poichè la funzione è non derivabile in x = 0, si pone, per convenzione,
% la derivata in x = 0 pari a 0.
% La funzione è element-wise, quindi può essere usata anche se in input sono passati vettori o matrici
%
% Input:
% - x è il valore rispetto al quale deve essere calcolata la derivata
%
% Output:
% - derivative è il valore della derivata

derivative = x > 0;
end

