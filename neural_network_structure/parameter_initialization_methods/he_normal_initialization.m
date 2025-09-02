function [W] = he_normal_initialization(neurons, num_inputs)
% Questa funzione inizializza i parametri della rete secondo l'inizializzazione normale di He, dove i parametri sono scelti randomicamente da una distribuzione normale con media 0 e varianza 2/num_input_del_neurone
% Input:
% - neurons è il numero di neuroni dello strato attuale. Corrisponde al numero di righe della matrice dei pesi
% - num_inputs è il numero di input per ogni neurone. Corrisponde al numero di colonne della matrice dei pesi
% Output:
% - W è la matrice dei pesi inizializzata

std_dev = sqrt(2/num_inputs);
W = randn(neurons, num_inputs) * std_dev;


end

