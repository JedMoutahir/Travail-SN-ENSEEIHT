close all;
clear;
for i=1:7
    dir1 = strcat("Data_Exo_2/SG", num2str(i), ".mat");
    dir2 = strcat("Data_Exo_2/ImSG", num2str(i), ".mat");
    load(dir1);
    load(dir2);
    
    x = reshape(Data, 1, [])';
    y = reshape(log(DataMod), 1, [])';
    
    %-------------------------MCO-------------------------
    Beta_chapeau = MCO(x, y);
    Ireconstruit = Tinv(ImMod, Beta_chapeau(1), Beta_chapeau(2));
    erreurMCO = sqrt(immse(Ireconstruit,I));
    
    %Affichage Image originale
    figure;
    colormap gray
    subplot(2,2,1), image(I*255);
    title("Image originale");
    
    %Affichage Image modifiée
    subplot(2,2,2), image(ImMod*255);
    title("Image modifiée");
    
    %Affichage Image reconstruite
    subplot(2,2,3), image(Ireconstruit*255);
    title("Image reconstruite avec MCO");
    
    
    %-------------------------MTO-------------------------
    Beta_chapeau = MTO(x, y);
    Ireconstruit = Tinv(ImMod, Beta_chapeau(1), Beta_chapeau(2));
    erreurTO = sqrt(immse(Ireconstruit,I));
    
    %Affichage Image originale
    figure;
    colormap gray
    subplot(2,2,1), image(I*255);
    title("Image originale");
    
    %Affichage Image modifiée
    subplot(2,2,2), image(ImMod*255);
    title("Image modifiée");
    
    %Affichage Image reconstruite
    subplot(2,2,3), image(Ireconstruit*255);
    title("Image reconstruite avec MTO");
end




%-------------------------fonctions-------------------------
function I = Tinv(J,alpha,beta)
    I = (log(J)-beta)/alpha;
end


function X = MCO(x, y)
    A = [x -ones(length(x),1)];
    X = pinv(A)*y;
end

function X = MTO(x, y)
    A = [x -ones(length(x),1)];
    [~, ~, V] = svd([A y]);
    [n, m] = size(V);
    X = 1/(-V(n,m)) * V(:, m);
end