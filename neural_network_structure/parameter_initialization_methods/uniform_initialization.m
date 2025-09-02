function [W] = uniform_initialization(neurons, prev_layer_neurons)
% Questa funzione inizializza i parametri della rete scegliendo numeri casuali dalla distribuzione uniforme di intervallo (-0.1, 0.1)
% Input:
% - nuerons è il numero di neuroni dello strato attuale. Corrisponde al numero di righe della matrice dei pesi
% - prev_layer_neurons è il numero di neuroni dello strato precedente. Corrisponde al numero di colonne della matrice dei pesi
% Output:
% - W è la matrice dei pesi inizializzata

W = 0.2 .*rand(neurons, prev_layer_neurons) - 0.1;

end

