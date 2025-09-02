function [] = draw_accuracy_chart(train_accuracies, eval_accuracies, graph_title)
% Questa funzione mostra un istogramma delle accuratezze del modello sul
% training set e sull'evaluation set, che può essere test set o validation
% set.
% Input:
% - train_accuracies è un vettore, dove la componente i-esima è l'accuratezza del modello i sul training set
% - eval_accuracies è un vettore, dove la componente i-esima è l'accuratezza del modello i sul validation set o sul test set
% - title è il titolo da dare al grafico

% Controllo che i due vettori in input abbiano la stessa lunghezza
if(length(train_accuracies) ~= length(eval_accuracies))
    error("In draw_accuracy_chart the number of training accuracies and evaluation accuracies should be the same");
end

% Calcolo il numero di modelli
number_of_models = length(train_accuracies);


% Manipolo i dati per poter disegnare un istogramma raggruppato
data_to_show = [train_accuracies(:), eval_accuracies(:)];

% Disegno il grafico
b = bar(data_to_show, 'grouped');

% Definisco le etichette
xlabel('Modello');
ylabel('F1 score');
title(graph_title);

% Aggiungo la legenda
legend({'Training', 'Evaluation'}, 'Location','northeast');

% Miglioro leggibilità asse x
xticks(1:number_of_models);
xticklabels(compose("Modello %d", 1:number_of_models));

% Limito l'intervallo dei valori possibili lungo l'asse delle y
ylim([0 1]);

% Agguingo griglia
grid on;

% Disegno i valori delle barre
for bar_group = 1:numel(b)

   % Calcolo le coordinate delle barre
   x_coord = b(bar_group).XEndPoints;
   y_coord = b(bar_group).YEndPoints;

   % Calcolo i valori delle due barre
   labels = string(b(bar_group).YData);
    
   % Disegno i valori
   text(x_coord, y_coord, labels, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

end


end

