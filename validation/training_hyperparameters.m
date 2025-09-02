classdef training_hyperparameters
    % Questa classe è una enumerazione dell'insieme degli iperparametri
    % necessari per addestrare la rete
    % Valori:
    % - ALPHA è il passo del SGD con momentum
    % - BETA è il coefficiente del momentum
    % - EPOCHS_NUM indica la durata del SGD con momentum, in termini di epoche
    % - MINIBATCH_SIZE è la grandezza del minibatch
    % - REGULARIZATION_COEFFICIENT è il coefficiente di regolarizzazione

    
    properties
        Value 
    end

    enumeration
        ALPHA (1)
        BETA (2)
        EPOCHS_NUM (3)
        MINIBATCH_SIZE(4)
        REGULARIZATION_COEFFICIENT(5)
    end


    methods
        function obj = training_hyperparameters(val)
            obj.Value = val;
        end

        function str = to_string(obj)
            
            switch obj
                case training_hyperparameters.ALPHA
                    str = 'Learning rate';
                case training_hyperparameters.BETA
                    str = 'Momentum coefficient';
                case training_hyperparameters.EPOCHS_NUM
                    str = 'Number of epochs';
                case training_hyperparameters.MINIBATCH_SIZE
                    str = 'Minibatch size';
                case training_hyperparameters.REGULARIZATION_COEFFICIENT
                    str = 'Regularization coefficient';
                otherwise
                    str = 'Unknown hyperparameter';
            end

        end
    end

end


