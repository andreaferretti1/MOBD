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

% Creo i folds
folds_idx = define_folds(folds_num, X_training, Y_training);

% Definisco il vettore contenente l'accuratezza sul validation set di ogni modello addestrato
val_f1_scores = zeros(folds_num, 1);

% Definisco il vettore contenente l'accuratezza sul validation set di ogni modello addestrato
train_f1_scores = zeros(folds_num, 1);

numeric_features_idx = [1, 2, 5, 6, 7, 8];

% Addestro i modelli, cambiando il validation set ad ogni iterazione, e calcolo l'accuratezza
for iteration = 1:folds_num

    % Calcolo i campioni del fold di validazione
    val_idx = folds_idx{iteration};
    X_validation = X_training(val_idx, :);
    Y_validation = Y_training(val_idx);

    % Calcolo i campioni dei fold di training
    train_idx = setdiff(1:num_samples, val_idx);
    X_train_folds = X_training(train_idx, :);
    Y_train_folds = Y_training(train_idx);

    % Normalizzo le features numeriche
    [X_train_folds( :, numeric_features_idx), X_validation( :, numeric_features_idx)] = z_score(X_train_folds( :, numeric_features_idx), X_validation( :, numeric_features_idx));

    % Calcolo i pesi da attribuire alle classi
    [w_pos, w_neg] = weight_class(Y_train_folds);

    % Addestro la rete neurale
    neural_network_trained = train_model(X_train_folds, Y_train_folds, X_validation, Y_validation, neural_network, training_hyperparams, true, w_pos, w_neg);

    % Classifico i campioni del fold di validazione
    [~, Y_val_classified] = predict_and_classify(X_validation, neural_network_trained);

    % Calcolo l'F1 score del modello sul fold di validazione
    [f1_score, ~, ~] = evaluate_model(Y_val_classified, Y_validation);

    % Salvo l'F1 score dell'iterazione corrente
    val_f1_scores(iteration) = f1_score;

    % Classifico i campioni del training set
    [~, Y_train_classified] = predict_and_classify(X_train_folds, neural_network_trained);

    % Calcolo l'F1 score del modello sul training set
    [f1_score, ~, ~] = evaluate_model(Y_train_classified, Y_train_folds);

    % Salvo l'F1 score dell'iterazione corrente
    train_f1_scores(iteration) = f1_score;


end

% Calcolo l'accuratezza media sul validation set e sul training set dei modelli addestrati 
mean_val_f1_score = mean(val_f1_scores);
mean_train_f1_score = mean(train_f1_scores);

end