function [campaign_categorical] = transform_campaign(campaign)
% Questa funzione trasforma la feature numerica "campaign" in una feature
% categorica. Le categorie scelte sono <=11 e >11
%
% Input:
% - campaign è la colonna dei valori della feature campaign
% 
% Output:
% - campaign_categorical è la corrispondente feature categorica

% Definisco la colonna che conterrà i valori categorici
num_samples = length(campaign);
campaign_categorical = strings(num_samples, 1);

% Aggiungo le categorie
campaign_categorical(campaign <= 11) = "<=11";
campaign_categorical(campaign > 11) = ">11";

campaign_categorical = categorical(campaign_categorical);


end

