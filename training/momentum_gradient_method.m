function [W, b] = momentum_gradient_method(training_hyperparams, train_X, train_Y, eval_X, eval_Y, neural_network, is_validation, w_pos, w_neg)
% Questa funzione implementa il metodo del gradiente con momentum. Questa
% funzione calcola la loss e la metrica F2 score sul training set alla fine di ogni minibatch, e
% calcola le stesse metriche sul validation/test set
%
% Input:
% - training_hyperparams sono gli iperparametri di addestramento
% - train_X è l'insieme dei campioni da utilizzare per l'addestramento
% - train_Y è l'insieme delle label relative ai campioni da utilizzare per l'addestramento
% - eval_X è la matrice delle features dei campioni del validation/test set
% - eval_Y è il vettore delle labels dei campioni del validation/test set
% - neural_network è il cell array contenente gli elementi che definiscono la rete neurale
% - is_validation è un booleano che indica se l'addestramento viene fatto per la validazione o per ottenere la rete finale
% - w_pos è il peso da attribuire alla classe positiva
% - w_neg è il peso da attribuire alla classe negativa
%
% Ouptut:
% - W è il cell array contenente le matrici dei pesi aggiornate
% - b è il cell array contenente i vettori dei bias aggiornati



% Inizializzo la schermata per mostrare i grafici
plot_handle = init_dashboard(is_validation, training_hyperparams, neural_network);


% Estraggo i pesi e i bias della rete neurale
W = neural_network{neural_network_structure.WEIGHT_MATRIX.Value};
b = neural_network{neural_network_structure.BIAS_VECTOR.Value};


% Definisco due variabili in cui memorizzare il valore dei pesi nell'iterazione precedente
W_prev = W;
b_prev = b;


[num_samples, ~] = size(train_X);

% Estraggo i parametri di addestramento
alpha = training_hyperparams(training_hyperparameters.ALPHA.Value);
beta = training_hyperparams(training_hyperparameters.BETA.Value);
minibatch_size = training_hyperparams(training_hyperparameters.MINIBATCH_SIZE.Value);
regularization_parameter = training_hyperparams(training_hyperparameters.REGULARIZATION_COEFFICIENT.Value);
max_epochs_num = training_hyperparams(training_hyperparameters.EPOCHS_NUM.Value);

% Definisco le variabili utili per il grafico
train_loss = zeros(max_epochs_num, 1);

if ~is_validation
    train_f2_score = zeros(max_epochs_num, 1);
else
    train_f2_score = [];
end

eval_loss = zeros(max_epochs_num, 1);

if ~is_validation
    eval_f2_score = zeros(max_epochs_num, 1);
else
    eval_f2_score = [];
end

iteration = 0;


for epoch = 1:max_epochs_num

    % Creo i minibatch
    minibatches = create_minibatches(num_samples, minibatch_size);

    for idx = 1:length(minibatches)

        % Calcolo la dimensione del minibatch
        minibatch_data = size(train_X(minibatches{idx}, :), 1);

        % Applico l'algoritmo di forwardpropagation
        [Y_predicted_e, a, z] = forwardpropagation(train_X(minibatches{idx}, :), W, b, neural_network{neural_network_structure.ACTIVATION_FUNCTIONS.Value});

        % Calcolo il gradiente medio della loss function
        [grad_W, grad_b] = backpropagation_with_regularization(minibatch_data, train_Y(minibatches{idx}, :), neural_network, regularization_parameter, Y_predicted_e, a, z, w_pos, w_neg);

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

        
        iteration = iteration + 1;

        update_status_text(plot_handle, epoch, max_epochs_num, iteration);

    end

        % Calcolo le metriche sul training set
        [Y_predicted_t, Y_classified_t] = predict_and_classify(is_validation, train_X, neural_network);
        train_loss(epoch) = mean(binary_cross_entropy(Y_predicted_t, train_Y, w_pos, w_neg), 'all');

        [Y_predicted_e, Y_classified_e] = predict_and_classify(is_validation, eval_X, neural_network);
         eval_loss(epoch) = mean(binary_cross_entropy(Y_predicted_e, eval_Y, w_pos, w_neg), 'all');

        if ~is_validation

            [train_f2_score(epoch), ~, ~] = evaluate_model(Y_classified_t, train_Y);
            [eval_f2_score(epoch), ~, ~] = evaluate_model(Y_classified_e, eval_Y);
        
        end


       % Aggiorno la dashboard
       update_dashboard(plot_handle, iteration, epoch, max_epochs_num, train_loss, train_f2_score, eval_loss, eval_f2_score, is_validation);

end

end

