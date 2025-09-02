function [loss] = binary_cross_entropy(Y_predicted, Y_actual)
% Questa funzione implementa la binary cross entropy
% Input:
% - Y_preditced è il vettore delle predizioni del classificatore
% - Y_actual è il vettore delle label dei campioni su cui è stata effettuata la predizione
% Output:
% - loss è il vettore delle loss sui campioni passati in input

% Verifico che i due vettori passati in input abbiano la stessa dimensione
if(numel(Y_predicted) ~= numel(Y_actual))
    error("Couldn't compute loss function because Y_predicted and Y_actual had different size");
end

% Modifico l'intervallo di Y_predicted in [1e-12, 1-1e-12] per evitare che il logaritmo sia infinito
epsilon = 1e-12;
Y_predicted = max(min(Y_predicted, 1-epsilon), epsilon);


% Calcolo la loss
loss = - Y_actual .* log(Y_predicted) - ( 1 - Y_actual) .* log( 1 - Y_predicted);
 

end

