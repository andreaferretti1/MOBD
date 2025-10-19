function [log_feature] = apply_log(feature)
% Questa funzione riceve in input i valori di una feature numerica e
% applica il logaritmo per ridurne l'asimmetria. La funzione controlla se
% ci sono valori negativi o nulli, e in tal caso trasla l'intervallo dei dati in
% [1, max_value + 1 - min_value]
% Input:
% - feature è il vettore contenente i valori della feature
% Output:
% - log_feature è il vettore contenente il logaritmo dei valori della feature

% Calcolo il minimo valore della feature
min_value = min(feature);

% Controllo se il valore è negativo o nullo
if(min_value <= 0)
    feature = feature + 1 - min_value;
end

log_feature = log(feature);

end

