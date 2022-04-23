
% TP3 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : MOUTAHIR
% Prenom : Jed
% Groupe : 1SN-C

function varargout = fonctions_TP3_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction estimation_F (exercice_1.m) ------------------------------------
function [rho_F,theta_F,ecart_moyen] = estimation_F(rho,theta)
     A = [cos(theta), sin(theta)];
     B = rho;
     X = A\B;
     xF = X(1);
     yF = X(2); 
     rho_F = sqrt(xF^2 + yF^2);
     theta_F = atan2(yF, xF);

    % A modifier lors de l'utilisation de l'algorithme RANSAC (exercice 2)
    ecart_moyen = 1/length(rho) * sum(abs(rho-rho_F*cos(theta-theta_F)));
end

% Fonction RANSAC_2 (exercice_2.m) ----------------------------------------
function [rho_F_estime,theta_F_estime] = RANSAC_2(rho,theta,parametres)
ecart_min = Inf;
rho_F_estime = 0;
theta_F_estime = 0;
for i=1:parametres(3)
        ind = randperm(length(rho), 2);
        rho_sous_ensemble = [rho(ind(1)) ; rho(ind(2))];
        theta_sous_ensemble = [theta(ind(1)) ; theta(ind(2))];
        [rho_F_sous_ensemble,theta_F_sous_ensemble,~] = estimation_F(rho_sous_ensemble,theta_sous_ensemble);
        rho_autre = rho;
        rho_autre(ind) = [];
        theta_autre = theta;
        theta_autre(ind) = [];
        verif = abs(rho_autre - rho_F_sous_ensemble*cos(theta_autre - theta_F_sous_ensemble)) < parametres(1);
        prop = sum(verif) / length(rho_autre);

        if prop > parametres(2)
            [rho_F,theta_F,ecart] = estimation_F(rho_autre(verif),theta_autre(verif));
            if ecart < ecart_min
                ecart_min = ecart;
                rho_F_estime = rho_F;
                theta_F_estime = theta_F;
            end
        end
end
end

% Fonction G_et_R_moyen (exercice_3.m, bonus, fonction du TP1) ------------
function [G, R_moyen, distances] = ...
         G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)
G = [mean(x_donnees_bruitees) , mean(y_donnees_bruitees)];
distances = (G(1)-x_donnees_bruitees).^2 + (G(2)-y_donnees_bruitees).^2;
R_moyen = mean(distances.^0.5);
end

% Fonction estimation_C_et_R (exercice_3.m, bonus, fonction du TP1) -------
function [C_estime,R_estime,critere] = ...
         estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,n_tests,C_tests,R_tests)
     
    % Attention : par rapport au TP1, le tirage des C_tests et R_tests est 
    %             considere comme etant deje effectue 
    %             (il doit etre fait au debut de la fonction RANSAC_3)
     Mx = repmat(C_tests(1,:)',1,length(x_donnees_bruitees)) - repmat(x_donnees_bruitees,n_tests,1);
     My = repmat(C_tests(2,:)',1,length(y_donnees_bruitees)) - repmat(y_donnees_bruitees,n_tests,1);
    distances_C_candidats = (Mx.^2 + My.^2).^0.5;
    [~, ind_estime] = min(sum((distances_C_candidats-repmat(R_tests',1,length(x_donnees_bruitees))).^2,2));
    C_estime = C_tests(:,ind_estime);
    R_estime = R_tests(:,ind_estime);
    critere = 1/length(R_tests) * sum(abs(R_tests - R_estime));
end

% Fonction RANSAC_3 (exercice_3, bonus) -----------------------------------
function [C_estime,R_estime] = ...
         RANSAC_3(x_donnees_bruitees,y_donnees_bruitees,parametres)
     
    % Attention : il faut faire les tirages de C_tests et R_tests ici
    [G, R_moyen, ~] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
    
    R_tests = R_moyen/2 + R_moyen*rand([1,parametres(3)]);
    C_tests = -ones(2,parametres(3)).*R_moyen + 2*R_moyen*rand([2,parametres(3)]) + G';

    ecart_min = Inf;
    R_estime = 0;
    C_estime = [0, 0];
    for i=1:parametres(3)
            ind = randperm(length(x_donnees_bruitees), 3);
            
            x_sous_ensemble = x_donnees_bruitees(ind);
            y_sous_ensemble = y_donnees_bruitees(ind);
            [C_estime_sous_ensemble, R_estime_sous_ensemble] = estimation_cercle_3points(x_sous_ensemble,y_sous_ensemble);
            x_autre = x_donnees_bruitees;
            x_autre(ind) = [];
            y_autre = y_donnees_bruitees;
            y_autre(ind) = [];
            d = abs(sqrt((repmat(C_estime_sous_ensemble(1)',1,length(x_autre))-x_autre).^2 + (repmat(C_estime_sous_ensemble(2)',1,length(y_autre))-y_autre).^2) - R_estime_sous_ensemble);
            verif = d < parametres(1);
            prop = sum(verif) / length(x_autre);
    
            if prop > parametres(2)
                [C,R,ecart] = estimation_C_et_R(x_autre(verif),y_autre(verif),parametres(3),C_tests,R_tests);
                if ecart < ecart_min
                    ecart_min = ecart;
                    C_estime = C;
                    R_estime = R;
                end
            end
    end
end
