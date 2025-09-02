function [Y, a, z] = forwardpropagation(X, W, b, g)
% Questa funzione implementa l'algoritmo di forwardpropagation per il
% calcolo della previsione su un campione
% Input:
% - X è il minibatch su cui devono essere calcolate le previsioni
% - W è un cell array, in cui la cella i-esima contiene la matrice dei pesi relativa all'ingresso nello strato i
% - b è un cell array, in cui la cella i-esima contiene il vettore dei pesi di bias relativo all'ingresso nello strato i
% - g è un cell array, in cui la cella i-esima contiene il vettore la
% funzione di attivazione (rappresentata da function handle) dei neuroni dello strato i + 1 (perchè lo strato di input non ce l'ha)
% Il numero degli strati viene calcolato implicitamente tramite le dimensioni del cell array W e delle singole matrici dei pesi.
% Output:
% - Y è l'insieme delle previsioni del modello sul minibatch. La riga j rappresenta la previsione sul campione j-esimo del minibatch
% - a è il cell array delle uscite degli strati, utili per la backpropagation. Ogni cella contiene una matrice, dove la colonna j rappresenta l'uscita della rete neurale relativa al j-esimo campione
% - z è il cell array contenente la somma pesata relativi ai neruoni di ogni strato, utili per la backpropagation. Ogni cella contiene una matrice, dove la colonna j rappresenta la somma pesata in ingresso allo strato relativa al j-esimo campione

% Calcolo il numero di strati
num_of_layers = length(W) + 1; 

% Dichiaro il cell array a delle uscite dei nodi di uno strato
a = cell(num_of_layers, 1);

% Dichiaro il cell array z della somma pesata delle uscite di uno strato
z = cell(num_of_layers - 1, 1);

% ----------Implemento l'algoritmo di forwardpropagation----------

a{1} = X';

for layer = 2:num_of_layers
    
    z{layer - 1} = W{layer - 1} * a{layer - 1} + repmat(b{layer - 1}, 1, size(X, 1));
    a{layer} = g{layer - 1}(z{layer - 1});
    
end

Y = a{num_of_layers}';

end

