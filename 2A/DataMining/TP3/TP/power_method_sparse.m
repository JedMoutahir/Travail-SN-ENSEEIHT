function [r]=power_method_sparse(Q, v, alpha, eps)
% Algorithme de la puissance it?r?e dans le cas "creux"
% Q est la matrice repr?sentative du graphe d'Internet.
% v est le vecteur de personalisation.
% alpha est le param?tre de poids.
% eps est la pr?cision souhait?e (crit?re d'arret).
% r est le vecteur propre assoic?e ? la valeur propre 1.

% Initialisation
    nbMaxIteration = 500;
    n = length(Q(:, 1));
    r = ones(n, 1) ./ n;
    k = 0;
    P = columnstochastic_matrix(Q);
    qk = alpha*P*r + (1 - alpha)*v;
    newR = qk / norm(qk, 1);
    while norm(newR - r, 1) >= eps * norm(r, 1) || k > nbMaxIteration
        r = newR;
        qk = alpha*P*r + (1 - alpha)*v;
        newR = qk / norm(qk, 1);

        k = k + 1;
    end
    r = newR;
end