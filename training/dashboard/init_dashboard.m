function [h] = init_dashboard(is_validation, training_hyperparams, neural_network)
% Questa funzione inizializza la dashboard da mostrare a schermo durante
% l'addestramento del modello. Se l'addetstramento è per il tuning degli
% iperparametri, non viene mostrato l'F2-score.
%
% Input:
% - is_validation indica se il training è effettuato nella fase di validazione
% - training_hyperparams sono gli ieprparametri di addestramento da mostrare a schermo
% - neural_network è il cell array contenente la struttura della rete neurale
% Output:
% - h è l'handle del grafico

figure(1);
clf;
grid on;

if is_validation

    sgtitle('Cross-Validation Training (Solo Loss Monitoring)');

else

    sgtitle('Final Model Training (Loss & F2 Score)');

end

% Grafico delle loss
if is_validation
    h.ax_loss = subplot(2, 2, [1 3]);
else
    h.ax_loss = subplot(2, 2, 3);
end

grid on;
hold on;

h.line_train_loss = plot(NaN, NaN, 'b-o', 'LineWidth', 1.5, 'DisplayName', 'Train Loss');
h.line_eval_loss = plot(NaN, NaN, 'r-o', 'LineWidth', 1.5, 'DisplayName', 'Eval Loss');

xlabel('Iterazioni');
ylabel('Mean Loss');
title('Andamento Loss Media');
legend('Location', 'best');


% Grafico degli F2-score
if ~is_validation

    h.ax_f2 = subplot(2, 2, 1);
    grid on; 
    hold on;

    h.line_train_f2 = plot(NaN, NaN, 'b-o', 'LineWidth', 1.5, 'DisplayName', 'Train F2');
    h.line_eval_f2  = plot(NaN, NaN, 'r-o', 'LineWidth', 1.5, 'DisplayName', 'Eval F2');

    xlabel('Iterazioni');
    ylabel('F2 Score');
    title('Andamento F2 Score');
    legend('Location', 'best');

end


% Inizializo il pannello delle info
subplot(2, 2, [2, 4]);
axis off; 
title('Iperparametri');


% Formatto gli iperparametri di addestramento
param_string = sprintf(['\\bfPARAMETRI DI ADDESTRAMENTO:\\rm\n' ...
    'Alpha: %.4f\n' ...
    'Beta: %.2f\n' ...
    'Taglia del minibatch: %d\n' ...
    'Coefficiente di regolarizzazione: %.4f\n'], ...
    training_hyperparams(training_hyperparameters.ALPHA.Value), ...
    training_hyperparams(training_hyperparameters.BETA.Value), ...
    training_hyperparams(training_hyperparameters.MINIBATCH_SIZE.Value), ...
    training_hyperparams(training_hyperparameters.REGULARIZATION_COEFFICIENT.Value) );

% Formatto la struttura della rete neurale
net_string = get_network_structure_string(neural_network, is_validation);

% Concateno le stringhe
h.static_info_str = [param_string, net_string];

% Mostro la stringa
h.text_handle = text(0.05, 0.95, h.static_info_str, 'FontSize', 11, 'VerticalAlignment', 'top', 'FontName', 'Courier');

end

