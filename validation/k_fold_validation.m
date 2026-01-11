function [mean_train_f2_score, mean_val_f2_score, mean_train_precision, mean_val_precision, mean_train_recall, mean_val_recall, best_threshold] = k_fold_validation(folds_num, neural_network, training_hyperparams, X_training, Y_training)
% Questa funzione implementa l'algoritmo di K-fold cross validation. Dopo
% aver addestrato i K modelli, si sceglie la soglia di decisione che
% massimizza l'F2-score su tutto il vettore contenente le predizioni dei
% modelli sui rispettivi fold di validazione. Successivamente, viene
% calcolato l'F2-score per ciascun fold, e ne viene calcolata la media
%
% Input:
% - folds_num è il numero di folds in cui suddividere il training set
% - neural_network è il cell array che indica la struttura della rete neurale
% - training_hyperparams è il vettore contenente gli iperparametri di addestramento
% - X_training è la matrice relativa ai valori delle features dei campioni di addestramento
% - Y_training è il vettore relativo alle label dei campioni di addestramento
%
% Output:
% - mean_train_f2_score è l'F2 score medio sul validation set dei modelli ottenuti
% - mean_val_f2_score è l'F2 score medio sul training set dei modelli addestrati
% - best_threshold è la soglia che massimizza l'F2-score

% Mescolo il training set
num_samples = size(X_training, 1);

% Creo i folds
folds_idx = define_folds(folds_num, X_training, Y_training);

% Creo gli array contenenti le predizioni dei modelli sui campioni dei rispettivi fold di validazione, e le corrispettive label
Y_val_predicted = cell(folds_num, 1);
Y_val_folds = cell(folds_num, 1);

% Creo gli array contenenti le predizioni dei modelli sui campioni dei rispettivi fold di addestramento, e le corrispettive label
Y_train_predicted = cell(folds_num, 1);
Y_train_folds = cell(folds_num, 1);


% Definisco i vettori che memorizzano le metriche sul validation set di ogni modello addestrato
val_f2_scores = zeros(folds_num, 1);
train_f2_scores = zeros(folds_num, 1);

val_precision = zeros(folds_num, 1);
train_precision = zeros(folds_num, 1);

val_recall = zeros(folds_num, 1);
train_recall = zeros(folds_num, 1);


numeric_features = ["age", "balance", "duration", "previous", "campaign", "pdays"];

% Addestro i modelli, cambiando il validation set ad ogni iterazione, e calcolo l'F2 score
for iteration = 1:folds_num

    % Calcolo i campioni del fold di validazione
    val_idx = folds_idx{iteration};
    X_validation = X_training(val_idx, :);
    Y_validation = Y_training(val_idx);

    Y_val_folds{iteration} = Y_validation;

    % Calcolo i campioni dei fold di training
    train_idx = setdiff(1:num_samples, val_idx);
    X_train_set = X_training(train_idx, :);
    Y_train_set = Y_training(train_idx);

    Y_train_folds{iteration} = Y_train_set;


    % Normalizzo le features numeriche
    [X_train_set{ :, numeric_features}, X_validation{ :, numeric_features}] = z_score(X_train_set{ :, numeric_features}, X_validation{ :, numeric_features});

    % Calcolo i pesi da attribuire alle classi
    [w_pos, w_neg] = weight_class(Y_train_set);

    % Trasformo la tabella delle features in matrici
    X_train_set = table2array(X_train_set);
    X_validation = table2array(X_validation);

    % Addestro la rete neurale
    neural_network_trained = train_model(X_train_set, Y_train_set, X_validation, Y_validation, neural_network, training_hyperparams, true, w_pos, w_neg);

    % Calcolo le predizioni del modello sui campioni del fold di validazione e dei fold di addestramento
    [Y_train_predicted{iteration}, ~] = predict_and_classify(true, X_train_set, neural_network_trained);
    [Y_val_predicted{iteration}, ~] = predict_and_classify(true, X_validation, neural_network_trained);

end

% Calcolo la soglia ottimale
all_val_predictions = vertcat(Y_val_predicted{ : });
all_val_labels = vertcat(Y_val_folds{ : });

[best_threshold, ~] = tune_threshold(all_val_predictions, all_val_labels);

% Calcolo le metriche medie dei modelli
for iteration = 1 : folds_num

    % Fold di validazione
    Y_val_probabilities = Y_val_predicted{iteration};
    Y_val_labels = Y_val_folds{iteration};

    Y_val_classified = Y_val_probabilities >= best_threshold;

    [val_f2_scores(iteration), val_precision(iteration), val_recall(iteration)] = evaluate_model(Y_val_classified, Y_val_labels);

    % Fold di addestramento
    Y_train_probabilities = Y_train_predicted{iteration};
    Y_train_labels = Y_train_folds{iteration};

    Y_train_classified = Y_train_probabilities >= best_threshold;

    [train_f2_scores(iteration), train_precision(iteration), train_recall(iteration)] = evaluate_model(Y_train_classified, Y_train_labels);

end

% Calcolo le metriche medie sul validation set e sul training set dei modelli addestrati
mean_val_f2_score = mean(val_f2_scores);
mean_train_f2_score = mean(train_f2_scores);

mean_val_precision = mean(val_precision);
mean_train_precision = mean(train_precision);

mean_val_recall = mean(val_recall);
mean_train_recall = mean(train_recall);

end