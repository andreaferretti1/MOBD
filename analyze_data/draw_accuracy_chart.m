function [] = draw_accuracy_chart(train_results, eval_results, graph_title)
% Questa funzione mostra un istogramma delle accuratezze del modello sul
% training set e sull'evaluation set, che può essere test set o validation
% set.
%
% Input:
% - train_results è la struct contenente precision, recall e F2-score calcolati sul training set
% - eval_results è la struct contenente precision, recall e F2-score calcolati sul test set
% - title è il titolo da dare al grafico


% Estraggo i dati dalle struct
data_to_show = [
    train_results.f2, eval_results.f2;
    train_results.precision, eval_results.precision;
    train_results.recall,    eval_results.recall
    ];


% Disegno il grafico
b = bar(data_to_show, 'grouped');
grid on;
hold on;

% Imposto i colori delle barre: blu per training e rosso per test

b(1).FaceColor = [0.2, 0.4, 0.7]; % Training
b(2).FaceColor = [0.8, 0.3, 0.3]; % Test

% Aggiungo titolo e legenda
title(graph_title, 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Valore');
legend({'Training', 'Test'}, 'Location', 'northeastoutside');

% Miglioro leggibilità asse x
xticks(1:3);
xticklabels({'F-2 Score', 'Precision', 'Recall'});

% Limito l'intervallo dei valori possibili lungo l'asse delle y
ylim([0 1.15]);

% Inserisco i valori sopra ciascuna barra
for i = 1:numel(b)
    x_coord = b(i).XEndPoints;
    y_coord = b(i).YEndPoints;
    labels = string(round(b(i).YData, 3));
    
    text(x_coord, y_coord, labels, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 10, ...
        'FontWeight', 'bold');
end

hold off;


end

