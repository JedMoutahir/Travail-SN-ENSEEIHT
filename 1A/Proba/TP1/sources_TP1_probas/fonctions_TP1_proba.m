
% TP1 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom : Moutahir
% Prénom : Jed
% Groupe : 1SN-C

function varargout = fonctions_TP1_proba(varargin)

    switch varargin{1}     
        case 'ecriture_RVB'
            varargout{1} = feval(varargin{1},varargin{2:end});
        case {'vectorisation_par_colonne','decorrelation_colonnes'}
            [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});
        case 'calcul_parametres_correlation'
            [varargout{1},varargout{2},varargout{3}] = feval(varargin{1},varargin{2:end}); 
    end

end

% Fonction ecriture_RVB (exercice_0.m) ------------------------------------
% (Copiez le corps de la fonction ecriture_RVB du fichier du meme nom)
function image_RVB = ecriture_RVB(image_originale)
    canal_R = image_originale(1:2:end,2:2:end);
    canal_B = image_originale(2:2:end,1:2:end);
    canal_V = 0.5*(image_originale(1:2:end,1:2:end) + image_originale(2:2:end,2:2:end));
    image_RVB = cat(3, canal_R, canal_B, canal_V);
end

% Fonction vectorisation_par_colonne (exercice_1.m) -----------------------
function [Vd,Vg] = vectorisation_par_colonne(I)
    Vg = I(:,1:end-1);
    Vg = Vg(:);
    Vd = I(:,2:end);
    Vd = Vd(:);
end

% Fonction calcul_parametres_correlation (exercice_1.m) -------------------
function [r,a,b] = calcul_parametres_correlation(Vd,Vg)
md = mean(Vd);
mg = mean(Vg);
sd = size(Vd);
sd = sd(1);
sg = size(Vg);
sg = sg(1);
vard = 1/sd * sum((Vd-md).*(Vd-md));
varg = 1/sg * sum((Vg-mg).*(Vg-mg));
cov = 1/sd * sum((Vd-md).*(Vg-mg));
r = cov/(sqrt(vard)*sqrt(varg));
a = cov/vard;
b = mg - md * a;
end

% Fonction decorrelation_colonnes (exercice_2.m) --------------------------
function [I_decorrelee,I_min] = decorrelation_colonnes(I,I_max)
sd = size(I);
I_decalee = cat(2, zeros([sd(1), 1]), I(:, 1:end-1));
I_decorrelee = I - I_decalee;
I_min = -I_max;
end



