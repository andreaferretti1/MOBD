%Punto di accesso al codice

function main

% --------------------Importo il dataset dal file csv--------------------

data = get_dataset;


% ----------------------------Analizzo i dati----------------------------

% Eseguo il preprocessamento dei dati per poterli analizzare
[X, Y] = preprocess_data(data);

% % % Analizzo le feature numeriche
% % numeric_features= ["age", "balance", "duration", "campaign", "pdays", "previous"];
% % 
% % show_numerical_feature_graphs(X(:, numeric_features), numeric_features);


% Imposto il seed, in maniera tale da avere risultati uguali in esecuzioni diverse del codice
rng(1);

% Suddivido il dataset in training set e test set
 [X_training, X_test, Y_training, Y_test] = split_dataset(X, Y, 0.33);


% % % Disegno gli scatter plot tra ciascuna feature numerica e la label del training set
% % show_numerical_features_scatter_plot(X_training(:, numeric_features), numeric_features, Y_training);
% % 
% % % Trasformo pdays e campaign in feature categoriche e analizzo come varia la loro relazione con la label
% % pdays = transform_pdays(X_training.pdays);
% % feature_label_frequency(pdays, "pdays", Y_training);
% % 
% % campaign = transform_campaign(X_training.campaign);
% % feature_label_frequency(campaign, "campaign", Y_training);


% ---------Avvio la pipeline di pulizia e codifica delle features---------

[X_training] = process_features(X_training);
[X_test] = process_features(X_test);

% ----------------Effettuo il tuning degli iperparametri------------------

% Definisco i possibili valori degli iperparametri
alpha = [0.0006, 0.0006, 0.0006, 0.0006, 0.0006, 0.0006, 0.0006];
beta = [0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95];
epochs = [50, 50, 50, 50, 50, 50, 50];
minibatch_sizes = [128, 128, 128, 128, 128, 128, 128];
regularization_coefficients = [0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001];

input_neurons = size(X_training, 2);
output_neurons = 1;
network_configs = {
    struct('neurons', [input_neurons, 64, 32, 16, 8, 4, output_neurons], 'act_funcs', ["relu", "relu", "relu", "relu", "relu", "sigmoid"] ), ...
    struct('neurons', [input_neurons, 64, 32, 16, 8, 4, output_neurons], 'act_funcs', ["relu", "relu", "relu", "relu", "relu", "sigmoid"] ), ...
    struct('neurons', [input_neurons, 64, 32, 16, 8, 4, output_neurons], 'act_funcs', ["relu", "relu", "relu", "relu", "relu", "sigmoid"] ), ...
    struct('neurons', [input_neurons, 64, 32, 16, 8, 4, output_neurons], 'act_funcs', ["relu", "relu", "relu", "relu", "relu", "sigmoid"] ), ...
    struct('neurons', [input_neurons, 64, 32, 16, 8, 4, output_neurons], 'act_funcs', ["relu", "relu", "relu", "relu", "relu", "sigmoid"] ), ...
    struct('neurons', [input_neurons, 64, 32, 16, 8, 4, output_neurons], 'act_funcs', ["relu", "relu", "relu", "relu", "relu", "sigmoid"] ), ...
    struct('neurons', [input_neurons, 128, 64, 32, 16, output_neurons], 'act_funcs', ["relu", "relu", "relu", "relu", "sigmoid"] ),
    };

parameter_initialization_method = ["he_normal", "he_normal", "he_normal", "he_normal", "he_normal", "he_normal", "he_normal"];
threshold_positivity = [0.95, 0.85, 0.875, 0.9, 0.925, 0.975, 0.5];

[best_network_hyperparams, best_training_hyperparams] = tune_hyperparameters(X_training, Y_training, alpha, beta, epochs, minibatch_sizes, regularization_coefficients, network_configs, parameter_initialization_method, threshold_positivity);


% ---Addestro il modello con la combinazione di iperparametri migliore---
num_neurons_per_layer = best_network_hyperparams{neural_network_hyperparameters.NETWORK_CONFIGURATION}.neurons;
num_hidden_layers = numel(num_neurons_per_layer) - 2;
activation_functions = best_network_hyperparams{neural_network_hyperparameters.NETWORK_CONFIGURATION}.act_funcs;
parameter_initialization_method = best_network_hyperparams{neural_network_hyperparameters.PARAM_INIT_METHOD};
threshold_positivity = best_network_hyperparams{neural_network_hyperparameters.THRESHOLD_POSITIVITY};
neural_network = define_neural_network_structure(num_hidden_layers, num_neurons_per_layer, activation_functions, parameter_initialization_method, threshold_positivity);
is_validation = false;

% Normalizzo le features numeriche
numeric_features = ["age", "balance", "duration", "previous"];
[X_training{:, numeric_features}, X_test{ :, numeric_features}] = z_score(X_training{:, numeric_features}, X_test{ :, numeric_features});

% Trasformo le tabelle in matrici
X_training = table2array(X_training);
X_test = table2array(X_test);

% Calcolo i pesi da attribuire alle classi
[w_pos, w_neg] = weight_class(Y_training);

% Addestro il modello
neural_network_trained = train_model(X_training, Y_training, neural_network, best_training_hyperparams, is_validation, w_pos, w_neg);


% ---Valuto le prestazioni del modello sul training set e sul data set---
[~, Y_classified] = predict_and_classify(X_test, neural_network_trained);
[F1_score_test, ~, ~] = evaluate_model(Y_classified, Y_test);

[~, Y_classified] = predict_and_classify(X_training, neural_network_trained);
[F1_score_training, ~, ~] = evaluate_model(Y_classified, Y_training);

draw_accuracy_chart(F1_score_training, F1_score_test, 'Valutazione prestazioni modello finale');

end