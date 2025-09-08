%Punto di accesso al codice

function main
% Importo il dataset dal file csv
data = get_dataset;

% Analizzo il trend dal punto di vista cronologico
% ****analyze_time_trends(data( : , {'month', 'y'}));****

% Processo i dati. Il processamento consiste nell'eliminare campioni
% con features mancanti, nel codificare la label e le features
% categoriche, e nel normalizzare le features numeriche.

[X, Y] = process_data(data);

% Analizzo le feature numeriche
numeric_features_idx = [1, 2, 5, 6, 7, 8];
%show_numerical_feature_graphs(X(:, numeric_features_idx), {'age','balance', 'duration', 'campaign', 'pdays', 'previous'});
 

% Imposto il seed, in maniera da avere risultati uguali in esecuzioni diverse del codice
rng(1);

% Suddivido il dataset in training set e test set
[X_training, X_test, Y_training, Y_test] = split_dataset(X, Y, 0.33);
 

% Effettuo il tuning degli iperparametri
% Definisco i possibili valori degli iperparametri
alpha = [0.01, 0.01, 0.01, 0.01, 0.01, 0.01];
beta = [0.9, 0.9, 0.9, 0.9, 0.9, 0.9];
epochs = [100, 100, 100, 100, 100, 100];
 minibatch_sizes = [128, 128, 128, 128, 128, 128];
 regularization_coefficients = [0.00004, 0.00005, 0.00006, 0.00007, 0.00008, 0.000009];
 
 input_neurons = size(X_training, 2);
 output_neurons = 1;
 network_configs = { 
          struct('neurons', [input_neurons, 128, 64, 32, output_neurons], 'act_funcs', ["relu", "relu", "relu", "sigmoid"] ), ...
          struct('neurons', [input_neurons, 128, 64, 32, output_neurons], 'act_funcs', ["relu", "relu", "relu", "sigmoid"] ), ...
          struct('neurons', [input_neurons, 128, 64, 32, output_neurons], 'act_funcs', ["relu", "relu", "relu", "sigmoid"] ), ...
          struct('neurons', [input_neurons, 128, 64, 32, output_neurons], 'act_funcs', ["relu", "relu", "relu", "sigmoid"] ), ...
          struct('neurons', [input_neurons, 128, 64, 32, output_neurons], 'act_funcs', ["relu", "relu", "relu", "sigmoid"] ), ...
          struct('neurons', [input_neurons, 128, 64, 32, output_neurons], 'act_funcs', ["relu", "relu", "relu", "sigmoid"] )
 };
 
 parameter_initialization_method = ["he_normal", "he_normal", "he_normal", "he_normal", "he_normal", "he_normal"];
 threshold_positivity = [0.8, 0.8, 0.8, 0.8];
 
 [best_network_hyperparams, best_training_hyperparams] = tune_hyperparameters(X_training, Y_training, alpha, beta, epochs, minibatch_sizes, regularization_coefficients, network_configs, parameter_initialization_method, threshold_positivity);
 
 % Addestro il modello con la combinazione di iperparametri migliore
 num_neurons_per_layer = best_network_hyperparams{neural_network_hyperparameters.NETWORK_CONFIGURATION}.neurons;
 num_hidden_layers = numel(num_neurons_per_layer) - 2;
 activation_functions = best_network_hyperparams{neural_network_hyperparameters.NETWORK_CONFIGURATION}.act_funcs;
 parameter_initialization_method = best_network_hyperparams{neural_network_hyperparameters.PARAM_INIT_METHOD};
 threshold_positivity = best_network_hyperparams{neural_network_hyperparameters.THRESHOLD_POSITIVITY};
 neural_network = define_neural_network_structure(num_hidden_layers, num_neurons_per_layer, activation_functions, parameter_initialization_method, threshold_positivity);
 is_validation = false;
 
 % Normalizzo le features numeriche
 [X_training(:, numeric_features_idx), X_test( :, numeric_features_idx)] = z_score(X_training(:, numeric_features_idx), X_test( :, numeric_features_idx));
 
 % Calcolo i oesi da attribuire alle classi
 [w_pos, w_neg] = weight_class(Y_training);

 % Addestro il modello
 neural_network_trained = train_model(X_training, Y_training, neural_network, best_training_hyperparams, is_validation, w_pos, w_neg); 

 % Valuto le prestazioni del modello sul training set e sul data set
 [~, Y_classified] = predict_and_classify(X_test, neural_network_trained);
 [F1_score_test, ~, ~] = evaluate_model(Y_classified, Y_test);
 
 [~, Y_classified] = predict_and_classify(X_training, neural_network_trained);
 [F1_score_training, ~, ~] = evaluate_model(Y_classified, Y_training);
 
 draw_accuracy_chart(F1_score_training, F1_score_test, 'Valutazione prestazioni modello finale');

end