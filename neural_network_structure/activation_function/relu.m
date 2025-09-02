function [result] = relu(x)
% Questa funzione rappresenta la funzione di ativazione relu.
% La funzione è element-wise, quindi può essere usata anche se in input sono passati vettori o matrici

result = max(0, x);
end

