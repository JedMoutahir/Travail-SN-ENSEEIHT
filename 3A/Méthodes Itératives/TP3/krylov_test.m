
function [x, flag, relres, iter, resvec] = krylov(A, b, x0, tol, maxit, type)
% Résolution de Ax = b par une méthode de Krylov

% x      : solution
% flag   : convergence (0 = convergence, 1 = pas de convergence en maxit)
% relres : résidu relatif (backward error normwise)
% iter   : nombre d'itérations
% resvec : vecteur contenant les iter normes du résidu

% A     :matrice du système
% b     : second membre
% x0    : solution initiale
% tol   : seuil de convergence (pour l'erreur inverse)
% maxit : nombre d'itérations maximum
% type : méthode de Krylov
%        type == 0  FOM
%        type == 1  GMRES

n = size(A, 2);
r0 = b - A*x0;
beta = norm(r0);
normb = norm(b);
% norme relative du résidu == backward erreur normwise
relres = beta / normb;
% matlab va agrandir de lui même le vecteur resvec et les matrices V et H
resvec(1) = beta;
V(:,1) = r0 / beta;
j = 1;
x = x0;

while (relres > tol && j < maxit) % critère d'arrêt
    
    % w = Av_j
    w = A*V(:, j);
    
    % orthogonalisation (Modified Gram-Schmidt)
    for i = 1:j
        H(i,j) = V(:,i)'*w;
        w = w - H(i,j)*V(:,i);
    end
    
    % calcul de H(j+1, j) et normalisation de V(:, j+1)
     H(j+1, j) = norm(w, 2);
     V(:, j+1) = w / H(j+1, j);
    
    % suivant la méthode
    if(type == 0)
        % FOM
        % résolution du système linéaire H.y = beta.e1
        % construction de beta.e1 (taille j)
        be1 = zeros(j, 1);
        be1(1) = beta;
        % résolution de H.y = beta.e1 avec '\'
        y = H(1:j, 1:j) \ be1;
        
    else
        % GMRES
        % résolution du problème aux moindres carrés argmin ||beta.e1 - H_barre.y||
        % construction de beta.e1 (taille j+1)
        be1 = zeros(j+1, 1);
        be1(1) = beta;
        % résolution de argmin ||beta.e1 - H_barre.y|| avec '\'
        y = H \ be1;
    end
    
    % calcul de l'itérée courant x 
    x = x0 + V(:,1:j)*y;

    % calcul dde la norme du résidu et rangement dans resvec
    resvec(j+1) = norm(b-A*x, 2);
    % calcul de la norme relative du résidu (backward error) relres
    relres = resvec(j+1) / normb;
    j= j+1;
    
end

% le nombre d'itération est j - 1 (imcrément de j en fin de boucle)
iter = j-1;

% positionnement du flac suivant comment on est sortie de la boucle
if(relres > tol)
    flag = 1;
else
    flag = 0;
end