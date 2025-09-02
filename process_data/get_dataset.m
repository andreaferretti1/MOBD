function [dataset] = get_dataset()
%Questa funzione estrae il dataset dal file.

% Prendo il path del file
path = fullfile(pwd, "resources", "bank-full.csv");
%Estraggo i dati dal file
dataset = readtable(path);
end

