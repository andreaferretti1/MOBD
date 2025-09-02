function [precision] = precision(TP, FP)
% Questa funzione implementa la metrica di valutazione "precisione", la quale
% esprime il numero di campioni predetti come positivi dal modello, e che
% lo sono effettivamente.
% La formula utilizzata è Precision = true positives / (true positives + false positives)
% Input:
% - TP è il numero di true positives
% - FP è il numero di false positives
% Output:
% - precision è il valore di precision del modello

if(TP + FP == 0)
    precision = 0;
else
    precision = TP / (TP + FP);
end

end

