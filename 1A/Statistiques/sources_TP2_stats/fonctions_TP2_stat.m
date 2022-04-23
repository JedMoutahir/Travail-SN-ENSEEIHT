
% TP2 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : MOUTAHIR
% Prénom : Jed
% Groupe : 1SN-C

function varargout = fonctions_TP2_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction centrage_des_donnees (exercice_1.m) ----------------------------
function [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees)
     x_G = mean(x_donnees_bruitees);
     y_G = mean(y_donnees_bruitees);
     x_donnees_bruitees_centrees = x_donnees_bruitees - x_G;
     y_donnees_bruitees_centrees = y_donnees_bruitees - y_G;
end

% Fonction estimation_Dyx_MV (exercice_1.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
           estimation_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,n_tests)
     Psi_candidats = rand([1,n_tests]).*pi -pi/2 ;
     Tan_psi_candidats = tan(Psi_candidats);
     [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
     Mx = repmat(Tan_psi_candidats(1,:)',1,length(x_donnees_bruitees_centrees)).*repmat(x_donnees_bruitees,n_tests,1);
     My = repmat(y_donnees_bruitees_centrees,n_tests,1);
     distances_Tan_psi_candidats = (My - Mx).^2;
     [val, ind_estime] = min(sum(distances_Tan_psi_candidats,2));
     a_Dyx = Tan_psi_candidats(:,ind_estime);
     b_Dyx = mean(y_donnees_bruitees - a_Dyx*x_donnees_bruitees);
end

% Fonction estimation_Dyx_MC (exercice_2.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
                   estimation_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)
     A = [x_donnees_bruitees', ones(length(x_donnees_bruitees),1)];
     B = y_donnees_bruitees';
     X = inv(A'*A)*A'*B;
     a_Dyx = X(1);
     b_Dyx = X(2);
end

% Fonction estimation_Dorth_MV (exercice_3.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
         estimation_Dorth_MV(x_donnees_bruitees,y_donnees_bruitees,n_tests)
     Theta_candidats = rand([1,n_tests]).*pi;
     Cos_psi_candidats = cos(Theta_candidats);
     Sin_psi_candidats = sin(Theta_candidats);
     [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
     Mx = repmat(Cos_psi_candidats(1,:)',1,length(x_donnees_bruitees_centrees)).*repmat(x_donnees_bruitees,n_tests,1);
     My = repmat(Sin_psi_candidats(1,:)',1,length(y_donnees_bruitees_centrees)).*repmat(y_donnees_bruitees_centrees,n_tests,1);
     distances_Tan_psi_candidats = (Mx + My).^2;
     [val, ind_estime] = min(sum(distances_Tan_psi_candidats,2));
     theta_Dorth = Theta_candidats(:,ind_estime);
     rho_Dorth = mean(x_donnees_bruitees*cos(theta_Dorth) + y_donnees_bruitees*sin(theta_Dorth));
end

% Fonction estimation_Dorth_MC (exercice_4.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
                 estimation_Dorth_MC(x_donnees_bruitees,y_donnees_bruitees)
     [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
     C = [x_donnees_bruitees_centrees', y_donnees_bruitees_centrees'];
     CtC = C'*C;
     [V,D] = eig(CtC);
     valeurs_propres = diag(D);
     [val, ind_estime] = min(valeurs_propres);
     Y_estime = V(:,ind_estime);
     theta_Dorth = acos(Y_estime(1));
     if Y_estime(2) <  0 
         theta_Dorth = -theta_Dorth;
     end
     rho_Dorth = mean(x_donnees_bruitees*cos(theta_Dorth) + y_donnees_bruitees*sin(theta_Dorth));
end
