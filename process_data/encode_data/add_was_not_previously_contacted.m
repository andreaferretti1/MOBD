function [was_not_previously_contacted, new_pdays] = add_was_not_previously_contacted(pdays)
% Questa funzione crea la colonna "was_not_previously_contacted", che
% indica se il cliente non è stato contattato in campagne precedenti, ed
% elimina il valore -1 dalla colonna pdays.

% Creo la colonna was_not_previously_contacted
was_not_previously_contacted = double(pdays == -1);
    
% Modifico la colonna pdays
new_pdays = pdays;
new_pdays(pdays == -1) = 0;

end

