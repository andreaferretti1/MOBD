function [recall] = recall(TP,FN)
% Questa funzione implementa la metrica "recall", che misura la percentuale
% del numero di campioni che sono positivi, e che sono stati predetti
% correttamente dal modello
% La formula è Recall = true positives / (true positives + false negatives)
% Input:
% - TP è il numero di true positives
% - FN è il numero di false negatives
% Output:
% - recall è il valore di recall del modello


if(TP + FN == 0)
    recall = 0;
else
    recall = TP / (TP + FN);
end

end

