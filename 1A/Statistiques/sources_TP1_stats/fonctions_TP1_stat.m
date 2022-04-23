
% TP1 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : MOUTAHIR
% Prénom : JED
% Groupe : 1SN-C

function varargout = fonctions_TP1_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction G_et_R_moyen (exercice_1.m) ----------------------------------
function [G, R_moyen, distances] = ...
         G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)
G = [mean(x_donnees_bruitees) , mean(y_donnees_bruitees)];
distances = (G(1)-x_donnees_bruitees).^2 + (G(2)-y_donnees_bruitees).^2;
R_moyen = mean(distances.^0.5);
end

% Fonction estimation_C_uniforme (exercice_1.m) ---------------------------
function [C_estime, R_moyen] = ...
         estimation_C_uniforme(x_donnees_bruitees,y_donnees_bruitees,n_tests)
     [G, R_moyen, distances] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
     C_candidats = -ones(2,n_tests).*R_moyen + 2*R_moyen*rand([2,n_tests]) + G';
     Mx = repmat(C_candidats(1,:)',1,length(x_donnees_bruitees)) - repmat(x_donnees_bruitees,n_tests,1);
     My = repmat(C_candidats(2,:)',1,length(y_donnees_bruitees)) - repmat(y_donnees_bruitees,n_tests,1);
    distances_C_candidats = (Mx.^2 + My.^2).^0.5;
     [val, ind_C_estime] = min(sum((distances_C_candidats-R_moyen).^2,2));
    C_estime = C_candidats(:,ind_C_estime);
    
end

% Fonction estimation_C_et_R_uniforme (exercice_2.m) ----------------------
function [C_estime, R_estime] = ...
         estimation_C_et_R_uniforme(x_donnees_bruitees,y_donnees_bruitees,n_tests)
        [G, R_moyen, distances] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
        R_candidats = R_moyen/2 + R_moyen*rand([1,n_tests]);
     C_candidats = -ones(2,n_tests).*R_moyen + 2*R_moyen*rand([2,n_tests]) + G';
     Mx = repmat(C_candidats(1,:)',1,length(x_donnees_bruitees)) - repmat(x_donnees_bruitees,n_tests,1);
     My = repmat(C_candidats(2,:)',1,length(y_donnees_bruitees)) - repmat(y_donnees_bruitees,n_tests,1);
    distances_C_candidats = (Mx.^2 + My.^2).^0.5;
     [val, ind_estime] = min(sum((distances_C_candidats-repmat(R_candidats',1,length(x_donnees_bruitees))).^2,2));
    C_estime = C_candidats(:,ind_estime);
    R_estime = R_candidats(:,ind_estime);
end

% Fonction occultation_donnees (donnees_occultees.m) ----------------------
function [x_donnees_bruitees, y_donnees_bruitees] = ...
         occultation_donnees(x_donnees_bruitees, y_donnees_bruitees, theta_donnees_bruitees)
    T1 = rand()*2*pi
    T2 = rand()*2*pi
    if(T1 < T2)
        ind = theta_donnees_bruitees <= T1 | theta_donnees_bruitees >= T2;
    else
        ind = theta_donnees_bruitees > T2 & theta_donnees_bruitees < T1;
    end
    
    x_donnees_bruitees(ind) = [];
    y_donnees_bruitees(ind) = [];



end

% Fonction estimation_C_et_R_normale (exercice_4.m, bonus) ----------------
function [C_estime, R_estime] = ...
         estimation_C_et_R_normale(x_donnees_bruitees,y_donnees_bruitees,n_tests)



end
