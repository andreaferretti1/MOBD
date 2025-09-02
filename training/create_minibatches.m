function [minibatches] = create_minibatches(num_of_data, minibatch_size)
% Questa funzione restituisce un cell array, dove ogni cella i contiene gli
% indici che corrispondono ai campioni del training set da assegnare al
% minibatch i.
% Input:
% - num_of_data è il numero dei campioni del training set
% - minibatch_size è la grandezza del minibatch
% Output
% - minibatches è un cell array in la cella i-esima contiene il vettore degli indici dell i-esimo minibatch

% Creo il cell array
num_of_minibatches = ceil(num_of_data / minibatch_size);
minibatches = cell(num_of_minibatches, 1);

% Genero una permutazione randomica degli indici
rand_indexes = randperm(num_of_data);

% Suddivido gli indici in minibatch
for i = 1:num_of_minibatches
    start = minibatch_size * (i - 1) + 1;
    stop = min(minibatch_size * i, num_of_data);
    minibatches{i} = rand_indexes(start : stop);
end


end