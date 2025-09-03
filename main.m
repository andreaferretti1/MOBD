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
% ****show_numerical_feature_graphs(X(:, [1, 2, 5, 6, 7, 8]), {'age','balance', 'duration', 'campaign', 'pdays', 'previous'});****
 

% Imposto il seed, in maniera da avere risultati uguali in esecuzioni diverse del codice
rng(1);

% Suddivido il dataset in training set e test set
[X_training, X_test, Y_training, Y_test] = split_dataset(X, Y, 0.33);


% Effettuo il tuning degli iperparametri
% Definisco i possibili valori degli iperparametri
alpha = [0.001, 0.00001, 0.00001, 0.0001];
beta = [0.9, 0.9, 0.9, 0.9];
epochs = [80, 80, 80, 80];
minibatch_sizes = [256, 256, 256, 256];
regularization_coefficients = [0.005, 0.01, 0.5, 0.2];

input_neurons = size(X_training, 2);
output_neurons = 1;
network_configs = { ...
    struct('neurons', [input_neurons, 128, 64, output_neurons], 'act_funcs', ["relu", "relu", "sigmoid"]), ...
    struct('neurons', [input_neurons, 32, 16, 8, 4 output_neurons], 'act_funcs', ["relu", "relu", "relu", "relu", "sigmoid"]),...
    struct('neurons', [input_neurons, 32, 16, 8, output_neurons], 'act_funcs', ["relu", "relu", "relu", "sigmoid"]),...
    struct('neurons', [input_neurons, 32, 16, 8, output_neurons], 'act_funcs', ["relu", "relu", "relu", "sigmoid"])...

};

parameter_initialization_method = ["he_normal", "he_normal", "uniform", "he_normal"];
threshold_positivity = [0.2, 0.3, 0.2, 0.1];

[best_network_hyperparams, best_training_hyperparams] = tune_hyperparameters(X_training, Y_training, alpha, beta, epochs, minibatch_sizes, regularization_coefficients, network_configs, parameter_initialization_method, threshold_positivity);

% Addestro il modello con la combinazione di iperparametri migliore
num_neurons_per_layer = best_network_hyperparams{neural_network_hyperparameters.NETWORK_CONFIGURATION}.neurons;
num_hidden_layers = numel(num_neurons_per_layer) - 2;
activation_functions = best_network_hyperparams{neural_network_hyperparameters.NETWORK_CONFIGURATION}.act_funcs;
parameter_initialization_method = best_network_hyperparams{neural_network_hyperparameters.PARAM_INIT_METHOD};
threshold_positivity = best_network_hyperparams{neural_network_hyperparameters.THRESHOLD_POSITIVITY};
neural_network = define_neural_network_structure(num_hidden_layers, num_neurons_per_layer, activation_functions, parameter_initialization_method, threshold_positivity);
is_validation = false;

neural_network_trained = train_model(X_training, Y_training, neural_network, best_training_hyperparams, is_validation);

% Valuto le prestazioni del modello sul training set e sul data set
[~, Y_classified] = predict_and_classify(X_test, neural_network_trained);
[F1_score_test, ~, ~] = evaluate_model(Y_classified, Y_test);

[~, Y_classified] = predict_and_classify(X_training, neural_network_trained);
[F1_score_training, ~, ~] = evaluate_model(Y_classified, Y_training);

draw_accuracy_chart(F1_score_training, F1_score_test, 'Valutazione prestazioni modello finale');
end