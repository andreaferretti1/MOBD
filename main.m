function main

% ---------------------Importo il dataset dal file csv---------------------

data = get_dataset;

% ------------------Eseguo il preprocessamento dei dati--------------------

[X, Y] = preprocess_data(data);

% ---------Avvio la pipeline di pulizia e codifica delle features---------

[X] = process_features(X);

% ------------Suddivido il dataset in training set e test set--------------

rng(1);

[X_training, X_test, Y_training, Y_test] = split_dataset(X, Y, 0.33);

% ----------------Effettuo il tuning degli iperparametri------------------

% Definisco i possibili valori degli iperparametri

% % alpha = [0.003, 0.002];
% % beta = [0.95, 0.95];
% % epochs = [70, 70];
% % minibatch_sizes = [256, 256];
% % regularization_coefficients = [0.004, 0.004];
% % 
% % input_neurons = size(X_training, 2);
% % output_neurons = 1;
% % 
% % network_configs = {
% %     struct('neurons', [input_neurons, 128, 64, 32, 16, output_neurons], 'act_funcs', ["relu", "relu", "relu", "relu", "sigmoid"] ), ...
% %     struct('neurons', [input_neurons, 128, 64, 32, 16, output_neurons], 'act_funcs', ["relu", "relu", "relu", "relu", "sigmoid"] )
% %     };
% % 
% % parameter_initialization_method = ["he_normal", "he_normal"];
% % 
% % tune_hyperparameters(X_training, Y_training, alpha, beta, epochs, minibatch_sizes, regularization_coefficients, network_configs, parameter_initialization_method);


% ----Addestro il modello con la combinazione di iperparametri migliore----

input_neurons = size(X_training, 2);
output_neurons = 1;

num_neurons_per_layer = [input_neurons, 128, 64, 32, 16, output_neurons];
num_hidden_layers = numel(num_neurons_per_layer) - 2;
activation_functions = ["relu", "relu", "relu", "relu", "sigmoid"];
parameter_initialization_method = "he_normal";
threshold_positivity = 0.9;
neural_network = define_neural_network_structure(num_hidden_layers, num_neurons_per_layer, activation_functions, parameter_initialization_method, threshold_positivity);
is_validation = false;

training_params = zeros(numel(enumeration('training_hyperparameters')), 1);
training_params(training_hyperparameters.ALPHA.Value) = 0.002;
training_params(training_hyperparameters.BETA.Value) = 0.95;
training_params(training_hyperparameters.EPOCHS_NUM.Value) = 100;
training_params(training_hyperparameters.MINIBATCH_SIZE.Value) = 128;
training_params(training_hyperparameters.REGULARIZATION_COEFFICIENT.Value) = 0.004;

% Normalizzo le features numeriche
numeric_features = ["age", "balance", "duration", "previous", "campaign", "pdays"];
[X_training{:, numeric_features}, X_test{ :, numeric_features}] = z_score(X_training{:, numeric_features}, X_test{ :, numeric_features});

% Trasformo le tabelle in matrici
X_training = table2array(X_training);
X_test = table2array(X_test);

% Calcolo i pesi da attribuire alle classi
[w_pos, w_neg] = weight_class(Y_training);

% Addestro il modello
neural_network_trained = train_model(X_training, Y_training, X_test, Y_test, neural_network, training_params, is_validation, w_pos, w_neg);


% ---Valuto le prestazioni del modello sul training set e sul data set---
[~, Y_classified_test] = predict_and_classify(false, X_test, neural_network_trained);
[F2_score_test, precision_test, recall_test] = evaluate_model(Y_classified_test, Y_test);

[~, Y_classified_training] = predict_and_classify(false, X_training, neural_network_trained);
[F2_score_training, precision_training, recall_training] = evaluate_model(Y_classified_training, Y_training);

results_training = struct('f2', F2_score_training, 'precision', precision_training, 'recall', recall_training);
results_test = struct('f2', F2_score_test, 'precision', precision_test, 'recall', recall_test);

draw_accuracy_chart(results_training, results_test, 'Valutazione prestazioni modello finale');

end