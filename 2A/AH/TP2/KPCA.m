function [k2, K, alpha, Y, V0] = KPCA(Xc, PrecApprox)
[~,n] = size(Xc);
K = zeros(n, n);

% Étape 1 : Calcul de la matrice de Gram K
% La fonction noyau calcule la mesure de similarité entre deux vecteurs
% K est la matrice de Gram symétrique de taille n x n, où n est le nombre de données d'entrée
for i = 1 : n
    for j = 1 : n
        K(i,j) = noyau(Xc(:,i), Xc(:,j));
    end
end

% Étape 2 : Calcul de la matrice centrale Kc
% La matrice Kc est calculée en utilisant la matrice de Gram K et la formule de centre de masse
% Kc est également symétrique et de taille n x n
Kc = K - ones(n,n)*K/n - K*ones(n,n)/n + ones(n,n)*K*ones(n,n)/(n^2);

% Étape 3 : Calcul des vecteurs et valeurs propres
% La fonction eig calcule les vecteurs et valeurs propres de la matrice centrale Kc
% Les vecteurs propres sont stockés dans la matrice V et les valeurs propres correspondantes sont stockées dans la matrice diagonale D
[V, D] = eig(Kc);

% Étape 4 : Tri des valeurs propres
% Les valeurs propres dans D sont triées en ordre décroissant en utilisant la fonction sort
% Les indices de tri sont stockés dans le vecteur ind et les valeurs triées sont stockées dans le vecteur Val
[Val, ind] = sort(diag(D), 'descend');
U = V(:, ind);

% Étape 5 : Sélection du nombre de composantes principales
% La méthode de seuil d'énergie est utilisée pour déterminer le nombre k2 de composantes principales nécessaires
% Le paramètre PrecApprox est utilisé pour spécifier le niveau d'énergie souhaité
y = 1 - sqrt(Val(2)/Val(1));
k2 = 2;
for i = 3 : n
    if (y < PrecApprox)
        y = 1 - sqrt(Val(i)/Val(1));
        k2 = i;
    else
        break;
    end
end

% Étape 6 : Calcul des coefficients de projection alpha
% La fonction calcule les coefficients de projection alpha en normalisant les vecteurs propres triés et en les projetant sur la matrice de Gram K
% Les coefficients alpha sont stockés dans la matrice alpha
alpha = zeros(n, k2);
for i = 1 : k2
    alpha(:,i) = U(:,i)/sqrt(Val(i));
end

% Étape 7 : Projection des données sur les composantes principales
% Les données d'entrée Xc sont projetées sur les k2 composantes principales en utilisant les coefficients alpha et la matrice de Gram K
% Les données projetées sont stockées dans la matrice Y
Y = alpha' * K';

% Étape 8 : Extraction des vecteurs propres
% Les k2 vecteurs propres triés sont extraits de la matrice V et stockés dans la matrice V0
V0 = U(:, 1:k2);
end