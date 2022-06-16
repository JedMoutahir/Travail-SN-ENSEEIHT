close all;
clear;

%Information binaire a transmettre
NbBitsMessage = 1000;
Infomation = randi(2,1,NbBitsMessage) -1;

%----------------------------------------------
%-----------------MODULATEUR 1-----------------
%----------------------------------------------

%Mapping : binaire à moyenne nulle
mapped1 = Infomation*2-1;

%Surechantillonnage
Fe = 24000;
Te = 1/Fe;
L = length(mapped1);
nbSymboles = 2;
Rb = 3000;
Ts = nbSymboles/Rb;
Ns = floor(Ts/Te);
Tsignal = [0 : Te : (L*Ns-1)*Te];
signal1 = kron(mapped1, [1, zeros(1,Ns-1)]);

%Filtrage de mise en forme : retangulaire
rectangle = ones(1,Ns);
signal1Filtred= filter(rectangle,1,signal1);

%Tracé signal transmis en fonction du temps
figure;
plot(Tsignal, signal1Filtred);
title('signal 1 filtré');
xlabel('t en s');
ylabel('signal1Filtred(t)');

%Tracé densité spectrale de puissance du signal transmis en fonction de la fréquence
Np = 4096;
DSP1 = pwelch(signal1Filtred,[],[],Np,Fe,'centered');
F1 = linspace(-Fe/2,Fe/2,Np);
figure;
semilogy(F1,DSP1);
title('DSP signal 1 filtré');
xlabel('f en Hz');
ylabel('DSPsignal1Filtred(f)');

%DSP Théorique
DSPTheorique1 = Ts*(sin(pi*F1*Ts)./(pi*F1*Ts)).^2;
figure;
semilogy(F1,DSP1);
hold on;
semilogy(F1,DSPTheorique1);
legend('DSP1','DSPThéorique');
xlabel('f en Hz');
ylabel('DSP(f)');
hold off;
title('Comparaison DSP1 et DSP Théorique');

%----------------------------------------------
%-----------------MODULATEUR 2-----------------
%----------------------------------------------

%Mapping : 4-aires à moyenne
int = reshape(Infomation,2,length(Infomation)/2);
int = bi2de(int');
mapped2 = int*2-3;

%Surechantillonnage
Fe = 24000;
Te = 1/Fe;
L = length(mapped2);
nbSymboles = 4;
Rb = 3000;
Ts = nbSymboles/Rb;
Ns = floor(Ts/Te);
Tsignal = [0 : Te : (L*Ns-1)*Te];
signal2 = kron(mapped2', [1, zeros(1,Ns-1)]);

%Filtrage de mise en forme : retangulaire
rectangle = ones(1,Ns);
signal2Filtred= filter(rectangle,1,signal2);

%Tracé signal transmis en fonction du temps
figure;
plot(Tsignal, signal2Filtred);
title('signal 2 filtré');
xlabel('t en s');
ylabel('signal2Filtred(t)');

%Tracé densité spectrale de puissance du signal transmis en fonction de la fréquence
Np = 4096;
DSP2 = pwelch(signal2Filtred,[],[],Np,Fe,'centered');
F2 = linspace(-Fe/2,Fe/2,Np);
figure;
semilogy(F2,DSP2);
title('DSP signal 2 filtré');
xlabel('f en Hz');
ylabel('DSPsignal2Filtred(f)');

%DSP Théorique
DSPTheorique2 = Ts*sin(pi*F2*Ts).^4./(pi*F2*Ts).^2;
figure;
semilogy(F2,DSP2);
hold on;
semilogy(F2,DSPTheorique2);
legend('DSP2','DSPThéorique');
xlabel('f en Hz');
ylabel('DSP(f)');
hold off;
title('Comparaison DSP2 et DSP Théorique');


%----------------------------------------------
%-----------------MODULATEUR 3-----------------
%----------------------------------------------

%Mapping : binaire à moyenne
mapped3 = Infomation*2-1;

%Surechantillonnage
Fe = 24000;
Te = 1/Fe;
L = length(mapped3);
nbSymboles = 2;
Rb = 3000;
Ts = nbSymboles/Rb;
Ns = floor(Ts/Te);
Tsignal = [0 : Te : (L*Ns-1)*Te];
signal3 = kron(mapped3, [1, zeros(1,Ns-1)]);


%Filtrage de mise en forme : racine de cosinus sureleve
a = 0.5;
L3 = 5;
h = rcosdesign(a, L3, Ns);
signal3Filtred= filter(h,1,signal3);

%Tracé signal transmis en fonction du temps
figure;
plot(Tsignal, signal3Filtred);
title('signal 3 filtré');
xlabel('t en s');
ylabel('signal3Filtred(t)');

%Tracé densité spectrale de puissance du signal transmis en fonction de la fréquence
Np = 4096;
DSP3 = pwelch(signal3Filtred,[],[],Np,Fe,'centered');
F3 = linspace(-Fe/2,Fe/2,Np);
figure;
semilogy(F3,DSP3);
title('DSP signal 3 filtré');
xlabel('f en Hz');
ylabel('DSPsignal3Filtred(f)');

%DSP Théorique
DSPTheorique3 = 0;
figure;
semilogy(F3,DSP3);
hold on;
semilogy(F3,DSPTheorique3);
legend('DSP3','DSPThéorique');
xlabel('f en Hz');
ylabel('DSP(f)');
hold off;
title('Comparaison DSP3 et DSP Théorique');


%-----------------------------------------------------------------------
%----------------------------Comparaison DSP----------------------------
%-----------------------------------------------------------------------

figure;
semilogy(F1,DSP1);
hold on;
semilogy(F2,DSP2);
semilogy(F3,DSP3);
legend('DSP1','DSP2','DSP3');
xlabel('f en Hz');
ylabel('DSP(f)');
hold off;
title('Comparaison des DSP');