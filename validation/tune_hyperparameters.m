function [neural_network_params, training_params] = tune_hyperparameters(X_training, Y_training, alpha, beta, epochs, minibatch_sizes, regularization_coefficients, network_configs, parameter_initialization_method, threshold_positivity)
% Questa funzione implementa il processo di tuning degli iperparametri. La
% funzione restituisce in output la combinazione di iperparametri migliore.
% La funzione salva le reti neurali provate e l'F1 score su validation set e su training set nel file validation_result.txt
% Input:
% - X_training è la matrice dell'insieme dei valori di input dei campioni del training set
% - Y_training è il vettore delle labels dei campioni del training set
% - alpha è il vettore dei valori del learning rate tra cui scegliere
% - beta è il vettore dei valori del coefficiente di momentum tra cui scegliere
% - epochs è il vettore dei valori del numero di epoche tra cui scegliere
% - minibatch_sizes è il vettore dei valori della grandezza del minibatch tra cui scegliere
% - regularization_coefficients è il vettore dei valori del coefficiente di regolarizzazione tra cui scegliere
% - network_configs è un cell array di struct. Ogni struct ha un vettore che indica il numero di neuroni per ognistrato, inclusi strato di input e output, e un array di stringhe che indicano la funzione di attivazione per ciascuno strato
% - parameter_initialization_method è il vettore dei possibili modi di inizializzare i parametri della rete
% - threshold_positivity è il vettore delle soglie di positività del classificatore tra cui scegliere
% Output:
% - neural_network_params è il cell array degli iperparametri relativi alla struttura della rete neurale che, assieme agli iperparametri di addestramento, hanno dato accuratezza maggiore
% - training_params è il vettore degli iperparametri relativiall'addestramento che, assieme agli iperparametri della struttura della rete neurale, hanno dato accuratezza maggiore

% Scrivo su file la data di validazione
fid = fopen("validation_result.txt", "a");
today = string(datetime('today', 'Format', 'dd-MM-yyyy'));
fprintf(fid, "\n\n\n------------------------- %s -------------------------\n\n\n", today);
fclose(fid);

% Definisco la variabili in cui salvare l'F1 score sul validation set
best_val_f1_score = 0;

f1_score_difference = 0;

% Definisco i vettori in cui salvare la combinazione di iperparametri migliore
neural_network_params = cell(numel(enumeration('neural_network_hyperparameters')), 1);
training_params = zeros(numel(enumeration('training_hyperparameters')), 1);

% Definisco il valore di tolleranza della differenza tra accuratezza media sul training set e sul validation set
tolerance_value = 0.05;

number_of_model = 0;

% Valido i modelli
for i = 1:numel(alpha)

    number_of_model = number_of_model + 1;

    
    a = alpha(i);
    b = beta(i);
    e = epochs(i);
    minibatch = minibatch_sizes(i);
    r = regularization_coefficients(i);
    th = threshold_positivity(i);
    net_config = network_configs{i};
    
    neurons_per_layer = net_config.neurons;
    activation_functions_per_layer = net_config.act_funcs;
    if(numel(neurons_per_layer) - 1 ~= numel(activation_functions_per_layer))
        error("Number of activation functions differs from number of layers for configuration");
    end
    
    
    param_init_method = parameter_initialization_method(i);
    
    % Definisco la struttura della rete neurale e il vettore degli iperparametri di addestramento
    neural_network = define_neural_network_structure(numel(neurons_per_layer) - 2, neurons_per_layer, activation_functions_per_layer, param_init_method, th);
    
    training_params(training_hyperparameters.ALPHA.Value) = a;
    training_params(training_hyperparameters.BETA.Value) = b;
    training_params(training_hyperparameters.EPOCHS_NUM.Value) = e;
    training_params(training_hyperparameters.MINIBATCH_SIZE.Value) = minibatch;
    training_params(training_hyperparameters.REGULARIZATION_COEFFICIENT.Value) = r;

    % Eseguo l'algoritmo di k-fold validation
    [mean_train_f1_score, mean_val_f1_score] = k_fold_validation(5, neural_network, training_params, X_training, Y_training);

    % Controllo che l'accuratezza sul validation set sia simile a quella
    % sul training set
    f1_score_difference = abs(mean_train_f1_score - mean_val_f1_score);
    

    % Confronto l'accuratezza media sul validation set con l'accuratezza media sul validation set migliore
    if(mean_val_f1_score > best_val_f1_score)
        
        % Aggiorno i parametri
        best_val_f1_score = mean_val_f1_score;
       
    end


    neural_network_params{neural_network_hyperparameters.NETWORK_CONFIGURATION.Value} = net_config;
    neural_network_params{neural_network_hyperparameters.PARAM_INIT_METHOD.Value} = param_init_method;
    neural_network_params{neural_network_hyperparameters.THRESHOLD_POSITIVITY.Value} = th;


    save_hyperparams(number_of_model, neural_network_params, training_params, mean_val_f1_score, mean_train_f1_score);
    
end

if(best_val_f1_score <= 0.85 && f1_score_difference > tolerance_value)
    error("Didn't find suitable model\n");
end

end

