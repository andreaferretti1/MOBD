function [folds] = define_folds(folds_num, num_of_samples)
% Questa funzione definisce i folds in cui deve essere suddiviso il training_set
% Input:
% - folds_num è il numero di folds in cui deve essere suddiviso il training_set
% - num_of_samples è il numero di campioni di addestramento
% Output:
% - folds è un array lungo num_folds, dove la componente i-esima indica l'indice di inizio dell'i-esimo fold

% Dichiaro l'array dei folds
folds = zeros(folds_num, 1);

% Definisco la grandezza di un fold
fold_size = floor( num_of_samples / folds_num );

% Calcolo i campioni extra
extra_samples = mod(num_of_samples, folds_num);

start_idx = 1;

% Popolo l'array
for fold = 1: folds_num
    
    folds(fold) = start_idx;

    if( extra_samples > 0)
        start_idx = start_idx + fold_size + 1;
        extra_samples = extra_samples - 1;
    else
        start_idx = start_idx + fold_size;
    end
   

end


end

