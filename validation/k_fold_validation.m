function [mean_train_f2_score, mean_val_f2_score, mean_train_precision, mean_val_precision, mean_train_recall, mean_val_recall] = k_fold_validation(folds_num, neural_network, training_hyperparams, X_training, Y_training)
% Questa funzione implementa l'algoritmo di K-fold cross validation
% Input:
% - folds_num è il numero di folds in cui suddividere il training set
% - neural_network è il cell array che indica la struttura della rete neurale
% - training_hyperparams è il vettore contenente gli iperparametri di addestramento
% - X_training è la matrice relativa ai valori delle features dei campioni di addestramento
% - Y_training è il vettore relativo alle label dei campioni di addestramento
% Output:
% - mean_train_f2_score è l'F2 score medio sul validation set dei modelli ottenuti 
% - mean_val_f2_score è l'F2 score medio sul training set dei modelli addestrati 

% Mescolo il training set
num_samples = size(X_training, 1);

% Creo i folds
folds_idx = define_folds(folds_num, X_training, Y_training);

% Definisco i vettori che memorizzano le metriche sul validation set di ogni modello addestrato
val_f2_scores = zeros(folds_num, 1);
train_f2_scores = zeros(folds_num, 1);

val_precision = zeros(folds_num, 1);
train_precision = zeros(folds_num, 1);

val_recall = zeros(folds_num, 1);
train_recall = zeros(folds_num, 1);


numeric_features = ["age", "balance", "duration", "previous"];

% Addestro i modelli, cambiando il validation set ad ogni iterazione, e calcolo l'F2 score
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
    [X_train_folds{ :, numeric_features}, X_validation{ :, numeric_features}] = z_score(X_train_folds{ :, numeric_features}, X_validation{ :, numeric_features});

    % Calcolo i pesi da attribuire alle classi
    [w_pos, w_neg] = weight_class(Y_train_folds);

    % Trasformo la tabella delle features in matrici
    X_train_folds = table2array(X_train_folds);
    X_validation = table2array(X_validation);

    % Addestro la rete neurale
    neural_network_trained = train_model(X_train_folds, Y_train_folds, X_validation, Y_validation, neural_network, training_hyperparams, true, w_pos, w_neg);

    % Classifico i campioni del fold di validazione
    [~, Y_val_classified] = predict_and_classify(X_validation, neural_network_trained);

    % Calcolo le metriche del modello sul fold di validazione
    [val_f2_scores(iteration), val_precision(iteration), val_recall(iteration)] = evaluate_model(Y_val_classified, Y_validation);
   
    % Classifico i campioni del training set
    [~, Y_train_classified] = predict_and_classify(X_train_folds, neural_network_trained);

    % Calcolo le metriche del modello sul training set
    [train_f2_scores(iteration), train_precision(iteration), train_recall(iteration)] = evaluate_model(Y_train_classified, Y_train_folds);

    % Salvo l'F2 score dell'iterazione corrente
    train_f2_scores(iteration) = f2_score;


end

% Calcolo le metriche medie sul validation set e sul training set dei modelli addestrati 
mean_val_f2_score = mean(val_f2_scores);
mean_train_f2_score = mean(train_f2_scores);

mean_val_precision = mean(val_precision);
mean_train_precision = mean(train_precision);

mean_val_recall = mean(val_recall);
mean_train_recall = mean(train_recall);

end