function [cos_out, sin_out] = encode_day_and_month(data)
% Questa funziona codifica il giorno e il mese utilizzando seno e coseno,
% in modo tale da fornire una rappresentazione circolare dell'anno anzichè
% lineare

% data è una tabella con le colonne day e month

num_of_data = height(data);
% Inizializzo le colonne del seno e del coseno
cos_out = zeros(num_of_data, 1);
sin_out = zeros(num_of_data, 1);

% Determino il numero di base da associare ad ogni mese, a cui aggiungo il
% giorno del mese. In uìquesto caso si considera febbraio composto da 28
% giorni, poichè nel dataset non ci sono campioni relativi al 29 febbraio.
starting_days = containers.Map({'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'}, [0, 31, 59, 90, 120, 151, 181, 212, 242, 273, 304, 334]);

% Converto giorno e mese in seno e coseno
for idx = 1:num_of_data
    month_key = lower(data.month{idx});

    number_of_year = starting_days(month_key) + data.day(idx, :) - 1;
    cos_out(idx) = cos( 2 * pi * number_of_year / 365);
    sin_out(idx) = sin( 2 * pi * number_of_year / 365);
end

end

