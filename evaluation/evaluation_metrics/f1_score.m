function [f1_score] = f1_score(precision, recall)
% Questa funzione calcola la metrica F1 score, che rappresenta la media
% armonica delle metriche precision e recall
% La formula utilizzata è F1 = 2 * precision * recall / (precision + recall)
% Input:
% - precision è il valore di precision del modello
% - recall è il valore di recall del modello
% Ouput:
% - f1_score è il valore di F1 score del modello

% Calcolo numeratore e denominatore
num = 2 * precision * recall;
den = precision + recall;

% Calcolo F1 score. Se il denominatore è nullo, ritorno 0.
if(den == 0)
    f1_score = 0;
else
    f1_score = num / den;
end

end

