clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Separation des canaux RVB','Position',[0,0,0.67*L,0.67*H]);
figure('Name','Nuage de pixels dans le repere RVB','Position',[0.67*L,0,0.33*L,0.45*H]);

% Lecture et affichage d'une image RVB :
I = imread('ishihara-0.png');
figure(1);				% Premiere fenetre d'affichage
subplot(2,2,1);				% La fenetre comporte 2 lignes et 2 colonnes
imagesc(I);
axis off;
axis equal;
title('Image RVB','FontSize',20);

% Decoupage de l'image en trois canaux et conversion en doubles :
R = double(I(:,:,1));
V = double(I(:,:,2));
B = double(I(:,:,3));

% Affichage du canal R :
colormap gray;				% Pour afficher les images en niveaux de gris
subplot(2,2,2);
imagesc(R);
axis off;
axis equal;
title('Canal R','FontSize',20);

% Affichage du canal V :
subplot(2,2,3);
imagesc(V);
axis off;
axis equal;
title('Canal V','FontSize',20);

% Affichage du canal B :
subplot(2,2,4);
imagesc(B);
axis off;
axis equal;
title('Canal B','FontSize',20);

% Affichage du nuage de pixels dans le repere RVB :
figure(2);				% Deuxieme fenetre d'affichage
plot3(R,V,B,'b.');
axis equal;
xlabel('R');
ylabel('V');
zlabel('B');
rotate3d;

% Matrice des donnees :
X = [R(:), V(:), B(:)];			% Les trois canaux sont vectorises et concatenes

% Matrice de variance/covariance :
n = length(X);
xmoy = sum(X)/n;
Sigma = X'*X/n -xmoy'*xmoy; 

% Coefficients de correlation lineaire :
rRV = Sigma(1,2)/(Sigma(1,1)^0.5 * Sigma(2,2)^0.5);
rRB = Sigma(1,3)/(Sigma(1,1)^0.5 * Sigma(3,3)^0.5);
rVB = Sigma(2,3)/(Sigma(2,2)^0.5 * Sigma(3,3)^0.5);

% Proportions de contraste :
den = Sigma(1,1) + Sigma(2,2) + Sigma(3,3);
cR = Sigma(1,1)/den;
cV = Sigma(2,2)/den;
cB = Sigma(3,3)/den;

%ACP
[W,D] = eig(Sigma);
[D, indices] = sort(diag(D), 'descend');
W = W(:,indices);
C = (X-xmoy)*W;
imgC = (reshape(C, size(I)));

% Affichage du canal 1 :
figure;
colormap gray;
subplot(2,2,1);
imagesc(imgC(:,:,1));
axis off;
axis equal;
title('Canal 1','FontSize',20);

% Affichage du canal 2 :
subplot(2,2,2);
imagesc(imgC(:,:,2));
axis off;
axis equal;
title('Canal 2','FontSize',20);

% Affichage du canal 3 :
subplot(2,2,3);
imagesc(imgC(:,:,3));
axis off;
axis equal;
title('Canal 3','FontSize',20);

% Affichage du nuage de pixels dans le nouveau repere :
figure;
plot3(imgC(:,:,1), imgC(:,:,2), imgC(:,:,3), 'b.');
axis equal;
xlabel('1');
ylabel('2');
zlabel('3');
rotate3d;

% Nouvelle Matrice de variance/covariance :
n = length(C);
cmoy = sum(C)/n;
SigmaC = C'*C/n -cmoy'*cmoy; 

% Nouveaux Coefficients de correlation lineaire :
r12 = SigmaC(1,2)/(SigmaC(1,1)^0.5 * SigmaC(2,2)^0.5);
r13 = SigmaC(1,3)/(SigmaC(1,1)^0.5 * SigmaC(3,3)^0.5);
r23 = SigmaC(2,3)/(SigmaC(2,2)^0.5 * SigmaC(3,3)^0.5);

% Nouvelles Proportions de contraste :
den = SigmaC(1,1) + SigmaC(2,2) + SigmaC(3,3);
c1 = SigmaC(1,1)/den;
c2 = SigmaC(2,2)/den;
c3 = SigmaC(3,3)/den;
