% Ce programme est le script principal permettant d'illustrer
% un algorithme de reconnaissance de chiffres.

% Nettoyage de l'espace de travail
clear all; close all;

% Repertories contenant les donnees et leurs lectures
addpath('Data');
addpath('Utils')

rng('shuffle')

PrecApprox = 0.7;
% Bruit
sig0=0.3;

%tableau des csores de classification
% intialisation aléatoire pour affichage
r=rand(6,5);
r2=rand(6,5);

for k=1:5
    % Definition des donnees
    file=['D' num2str(k)]

    % Recuperation des donnees
    disp('Generation de la base de donnees');
    sD=load(file);
    D=sD.(file);
    %

    % Bruitage des données
    Db= D+sig0*rand(size(D));

    %%%%%%%%%%%%%%%%%%%%%%%
    % Analyse des donnees
    %%%%%%%%%%%%%%%%%%%%%%%
    disp('PCA : calcul du sous-espace');
    %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%

    % Centrage des données
    [m, n] = size(Db);
    moy = (Db * ones(n,1)) / n;
    Dbc = Db - moy * ones(1,n);

    % PCA
    [k1, V1] = PCA(Dbc, PrecApprox);

    %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

    disp('kernel PCA : calcul du sous-espace');
    %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
    [k2, K, alpha, Y, V2] = KPCA(Dbc, PrecApprox);

    %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Reconnaissance de chiffres
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Lecture des chiffres é reconnaitre
    disp('test des chiffres :');
    tes(:,1) = importerIm('test1.jpg',1,1,16,16);
    tes(:,2) = importerIm('test2.jpg',1,1,16,16);
    tes(:,3) = importerIm('test3.jpg',1,1,16,16);
    tes(:,4) = importerIm('test4.jpg',1,1,16,16);
    tes(:,5) = importerIm('test5.jpg',1,1,16,16);
    tes(:,6) = importerIm('test9.jpg',1,1,16,16);

    for tests=1:6
        % Bruitage
        tes(:,tests)=tes(:,tests)+sig0*rand(length(tes(:,tests)),1);

        % Classification depuis ACP
        %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
        disp('PCA : classification');
        tesc = tes(:,tests) - moy;
        Image = V1(:,1:k1)' * tesc;
        r(tests,k) = (norm((eye(m) - (V1(:,1:k1) * V1(:,1:k1)'))*tesc, 2))/(norm(tesc, 2));
        if(tests==k)
            figure(100+k)
            subplot(1,3,1);
            imshow(reshape(tes(:,tests),[16,16]));
            subplot(1,3,2);
            imshow(reshape(moy + V1(:,1:k1) * Image,[16,16]));
            title('PCA');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

        % Classification depuis kernel ACP
        %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
        disp('kernel PCA : classification');
        somme1 = 0;
        for s=1:n
            somme1 = somme1 + noyau(Dbc(:, s), tesc);
        end
        den = noyau(tesc, tesc) - 2*somme1/n + sum(K * ones(n, 1))/(n^2);
        num = 0;
        beta = zeros(k2, 1);
        for i=1:k2
            somme2 = 0;
            for j=1:n
                somme2 = somme2 + alpha(j,i)*noyau(tesc, Dbc(:,j));
            end
            somme3 = 0;
            for l=1:n
                for j=1:n
                    somme3 = somme3 + alpha(l,i)*K(j,l)/n;
                end
            end
            beta(i) = somme2 - somme3;
        end
        for i=1:k2
            for j=1:k2
                for p=1:n
                    for q=1:n
                        num = num + beta(i)*beta(j)*alpha(p,i)*alpha(q,j)*K(p,q);
                    end
                end
            end
        end
        r2(tests,k) = 1 - num/den;
        if(tests==k)
            z = zeros(m, 1);
            for ite=1:4
                num = zeros(m, 1);
                den = 0;
                for i=1:n
                    gamma = 0;
                    for j=1:k2
                        for l=1:n
                            gamma = gamma + alpha(l,j)*alpha(i,j)*noyau(tesc, Dbc(:,l));
                        end
                    end
                    num = num + gamma*noyau(Dbc(:,i), z)*Db(:,i);
                    den = den + gamma*noyau(Dbc(:,i), z);
                end
                z = num/den;
            end
            figure(100+k)
            subplot(1,3,3);
            imshow(reshape(z,[16,16]));
            title('Kernel PCA');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%
    end

end


% Affichage du résultat de l'analyse par PCA
couleur = hsv(6);

figure(11)
for tests=1:6
    hold on
    plot(1:5, r(tests,:),  '+', 'Color', couleur(tests,:));
    hold off

    for i = 1:4
        hold on
        plot(i:0.1:(i+1),r(tests,i):(r(tests,i+1)-r(tests,i))/10:r(tests,i+1), 'Color', couleur(tests,:),'LineWidth',2)
        hold off
    end
    hold on
    if(tests==6)
        testa=9;
    else
        testa=tests;
    end
    text(5,r(tests,5),num2str(testa));
    hold off
end

% Affichage du résultat de l'analyse par kernel PCA
figure(12)
for tests=1:6
    hold on
    plot(1:5, r2(tests,:),  '+', 'Color', couleur(tests,:));
    hold off

    for i = 1:4
        hold on
        plot(i:0.1:(i+1),r2(tests,i):(r2(tests,i+1)-r2(tests,i))/10:r2(tests,i+1), 'Color', couleur(tests,:),'LineWidth',2)
        hold off
    end
    hold on
    if(tests==6)
        testa=9;
    else
        testa=tests;
    end
    text(5,r2(tests,5),num2str(testa));
    hold off
end