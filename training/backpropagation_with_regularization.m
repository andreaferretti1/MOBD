function [grad_W, grad_b] = backpropagation_with_regularization(minibatch_size, Y_labels, neural_network, lambda, Y_predicted, a, z, w_pos, w_neg)
% Questa funzione implementa l'algoritmo di backpropagation per il calcolo
% del gradiente dell'errore commesso su un campione. L'algoritmo di
% backpropagation è stato scritto in forma vettoriale, in modo tale da
% sfruttare le caratteristiche del linguaggio di programmazione MATLAB.
% Inoltre, l'algoritmo calcola la media della somma dei
% gradienti sul minibatch, e aggiunge il gradiente del termine di
% regolarizzazione, che in questo caso è la norma l2.
% Input:
% - minibatch_size è la grandezza del minibatch
% - Y_labels è l'insieme delle label dei campioni del minibatch
% - neural_network è il cell array contenente gli elementi che definiscono la rete neurale
% - lambda è il coefficiente di regolarizzazione
% - Y_predicted è l'insieme delle predizioni effettuate dal modello sui campioni del minibatch
% - a è l'insieme delle uscite degli strati della rete neurale
% - z è l'insieme delle somme pesate in input ai neuroni di ciascuno strato
% - w_pos è il peso da attribuire alla classe positiva
% - w_neg è il peso da attribuire alla classe negativa
% Output:
% - grad_W è un cell array, in cui la cella i-esima rappresenta la matrice contenente la media della somma dei gradienti degli errori sul minibatch rispetto ai pesi che vanno dallo strato i allo strato i+1
% - grad_b è un cell array, in cui la cella i-esima rappresenta il vettore contenente la media della somma dei gradienti degli errori sul minibatch rispetto ai bias dello strato i

% Estraggo gli elementi della rete neurale
W = neural_network{neural_network_structure.WEIGHT_MATRIX.Value};
b = neural_network{neural_network_structure.BIAS_VECTOR.Value};
g_derivative = neural_network{neural_network_structure.ACTIVATION_FUNCTIONS_DERIVATIVE.Value};

% Calcolo il numero di strati
num_layers = length(W) + 1;


% Inizializzo il gradiente
grad_W = cell(size(W));
grad_b = cell(size(b));

% Calcolo il vettore del peso da dare a ciascun campione
weight_vector = w_pos .* Y_labels + w_neg .* (1 - Y_labels);

% Creo un vettore che tiene traccia del gradiente dell'errore rispetto alle z
dE_dz = weight_vector' .* (Y_predicted' - Y_labels');

for layer = (num_layers - 1):-1:1
    
    % Calcolo la media dei gradienti degli errori
    grad_b{layer } = sum(dE_dz, 2) / minibatch_size;
    grad_W{layer} = (dE_dz * a{layer}') / minibatch_size;

    % Aggiungo il termine di regolarizzazione
    grad_W{layer} = grad_W{layer} + 2*lambda*W{layer};

    if layer > 1
        % Definisco il vettore degli elementi sulla diagonale della matrice Jacobiana relativa a dg_dz
        dg_dz_diag = g_derivative{layer - 1}(z{layer - 1});
      
        dE_dz = (W{layer}' * dE_dz) .* dg_dz_diag;
    end

end

end


