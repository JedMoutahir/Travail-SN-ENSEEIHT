
% TP3 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom :
% Prénom : 
% Groupe : 1SN-

function varargout = fonctions_TP3_proba(varargin)

    switch varargin{1}
        
        case 'matrice_inertie'
            
            [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});
            
        case {'ensemble_E_recursif','calcul_proba'}
            
            [varargout{1},varargout{2},varargout{3}] = feval(varargin{1},varargin{2:end});
    
    end
end

% Fonction ensemble_E_recursif (exercie_1.m) ------------------------------
function [E,contour,G_somme] = ...
    ensemble_E_recursif(E,contour,G_somme,i,j,voisins,G_x,G_y,card_max,cos_alpha)
    contour(i,j) = 0;
    for k=1:size(voisins)
        ind_k = [i + voisins(k,1) , j + voisins(k,2)];
        G_k = [G_x(ind_k(1), ind_k(2)) ; G_y(ind_k(1), ind_k(2))];
        %sum(sum(contour))
        %(G_somme * G_k) / (norm(G_somme) * norm(G_k))
        %contour(ind_k(1), ind_k(2))
        if(contour(ind_k(1), ind_k(2)) ~= 0 && (G_somme * G_k) / (norm(G_somme) * norm(G_k)) >= cos_alpha && size(E,1) <= card_max)
            E = [E ; ind_k];
            G_somme(1) = G_somme(1) + G_x(ind_k(1), ind_k(2));
            G_somme(2) = G_somme(2) + G_y(ind_k(1), ind_k(2));
            [E,contour, G_somme] = ensemble_E_recursif(E,contour,G_somme,ind_k(1), ind_k(2),voisins,G_x,G_y,card_max,cos_alpha);
        end
    end
end

% Fonction matrice_inertie (exercice_2.m) ---------------------------------
function [M_inertie,C] = matrice_inertie(E,G_norme_E)
    E_flip = fliplr(E);
    PI = sum(G_norme_E);
    xm = 1.0 / PI * sum(G_norme_E .* E_flip(:,1));
    ym = 1.0 / PI * sum(G_norme_E .* E_flip(:,2));
    C = [xm , ym];
    M_inertie = 1.0 / PI * [sum(G_norme_E .* (E_flip(:,1) - xm).^2), sum(G_norme_E .* (E_flip(:,1) - xm) .* (E_flip(:,2) - ym)) ; sum(G_norme_E .* (E_flip(:,1) - xm) .* (E_flip(:,2) - ym)), sum(G_norme_E .* (E_flip(:,2) - ym).^2)];
end

% Fonction calcul_proba (exercice_2.m) ------------------------------------
function [x_min,x_max,probabilite] = calcul_proba(E_nouveau_repere,p)
    x_min = min(E_nouveau_repere(:,1));
    x_max = max(E_nouveau_repere(:,1));
    y_min = min(E_nouveau_repere(:,2));
    y_max = max(E_nouveau_repere(:,2));
    N = round((x_max-x_min) * (y_max-y_min));
    probabilite = 1-binocdf(size(E_nouveau_repere,1), N, p);
end
