close all;
clear all;


A = [100 ; 200 ; 300 ; 400];
G = [1, 1, 1 ; 2, 2, 4 ; 3, 4, 5 ;  1, 0, 1];
b = [-151.66 ; 96.534 ; -253.27 ; -1202.7];

Q = G'*G - G'*A * (inv(A'*A)) * A'*G;

[~, n] = size(G);
[m, p] = size(A);
res = [A G]\b;
Ibar = res(p+1:end);
I = zeros(size(Ibar));
R = chol(Q);

[Isol, min] = reccsol(4, 1100000, 1, 1, 0, I, Ibar, Q, R);