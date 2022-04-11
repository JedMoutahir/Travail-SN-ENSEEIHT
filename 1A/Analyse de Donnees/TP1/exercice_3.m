clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

for i=16:30
    % Lecture d'une image RVB :
    I = imread(strcat('ishihara-',int2str(i),'.png'));
    
    % Decoupage de l'image en trois canaux et conversion en doubles :
    R = double(I(:,:,1));
    V = double(I(:,:,2));
    B = double(I(:,:,3));
    
    % Matrice des donnees :
    X = [R(:), V(:), B(:)];			% Les trois canaux sont vectorises et concatenes
    
    % Matrice de variance/covariance :
    n = length(X);
    xmoy = sum(X)/n;
    Sigma = X'*X/n -xmoy'*xmoy; 
    
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
end