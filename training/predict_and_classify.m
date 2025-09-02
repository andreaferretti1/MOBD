function [Y_predicted, Y_classified] = predict_and_classify(X_samples, neural_network)
% Questa funzione calcola la previsione del modello su un insieme di campioni, e assegna ciascun campione a una delle due classi, compranado il valore predetto dalla rete neurale con la soglia di positività.
% Input:
% - X_samples è la matrice dei campioni su cui devono essere calcolate le previsioni
% - neural_network è il cell array contenente gli elementi che descrivono la rete neurale
% Output:
% - Y_predicted è il vettore delle previsioni del modello
% - Y_classification è il vettore delle classi di appartenenza dei campioni su cui è stata calcolata la previsione


% Calcolo le previsioni sui campioni
[Y_predicted, ~, ~] = forwardpropagation(X_samples, neural_network{neural_network_structure.WEIGHT_MATRIX.Value}, neural_network{neural_network_structure.BIAS_VECTOR.Value}, neural_network{neural_network_structure.ACTIVATION_FUNCTIONS.Value});

% Classifico i campioni
Y_classified = Y_predicted >= neural_network{neural_network_structure.THRESHOLD_POSITIVITY.Value};

end

