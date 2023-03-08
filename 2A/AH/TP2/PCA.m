function [k1, U] = PCA(Xc, PrecApprox)
[~,n] = size(Xc);

% Étape 1 : Calcul de la matrice de covariance
% La matrice de covariance sigma est calculée en utilisant les données d'entrée Xc et la formule de covariance
% sigma est symétrique et de taille n x n, où n est le nombre de données d'entrée
sigma = (Xc * Xc')/n;

% Étape 2 : Calcul des vecteurs et valeurs propres
% La fonction eig calcule les vecteurs et valeurs propres de la matrice de covariance sigma
% Les vecteurs propres sont stockés dans la matrice V et les valeurs propres correspondantes sont stockées dans la matrice diagonale D
[V,D] = eig(sigma);

% Étape 3 : Tri des valeurs propres
% Les valeurs propres dans D sont triées en ordre décroissant en utilisant la fonction sort
% Les indices de tri sont stockés dans le vecteur ind et les valeurs triées
% sont stockées dans le vecteur Vals
[Val,ind] = sort(diag(D),'descend');

%C = U' * Xc;

% Étape 4 : Sélection du nombre de composantes principales
% La méthode de seuil d'énergie est utilisée pour déterminer le nombre k1 de composantes principales nécessaires
% Le paramètre PrecApprox est utilisé pour spécifier le niveau d'énergie souhaité
y = 1 - sqrt(Val(2)/Val(1));
k1 = 2;
for i = 3 : n
    if (y < PrecApprox)
        y = 1 - sqrt(Val(i)/Val(1));
        k1 = i;
    else
        break;
    end
end

% Étape 5 : Extraction des vecteurs propres
% Les k1 vecteurs propres triés sont extraits de la matrice V et stockés dans la matrice U
U = V(:,ind);

end