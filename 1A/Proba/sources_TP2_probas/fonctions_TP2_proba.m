
% TP2 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom : MOUTAHIR
% Prenom : Jed
% Groupe : 1SN-C

function varargout = fonctions_TP2_proba(varargin)

    switch varargin{1}
        
        case {'calcul_frequences_caracteres','determination_langue','coeff_compression','gain_compression','partitionnement_frequences'}

            varargout{1} = feval(varargin{1},varargin{2:end});
            
        case {'recuperation_caracteres_presents','tri_decroissant_frequences','codage_arithmetique'}
            
            [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});
            
        case 'calcul_parametres_correlation'
            
            [varargout{1},varargout{2},varargout{3}] = feval(varargin{1},varargin{2:end});
            
    end

end

% Fonction calcul_frequences_caracteres (exercice_0.m) --------------------
function frequences = calcul_frequences_caracteres(texte,alphabet)
    frequences = zeros(length(alphabet),1);
    for i = 1:length(alphabet)
        frequences(i) = length(find(texte==alphabet(i))) / length(texte);
    end
end

% Fonction recuperation_caracteres_presents (exercice_0.m) ----------------
function [selection_frequences,selection_alphabet] = ...
                      recuperation_caracteres_presents(frequences,alphabet)
    selection_frequences = frequences(find(frequences > 0));
    selection_alphabet = alphabet(find(frequences > 0));
end

% Fonction tri_decremental_frequences (exercice_0.m) ----------------------
function [frequences_triees,indices_frequences_triees] = ...
                           tri_decroissant_frequences(selection_frequences)
    [frequences_triees, indices_frequences_triees] = sort(selection_frequences, 'descend');
end

% Fonction determination_langue (exercice_1.m) ----------------------------
function langue = determination_langue(frequences_texte, frequences_langue, nom_norme)
    % Note : la variable nom_norme peut valoir 'L1', 'L2' ou 'Linf'.
    if size(frequences_texte,2)==1
        frequences_texte = transpose(frequences_texte);
    end

    N = zeros(15,1);
    for i = 1:15
        switch nom_norme
            case 'L1'
                L = sum(abs(frequences_texte - frequences_langue(i,:)));
            case 'L2'
                L = sum((frequences_texte - frequences_langue(i,:)).^2);
            case 'Linf'
                L = max(frequences_texte - frequences_langue(i,:));
            otherwise
                L = 0;
        end
        N(i) = L;
    end
    [val,langue] = min(N);
end

% Fonction coeff_compression (exercice_2.m) -------------------------------
function coeff_comp = coeff_compression(signal_non_encode,signal_encode)
    coeff_comp = length(signal_non_encode) / length(signal_encode) * 8;
end

% Fonction coeff_compression (exercice_2bis.m) -------------------------------
function gain_comp = gain_compression(coeff_comp_avant,coeff_comp_apres)
    gain_comp = coeff_comp_apres / coeff_comp_avant;
end

% Fonction partitionnement_frequences (exercice_3.m) ----------------------
function bornes = partitionnement_frequences(selection_frequences)
    bornes = zeros(2, length(selection_frequences));
    for i = 2:length(selection_frequences)
        bornes(1, i) = bornes(1, i-1) + selection_frequences(i-1);
    end
    for i = 1:length(selection_frequences)-1
        bornes(2, i) = bornes(1, i+1);
    end
bornes(2,length(selection_frequences)) = 1;
end

% Fonction codage_arithmetique (exercice_3.m) -----------------------------
function [borne_inf,borne_sup] = ...
                       codage_arithmetique(texte,selection_alphabet,bornes)
    borne_inf = 0;
    borne_sup = 1;
    for i = 1:length(texte)
            j = find(selection_alphabet == texte(i));
            largeur = borne_sup-borne_inf;
            borne_sup = borne_inf+largeur*bornes(2,j);
            borne_inf = borne_inf+largeur*bornes(1,j);
    end 
end