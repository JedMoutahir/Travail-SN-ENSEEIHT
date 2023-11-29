% Résolution de l'équation elliptique
%   - nabla (c.grad u) + a.u = f

clear all
close all

% Les différents fichiers pour définir le problème d'EDP (voir explications)
% geometry
geom = 'tubeG';
% boundaries
boundary = 'tubeB';
% source
source = 'tubeF';

% commenter ces 2 lignes si pénurie de licences Matlab
figure(1);
pdegplot(geom), axis equal;

% Choix du niveau de raffinage : on effectuera autant de résolutions que de
% niveaux de raffinage
nR = input('Niveau de raffinage 0 <= nR < 4 : '); 

while (nR >= 4) || (nR < 0)
  nR = input('Niveau de raffinage 0 <= nR < 4 : ');
end

% Choix du préconditionneur pour le premier test
choix = menu( 'Test Gradient Conjugue Préconditionné', ...
              'sans','diagnonal','cholesky incomplet sans fill-in',...
              'cholesky incomplet avec tolérance','fin');

while choix < 5

  close all;
  
  % choix du seuil dans le cas de la factorisation incomplète de Cholesky avec
  % treshold
  if choix == 4
    DropTol = input('Drop Tolerance (réel positif) :  ') ;
  end

  % Création du maillage avec l'aide du fichier geom
  % commenter la ligne suivante si pénurie de licences Matlab
  [p,e,t] = initmesh(geom);

  % Boucle sur les niveaux de raffinage 
  for k = 0:nR

    % commenter cette section si pénurie de licences Matlab
    % -- début section

    %% Construction du problème

    % Raffinage
    if k > 0 
      [p,e,t] = refinemesh(geom, p, e, t);
    end

    % Dessin du maillage
    figure(2);
    pdemesh(p, e, t), axis equal
    xlabel(['number of triangles = ' num2str(size(t, 2))]);
    disp('fin construction du maillage : taper une touche');
    pause

    % Construction de la matrice de rigidité ainsi que du
    % second membre
    % problème résolu : - nabla(c.grad u ) + a.u = f
    % avec
    
    a = 0.0;
    
    % avec c variable suivant les sous-domaines Omega 1, 2 et 3
    
    c = setupC(p, t);
    
    % avec f donné par le fichier source
    % avec conditions aux limites données par le fichier boundary 
    %   Gamma 1 et Gamma 3 : Neumann homogènes
    %   Gamma 2 : Dirichlet u = 10
    %   Gamma 4 : Dirichlet u = 100
    
    [A,b]= assempde(boundary, p, e, t, c, a, source);

    % -- fin section

    % décommenter la section suivante si pénurie de licences Matlab
    % -- début section
    %switch k
    %  case 0
    %    load mat0;
    %  case 1
    %    load mat1;
    %  case 2
    %    load mat2;
    %  case 3
    %    load mat3;
    %  otherwise
    %    disp('impossible');
    %end
    % -- fin section

    % dimension du problème
    n = size(A, 1);

    % Définition des paramètres gouvernant l'arrêt de la méthode itérative
    tol = 1.e-10; 
    maxit = floor(n/2);

    %% CONSTRUCTION DU PRÉCONDITIONNEUR M1*M2 = M
    tic
    switch choix

      case 1,
        % Sans Préconditionnement
        M1 = eye(n);
        M2 = M1;
        
      case 2,
        % Diagonal
        M1 = eye(n);
        M2 = diag(diag(A));

      case 3,
        % Cholesky Incomplet sans remplissage
        M1 = ichol(A);
        M2 = M1';

      case 4,
        % Cholesky Incomplet avec treshold
        M1 = cholinc_n7(A, DropTol);
        M2 = M1';

    end
    timep = toc;

    if choix >= 3

      % Afficher dans une même figure
      % - la structure de la matrice A dans la partie triangulaire supérieure
      % - le facteur triangulaire inférieur du préconditionneur
      % ...
      
      % À COMPLÉTER
      figure(3);
      spy(triu(A) + M1);
      disp('press any key')
      pause
      
    end

    %% RÉSOLUTION DU SYSTÈME PRÉCONDITIONNÉ AVEC CG
    
    % affectations pour permettre les affichages dans le code initial :
    % À SUPPRIMER
    %x = zeros(n, 1);
    %iter = 100;
    % fin affectations à supprimer
    
    tic;
    
    
    [x, flag, relres, iter, resvec] = pcg(A, b, tol, maxit, M1, M2);
    
    
    timer = toc;
    
    % Affichage d'informations
    fprintf(' ------------------------------------------ \n');
    fprintf(' niveau de Raffinage : %5d \n', k);
    fprintf(' Taille du probleme : %5d \n', n);
    fprintf(' - flag : %5d \n', flag);
    fprintf(' - norme relative du résidu : %e \n', relres);
    fprintf(' - Nb iterations : %4d \n' , iter);
    fprintf(' - Elapsed time pour la construction du préconditionneur : %e s \n', timep);
    fprintf(' - Elapsed time pour la résolution : %e s \n', timer);
    fprintf(' - Elapsed time : %e s \n',timer + timep);

    % Dessin de la solution sur la géométrie
    % commenter les 4 lignes suivantes si pénurie de licences Matlab
    figure(4)
    Titre = [ 'Solution' ];
    pdeplot(p, e, t, 'xydata', x, 'title', Titre, 'colormap', 'jet', ...
            'mesh', 'off', 'contour', 'off', 'levels', 20), axis equal;
    fprintf(' ------------------------------------------ \n');
    disp('fin dessin solution : taper une touche');
    pause;

    % Afficher l'historique de convergence en les superposant pour les
    % différentes finesse de maillage

    % pour tracer les courbes de décroissance de la norme relative du résidu 
    % des différents maillages avec des couleurs différentes
    % niveau k = 0..3  => couleur(k+1)
    couleur = ['g', 'r', 'c', 'm'];

    figure(5)
    % À COMPLÉTER par le tracé de l'historique de convergence avec une
    % couleur diférente suivant le maillage (niveau)
    semilogy(resvec/norm(b), couleur(k+1))

    
    hold on
    disp('fin résolution pour ce maillage : taper une touche');
    pause

  end % for k, niveau de raffinage

  disp('nouveau calcul (avec autre préconditionneur ?)');
 
  % Choix du préconditionneur pour le test suivant
  choix = menu( 'Test Gradient Conjugue Préconditionné', ...
               'sans','diagnonal','cholesky incomplet sans fill-in',...
               'cholesky incomplet avec tolérance','fin');

end

close all;
