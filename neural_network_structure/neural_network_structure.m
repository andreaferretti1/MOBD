classdef neural_network_structure
    % Questa classe è una enumerazione degli elementi che definiscono
    % la struttura della rete neurale.
    % Valori:
    % - WEIGHT_MATRIX è l'insieme delle matrici dei pesi
    % - BIAS_VECTOR è l'insieme dei vettori di bias
    % - ACTIVATION_FUNCTIONS è l'insieme delle funzioni di attivazione
    % - ACTIVATION_FUNCTIONS_DERIVATIVE è l'insieme delle derivate delle funzioni di attivazione
    % - THRESHOLD_POSITIVITY è la soglia di probabilità oltre la quale il classificatore considera una predizione come positiva

    properties
        Value 
    end

    enumeration

        WEIGHT_MATRIX (1)
        BIAS_VECTOR (2)
        ACTIVATION_FUNCTIONS (3)
        ACTIVATION_FUNCTIONS_DERIVATIVE (4)
        THRESHOLD_POSITIVITY (5)

    end

    methods
        function obj = neural_network_structure(val)
            obj.Value = val;
        end
    end
    
end

