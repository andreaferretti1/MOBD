function [neural_network_trained] = train_model(X_training, Y_training, X_eval, Y_eval, neural_network, training_hyperparams, is_validation, w_pos, w_neg)
% Questa funzione addestra il modello.
% 
% Input:
% - X_training è la matrice dei valori delle features dei campioni del training set
% - Y_training è il vettore delle label dei campioni del training set
% - X_eval è la matrice dei valori delle features dei campioni del validation set
% - Y_eval è il vettore delle label dei campioni del validation set
% - neural_network è il cell array contenente gli elementi che definiscono la rete neurale
% - training_hyperparams è il vettore degli iperparametri di addestramento
% - w_pos è il peso da attribuire alla classe positiva
% - w_neg è il peso daattribuire alla classe negativa
% is_validation è un booleano che indica se sto addestrando la rete per fare tuning degli iperparametri o no
% 
% Output:
% - neural_network_trained è il cell array che definisce la struttura della rete neurale addestrata, con matrici dei pesi e vettori di bias aggiornati


% Addestro il modello
[W_trained, b_trained] = momentum_gradient_method(training_hyperparams, X_training, Y_training, X_eval, Y_eval, neural_network, is_validation, w_pos, w_neg);

% Definisco la rete neurale addestrata
neural_network_trained = neural_network;
neural_network_trained{neural_network_structure.WEIGHT_MATRIX.Value} = W_trained;
neural_network_trained{neural_network_structure.BIAS_VECTOR.Value} = b_trained;

end