function [f2_score] = f2_score(precision, recall)
% Questa funzione calcola la metrica F2 score, che rappresenta la media
% armonica pesata delle metriche precision e recall
% La formula utilizzata è F2 = 5 * precision * recall / ( 4 * precision + recall)
% Input:
% - precision è il valore di precision del modello
% - recall è il valore di recall del modello
% Ouput:
% - f2_score è il valore di F2 score del modello

% Calcolo numeratore e denominatore
num = 5 * precision * recall;
den = 4 * precision + recall;

% Calcolo F1 score. Se il denominatore è nullo, ritorno 0.
if(den == 0)
    f2_score = 0;
else
    f2_score = num / den;
end

end

