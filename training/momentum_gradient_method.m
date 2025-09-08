function [W, b] = momentum_gradient_method(alpha, beta, train_X, train_Y, eval_X, eval_Y, neural_network, minibatch_size, max_epochs_num, regularization_parameter, isValidation, w_pos, w_neg)
% Questa funzione implementa il metodo del gradiente con momentum. Questa
% funzione calcola la loss e la metrica F1-score sul training set alla fine di ogni minibatch, e
% calcola le stesse metriche sul validation/test set 
% Input:
% - alpha è il passo
% - beta è il momento
% - train_X è l'insieme dei campioni da utilizzare per l'addestramento
% - train_Y è l'insieme delle label relative ai campioni da utilizzare per l'addestramento
% - eval_X è la matrice delle features dei campioni del validation/test set
% - eval_Y è il vettore delle labels dei campioni del validation/test set
% - neural_network è il cell array contenente gli elementi che definiscono la rete neurale
% - minibatch_size indica la dimensione del minibatch
% - max_epochs_num è il numero di epoche dopo le quali l'algoritmo termina, nel caso in cui non dovesse convergere
% - regularization_parameter è il parametro di regolarizzazione
% - isValidation è un booleano che indica se l'addestramento viene fatto per la validazione o per ottenere la rete finale
% - w_pos è il peso da attribuire alla classe positiva
% - w_neg è il peso da attribuire alla classe negativa
% Ouptut:
% - W è il cell array contenente le matrici dei pesi aggiornate
% - b è il cell array contenente i vettori dei bias aggiornati

% Inizializzo la schermata per mostrare i grafici
figure(1);
clf;
grid on;
if(isValidation)
    legend_string = "Validation ";
else
    legend_string = "Training ";
end

% Inizializzo il primo grafico
f1_score_diagram = subplot(2, 2, 1);
hold on;
train_f1_plot = plot(NaN, NaN, 'b-', 'LineWidth', 2);
eval_f1_plot = plot(NaN, NaN, 'r-', 'LineWidth', 2);
xlabel('Iterazioni');
ylabel('F1 score');
legend({'Training F1 score', legend_string + "F1 score"});
hold off;

% Inizializzo il secondo grafico
loss_diagram = subplot(2, 2, 3);
hold on;
train_loss_plot = plot(NaN, NaN, 'b-', 'LineWidth', 2);
eval_loss_plot = plot(NaN, NaN, 'r-', 'LineWidth', 2);
xlabel('Iterazioni');
ylabel('Average loss');
legend({'Training loss', legend_string + "loss"});
hold off;

% Creo a destra un pannello su cui scrivo informazioni sulle iterazioni
info_panel = subplot(2, 2, [2, 4]); 
axis off; 
title('Info Addestramento');

% Creo il testo che mostra gli iperparametri
static_text = sprintf('Alpha: %f\nBeta: %.2f\nMinibatch size: %d\nRegularization: %f\nThreshold: %.2f', ...
                       alpha, beta, minibatch_size, regularization_parameter, neural_network{neural_network_structure.THRESHOLD_POSITIVITY.Value});
text(0.05, 0.9, static_text, 'FontSize', 11, 'VerticalAlignment', 'top');

% Creo il testo con le informazioni da aggiornare ad ogni iterazione
dynamic_text_handle = text(0.05, 0.6, 'Inizializzazione...', 'FontSize', 11, 'VerticalAlignment', 'top', 'FontWeight', 'bold');


% Estraggo i pesi e i bias della rete neurale
W = neural_network{neural_network_structure.WEIGHT_MATRIX.Value};
b = neural_network{neural_network_structure.BIAS_VECTOR.Value};

% Calcolo la dimensione del training set
[num_samples, ~] = size(train_X);

% Definisco le variabili utili per il grafico
max_num_iterations = ceil(num_samples / minibatch_size) * max_epochs_num;
eval_frequency = 30;
num_of_evaluations = floor(max_num_iterations / eval_frequency);
train_loss = zeros(max_num_iterations, 1);
eval_loss = zeros(num_of_evaluations, 1);
train_f1_score = zeros(max_num_iterations, 1);
eval_f1_score = zeros(num_of_evaluations, 1);
iteration = 0;

% Definisco due variabili in cui memorizzare il valore dei pesi nell'iterazione precedente
W_prev = W;
b_prev = b;


% Definisco il vettore in cui memorizzare i valori della loss function
for epoch = 1:max_epochs_num
     
    % Creo i minibatch
    minibatches = create_minibatches(num_samples, minibatch_size);
    
    for idx = 1:length(minibatches)

        % Calcolo la dimensione del minibatch
        minibatch_data = size(train_X(minibatches{idx}, :), 1);

        % Applico l'algoritmo di forwardpropagation
        [Y_predicted, a, z] = forwardpropagation(train_X(minibatches{idx}, :), W, b, neural_network{neural_network_structure.ACTIVATION_FUNCTIONS.Value});
        
        % Calcolo il gradiente medio della loss function
        [grad_W, grad_b] = backpropagation_with_regularization(minibatch_data, train_Y(minibatches{idx}, :), neural_network, regularization_parameter, Y_predicted, a, z, w_pos, w_neg);
        
        % Aggiorno i parametri della rete
        W_next = cell(length(W), 1);
        b_next = cell(length(b), 1);

        for i = 1:length(W)
            W_next{i} = W{i} - alpha * grad_W{i} + beta * ( W{i} - W_prev{i} );
            b_next{i} = b{i} - alpha * grad_b{i} + beta * ( b{i} - b_prev{i} );
        end
        
        W_prev = W;
        b_prev = b;

        W = W_next;
        b = b_next;

        neural_network{neural_network_structure.WEIGHT_MATRIX.Value} = W;
        neural_network{neural_network_structure.BIAS_VECTOR.Value} = b;

        %--------------- Aggiorno i dati del grafico ---------------
        iteration = iteration + 1;
       
        % Calcolo loss media e F1 score sul training set e aggiorno i grafici
        [Y_predicted, Y_classified] = predict_and_classify(train_X, neural_network);
        train_loss(iteration) = mean(binary_cross_entropy(Y_predicted, train_Y, w_pos, w_neg), 'all');
        [train_f1_score(iteration), ~, ~] = evaluate_model(Y_classified, train_Y);
        set(train_loss_plot, 'XData', 1:iteration, 'YData', train_loss(1:iteration));
        set(train_f1_plot, 'XData', 1:iteration, 'YData', train_f1_score(1:iteration));

        % Calcolo loss media e F1 score sul validation set, se deve essere fatto
        if(mod(iteration, eval_frequency) == 0)
            index = iteration / eval_frequency;
            [Y_predicted, Y_classified] = predict_and_classify(eval_X, neural_network);
            eval_loss(index) = mean(binary_cross_entropy(Y_predicted, eval_Y, w_pos, w_neg), 'all');
            [eval_f1_score(index), ~, ~] = evaluate_model(Y_classified, eval_Y);
            set(eval_f1_plot, 'XData', 1:eval_frequency:iteration, 'YData', eval_f1_score(1:index));
            set(eval_loss_plot, 'XData', 1:eval_frequency:iteration, 'YData', eval_loss(1:index));
        end
        
        
        % Aggiorno il testo da mostrare a schermo
        dynamic_str = sprintf('Iterazione: %d\nEpoca: %d / %d',...
                          iteration, epoch, max_epochs_num);
    
        set(dynamic_text_handle, 'String', dynamic_str);

        drawnow limitrate;

    end



end


end

