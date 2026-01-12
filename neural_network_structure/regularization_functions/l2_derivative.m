function [derivative] = l2_derivative(lambda, W)
% Questa funzione calcola il gradiente della norma L2.
% 
% Input:
% - lambda è il parametro di regolarizzazione
% - W è una matrice di parametri
% 
% Output:
% - derivative è la matrice delle derivate parziali della norma L2, calcolata nel valore dei parametri

derivative = 2 * lambda * W;
end

