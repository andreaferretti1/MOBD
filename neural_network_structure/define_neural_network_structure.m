function [neural_network] = define_neural_network_structure(num_hidden_layers, num_neurons_per_layer, activation_function, parameter_initialization_method, threshold_positivity)
% Questa funzione definisce la struttura della rete neurale.
% Input:
% - num_layers è il numero di strati nascosti
% - num_neurons_per_layer è un vettore che indica il numero di neuroni per ogni layer, inclusi gli strati di input e di output
% - activation_function è un vettore di stringhe che indica la funzione di attivazione per ogni strato nascosto e per lo strato di uscita
% - parameter_initialization_method indica il metodo con cui devono essere inizializzati i pesi
% - threshold_positivity è la soglia di positività
% Output:
% - neural_network è il cell arraycontenente gli elementi che definiscono la rete neurale

% Definisco il cell array della rete neurale
neural_network = cell(5,1);

% Dichiaro i cell array
W = cell(num_hidden_layers + 1, 1);
b = cell(num_hidden_layers + 1, 1);
g = cell(num_hidden_layers + 1, 1);
g_derivative = cell(num_hidden_layers, 1);

% Definisco il metodo di inizializzazione dei parametri della rete
if(strcmp(parameter_initialization_method, "glorot_uniform"))
    initialize_param = @glorot_uniform_initialization;
elseif(strcmp(parameter_initialization_method, "glorot_normal"))
    initialize_param = @glorot_normal_initialization;
elseif(strcmp(parameter_initialization_method, "he_normal"))
    initialize_param = @he_normal_initialization;
elseif(strcmp(parameter_initialization_method, "uniform"))
    initialize_param = @uniform_initialization;
else
    error("%s parameter initialization method not implemented", parameter_initialization_method);
end 


% Popolo i cell array
for layer = 1: (num_hidden_layers + 1)
    W{layer} = initialize_param(num_neurons_per_layer(layer + 1), num_neurons_per_layer(layer));
    b{layer} = zeros(num_neurons_per_layer(layer + 1), 1);
    
    act_fun = char(activation_function(layer));
    
    if(strcmpi(act_fun, "relu"))
    
        g{layer} = @relu;

        if(layer <= num_hidden_layers)
            g_derivative{layer} = @relu_derivative;
        end

    elseif (strcmpi(act_fun, "sigmoid"))
        
        g{layer} = @sigmoid;

        if(layer <= num_hidden_layers)
            g_derivative{layer} = @sigmoid_derivative;
        end
    else 
        error("Activation function %s at layer %d not found", act_fun, layer);
    end
 
end

% Popolo il cell array
neural_network{neural_network_structure.WEIGHT_MATRIX.Value} = W;
neural_network{neural_network_structure.BIAS_VECTOR.Value} = b;
neural_network{neural_network_structure.ACTIVATION_FUNCTIONS.Value} = g;
neural_network{neural_network_structure.ACTIVATION_FUNCTIONS_DERIVATIVE.Value} = g_derivative;
neural_network{neural_network_structure.THRESHOLD_POSITIVITY.Value} = threshold_positivity;

end


