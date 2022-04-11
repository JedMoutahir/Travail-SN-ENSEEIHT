%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Analyse de données
% TP3 - Classification bayésienne
% exercice_3_bis.m
%--------------------------------------------------------------------------

clear
close all
clc

% Chargement des données de l'exercice 2
load resultats_ex2

%% Modification de la probabilité à priori
P = [0.02 0.29 0.69];
V_chrysanthemes = P(1)*V_chrysanthemes;
V_oeillets = P(2)*V_oeillets;
V_pensees = P(3)*V_pensees;

%% Classifieur par maximum de vraisemblance
% code_classe est la matrice contenant des 1 pour les chrysanthemes
%                                          2 pour les oeillets
%                                          3 pour les pensees
% l'attribution de 1,2 ou 3 correspond au maximum des trois vraisemblances

classe_chysanthemes = V_pensees < V_chrysanthemes & V_oeillets < V_chrysanthemes;
classe_pensees = V_pensees > V_chrysanthemes& V_oeillets < V_oeillets;
classe_oeillets = V_pensees < V_oeillets & V_oeillets > V_chrysanthemes;
code_classe = classe_chysanthemes + classe_oeillets * 2 + classe_pensees * 3;

%% Affichage des classes

figure('Name','Classification par maximum de vraisemblance',...
       'Position',[0.25*L,0.1*H,0.5*L,0.8*H])
axis equal ij
axis([r(1) r(end) v(1) v(end)]);
hold on
imagesc(r,v,code_classe)
carte_couleurs = [.45 .45 .65 ; .45 .65 .45 ; .65 .45 .45];
colormap(carte_couleurs)
hx = xlabel('$\overline{r}$','FontSize',20);
set(hx,'Interpreter','Latex')
hy = ylabel('$\bar{v}$','FontSize',20);
set(hy,'Interpreter','Latex')
view(-90,90)

%% Comptage des images correctement classees
%comptage chrysanthemes
nb_bien_classee = 0;
for i=1:length(X_chrysanthemes)
    x = X_chrysanthemes(i,:);
    vxC = vraisemblance(x(1), x(2), mu_chrysanthemes, Sigma_chrysanthemes, -1);
    vxO = vraisemblance(x(1), x(2), mu_oeillets, Sigma_oeillets, -1);
    vxP = vraisemblance(x(1), x(2), mu_pensees, Sigma_pensees, -1);
    if(vxC > vxO & vxC > vxP)
        nb_bien_classee = nb_bien_classee +1;
    end
end
pC = nb_bien_classee/length(X_chrysanthemes);
disp(['Il y a ' num2str(pC*100) '% des chrysanthemes bien classées'])
%comptage oeillets
nb_bien_classee = 0;
for i=1:length(X_oeillets)
    x = X_oeillets(i,:);
    vxC = vraisemblance(x(1), x(2), mu_chrysanthemes, Sigma_chrysanthemes, -1);
    vxO = vraisemblance(x(1), x(2), mu_oeillets, Sigma_oeillets, -1);
    vxP = vraisemblance(x(1), x(2), mu_pensees, Sigma_pensees, -1);
    if(vxC < vxO & vxO > vxP)
        nb_bien_classee = nb_bien_classee +1;
    end
end
pO = nb_bien_classee/length(X_oeillets);
disp(['Il y a ' num2str(pO*100) '% des oeillets bien classées'])
%comptage pensees
nb_bien_classee = 0;
for i=1:length(X_pensees)
    x = X_pensees(i,:);
    vxC = vraisemblance(x(1), x(2), mu_chrysanthemes, Sigma_chrysanthemes, -1);
    vxO = vraisemblance(x(1), x(2), mu_oeillets, Sigma_oeillets, -1);
    vxP = vraisemblance(x(1), x(2), mu_pensees, Sigma_pensees, -1);

    vxC = P(1)*vxC;
    vxO = P(2)*vxO;
    vxP = P(3)*vxP;

    if(vxP > vxO & vxC < vxP)
        nb_bien_classee = nb_bien_classee +1;
    end
end
pP = nb_bien_classee/length(X_pensees);
disp(['Il y a ' num2str(pP*100) '% des pensees bien classées'])
