function [W] = glorot_normal_initialization(neurons, num_inputs)
% Questa funzione implementa la tecnica di inizializzazione dei parametri di Glorot con distribuzione normale. I parametri vengono scelti randomicamente da una distribuzione normale con media zero e varianza 2/(numero_di_neuroni + numero_di_input_per_neurone)
% Input:
% - neurons è il numero di neuroni dello strato attuale. Corrisponde alle righe della matrice dei pesi
% - num_inputs è il numero di input ricevuti da ciascun neurone. Corrisponde alle colonne della matrice dei pesi
% Ouput:
% - W è la matrice dei pesi inizializzata

std_dev = sqrt(2 / (neurons + num_inputs));
W = randn(neurons, num_inputs) * std_dev;

end

