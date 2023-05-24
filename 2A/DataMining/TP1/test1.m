close all;
clear all;

Q = [2 2 2 ; 2 4 5 ; 2 5 7];
Ibar = [0.1 ; 0.2 ; 0.3];

Icalc = minphi(Ibar, Q);
I1 = [0 ; 1 ; 0];
I2 = [1 ; -1 ; 1];

phi(Icalc, Ibar, Q)
phi(I1, Ibar, Q)
phi(I2, Ibar, Q)
