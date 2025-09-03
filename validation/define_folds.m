function [folds_idx] = define_folds(folds_num, X, Y)
% Questa funzione definisce i folds in cui deve essere suddiviso il
% training set. La suddivisione è stratificata, 
% in modo tale che la classe in minoranza sia rappresentata in ciascun fold 
% Input:
% - folds_num è il numero di folds in cui deve essere suddiviso il training set
% - X è la matrice delle features dei campioni che devono essere suddivisi nei fold
% - Y è il vettore delle labels dei campioni che devono essere suddivisi nei fold
% Output:
% - folds è un cell array lungo num_folds, dove la componente i-esima contiene gli indici dell'i-esimo fold

num_of_samples = size(X, 1);
if(num_of_samples ~= size(Y, 1))
    error("X and Y should have the same number of samples.");
end

% Dichiaro l'array dei folds
folds_idx = cell(folds_num, 1);

% Suddivido gli indici nelle due classi
positive_idx = find(Y == 1);
negative_idx = find(Y == 0);

% Eseguo lo shuffle dei campioni
positive_idx = positive_idx(randperm(length(positive_idx)));
negative_idx = negative_idx(randperm(length(negative_idx)));


% Suddivido i campioni nei fold
for fold = 1: folds_num
    
    % Calcolo gli indici di inizio e fine per i campioni positivi del fold corrente
    start_pos = floor((fold - 1) * length(positive_idx) / folds_num) + 1;
    end_pos = floor(fold * length(positive_idx) / folds_num);
    
    % Calcolo gli indici di inizio e fine per i campioni negativi del fold corrente
    start_neg = floor((fold - 1) * length(negative_idx) / folds_num) + 1;
    end_neg = floor(fold * length(negative_idx) / folds_num);
    
    % Assegno gli indici di entrambe le classi al fold corrente
    folds_idx{fold} = [positive_idx(start_pos:end_pos); negative_idx(start_neg:end_neg)];


end


end

