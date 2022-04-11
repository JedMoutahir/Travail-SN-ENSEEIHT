function L = laplacian(nu,dx1,dx2,N1,N2)
%
%  Cette fonction construit la matrice de l'opérateur Laplacien 2D anisotrope
%
%  Inputs
%  ------
%
%  nu : nu=[nu1;nu2], coefficients de diffusivité dans les dierctions x1 et x2. 
%
%  dx1 : pas d'espace dans la direction x1.
%
%  dx2 : pas d'espace dans la direction x2.
%
%  N1 : nombre de points de grille dans la direction x1.
%
%  N2 : nombre de points de grilles dans la direction x2.
%
%  Outputs:
%  -------
%
%  L      : Matrice de l'opérateur Laplacien (dimension N1N2 x N1N2)
%
% 

% Initialisation
L=sparse([]);

%%%%%%%%%%%%%%%%%%%%%%
%%%%%% TO DO %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% v1 = 2*(nu(1)/(dx1*dx1) + nu(2)/(dx2*dx2)).*ones(N1*N2,1);
% M1 = spdiag(v1);
% v2 = -nu(1)/(dx1*dx1).*ones((N1-2)*N2,1);
% M2 = spdiag(v2,-N2);
% v3 = -nu(1)/(dx1*dx1).*ones((N1-2)*N2,1);
% M3 = spdiag(v3, N2);
% v4 = -nu(2)/(dx2*dx2).*ones(N1*N2-2,1);
% M4 = spdiag(v4, 1);
% v5 = -nu(2)/(dx2*dx2).*ones(N1*N2-2,1);
% M5 = spdiag(v5, -1);
% L = sparse(M1+M2+M3+M4+M5)
dx2inv = nu(1)/ dx1^2;
dy2inv = nu(2)/ dx2^2;

ddxv = 2*(dx2inv + dy2inv) * ones(N2,1);
dxv = -dx2inv * ones(N2, 1);
dyv = -dy2inv * ones(N2, 1);
A = spdiags([dyv ddxv dyv], [-1 0 1], N2, N2);
D = spdiags(dxv, 0, N2, N2);
e = ones(N1,1);
J = spdiags([e e], [-1 1], N1, N1);
L = sparse(kron(eye(N1), A) + kron(J, D));
end    
