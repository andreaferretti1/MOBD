function [training_set_X, test_set_X, training_set_Y, test_set_Y] = split_dataset(X, Y, perc_test)
% Questa funzione riceve in input la matrice delle features e la colonna della label, e lo divide in training set
% e test set. Poichè il dataset è sbilanciato, la suddivisione è
% stratificata, ovvero per costruire il test set viene preso perc_test dei campioni con label
% negativa e perc_test dei campioni con label positiva 
% Input:
% - X è la matrice che rappresenta l'insieme dei valori delle features dei campioni
% - Y è il vettore che rappresenta l'insieme delle label dei campioni
% - perc_test è la percentuale di dataset che deve costituire il test set
% Output:
% - training_set_X è la matrice che rappresenta l'insieme dei valori delle features dei campioni del training set
% - test_set_X è lla matrice che rappresenta l'insieme dei valori delle features dei campioni del test set
% - training_set_Y è il vettore che rappresenta l'insieme delle label dei campioni del training set
% - test_set_Y è il vettore che rappresenta l'insieme delle label dei campioni del test set
% Il rimescolamento randomico del training set è implementato nella fase di
% creazione dei minibatch e di suddivisione del training set in folds.


% Controllo che perc_test sia compreso tra 0 e 1
if(perc_test <= 0 || perc_test >= 1)
    error("Test percentage must be between 0 and 1. Yours is %f", perc_test);
end

% Suddivido X e Y in campioni con label negativa e campioni con label positiva
X_positive = X( Y == 1, :);
Y_positive = Y( Y == 1);
X_negative = X( Y == 0, :);
Y_negative = Y( Y == 0 );

% Calcolo il numero di campioni del dataset con label positive
[positive_rows, ~] = size(X_positive);

% Calcolo il numero di campioni del dataset con label negative
[negative_rows, ~] = size(X_negative);

% Calcolo il numero di righe del test set per entrambe le tipologie di campione
test_positive_rows = floor( positive_rows * perc_test);
test_negative_rows = floor( negative_rows * perc_test);

% Calcolo gli indici dei campioni che costituiranno il test set
test_positive_idx = randperm( positive_rows, test_positive_rows);
test_negative_idx = randperm( negative_rows, test_negative_rows);

% Calcolo gli indici dei campioni che costituiranno il training set
training_positive_idx = setdiff(1:positive_rows, test_positive_idx);
training_negative_idx = setdiff(1:negative_rows, test_negative_idx);

% Suddivido il dataset
training_set_X = [ X_positive(training_positive_idx, :); X_negative(training_negative_idx, :)];
training_set_Y = [ Y_positive(training_positive_idx); Y_negative(training_negative_idx)];
test_set_X = [ X_positive(test_positive_idx, :); X_negative(test_negative_idx, :)];
test_set_Y = [ Y_positive(test_positive_idx); Y_negative(test_negative_idx)];
    
end

