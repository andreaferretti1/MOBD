function [was_not_previously_contacted, new_pdays] = add_was_not_previously_contacted(pdays)
% Questa funzione crea la colonna "was_not_previously_contacted", che
% indica se il cliente non è stato contattato in campagne precedenti, ed
% elimina il valore -1 dalla colonna pdays.

% Calcolo la lunghezza della colonna
col_length = length(pdays);

% Inizializzo le colonne
was_not_previously_contacted = zeros(col_length, 1);
new_pdays = pdays;

% Popolo was_not_previously_contacted
was_not_previously_contacted(pdays == -1) = 1;

% Elimino il valore -1 da pdays
new_pdays(pdays == -1) = 0;

end

