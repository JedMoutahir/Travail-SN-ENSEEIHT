clear all;
cJ = [1 2 3 4 5 6 7 8];
[c0, D] = decompositionHaar(cJ);
cJRecomp = reconstructionHaar(c0,D);

f = @(x) sqrt(abs(cos(x)));
J = 10;
N = 2^J;
L = f(linspace(0,1,N));
[c0, D] = decompositionHaar(L);
LRecomp = reconstructionHaar(c0, D);
plot(L);
hold on; 
plot(LRecomp);
hold off;
sum(abs(LRecomp - L))