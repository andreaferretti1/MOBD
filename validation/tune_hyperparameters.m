function tune_hyperparameters(X_training, Y_training, alpha, beta, epochs, minibatch_sizes, regularization_coefficients, network_configs, parameter_initialization_method)
% Questa funzione implementa il processo di tuning degli iperparametri
% La funzione salva le reti neurali provate e l'F2 score su validation set e su training set nel file validation_result.txt
% 
% Input:
% - X_training è la matrice dell'insieme dei valori di input dei campioni del training set
% - Y_training è il vettore delle labels dei campioni del training set
% - alpha è il vettore dei valori del learning rate tra cui scegliere
% - beta è il vettore dei valori del coefficiente di momentum tra cui scegliere
% - epochs è il vettore dei valori del numero di epoche tra cui scegliere
% - minibatch_sizes è il vettore dei valori della grandezza del minibatch tra cui scegliere
% - regularization_coefficients è il vettore dei valori del coefficiente di regolarizzazione tra cui scegliere
% - network_configs è un cell array di struct. Ogni struct ha un vettore che indica il numero di neuroni per ogni strato, inclusi strato di input e output, e un array di stringhe, che indica la funzione di attivazione per ciascuno strato
% - parameter_initialization_method è il vettore dei possibili modi di inizializzare i parametri della rete



% Scrivo su file la data di validazione
fid = fopen("validation_result.txt", "a");
today = string(datetime('today', 'Format', 'dd-MM-yyyy'));
fprintf(fid, "\n\n=================================================================\n");
fprintf(fid, "                  START BATCH RUN: %s\n", today);
fprintf(fid, "=================================================================\n\n");
fclose(fid);


% Definisco i vettori in cui salvare la combinazione di iperparametri corrente
neural_network_hyperparams = cell(numel(enumeration('neural_network_hyperparameters')), 1);
training_params = zeros(numel(enumeration('training_hyperparameters')), 1);


% Valido i modelli
for i = 1:numel(alpha)

    number_of_model = i;

    a = alpha(i);
    b = beta(i);
    e = epochs(i);
    minibatch = minibatch_sizes(i);
    reg_coeff = regularization_coefficients(i);
    net_config = network_configs{i};
    
    neurons_per_layer = net_config.neurons;
    activation_functions_per_layer = net_config.act_funcs;
    if(numel(neurons_per_layer) - 1 ~= numel(activation_functions_per_layer))
        error("Number of activation functions differs from number of layers for configuration");
    end
    
    
    param_init_method = parameter_initialization_method(i);
    
    % Definisco la struttura della rete neurale
    neural_network = define_neural_network_structure(numel(neurons_per_layer) - 2, neurons_per_layer, activation_functions_per_layer, param_init_method, -1);
    
    % Definisco gli iperparametri di addestramento
    training_params(training_hyperparameters.ALPHA.Value) = a;
    training_params(training_hyperparameters.BETA.Value) = b;
    training_params(training_hyperparameters.EPOCHS_NUM.Value) = e;
    training_params(training_hyperparameters.MINIBATCH_SIZE.Value) = minibatch;
    training_params(training_hyperparameters.REGULARIZATION_COEFFICIENT.Value) = reg_coeff;

    % Eseguo l'algoritmo di k-fold validation
    [mean_train_f2_score, mean_val_f2_score, mean_train_precision, mean_val_precision, mean_train_recall, mean_val_recall, best_threshold] = k_fold_validation(5, neural_network, training_params, X_training, Y_training);

    % Definisco gli iperparametri della rete
    neural_network_hyperparams{neural_network_hyperparameters.NETWORK_CONFIGURATION.Value} = net_config;
    neural_network_hyperparams{neural_network_hyperparameters.PARAM_INIT_METHOD.Value} = param_init_method;
    neural_network_hyperparams{neural_network_hyperparameters.THRESHOLD_POSITIVITY.Value} = best_threshold;
    
    % Salvo gli iperparametri e le metriche nel report
    save_hyperparams(number_of_model, neural_network_hyperparams, training_params, mean_train_f2_score, mean_val_f2_score, mean_train_precision, mean_val_precision, mean_train_recall, mean_val_recall);
    
    
end


end

