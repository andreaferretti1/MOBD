function [threshold, F2_score] = tune_threshold(Y_predicted, Y_validation)
% Questa funzione calcola la soglia che massimizza l'F2-score sui fold di
% validazione
% 
% Input:
% - Y_predicted è il vettore delle predizioni del modello sui fold di validazione
% - Y_validation è il vettore delle label dei fold di validazione
%
% Output:
% - threshold è la soglia che massimizza l'F2-score
% - F2_score è l'F2-score massimo ottenuto


% Inizializzo i parametri di ritorno
F2_score = 0;
threshold = 0;

% Calcolo la dimensione del vettore delle predizioni
predictions = length(Y_predicted);

if(predictions ~= length(Y_validation))
    
    error("Error during threshold tuning: y_predicted and y_validation must have the same size.\n");

end

for tr = 0.01 : 0.005 : 0.99
    
    % Classifico le predizioni in base alla soglia
    y_classified = Y_predicted >= tr;

    % Valuto le metriche
    [temp_F2_score, ~, ~] = evaluate_model(y_classified, Y_validation);

    % Aggiorno i parametri di ritorno
    if(temp_F2_score > F2_score)
    
        F2_score = temp_F2_score;
        threshold = tr;

    end


end

end

