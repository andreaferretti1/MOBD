function [pdays_categorical] = transform_pdays(pdays)
% Questa funzione converte la feature numerica pdays in una feature
% categorica. Le nuove categorie sono: "never_contacetd", [0, 70], (71, 150],
% (151, 220], (220, 380], >380
%
% Input:
% - pdays è la feature che deve essere categorizzata
%
% Ouptut:
% - pdays_categorical è la feature pdays categorizzata

samples = length(pdays);
pdays_categorical = strings(samples, 1);

% Converto i valori di pdays negli intervalli
pdays_categorical(pdays >= 0 & pdays <= 70 ) = "[0, 70]";
pdays_categorical(pdays > 70 & pdays <= 150) = "(70, 150]";
pdays_categorical(pdays > 150 & pdays <= 220) = "(150, 220]";
pdays_categorical(pdays > 220 & pdays <= 380) = "(220, 380]";
pdays_categorical(pdays > 380) = ">380";
pdays_categorical(pdays == -1) = "never_contacted";

pdays_categorical = categorical(pdays_categorical);

end


