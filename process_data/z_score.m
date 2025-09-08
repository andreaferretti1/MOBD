function [X_train_norm, X_eval_norm] = z_score(X_training,X_evaluation)
% Questa funzione normalizza i valori delle features con la normalizzazione
% z-score.
% Input:
% - X_training è la matrice delle features dei campioni del training set da normalizzare
% - X_evaluation è la matrice delle features dei campioni del validation/test set da normalizzare
% Output:
% - X_train_norm è la matrice delle features dei campioni del training set normalizzate
% - X_eval_norm è la matrice delle features dei campioni del validation/test set normalizzate

% Calcolo media e deviazione standard sui campioni del training set
mu = mean(X_training);
sigma = std(X_training);

sigma(sigma == 0) = 1;

% Normalizzo le features
X_train_norm = (X_training - mu) ./ sigma;
X_eval_norm = (X_evaluation - mu) ./ sigma;
end

