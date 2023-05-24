function [A,err]=irreducible_matrix(P,alpha,v)
% Modification de rang 1 d'une matrice colonne stochastique afin de la rendre
% irr?ductible
% P est la matrice colonne stochastique.
% alpha est le param?tre de poids (0<alpha<1).
% v est le vecteur de personalisation (vi>0 et ||v||1=1)
% A est la matrice irr?ductible
% err vaut 1 si alpha et v ne respectent pas les contraintes.

% Initialisation
n=length(P(:,1));

% Tests sur alpha et v

% Calcul de A
A=P;
err=0;

end