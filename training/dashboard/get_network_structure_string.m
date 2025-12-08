function [string] = get_network_structure_string(neural_network, is_validation)
% Questa funzione formatta la struttura della rete neurale in una stringa
%
% Input:
% - neural network è il cell array che definisce la struttura della rete neurale
% - is_validation indica se la rete neurale è addestrata per il tuning degli iperparametri
%
% Output:
% - string è la stringa formattata




% Estraggo matrici dei pesi e funzioni di attivazione degli strati
W = neural_network{neural_network_structure.WEIGHT_MATRIX.Value};
g = neural_network{neural_network_structure.ACTIVATION_FUNCTIONS.Value};

% Calcolo il numero di layer
num_computational_layers = length(W);

% Dichiaro un array in cui salvare le stringhe da concatenare
info_lines = cell(num_computational_layers + 3, 1);

% Inserisco il titolo
info_lines{1} = sprintf('STRUTTURA RETE:\n------------------\n');

% Inserisco le info dello strato di input
input_size = size(W{1}, 2);
info_lines{2} = sprintf('[Input] %d features\n', input_size);

% Inserisco le info degli strati rimanenti
for i = 1:num_computational_layers

    % Numero neuroni
    num_neurons = size(W{i}, 1);

    % Nome funzione attivazione
    act_func = func2str(g{i});

    % Formattazione etichetta
    if i == num_computational_layers
        label = '[Out]  ';
    else
        label = sprintf('[L%d]   ', i);
    end

    info_lines{i + 2} = sprintf('%s %d neuroni (%s)\n', label, num_neurons, act_func);
end

% Inserisco la soglia di decisione
thresh_str = "N/A (CV)";
if ~is_validation
    thresh_str = sprintf('%.5f', neural_network{neural_network_structure.THRESHOLD_POSITIVITY.Value});
end

info_lines{num_computational_layers + 3} = sprintf("Soglia: %s", thresh_str);

% Concateno le stringhe
string = [info_lines{:}];

end



