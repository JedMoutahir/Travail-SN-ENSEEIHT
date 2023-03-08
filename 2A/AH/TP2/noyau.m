function [k] = noyau(x, y)
% Modèle linéaire
%k = x'*y;

% Modèle polynomial
k = (x'*y + 1)^2;

% Modèle gaussien
% sigma = 5;
% k = exp(-norm(x-y)^2/(2*sigma^2));
end