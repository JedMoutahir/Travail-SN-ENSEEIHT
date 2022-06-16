%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Analyse de donnees
% TP4 - Reconnaissance de chiffres manuscrits par k plus proches voisins
% fonction kppv.m
%
% Données :
% DataA      : les données d'apprentissage (connues)
% LabelA     : les labels des données d'apprentissage
%
% DataT      : les données de test (on veut trouver leur label)
% Nt_test    : nombre de données tests qu'on veut labelliser
%
% K          : le K de l'algorithme des k-plus-proches-voisins
% ListeClass : les classes possibles (== les labels possibles)
%
% Résultat :
% Partition : pour les Nt_test données de test, le label calculé
%
%--------------------------------------------------------------------------
function [Partition, MatConfusion, TauxErreur] = kppv(DataA, LabelA, DataT, Nt_test, K, ListeClass, LabelT)

[Na,~] = size(DataA);

% Initialisation du vecteur d'étiquetage des images tests
Partition = zeros(Nt_test,1);

disp(['Classification des images test dans ' num2str(length(ListeClass)) ' classes'])
disp(['par la methode des ' num2str(K) ' plus proches voisins:'])

% Boucle sur les vecteurs test de l'ensemble de l'évaluation
for i = 1:Nt_test
    
    disp(['image test n°' num2str(i)])

    % Calcul des distances entre le vecteur de test 
    % et les vecteurs d'apprentissage (voisins)
    D = sum(abs(DataA - DataT(i,:))');
    
    % On ne garde que les indices des K + proches voisins
    [Dsorted, Indsort] = sort(D,'ascend');
    Kppv = LabelA(Indsort);
    Kppv = Kppv(1:K);

    % Comptage du nombre de voisins appartenant à chaque classe
    Classes = zeros(1,10);
    for j=1:K
        Classes(Kppv(j)+1) = Classes(Kppv(j)+1)+1;
    end
    
    % Recherche des classes contenant le maximum de voisins
    [~,ind] = max(Classes);
    ind = ind-1;
    %ind = find( Classes(:) == max(Classes(:)) )-1;
    %disp(ind);
    
    

    % Si l'image test a le plus grand nombre de voisins dans plusieurs  
    % classes différentes, alors on lui assigne celle du voisin le + proche,
    % sinon on lui assigne l'unique classe contenant le plus de voisins 
    if(nnz(Classes == max(Classes(:))) ~= 1)
        disp("égalité");
        Partition(i) = Kppv(1);

    else
    % Assignation de l'étiquette correspondant à la classe trouvée au point 
    % correspondant à la i-ème image test dans le vecteur "Partition" 
        Partition(i) = ind(1);

    end
    
end
MatConfusion = confusionmat(LabelT(1:Nt_test),Partition);
TauxErreur = sum(sum(abs(MatConfusion-diag(diag(MatConfusion)))))/Nt_test;

