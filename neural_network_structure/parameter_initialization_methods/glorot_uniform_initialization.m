function [W] = glorot_uniform_initialization(neurons, num_inputs)
% Questa funzione implementa il metodo di inizializzazione dei pesi di Glorot con distribuzione uniforme. Ciascun parametro è scelto casualmente dalla distribuzione uniforme con bound +-( 6 / (numero_neuroni + numero_input_per_neurone) ) ^ (1/2) 
% Input:
% - neurons è il numero di neuroni dello strato attuale. Corrisponde al numero di righe della matrice dei pesi
% - num_inputs è il numero di input per ogni neurone. Corrisponde al numero di colonne della matrice dei pesi
% Output:
% - W è la matrice dei pesi inizializzata

bound = sqrt(6 / (neurons + num_inputs));
W = (2*bound) .*rand(neurons, num_inputs) - bound;

end

