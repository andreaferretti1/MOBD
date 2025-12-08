function [] = save_hyperparams(model_number, neural_network_params, training_params, mean_train_f2_score, mean_val_f2_score, mean_train_precision, mean_val_precision, mean_train_recall, mean_val_recall)
% Questa funzione salva su file il valore degli iperparametri della rete
% neurale finale
% 
% Input:
% - model_number è il numero del modello addestrato
% - neural_network_params sono gli iperparametri che definiscono la struttura della rete neurale
% - training_params sono gli iperparametri di addestramento
% - mean_train_f2_score è l'F2 score medio del modello sui training set
% - mean_val_f2_score è l'F2 score medio del modello sui validation set
% - mean_train_precision è la precisione media del modello sui training set
% - mean_val_precision è la precisione media del modello sui validation set
% - mean_train_recall è la recall media del modello sui training set
% - mean_val_recall è la recall media del modello sui validation set

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
fprintf(fid, "Validation F2 = %.4f\n", mean_val_f2_score);
fprintf(fid, "Training F2 = %.4f\n\n", mean_train_f2_score);
fprintf(fid, "Validation Precision = %.4f\n", mean_val_precision);
fprintf(fid, "Training Precision = %.4f\n\n", mean_train_precision);
fprintf(fid, "Validation Recall = %.4f\n", mean_val_recall);
fprintf(fid, "Training Recall = %.4f\n\n", mean_train_recall);
fprintf(fid, "\n\n");

fclose(fid);

end

