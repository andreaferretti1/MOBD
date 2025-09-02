function [model_f1_score, model_precision, model_recall] = evaluate_model(Y_classified, Y_test)
% Questa funzione valuta le prestazioni del modello. Le metriche utilizzate
% sono F1 score, precision e recall.
% Input:
% - Y_pred è il vettore degli output classificati dal modello sui campioni del test set
% - Y_test è il vettore delle label dei campioni del test set
% Output:
% - model_f1_score è il valore di F1 score del modello
% - model_precision è il valore di precision del modello
% - model_recall è il valore di recall del modello

% Calcolo la matrice di confusione
[TP, FP, ~, FN] = confusion_matrix(Y_classified, Y_test);

% Cacolo le metriche di accuratezza
model_precision = precision(TP, FP);
model_recall = recall(TP, FN);
model_f1_score = f1_score(model_precision, model_recall);

end

