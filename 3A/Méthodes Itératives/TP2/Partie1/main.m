clear all;
close all;

N = 5;

A = getMatrixA(N);

rhsf = 2*ones(N-1,1);

sol_ref = A \ rhsf;

clear all;
N = 64;
h = 1/N;
A = getMatrixA(N);
omega = 2/3;
rhsf = zeros(N-1,1);
j = 2:N;
k = 6;
% kieme vecteur propre
um = sin(j/N*k*pi);
m = 10;
ump1 = weighted_jacobi(A,um',rhsf,omega,m);
x=h:h:1-h;
plot(x,um,x, ump1);
legend('um','ump1');
title('Damping effect of weighted Jacobi method')

clear all;
% Setup maillage
N = 64;
h = 1/N;
% Setup Jacobi
omega = 2/3;
% Setup of the fine and coarse grid matrix
% and the right-hand side
Ah = getMatrixA(N);
A2h = getMatrixA(N/2);
rhsf = 2*ones(N-1,1);
% Compute direct solution of linear system
sol_ref = Ah \ rhsf;
% Setup interpolation matrix
I2hh = interpol(N);
Ih2h = 0.5*I2hh';

% Initial vector
v(1:N-1,1) = 0;
% Vector to store the error at each iteration.
% We do 10 iterations.
nb_iter = 100;
err(1:nb_iter) = 0;
res(1:nb_iter) = 0;
res_h_init = inf;
% Multigrid iterations with 2 pre-smoothing steps
for i=1:nb_iter
    v = weighted_jacobi(Ah,v,rhsf,omega,2);
    % residual on fine grid
    res_h = rhsf - Ah*v;

    if(i == 1)
        res_h_init = res_h;
    end

    % Restriction of residual to coarser grid
    res_2h = Ih2h*res_h;
    % Solve the coarse grid error equation
    e_2h = A2h \ res_2h;
    % Interpolate the coarse grid error to the fine grid
    e_h = I2hh*e_2h;
    % Update the approximate fine grid solution
    v = v + e_h;
    % Compute the error with respect to the direct
    % solution of the linear system
    err(i) = norm(sol_ref-v);

    res(i) = norm(res_h)/norm(res_h_init);
end

figure;
plot(err);

figure;
plot(res);