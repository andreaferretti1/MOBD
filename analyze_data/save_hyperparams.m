function [] = save_hyperparams(model_number, neural_network_params, training_params, validation_accuracy, training_accuracy)
% Questa funzione salva su file il valore degli iperparametri della rete
% neurale finale
% Input:
% - model_number è il numero del modello addestrato
% - neural_network_params sono gli iperparametri che definiscono la struttura della rete neurale
% - training_params sono gli iperparametri di addestramento
% - validation_accuracy è l'F1 score medio del modello sui validation set
% - training_accuracy è l'F1 score medio del modell sui training set

% Apro il file in scrittura
fid = fopen("validation_result.txt", "a");

% Prendo gli iperparametri
network_hyperparams = enumeration('neural_network_hyperparameters');
training_hyperparams = enumeration('training_hyperparameters');


% Scrivo su file
fprintf(fid, "----- Model %d -----\n", model_number);
fprintf(fid, "----- Neural Network hyperparameters -----\n");
for i = 1:numel(network_hyperparams)
    
    param_name = network_hyperparams(i).to_string;
    param_value = neural_network_params{network_hyperparams(i).Value};
    fprintf(fid, "%s = %s\n", param_name, value_to_string(param_value));

end


fprintf(fid, "\n----- Training hyperparameters -----\n");
for i = 1:numel(training_hyperparams)

    param_name = training_hyperparams(i).to_string;
    param_value = training_params(training_hyperparams(i).Value);
    fprintf(fid, "%s = %s\n", param_name, value_to_string(param_value));

end

fprintf(fid, "\n----- Results -----\n");
fprintf(fid, "Validation F1 = %.4f\n", validation_accuracy);
fprintf(fid, "Training F1   = %.4f\n", training_accuracy);
fprintf(fid, "\n\n");

fclose(fid);

end

