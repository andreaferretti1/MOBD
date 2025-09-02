function [TP, FP, TN, FN] = confusion_matrix(y_pred, y)
% Questa funzione calcola la matrice di confusione sulle previsioni
% effettuate.
% Input:
% - y_pred è il vettore degli output predetti dal modello
% - y è il valore delle label dei campioni su cui il modello ha calcolato la previsione
% Output:
% - TP è il numero di true positives
% - FP è il numero di false positives
% - TN è il numero di true negatives
% - FN è il numero di false negatives

if(length(y_pred) ~= length(y))
    error("Error in matrix confusion calculation: y predicted and actual y are different in number");
end

% Per calcolare false positives e false negatives calcolo la differenza tra
% predizione e valore attuale. Se è 1, vuol dire che ho un false positive,
% se è -1 un false negative.
y_difference = y_pred - y;

FP = sum(y_difference == 1);
FN = sum(y_difference == -1);

% Per calcolare true positives e true negatives calcolo la somma tra
% predizione e valore attuale. Se è 2, allora ho un true positive, se è 0
% ho un true nagative.
y_sum = y_pred + y;

TP = sum(y_sum == 2);
TN = sum(y_sum == 0);

disp(TP);
disp(FP);
disp(TN);
disp(FN);
end

