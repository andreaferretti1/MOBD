function [w_pos, w_neg] = weight_class(Y_training)
% Questa funzione calcola i pesi bilanciati da attribuire a ciascuna classe per la
% loss function
% Input:
% - Y_training è il vettore delle labels dei campioni del training set
% Output:
% - w_pos è il peso da attribuire alla classe positiva
% - w_neg è il peso da attribuire alla classe negativa

% Calcolo il numero di campioni del training set
num_samples = size(Y_training, 1);

% Calcolo il numero di campioni della classe negativae positiva
num_negative_samples = sum(Y_training == 0);
num_positive_samples = sum(Y_training == 1);

% Calcolo i pesi
w_pos = num_samples / (2 * num_positive_samples);
w_neg = num_samples / (2 * num_negative_samples);

end

