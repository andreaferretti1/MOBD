classdef neural_network_hyperparameters
    % Questa classe è una enumerazione degli iperparametri relativi alla
    % rete neurale
    % Valori:
    % - NETWORK_CONFIGURATION indica la struct contenente il numero di neuroni e le funzioni di attivazione per ogni layer
    % - PARAM_INIT_METHOD è il metodo di inizializzazione dei parametri della rete
    % - THRESHOLD_POSITIVITY è la soglia di positività
    
    properties
        Value  
    end


    enumeration
        NETWORK_CONFIGURATION (1)
        PARAM_INIT_METHOD (2)
        THRESHOLD_POSITIVITY (3)
    end

    methods
        function obj = neural_network_hyperparameters(val)
            obj.Value = val;
        end


        function str = to_string(obj)
            switch obj
                case neural_network_hyperparameters.NETWORK_CONFIGURATION
                    str = 'Network configuration (neurons and activations)';
                case neural_network_hyperparameters.PARAM_INIT_METHOD
                    str = 'Parameter initialization method';
                case neural_network_hyperparameters.THRESHOLD_POSITIVITY
                    str = 'Positivity threshold';
                otherwise
                    str = 'Unknown hyperparameter';
            end
    end

    end
    
end

