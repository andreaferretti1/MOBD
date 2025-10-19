function [derivative] = l1_derivative(lambda, W)
% Questa funzione calcola il gradiente della norma l1.
% Input:
% - lambda è il parametro di regolarizzazione
% - W è una matrice di parametri
% Output:
% - derivative è la matrice delle derivate parziali della norma L1, calcolata nel valore dei parametri


grad = sign(W);
derivative = lambda * grad;

end

