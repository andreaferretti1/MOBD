function [mean_train_f1_score, mean_val_f1_score] = k_fold_validation(folds_num, neural_network, training_hyperparams, X_training, Y_training)
% Questa funzione implementa l'algoritmo di K-fold cross validation
% Input:
% - folds_num è il numero di folds in cui suddividere il training set
% - neural_network è il cell array che indica la struttura della rete neurale
% - training_hyperparams è il vettore contenente gli iperparametri di addestramento
% - X_training è la matrice relativa ai valori delle features dei campioni di addestramento
% - Y_training è il vettore relativo alle label dei campioni di addestramento
% Output:
% - mean_val_f1_score è l'F1 score media sul validation set dei modelli ottenuti 
% - mean_train_f1_score è l'F1 score media sul training set dei modelli addestrati 

% Mescolo il training set
num_samples = size(X_training, 1);
shuffled_idx = randperm(num_samples);
X_shuffled = X_training(shuffled_idx, :);
Y_shuffled = Y_training(shuffled_idx);

% Creo i folds
folds = define_folds(folds_num, num_samples);

% Definisco il vettore contenente l'accuratezza sul validation set di ogni modello addestrato
val_f1_scores = zeros(folds_num, 1);

% Definisco il vettore contenente l'accuratezza sul validation set di ogni modello addestrato
train_f1_scores = zeros(folds_num, 1);

% Addestro i modelli, cambiando il validation set ad ogni iterazione, e calcolo l'accuratezza
for iteration = 1:folds_num

    % Calcolo l'indice iniziale e finale del fold di validazione
    val_set_start_idx = folds(iteration);

    if(iteration ~= folds_num)
        val_set_end_idx = folds (iteration + 1);
    else
        val_set_end_idx = num_samples;
    end

    % Calcolo i campioni del fold di validazione
    val_idx = val_set_start_idx : val_set_end_idx;
    X_validation = X_shuffled(val_idx, :);
    Y_validation = Y_shuffled(val_idx);

    % Calcolo i campioni dei fold di training
    train_idx = setdiff(1:num_samples, val_idx);
    X_training = X_shuffled(train_idx, :);
    Y_training = Y_shuffled(train_idx);

    % Addestro la rete neurale
    neural_network_trained = train_model(X_training, Y_training, X_validation, Y_validation, neural_network, training_hyperparams, true);

    % Classifico i campioni del fold di validazione
    [~, Y_val_classified] = predict_and_classify(X_validation, neural_network_trained);

    % Calcolo l'F1 score del modello sul fold di validazione
    [f1_score, ~, ~] = evaluate_model(Y_val_classified, Y_validation);

    % Salvo l'F1 score dell'iterazione corrente
    val_f1_scores(iteration) = f1_score;

    % Classifico i campioni del training set
    [~, Y_train_classified] = predict_and_classify(X_training, neural_network_trained);

    % Calcolo l'F1 score del modello sul training set
    [f1_score, ~, ~] = evaluate_model(Y_train_classified, Y_training);

    % Salvo l'F1 score dell'iterazione corrente
    train_f1_scores(iteration) = f1_score;


end

% Calcolo l'accuratezza media sul validation set e sul training set dei modelli addestrati 
mean_val_f1_score = mean(val_f1_scores);
mean_train_f1_score = mean(train_f1_scores);

end